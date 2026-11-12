#include "circular_buffer.h"
#include <xc.h>

void cb_init(circular_buffer_t *cb, volatile char *storage, int size) {
    cb->buffer = storage;
    cb->head = 0;
    cb->tail = 0;
    cb->size = size;
}

int cb_push(circular_buffer_t *cb, char c) {
    int next = (cb->head + 1) % cb->size;
    if (next == cb->tail) return -1; // buffer pieno
    cb->buffer[cb->head] = c;
    cb->head = next;
    return 0;
}

int cb_pop(circular_buffer_t *cb, char *out) {
    if (cb->head == cb->tail) return -1; // buffer vuoto
    *out = cb->buffer[cb->tail];
    cb->tail = (cb->tail + 1) % cb->size;
    return 0;
}

int cb_available(circular_buffer_t *cb) {
    return (cb->head - cb->tail + cb->size) % cb->size;
}