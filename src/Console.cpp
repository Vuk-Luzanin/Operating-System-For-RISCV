
#include "../h/Console.hpp"
#include "../h/Riscv.hpp"

mySemaphore* myConsole::semInput = nullptr;
mySemaphore* myConsole::semOutput = nullptr;
uint64 myConsole::inputHead = 0;
uint64 myConsole::inputTail = 0;
uint64 myConsole::outputHead = 0;
uint64 myConsole::outputTail = 0;
char myConsole::inputBuffer[BUFFER_SIZE];
char myConsole::outputBuffer[BUFFER_SIZE];
uint64 myConsole::numberOfCharToSend = 0;
uint64 myConsole::numberOfCharToGet = 0;
bool myConsole::stopConsole = false;


void myConsole::console_init() {
    semInput = new mySemaphore(0);
    semOutput = new mySemaphore(0);
}

void myConsole::putCOutBuff(char c) {
    if ((outputTail+1) % BUFFER_SIZE == outputHead) {
        return;                                 //outputBuffer FULL
    }

    outputBuffer[outputTail] =  c;
    outputTail = (outputTail+1) % BUFFER_SIZE;
    numberOfCharToSend++;
    semOutput->signal();
}

int myConsole::getCInBuff() {
    semInput->wait();
    if (inputHead == inputTail) {
        return -1;                  //ERROR code
    }
    char res = inputBuffer[inputHead];
    inputHead = (inputHead+1) % BUFFER_SIZE;
    return res;
}

void myConsole::putCInBuff(char c) {
    if ((inputTail+1) % BUFFER_SIZE == inputHead) {
        return;                                 //outputBuffer FULL
    }
    inputBuffer[inputTail] =  c;
    inputTail = (inputTail+1) % BUFFER_SIZE;
    semInput->signal();
}

int myConsole::getCOutBuff() {
    semOutput->wait();
    if (outputHead == outputTail) {
        return -1;                  //ERROR code
    }
    char res = outputBuffer[outputHead];
    outputHead = (outputHead+1) % BUFFER_SIZE;
    return res;
}


void myConsole::sendCharacterOut(void*) {       //console thread running
    while (1) {
        if (myConsole::stopConsole && numberOfCharToSend == 0 && numberOfCharToGet == 0) {   //outBuff is full and no more character to get AND main thread said to finish
            thread_exit();
        }
        char console_status = *((char*) CONSOLE_STATUS);
        if (numberOfCharToSend>0 && (console_status & CONSOLE_TX_STATUS_BIT)) {
            char character = putcHelper();
            char* tmp = (char*) CONSOLE_TX_DATA;
            *tmp = character;
            numberOfCharToSend--;
        } else {
            thread_dispatch();
        }
    }
}

void myConsole::prepareGetC() {
    numberOfCharToGet++;
    char res = getCInBuff();

    if (res != 0x01b && res != 13) {               //ESCAPE
        putCOutBuff(res);
    }
    if(res==13) {                   //carrige return
        putCOutBuff(13);
        putCOutBuff(10);        //line feed
    }

    __asm__ volatile("mv a0, %0" : :"r"((uint64)res));

    //save a0 on old context stack
    Riscv::setA0onStack();
}

void myConsole::preparePutC(char c) {
    // put char in outputBuffer
    putCOutBuff(c);
}








