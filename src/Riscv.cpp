
#include "../h/Riscv.hpp"
#include "../h/MemoryAllocator.hpp"
#include "../h/TCB.hpp"
#include "../h/SleepingQueue.hpp"
#include "../h/Console.hpp"
#include "../h/Semaphore.hpp"
#include "../test/printing.hpp"
#include "../h/syscall_c.hpp"

int Riscv::brojac = 0;

// iz ove funkcije zelimo da se vratimo tamo odakle je pozvana, a ne na sepc (po defaultu je tako, a to bi bilo na sacuvanu sepc old niti u handleSupervisorTrap funkciji)
void Riscv::popSppSpie() {
    if (TCB::userMode) {
        mc_sstatus(SSTATUS_SPP);
    }
    __asm__ volatile ("csrw sepc, ra");
    __asm__ volatile ("sret");          //threadWrapper se poziva iz prekidne rutine, pa cem ona ovom mestu izaci iz nje
}

//implementirano na vezbama -> glavni deo prekidne rutine
void Riscv::handleSupervisorTrap() {
    //read args
    uint64 volatile arg1, arg2, arg3, arg4;
    __asm__ volatile("mv %0, a1" : "=r"(arg1));
    __asm__ volatile("mv %0, a2" : "=r"(arg2));
    __asm__ volatile("mv %0, a3" : "=r"(arg3));
    __asm__ volatile("mv %0, a4" : "=r"(arg4));
    uint64 volatile opCode;
    __asm__ volatile("mv %0, a0" : "=r"(opCode));

    __asm__ volatile("csrr %0, sscratch" : "=r"(TCB::running->ecallSP));     // ssratch <= sp

    uint64 volatile scause = Riscv::r_scause();         // read scause

    switch (scause) {
        case timerInt: {
            brojac++;
            if (brojac % 2 == 0) {
                SleepingQueue::wakeUpTCBs();                      //try to wake up
                mySemaphore::tryToUnblockTimer();                 //try to unblock
            }

            TCB::timeSliceCounter++;
            if (TCB::timeSliceCounter >= TCB::running->getTimeSlice()) {
                uint64 volatile sepc = r_sepc();
                uint64 volatile sstatus = r_sstatus();
                TCB::timeSliceCounter = 0;
                TCB::dispatch();
                w_sstatus(sstatus);
                w_sepc(sepc);
            }
            mc_sip(SIP_SSIP);
            break;
        }
        case hwInt: {                   //only from console
            //console_handler();
            uint64 volatile sepc = r_sepc();
            uint64 volatile sstatus = r_sstatus();

            char console_status = *((char*) CONSOLE_STATUS);        //8 bits
            if (console_status & CONSOLE_RX_STATUS_BIT) {           //can read
                char data = *((char *) CONSOLE_RX_DATA);
                if (myConsole::numberOfCharToGet>0) {
                    myConsole::numberOfCharToGet--;
                    myConsole::putCInBuff(data);
                }
            }
            plic_complete(plic_claim());                //done
            w_sstatus(sstatus);
            w_sepc(sepc);
            break;
        }
        case opInt: {
            //printString("Operation Interrupt\n");
            TCB::prepareThreadExit();
            break;
        }
        case addrRdInt: {
            //printString("Invalid Read Interrupt\n");
            TCB::prepareThreadExit();
            break;
        }
        case addrWrInt: {
            //printString("Invalid Write Interrupt\n");
            TCB::prepareThreadExit();
            break;
        }
        case ecallSysInt:
        case ecallUsrInt: {
            uint64 volatile sepc = Riscv::r_sepc() + 4;       // - adresa nakon ecall -cuvamo na steku old - u lokalnoj promenljivoj sepc(od old), sepc nismo cuvali u dispatchu - lokalnu prom. cuvamo na steku old niti
            uint64 volatile sstatus = Riscv::r_sstatus();

            switch (opCode) {
                case MemoryAllocator::MEM_ALLOC_CODE: {
                    MemoryAllocator::prepareMemAlloc(arg1);
                    break;
                }
                case MemoryAllocator::MEM_FREE_CODE: {
                    MemoryAllocator::prepareMemFree(arg1);
                    break;
                }
                case TCB::THREAD_CREATE: {
                    TCB::prepareThreadCreate((thread_t*) arg1, (TCB::Body) arg2, (void*) arg3, (void*) arg4);
                    break;
                }
                case TCB::THREAD_EXIT: {
                    TCB::prepareThreadExit();
                    break;
                }
                case TCB::THREAD_DISPATCH: {
                    TCB::dispatch();
                    break;
                }
                case mySemaphore::SEM_OPEN: {
                    mySemaphore::prepareSemOpen((sem_t*) arg1, (unsigned) arg2);
                    break;
                }
                case mySemaphore::SEM_CLOSE: {
                    mySemaphore::prepareSemClose((sem_t) arg1);
                    break;
                }
                case mySemaphore::SEM_WAIT: {
                    mySemaphore::prepareSemWait((sem_t) arg1);
                    break;
                }
                case mySemaphore::SEM_SIGNAL: {
                    mySemaphore::prepareSemSignal((sem_t) arg1);
                    break;
                }
                case mySemaphore::SEM_TIMED_WAIT: {
                    mySemaphore::prepareSemTimedWait((sem_t) arg1, (time_t) arg2);
                    break;
                }
                case mySemaphore::SEM_TRY_WAIT: {
                    mySemaphore::prepareSemTryWait((sem_t) arg1);
                    break;
                }
                case TCB::THREAD_TIME_SLEEP: {
                    TCB::prepareTimeSleep((time_t) arg1);
                    break;
                }
                case myConsole::CONSOLE_GETC: {
                    myConsole::prepareGetC();
                    break;
                }
                case myConsole::CONSOLE_PUTC: {
                    myConsole::preparePutC((char) arg1);
                    break;
                }
                case myConsole::CONSOLE_PUTC_HELPER: {
                    char res = myConsole::getCOutBuff();
                    __asm__ volatile("mv a0, %0" : :"r"((uint64)res));
                    //save a0 on old context stack
                    Riscv::setA0onStack();
                    break;
                }
            }
            w_sstatus(sstatus);
            w_sepc(sepc);
            break;
        }
    }
}

void Riscv::setA0onStack() {        //podmetanje povratne vrednosti u stari kontekst
//save a0 on old context stack
    uint64 save;
    __asm__ volatile("mv %0, a1" : "=r"(save));
    __asm__ volatile("mv a1, %0" : : "r"(TCB::running->ecallSP));   //TCB::running->tsmp = sp
    __asm__ volatile("sd a0, 80(a1)");                          // x10 = a0 register -> podmece se nova savuvana vrednost povratka iz funkcije
    __asm__ volatile("mv a1, %0" : : "r"(save));
}


void Riscv::changePrivMode() {
    if (TCB::userMode) {
        mc_sstatus(SSTATUS_SPP);
    }
}
