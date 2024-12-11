
#include "../h/Semaphore.hpp"
#include "../h/Riscv.hpp"
#include "../h/MemoryAllocator.hpp"

List<mySemaphore> mySemaphore::allSemaphores;

void *mySemaphore::operator new(size_t size) {
    size_t numofBlocks = (size + MemoryAllocator::HEADER_SIZE + MEM_BLOCK_SIZE - 1)/MEM_BLOCK_SIZE;
    return MemoryAllocator::my_mem_alloc(numofBlocks);
}

void mySemaphore::operator delete(void *p) {
    MemoryAllocator::my_mem_free(p);
}

mySemaphore::mySemaphore(int val) : value(val), startValue(val) {}

mySemaphore::~mySemaphore() {
    while (suspendedTCBs.peekFirst() != nullptr) {
        TCB* tmp = suspendedTCBs.peekFirst();
        suspendedTCBs.removeFirst();
        tmp->returnedValFromWaits = SEMDEAD;
        Scheduler::put(tmp);
    }
}

int mySemaphore::tryWait() {
    if (value > 0) {
        //semaphore is not locked -> thread will not block
        --value;
        return 1;
    }
    return 0;
}

int mySemaphore::wait(uint64 time) {
    if (--value < 0) {
        block(time);
    }
    return 0;
}

int mySemaphore::signal() {
    if (++value <= 0) {
        unblock();
    }
    return 0;
}

void mySemaphore::block(uint64 time) {
    TCB::running->setStatus(SUSPENDED);
    suspendedTCBs.addLast(TCB::running, time);
    TCB::dispatch();
}

void mySemaphore::unblock() {
    TCB* tmp = suspendedTCBs.peekFirst();
    suspendedTCBs.removeFirst();
    if (tmp) {
        Scheduler::put(tmp);
    }
}

void mySemaphore::tryToUnblockTimer() {                     //tail!? i povratna vrednost kad nije timed_wait
    List<mySemaphore>::Node *sem = allSemaphores.head;
    while (sem) {

        mySemaphore* curSem = sem->data;
        List<TCB>::Node* cur = curSem->suspendedTCBs.head;
        List<TCB>::Node* prev = nullptr;

        while (cur) {

            if (cur->timeBlockOrSleep == 0) {
                prev = cur;
                cur = cur->next;
                continue;
            }

            if (--(cur->timeBlockOrSleep) == 0) {
                List<TCB>::Node* tmp = cur;
                cur->data->returnedValFromWaits = TIMEOUT;          //TIMEOUT = -2
                Scheduler::put(cur->data);
                if (prev) {
                    prev->next = cur->next;
                } else {
                    curSem->suspendedTCBs.head = cur->next;
                }
                if (curSem->suspendedTCBs.tail == cur) {
                    curSem->suspendedTCBs.tail = prev;
                }
                cur = cur->next;
                delete tmp;
                continue;
            }
            prev = cur;
            cur = cur->next;
        }
        sem = sem->next;
    }
}


//ECALL handlers
void mySemaphore::prepareSemOpen(mySemaphore **handle, unsigned int init) {
    (*handle) = new mySemaphore(init);
    allSemaphores.addLast(*handle);

    if (!(*handle)) {
        __asm__ volatile("li a0, 0xffffffffffffffff");           //unsuccessful alloc ret = -1
    } else {
        __asm__ volatile("li a0, 0");
    }

    //save a0 on old context stack
    Riscv::setA0onStack();
}

void mySemaphore::prepareSemClose(mySemaphore *handle) {
    if (handle) {
        List<mySemaphore>::Node *cur = allSemaphores.head;
        List<mySemaphore>::Node *prev = nullptr;
        while (cur->data != handle) {
            prev = cur;
            cur = cur->next;
        }
        if (!cur) {
            __asm__ volatile("li a0, 0xffffffffffffffff");
        } else {
            if (prev) {
                prev->next = cur->next;
            } else {
                allSemaphores.head = cur->next;
            }
            if (allSemaphores.tail == cur) {
                allSemaphores.tail = prev;
            }
            //unblock all threads
            while (handle->suspendedTCBs.peekFirst()) {
                TCB* curTCB = handle->suspendedTCBs.removeFirst();
                curTCB->returnedValFromWaits = SEMDEAD;
                Scheduler::put(curTCB);
            }
            delete handle;
            __asm__ volatile("li a0, 0");
        }
    } else {
        __asm__ volatile("li a0, 0xffffffffffffffff");
    }

    //save a0 on old context stack
    Riscv::setA0onStack();
}

void mySemaphore::prepareSemWait(mySemaphore *id) {
    //init return
    TCB::running->returnedValFromWaits = 0;
    id->wait();

    //ret value
    if (TCB::running->returnedValFromWaits == SEMDEAD) {
        __asm__ volatile("li a0, 0xffffffffffffffff");
    } else if (TCB::running->returnedValFromWaits == TIMEOUT) {
        __asm__ volatile("li a0, 0xfffffffffffffffe");
    } else {
        __asm__ volatile("li a0, 0");
    }

    //save a0 on old context stack
    Riscv::setA0onStack();
}

void mySemaphore::prepareSemSignal(mySemaphore *id) {
    if (id) {
        id->signal();
        __asm__ volatile("li a0, 0");
    } else {
        __asm__ volatile("li a0, 0xffffffffffffffff");
    }

    //save a0 on old context stack
    Riscv::setA0onStack();
}

void mySemaphore::prepareSemTimedWait(mySemaphore *id, time_t timeout) {
    id->wait(timeout);

    //ret value
    if (TCB::running->returnedValFromWaits == SEMDEAD) {
        __asm__ volatile("li a0, 0xffffffffffffffff");
    } else if (TCB::running->returnedValFromWaits == TIMEOUT) {
        __asm__ volatile("li a0, 0xfffffffffffffffe");
    } else {
        __asm__ volatile("li a0, 0");
    }

    //save a0 on old context stack
    Riscv::setA0onStack();
}

void mySemaphore::prepareSemTryWait(mySemaphore *id) {
    uint64 res;
    if (id) {
        res = id->tryWait();
        __asm__ volatile("mv a0, %0" : : "r"(res));
    } else {
        __asm__ volatile("li a0, 0xffffffffffffffff");
    }

    //save a0 on old context stack
    Riscv::setA0onStack();
}

















