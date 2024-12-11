
#include "../h/syscall_c.hpp"
#include "../h/MemoryAllocator.hpp"
#include "../h/TCB.hpp"
#include "../test/printing.hpp"
//#include "../lib/mem.h"


void *mem_alloc(size_t size) {              // size = number of bytes
    if (size == 0) return nullptr;

    //prepare for system call
    size_t numofBlocks = (size + MemoryAllocator::HEADER_SIZE + MEM_BLOCK_SIZE - 1)/MEM_BLOCK_SIZE;        //whole number of blocks
    __asm__ volatile("mv a1, %0" : : "r"(numofBlocks));
    __asm__ volatile("li a0, 0x1");                                           //opCode

    __asm__ volatile("ecall");      //system call -> prelaz u sistemski rezim

    //return value
    uint64 volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return (void*) ret;
}

int mem_free(void *mem) {
    if (!mem) return -1;
    uint64 address = (uint64) mem;

    //prepare for system call
    __asm__ volatile("mv a1, %0" : : "r"(address));
    __asm__ volatile("li a0, 2");                                           //opCode

    __asm__ volatile("ecall");      //system call -> prelaz u sistemski rezim

    //return value
    int volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return ret;
}

int thread_create(thread_t *handle, void(*start_routine)(void *), void *arg) {
    if (!handle) return -1;
    uint64 volatile _handle = (uint64) handle;
    uint64 volatile _start_routine = (uint64) start_routine;
    uint64 volatile _arg = (uint64) arg;

    //allocate stack
    uint64 volatile _stack_space = (uint64) (new uint64[DEFAULT_STACK_SIZE]);
    if (_stack_space == 0) return -2;

    //args
    __asm__ volatile("mv a1, %0" : : "r"(_handle));
    __asm__ volatile("mv a2, %0" : : "r"(_start_routine));
    __asm__ volatile("mv a3, %0" : : "r"(_arg));
    __asm__ volatile("mv a4, %0" : : "r"(_stack_space));
    __asm__ volatile("li a0, 0x11");            //opCode

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim

    //return value
    int volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return ret;
}

int thread_exit() {
    __asm__ volatile("li a0, 0x12");            //opCode

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim

    //return value
    int volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return ret;
}

void thread_dispatch() {
    TCB::yield();
}

int sem_open(sem_t *handle, unsigned int init) {
    //args
    __asm__ volatile("mv a2, %0" : : "r"((uint64) init));       //ako se prvo stavi u a1, ne radi
    __asm__ volatile("mv a1, %0" : : "r"((uint64) handle));
    __asm__ volatile("li a0, 0x21");            //opCode

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim

    //return value
    int volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return ret;
}

int sem_close(sem_t handle) {
    //args
    __asm__ volatile("mv a1, %0" : : "r"((uint64) handle));
    __asm__ volatile("li a0, 0x22");            //opCode

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim

    //return value
    int volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return ret;
}

int sem_wait(sem_t id) {
    //args
    __asm__ volatile("mv a1, %0" : : "r"((uint64) id));
    __asm__ volatile("li a0, 0x23");            //opCode

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim

    //return value
    int volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return ret;
}

int sem_signal(sem_t id) {
    //args
    __asm__ volatile("mv a1, %0" : : "r"((uint64) id));
    __asm__ volatile("li a0, 0x24");            //opCode

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim

    //return value
    int volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return ret;
}

int sem_timedwait(sem_t id, time_t timeout) {
    //args
    __asm__ volatile("mv a2, %0" : : "r"((uint64) timeout));
    __asm__ volatile("mv a1, %0" : : "r"((uint64) id));
    __asm__ volatile("li a0, 0x25");            //opCode

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim

    //return valueFFFFFFFE if timer ends
    int volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return ret;
}

int sem_trywait(sem_t id) {
    //args
    __asm__ volatile("mv a1, %0" : : "r"((uint64) id));
    __asm__ volatile("li a0, 0x26");            //opCode

    __asm__ volatile("ecall");          //system call -> prelaz u sistemski rezim

    //return value
    int volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return ret;
}

int time_sleep(time_t ms) {
    if (ms == 0) {
        return 0;
    }
    //args
    __asm__ volatile("mv a1, %0" : : "r"((uint64) ms));
    __asm__ volatile("li a0, 0x31");            //opCode

    __asm__ volatile("ecall");

    //return value
    int volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return ret;
}

char getc() {
    __asm__ volatile("li a0, 0x41");            //opCode

    __asm__ volatile("ecall");

    //return value
    int volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return ret;
}

void putc(char c) {
    //args
    __asm__ volatile("mv a1, %0" : : "r"((uint64) c));
    __asm__ volatile("li a0, 0x42");            //opCode

    __asm__ volatile("ecall");
}

char putcHelper() {

    __asm__ volatile("li a0, 0x100");            //opCode

    __asm__ volatile("ecall");

    //return value
    uint64 volatile ret = 0;
    __asm__ volatile("mv %0, a0" : "=r"(ret));
    return (char)ret;
}








