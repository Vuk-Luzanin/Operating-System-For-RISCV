#ifndef PROJECT_BASE_MEMORYALLOCATOR_HPP
#define PROJECT_BASE_MEMORYALLOCATOR_HPP

#include "../lib/hw.h"


class MemoryAllocator {
public:
    static void memory_init ();

    static void prepareMemAlloc(size_t);
    static void* my_mem_alloc (size_t size);

    static void prepareMemFree(uint64 addr);
    static int my_mem_free (const void*);

    //static void mem_show();

    static const int MEM_ALLOC_CODE = 1;
    static const int MEM_FREE_CODE = 2;
    static uint64 constexpr HEADER_SIZE = 2*sizeof(uint64);

private:
    typedef struct FreeMemBlock {
        struct FreeMemBlock* next;
        size_t size;
    } FreeMemBlock;

    static void tryToJoin(FreeMemBlock*, FreeMemBlock*);

    static FreeMemBlock* freeMemHead;

    static int memoryIntitialized;

};



#endif //PROJECT_BASE_MEMORYALLOCATOR_HPP
