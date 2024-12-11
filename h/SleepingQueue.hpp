
#ifndef PROJECT_BASE_SLEEPINGQUEUE_HPP
#define PROJECT_BASE_SLEEPINGQUEUE_HPP

#include "TCB.hpp"
#include "list.hpp"

class SleepingQueue {
public:

    static uint64 getTimeToSleep(TCB* id);

    static int setToSleep(time_t time);
    static void wakeUpTCBs();

    //static void printSleepingQueue();

private:
    static List<TCB>::Node *headSleepingTCBs;

    friend class TCB;
};


#endif //PROJECT_BASE_SLEEPINGQUEUE_HPP
