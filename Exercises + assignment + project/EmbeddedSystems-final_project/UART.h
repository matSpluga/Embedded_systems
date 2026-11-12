#ifndef UART_H
#define UART_H

#include <xc.h> 
#include "circular_buffer.h"

extern circular_buffer_t rx_cb;
extern circular_buffer_t tx_cb;

void uart_init_buffers(void);
void send_string(char* str);

#endif 
