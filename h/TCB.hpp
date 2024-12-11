
#ifndef PROJECT_BASE_TCB_HPP
#define PROJECT_BASE_TCB_HPP

#include "../lib/hw.h"
#include "Scheduler.hpp"
#include "print.hpp"

//IZ KNJIGE - iskoriscena stanja niti + TCB klasa je vecim delom implementirana na vezbama
enum Status {RUNNING, SUSPENDED, SLEEPING, FINISHED};

class TCB {
public:
    void* operator new(size_t size);
    void operator delete(void *p);

    ~TCB() { delete[] stack; }
    using Body = void (*) (void*);
    static TCB* createThread(Body body, void* arg, void* stack, uint64 timeSlice);

    Status getStatus() { return status; }
    void setStatus(Status s) { status = s; }

    uint64 getTimeSlice() const { return timeSlice; }
    static void yield();

    static TCB* running;

    // helper with initialization and finish
    static void initTCB();
    static void endTCB();

    bool isFinished();

private:
    TCB(Body body, void* arg, void* stack, uint64 timeSlice);

    static void prepareThreadCreate(TCB **handle, Body, void* arg, void* stack_start);
    static void prepareThreadExit();
    static void prepareTimeSleep(time_t ms);

    uint64 ecallSP;
    static bool userMode;

    struct Context {    //ostale registre cuvamo na steku
        uint64 ra;
        uint64 sp;
    };

    Body body;
    void* arg;
    uint64* stack;          //POKAZUJE NA NAJNIZU LOKACIJU -> INICIJALIZUJE SE NA NAJVISU DA RASTE NANIZE
    Context context;
    Status status;
    int returnedValFromWaits;

    uint64 timeSlice;
    static uint64 timeSliceCounter;

    static TCB* console;
    static TCB* usrMain;

    static void threadWrapper();        // prvaXW se izvrsi za svaku napravljenu nit(poziva body), jer niko ne postavlja workeru da je finished - pa ce to raditi ova wrapper fija
    static void wraperUsrMain(void*);

    static void dispatch();
    static void contextSwitch(Context *oldContext, Context *runningContext); //parametri se prosledjuju kroz registre a0 (old) i a1 (running), na 0. pomeraju od a0 je ra, a na a0+8 je sp -> struct

    static const int THREAD_CREATE = 0x11;
    static const int THREAD_EXIT = 0x12;
    static const int THREAD_DISPATCH = 0x13;
    static const int THREAD_TIME_SLEEP = 0x31;
    static bool stopConsole;

    friend class Riscv;             // da bi pristupala dispatch();
    friend class MemoryAllocator;
    friend class SleepingQueue;
    friend class mySemaphore;
};

#endif //PROJECT_BASE_TCB_HPP
