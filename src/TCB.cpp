
#include "../h/TCB.hpp"
#include "../h/SleepingQueue.hpp"
#include "../h/Riscv.hpp"
#include "../h/Riscv.hpp"
#include "../h/MemoryAllocator.hpp"
#include "../h/Console.hpp"
#include "../h/Scheduler.hpp"
#include "../test/userMain.hpp"

TCB* TCB::running = nullptr;
TCB* TCB::console = nullptr;
TCB* TCB::usrMain = nullptr;
bool TCB::userMode = false;
bool TCB::stopConsole = false;

uint64 TCB::timeSliceCounter = 0;

TCB *TCB::createThread(Body body, void* arg, void* stack, uint64 timeSlice) {
    return new TCB(body, arg, stack, timeSlice);
}

void TCB::yield() {

    __asm__ volatile("li a0, 0x13");            //opCode
    __asm__ volatile("ecall");  // celokupni kontekst cuvamo u prekidnoj rutini koju sinhrono ovde zovemo
}

//implementirano na vezbama
void TCB::dispatch() {
    TCB *old = running;
    if (old->getStatus() == RUNNING) { Scheduler::put(old); }
    running = Scheduler::get();
    running->setStatus(RUNNING);
    TCB::contextSwitch(&old->context, &running->context);
}

//implementirano na vezbama
//zove se kada prvi put kreiramo nit -> tada se u threadWrapper nastavlja izvrsavanje -> necemo izaci iz prekidne rutine sa sret u prekidnoj rutini, nego u funkciji popSppSpie()
void TCB::threadWrapper() {         //zove se iz prekidne rutine (iz koda prekidne rutine) -> i dalje su ONEMOGUCENI PREKIDI -> na ovom mestu bi bilo dobro promeniti rezim u korisnicki
                                    //mozda nam je potrebno promeniti sstatus registar -> skidamo spp(supervisor previous previlege) i da vratimo spie (interrupt enable)
    Riscv::popSppSpie();            //zelimo da se izvrsi, da izadjemo iz privilegovanog rezima(iz prekidne rutine, ali da se program nastavi odmah ispod ovog poziva)
                                    // zato nam je bitno da popSppSpie ne bude inline funkcija, da bismo u ra registru prilikom poziva funkcije popSppSpie, sacuvali gde treba da nastavimo, a to je odmah ispod ovog poziva
    running->body(running->arg);                //poziva body()
    running->setStatus(FINISHED);     //kada zavrsi body -> finished = true

    // na kraju, ovu funkciju nismo regularno pozvali - pa samim tim ne znamo gde bi trebalo da se vratimo
    // zato cemo pozvati yield(), dok smo prethodno postavili finished na true -> yield ce promeniti kontekst, a kada vidi finished = true, nece nit ubaciti u Scheduler, pa se time i zavrsava
    TCB::yield();
}

void *TCB::operator new(size_t size) {
    size_t numofBlocks = (size + MemoryAllocator::HEADER_SIZE + MEM_BLOCK_SIZE - 1)/MEM_BLOCK_SIZE;
    return MemoryAllocator::my_mem_alloc(numofBlocks);
}

void TCB::operator delete(void *p) {
    MemoryAllocator::my_mem_free(p);
}
//implementirano na vezbama
TCB::TCB(Body body, void* arg, void* stack, uint64 timeSlice) :
        body(body),
        arg(arg),
        stack((uint64*) stack),
        context({
            (uint64) &threadWrapper,                                //podmecemo da se nakon konstruktora izvrsi threadWrapper()
            (uint64) &(this->stack[DEFAULT_STACK_SIZE])              //POKAZUJE IZNAD NAJVISE LOKACIJE
                }),
        timeSlice(timeSlice)
{
    if (body != nullptr) { Scheduler::put(this); }              //za main ce dispatch staviti, a ne konstruktor
}

void TCB::initTCB() {
    TCB* mainThread = new TCB(nullptr, nullptr,nullptr,DEFAULT_TIME_SLICE);
    running = mainThread;
    running->setStatus(RUNNING);
    //enable interrupts
    Riscv::ms_sstatus(Riscv::SSTATUS_SIE);
    myConsole::console_init();
    thread_create(&TCB::console, myConsole::sendCharacterOut, nullptr);
    thread_dispatch();
    TCB::userMode = true;
    thread_create(&TCB::usrMain, TCB::wraperUsrMain, nullptr);
}

void TCB::endTCB() {
    while (!TCB::usrMain->isFinished()) {
        thread_dispatch();
    }
    myConsole::numberOfCharToGet = 0;
    myConsole::stopConsole = true;
    while (!TCB::console->isFinished()) {
        thread_dispatch();
    }
}

void TCB::prepareThreadCreate(TCB **handle, Body start_routine, void* arg, void* stack_start) {

    (*handle) = createThread((TCB::Body) start_routine, arg, stack_start, DEFAULT_TIME_SLICE);

   if (!(*handle)) {
       __asm__ volatile("li a0, 0xffffffffffffffff");           //unsuccessful alloc ret = -1
   }
   __asm__ volatile("li a0, 0");

    //save a0 on old context stack
    Riscv::setA0onStack();
}

void TCB::prepareThreadExit() {
    TCB::timeSliceCounter = 0;
    TCB::running->setStatus(FINISHED);
    TCB::dispatch();
    //ret value
    __asm__ volatile("li a0, 0");

    //save a0 on old context stack
    Riscv::setA0onStack();
}

void TCB::prepareTimeSleep(time_t ms) {

    TCB::timeSliceCounter = 0;
    int ret = SleepingQueue::setToSleep((time_t) ms);
    TCB::dispatch();
    //ret value
    __asm__ volatile("mv a0, %0" : : "r"(ret));

    //save a0 on old context stack
    Riscv::setA0onStack();
}

bool TCB::isFinished() {
    return status == FINISHED;
}

void TCB::wraperUsrMain(void *) {
    userMain();
}





