
#ifndef PROJECT_BASE_CONSOLE_HPP
#define PROJECT_BASE_CONSOLE_HPP

#include "../lib/hw.h"
#include "../h/Semaphore.hpp"

class myConsole {
public:

private:
    static bool stopConsole;
    static const uint64 BUFFER_SIZE = 1024;

    static void sendCharacterOut(void*);

    static mySemaphore* semInput;
    static mySemaphore* semOutput;

    static void console_init ();

    static void putCOutBuff(char c);
    static int getCInBuff();
    static void putCInBuff(char c);
    static int getCOutBuff();

    static void prepareGetC();
    static void preparePutC(char c);

    static uint64 inputHead;
    static uint64 inputTail;
    static uint64 outputHead;
    static uint64 outputTail;

    static char inputBuffer[BUFFER_SIZE];
    static char outputBuffer[BUFFER_SIZE];
    static uint64 numberOfCharToSend;
    static uint64 numberOfCharToGet;

    static const int CONSOLE_GETC = 0x41;
    static const int CONSOLE_PUTC = 0x42;
    static const int CONSOLE_PUTC_HELPER = 0x100;
    static const int CONSOLE_INTERRUPT = 0x0a;      //not used - fail

    friend class Riscv;
    friend class TCB;
};


#endif //PROJECT_BASE_CONSOLE_HPP
