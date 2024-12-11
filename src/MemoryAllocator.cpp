
#include "../h/MemoryAllocator.hpp"
#include "../h/print.hpp"
#include "../h/Riscv.hpp"
#include "../h/TCB.hpp"

MemoryAllocator::FreeMemBlock* MemoryAllocator::freeMemHead = nullptr;
int MemoryAllocator::memoryIntitialized = 0;

void MemoryAllocator::memory_init() {
    if (memoryIntitialized == 1) return;
    memoryIntitialized = 1;
    freeMemHead = (FreeMemBlock*) HEAP_START_ADDR;
    *freeMemHead = { nullptr, (size_t) HEAP_END_ADDR - (size_t) HEAP_START_ADDR - HEADER_SIZE};
}

//deo koda je dat na proslim kolokvijumima - u delu Kontinualna alokacija
void *MemoryAllocator::my_mem_alloc(size_t size) {                           // size - numberOfBlocks (HEADER included)
    memory_init();
    FreeMemBlock* cur = freeMemHead;
    FreeMemBlock* prev = nullptr;
    FreeMemBlock* nextNode;

    for (; cur; prev = cur, cur = cur->next) {
        if (cur->size < size*MEM_BLOCK_SIZE - HEADER_SIZE) continue;            //no space
        if (cur->size - size*MEM_BLOCK_SIZE < 0) {
            continue;                                                           //no left free space for header
        } else if (cur->size == size*MEM_BLOCK_SIZE - HEADER_SIZE) {
            nextNode = cur->next;
        } else {                                    //cur->size >= size*MEM_BLOCK_SIZE
            size_t nextSize = cur->size - size*MEM_BLOCK_SIZE;
            cur->size = size*MEM_BLOCK_SIZE - HEADER_SIZE;
            nextNode = (FreeMemBlock*) ((size_t) cur + size*MEM_BLOCK_SIZE);
            nextNode->next = cur->next;
            nextNode->size = nextSize;
        }
        break;
    }
    if (!cur) return nullptr;

    cur->next = nullptr;
    if (prev) prev->next = nextNode;
    else freeMemHead = nextNode;
    return (cur + 1);             //preskace zaglavlje ( +1 jer je pokazivac na FreeMemBlock, pa se dodaje + 1*sizeof(FreeMemBlock) = 16)
}

//zadatak sa kolokvijuma - gotovo identican - zajedno sa tryJoin funkcijom
int MemoryAllocator::my_mem_free(const void * f) {
    memory_init();
    FreeMemBlock* toFree = ((FreeMemBlock*) f) - 1;
    if (toFree < HEAP_START_ADDR || toFree >= HEAP_END_ADDR) return -1;
    FreeMemBlock* prev = nullptr;
    FreeMemBlock* nextNode = nullptr;
    if (toFree < freeMemHead) {
        nextNode = freeMemHead;
        freeMemHead = toFree;
        prev = nullptr;
    } else {
        prev = freeMemHead;
        nextNode = freeMemHead->next;
        for (; nextNode && !(prev <toFree && nextNode > toFree); prev = nextNode, nextNode = nextNode->next);
    }
    tryToJoin(toFree, nextNode);
    tryToJoin(prev, toFree);

    return 0;
}

//zadatak sa kolokvijuma - gotovo identican
void MemoryAllocator::tryToJoin(MemoryAllocator::FreeMemBlock *f1, MemoryAllocator::FreeMemBlock *f2) {
    memory_init();
    if (!f1) return;
    if (f2 && ((uint64) f1 + HEADER_SIZE + f1->size == (uint64) f2)) {
        f1->size += HEADER_SIZE + f2->size;
        f1->next = f2->next;
    } else {
        f1->next = f2;
    }
}


void MemoryAllocator::prepareMemAlloc(size_t size) {                    //number of blocks - size

    void* addr = my_mem_alloc(size);

    __asm__ volatile("mv a0, %0" : : "r"((uint64) addr));       //ret value

    //save a0 on old context stack
    Riscv::setA0onStack();

}

void MemoryAllocator::prepareMemFree(uint64 addr) {

    uint64 ret = my_mem_free((void*) addr);

    __asm__ volatile("mv a0, %0" : : "r"(ret));       //ret value

    //save a0 on old context stack
    Riscv::setA0onStack();
}

/*
void MemoryAllocator::mem_show() {
    memory_init();
    for (int i=0;i<100;i++) printString("*");
    printString("\n\nPocetna adresa HEAPA:                    ");
    printInt((uint64)HEAP_START_ADDR);
    for (FreeMemBlock* cur = freeMemHead; cur; cur = cur->next) {
        printString("\nPocetna adresa bloka - ispred zaglavlja: ");
        printInt((uint64) cur);
        printString("\nVelicina bloka:                          ");
        printInt(cur->size);
        printString("\n\n");
        for (int i=0;i<100;i++) printString("*");
    }
    printString("\n");
}
*/










