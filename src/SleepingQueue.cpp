
#include "../h/SleepingQueue.hpp"

List<TCB>::Node *SleepingQueue::headSleepingTCBs = nullptr;

//not used
uint64 SleepingQueue::getTimeToSleep(TCB *id) {
    List<TCB>::Node* cur = SleepingQueue::headSleepingTCBs;
    while (cur) {
        if (id == cur->data) {
            return cur->timeBlockOrSleep;
        }
    }
    return 0;
}

int SleepingQueue::setToSleep(time_t time) {
    if (time == 0) return 0;
    TCB::running->setStatus(SLEEPING);
    //List<TCB>::Node *node = (List<TCB>::Node *) __mem_alloc(24);
    //List<TCB>::Node *node = new List<TCB>::Node(TCB::running, nullptr, time);
    List<TCB>::Node *node = (List<TCB>::Node*) MemoryAllocator::my_mem_alloc(1);
    node->data = TCB::running;
    node->timeBlockOrSleep = time;
    node->next = nullptr;

    List<TCB>::Node *cur = headSleepingTCBs;
    List<TCB>::Node *prev = nullptr;

    for (; cur; prev = cur, cur = cur->next) {
        if (node->timeBlockOrSleep < cur->timeBlockOrSleep) {
            cur->timeBlockOrSleep -= node->timeBlockOrSleep;
            break;
        } else {
            node->timeBlockOrSleep -= cur->timeBlockOrSleep;
        }
    }
    if (cur) {
        node->next = cur;
    }
    if (prev) {
        prev->next = node;
    } else {
        headSleepingTCBs = node;
    }
    return 0;
}

void SleepingQueue::wakeUpTCBs() {
    if (!headSleepingTCBs) {
        return;
    }
    List<TCB>::Node* cur = headSleepingTCBs;
    if (cur->timeBlockOrSleep > 0 && (--cur->timeBlockOrSleep) == 0) {
        while (cur && cur->timeBlockOrSleep == 0) {
            Scheduler::put(cur->data);
            List<TCB>::Node* prev = cur;
            cur = cur->next;
            delete prev;
        }
        headSleepingTCBs = cur;
    }
}

/*
void SleepingQueue::printSleepingQueue() {
    List<TCB>::Node* cur = headSleepingTCBs;
    printString("\nSleepingQueue\n");
    while (cur) {
        printString("Trenutni: ");
        printInt((uint64) cur->data);
        printString(" - ");
        printInt((uint64) cur->timeBlockOrSleep);
        printString("\nSledeci: ");
        if (cur->next) printInt((uint64) cur->next->data);
        printString("\n\n");
        cur = cur->next;
    }
}
*/