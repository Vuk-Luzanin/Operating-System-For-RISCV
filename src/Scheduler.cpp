
#include "../h/Scheduler.hpp"

//implementirano na vezbama
List<TCB> Scheduler::readyCoroutineQueue;

TCB *Scheduler::get() {
    return readyCoroutineQueue.removeFirst();
}

void Scheduler::put(TCB *tcb) {
    readyCoroutineQueue.addLast(tcb);
}
/*
void Scheduler::showScheduler() {
    readyCoroutineQueue.printList();
}*/
