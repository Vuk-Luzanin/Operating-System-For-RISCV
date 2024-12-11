
#ifndef PROJECT_BASE_SYSCALL_CPP_HPP
#define PROJECT_BASE_SYSCALL_CPP_HPP

#include "syscall_c.hpp"
#include "../lib/hw.h"


void* operator new (size_t);
void operator delete (void*) noexcept;


class Thread {
public:
    Thread (void (*body)(void*), void* arg);
    virtual ~Thread ();
    int start ();
    static void dispatch ();
    static int sleep (time_t);

protected:
    Thread ();
    virtual void run () { }
public:
    thread_t myHandle;
    void (*body)(void*);
    void* arg;
    static void startWrapper(void*);
};


class Semaphore {
public:
    Semaphore (unsigned init = 1);
    virtual ~Semaphore ();

    int wait();

    int signal();

    int timedWait(time_t);

    int tryWait();

private:
    sem_t myHandle;
};


class PeriodicThread : public Thread {
public:
    void terminate ();

protected:
    PeriodicThread (time_t period);

    virtual void periodicActivation () {}

private:
    time_t period;
    static void startWrapper(void *arg);
};


class Console {
public:
    static char getc ();
    static void putc (char);
};


#endif //PROJECT_BASE_SYSCALL_CPP_HPP
