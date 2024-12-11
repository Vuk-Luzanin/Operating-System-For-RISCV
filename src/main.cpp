
#include "../h/TCB.hpp"
#include "../h/Console.hpp"
#include "../test/printing.hpp"
#include "../h/Riscv.hpp"
#include "../h/MemoryAllocator.hpp"
#include "../h/syscall_c.hpp"
#include "../h/syscall_cpp.hpp"
#include "../test/userMain.hpp"

void exit_emulator() {
    __asm__ volatile("li a0, 0x5555 \n"
                     "li a0, 0x100000 \n"
                     "sw a0, 0(a1)");
}

void initialization() {
    //set Trap routine
    Riscv::w_stvec((uint64) &Riscv::supervisorTrap);
    TCB::initTCB();
}

void end() {
    TCB::endTCB();
    //disable interrupts
    Riscv::mc_sstatus(Riscv::SSTATUS_SIE);
}


int main() {
    initialization();
    end();
    return 0;
}




