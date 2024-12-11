
#ifndef PROJECT_BASE_LIST_HPP
#define PROJECT_BASE_LIST_HPP

#include "MemoryAllocator.hpp"
#include "../h/print.hpp"


//dato na vezbama! - dodato je polje za vreme i preklopljeni su operatori new i delete
template<typename T>
class List {
private:
    struct Node {
        T *data;
        Node *next;
        time_t timeBlockOrSleep;
        Node(T *data, Node *next, uint64 time = 0) : data(data), next(next), timeBlockOrSleep(time) {}

        void* operator new(size_t size) {
            size_t numofBlocks = (size + MemoryAllocator::HEADER_SIZE + MEM_BLOCK_SIZE - 1)/MEM_BLOCK_SIZE;
            return MemoryAllocator::my_mem_alloc(numofBlocks);
        }
        void operator delete(void *p) {
            MemoryAllocator::my_mem_free(p);
        }
    };
    Node *head, *tail;

public:
    List() : head(0), tail(0) {}
    List(const List<T> &) = delete;

    List<T> &operator=(const List<T> &) = delete;

    void addFirst(T *data, time_t time = 0) {
        Node *elem = new Node(data, head, time);
        head = elem;
        if (!tail) { tail = head; }
    }

    void addLast(T *data, time_t time = 0) {
        Node *elem = new Node(data, 0, time);
        if (tail) {
            tail->next = elem;
            tail = elem;
        } else {
            head = tail = elem;
        }
    }

    T *removeFirst() {
        if (!head) { return 0; }

        Node *elem = head;
        head = head->next;
        if (!head) { tail = 0; }

        T *ret = elem->data;
        delete elem;
        return ret;
    }

    T *peekFirst() {
        if (!head) { return 0; }
        return head->data;
    }

    T *removeLast() {
        if (!head) { return 0; }

        Node *prev = 0;
        for (Node *curr = head; curr && curr != tail; curr = curr->next) {
            prev = curr;
        }

        Node *elem = tail;
        if (prev) { prev->next = 0; }
        else { head = 0; }
        tail = prev;

        T *ret = elem->data;
        delete elem;
        return ret;
    }

    T *peekLast() {
        if (!tail) { return 0; }
        return tail->data;
    }


    friend class mySemaphore;
    friend class SleepingQueue;
};


#endif //PROJECT_BASE_LIST_HPP


/*void printList() {
        Node* cur = head;
        while (cur) {
            printInteger((uint64) cur->data);
            printString(" - ");
            printInteger(cur->timeBlockOrSleep);
            printString("\n");
            cur = cur->next;
        }
    }*/