#ifndef CIRCULAR_BUFFER_H
#define CIRCULAR_BUFFER_H

typedef struct {
    volatile char *buffer;
    volatile int head;
    volatile int tail;
    int size;
} circular_buffer_t;

void cb_init(circular_buffer_t *cb, volatile char *storage, int size);
int  cb_push(circular_buffer_t *cb, char c);   // 0 = ok, -1 = pieno
int  cb_pop(circular_buffer_t *cb, char *out); // 0 = ok, -1 = vuoto
int  cb_available(circular_buffer_t *cb);      // elementi presenti

#endif