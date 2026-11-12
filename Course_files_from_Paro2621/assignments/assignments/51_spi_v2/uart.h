#ifndef UART_H
#define UART_H

    #include "timer.h"
    #include <xc.h>

    #define FCY 72000000UL
    #define BAUDRATE 9600 // 115200
    #define BRGVAL ((FCY/BAUDRATE)/16)-1 // only for slow speed mode

    #define UART_BUFFER_SIZE 64
    #define TX_BUFFER_FULL -1
    #define RX_BUFFER_EMPTY -1

    // Function prototypes
    int uart1_mikrobus2_setup();
    int uart1_write(const char *msg);
    int uart1_read_char(void);
    int uart1_read_string(char *dest_buffer, int max_len);
    void __attribute__((__interrupt__)) _U1TXInterrupt(void);
    void __attribute__((__interrupt__)) _U1RXInterrupt(void);

#endif // UART_H