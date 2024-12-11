
#ifndef PROJECT_BASE_SEMAPHORE_HPP
#define PROJECT_BASE_SEMAPHORE_HPP

#include "syscall_c.hpp"
#include "../h/TCB.hpp"
#include "../lib/hw.h"
#include "print.hpp"

class mySemaphore {
public:

    mySemaphore(int val = 0);
    ~mySemaphore();

    static void prepareSemOpen(mySemaphore **handle, unsigned init);
    static void prepareSemClose(mySemaphore* handle);
    static void prepareSemWait(mySemaphore* id);
    static void prepareSemSignal(mySemaphore* id);
    static void prepareSemTimedWait(mySemaphore* id, time_t timeout);
    static void prepareSemTryWait(mySemaphore* id);

    static void tryToUnblockTimer();

    void* operator new(size_t size);
    void operator delete(void *p);

    int tryWait();
    int wait(uint64 time = 0);
    int signal();

    void block(uint64 time = 0);
    void unblock();

    int value;
    int startValue;

    static List<mySemaphore> allSemaphores;             //time field is not used
    List<TCB> suspendedTCBs;

    static const int SEM_OPEN = 0x21;
    static const int SEM_CLOSE = 0x22;
    static const int SEM_WAIT = 0x23;
    static const int SEM_SIGNAL = 0x24;
    static const int SEM_TIMED_WAIT = 0x25;
    static const int SEM_TRY_WAIT = 0x26;

    static const int SEMDEAD = -1;
    static const int TIMEOUT = -2;

    friend class Riscv;
    friend class TCB;
    friend class myConsole;
};



#endif //PROJECT_BASE_SEMAPHORE_HPP
