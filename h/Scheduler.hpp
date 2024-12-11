
#ifndef PROJECT_BASE_SCHEDULER_HPP
#define PROJECT_BASE_SCHEDULER_HPP

#include "list.hpp"

class TCB;

class Scheduler {
private:
    static List<TCB> readyCoroutineQueue;

public:
    static TCB *get();
    static void put(TCB *ccb);

    static uint64 size;

    //static void showScheduler();

};

#endif //PROJECT_BASE_SCHEDULER_HPP
