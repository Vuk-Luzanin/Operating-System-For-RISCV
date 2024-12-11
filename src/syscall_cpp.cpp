
#include "../h/syscall_cpp.hpp"
#include "../lib/console.h"

void *operator new(size_t n) {
    return mem_alloc(n);
}

void *operator new[](size_t n) {
    return mem_alloc(n);
}

void operator delete(void *p) noexcept {
    mem_free(p);
}

void operator delete[](void *p) noexcept {
    mem_free(p);
}

Thread::Thread(void (*body)(void *), void *arg): body(body), arg(arg) {}

Thread::~Thread() {
    delete myHandle;
}

int Thread::start () {
    if (body) {
        return thread_create(&myHandle, body, arg);
    } else {
        return thread_create(&myHandle, startWrapper, this);
    }
}

void Thread::dispatch() {
    thread_dispatch();
}

int Thread::sleep(time_t time) {
    return time_sleep(time);
}

Thread::Thread(): body(nullptr), arg(nullptr) {}

void Thread::startWrapper(void* t) {
    Thread* thr = (Thread*) t;
    thr->run();
}


Semaphore::Semaphore(unsigned int init) {
    sem_open(&myHandle, init);
}

Semaphore::~Semaphore() {
    sem_close(myHandle);
}

int Semaphore::wait() {
    return sem_wait(myHandle);
}

int Semaphore::signal() {
    return sem_signal(myHandle);
}

int Semaphore::timedWait(time_t time) {
    return sem_timedwait(myHandle, time);
}

int Semaphore::tryWait() {
    return sem_trywait(myHandle);
}


void PeriodicThread::terminate() {
    period = 0xFFFFFFFF;
}

struct PeriodicArgs {
    time_t time;
    void* handler;
    PeriodicArgs(time_t time, void* handler) : time(time), handler(handler){}
};

PeriodicThread::PeriodicThread(time_t period) : Thread(PeriodicThread::startWrapper, new PeriodicArgs(period, this)), period(period) {}


void PeriodicThread::startWrapper(void *arg) {
    PeriodicArgs* parg = (PeriodicArgs*) arg;
    PeriodicThread* thr = (PeriodicThread*) parg->handler;
    while (1) {
        if (thr->period == 0xFFFFFFFF) {        //stop signal
            break;
        }
        thr->periodicActivation();
        Thread::sleep(parg->time);
    }
}

char Console::getc() {
    return ::getc();            //from C_API
}

void Console::putc(char c) {
    ::putc(c);                  //from C_API
}
