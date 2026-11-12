/**
 * @file main_basic.c
 * @author ric
 * @date 2026-04-01
 * @brief Main function
*/

/*ATTENTION !!!
 * If you are working on main_basic, comment out all the code in 
 * main_advanced and vice versa. This is to avoid conflicts between 
 * the two files when building the project.
*/

#include <xc.h>
#include "timer.h"

#define FCY 72000000UL
#define BAUDRATE 9600
#define BRGVAL ((FCY/BAUDRATE)/16)-1 // only for slow speed mode

#define UART_BUFFER_SIZE 64
#define TX_BUFFER_FULL -1
#define RX_BUFFER_EMPTY -1

int uart1_standard_setup(){
    U1STA = 0x00;   // reset control and status register
    U1MODE = 0x00;  // reset mode register
    U1BRG = BRGVAL; // Baud

    U1MODEbits.UARTEN = 1;  // First UARTx Enable bit...
    U1STAbits.UTXEN   = 1;  // ...then UARTx Transmit Enable bit

    // Enable RX interrupt
    IFS0bits.U1RXIF = 0; // clear the flag
    IEC0bits.U1RXIE = 1; // enable the interrupt

    // uart1_write() will enable the interrupt when needed
    IEC0bits.U1TXIE = 0;
    IFS0bits.U1TXIF = 0;

    tmr_wait_ms(TIMER1, 0.1); 
    return 0;
}

struct circular_buffer { // circular buffer
    unsigned char data_buffer[UART_BUFFER_SIZE];
    volatile int idxW;  // The index we WRITE to
    volatile int idxR;  // The index we READ from
};

struct circular_buffer U1RX_buffer;
struct circular_buffer U1TX_buffer;

int uart1_write(const char *msg) {
    int i = 0;
    
    while (msg[i] != '\0') {
        int next_idxW = (U1TX_buffer.idxW + 1) % UART_BUFFER_SIZE;
        
        if (next_idxW == U1TX_buffer.idxR) {
            // if(U1STAbits.UTXBF) IFS0bits.U1TXIF = 1;
            // IEC0bits.U1TXIE = 1;
            // that would have happened only when we try to write 64+ bytes at once
            // just don't

            return TX_BUFFER_FULL;
        }
        
        U1TX_buffer.data_buffer[U1TX_buffer.idxW] = msg[i];
        U1TX_buffer.idxW = next_idxW;
        i++;
    }

    // Only force the flag high if the hardware FIFO has room.
    // If it's full, the hardware is already working and will set the flag itself.

    if(!U1STAbits.UTXBF) IFS0bits.U1TXIF = 1;
    IEC0bits.U1TXIE = 1; 

    return i;
}

void __attribute__((__interrupt__)) _U1TXInterrupt(void){
    // AFTER A BYTE IS COPIED IN THE TX BUFFER, at least one location is empty in the transmit buffer.
    IFS0bits.U1TXIF = 0;

    U1TXREG = U1TX_buffer.data_buffer[U1TX_buffer.idxR];
    U1TX_buffer.idxR = (U1TX_buffer.idxR+1)%UART_BUFFER_SIZE;

    if(U1TX_buffer.idxR == U1TX_buffer.idxW){
        IEC0bits.U1TXIE = 0;
    }
}

void __attribute__((__interrupt__)) _U1RXInterrupt(void){
    IFS0bits.U1RXIF = 0; // clear interrupt flag

    if(U1STAbits.OERR == 1) U1STAbits.OERR = 0; // in case of error, discard everything (data loss)

    while(U1STAbits.URXDA){ // as long as there are data to read
        unsigned char received_byte = U1RXREG; 
        int next_idxW = (U1RX_buffer.idxW + 1) % UART_BUFFER_SIZE;
        
        if(next_idxW != U1RX_buffer.idxR){ // if there is space into the buffer to store the incoming data
            U1RX_buffer.data_buffer[U1RX_buffer.idxW] = received_byte;
            U1RX_buffer.idxW = next_idxW;
        } else {
            // buffer is full, data discarded
        }
    }
}

int uart1_read_char(void) {
    if (U1RX_buffer.idxR == U1RX_buffer.idxW) {
        return RX_BUFFER_EMPTY; 
    }

    unsigned char data = U1RX_buffer.data_buffer[U1RX_buffer.idxR];
    U1RX_buffer.idxR = (U1RX_buffer.idxR + 1) % UART_BUFFER_SIZE;

    return data;
}

int uart1_read_string(char *dest_buffer, int max_len) {
    int count = 0;
    while ((U1RX_buffer.idxR != U1RX_buffer.idxW) && (count < max_len - 1)) {
        dest_buffer[count] = U1RX_buffer.data_buffer[U1RX_buffer.idxR];
        U1RX_buffer.idxR = (U1RX_buffer.idxR + 1) % UART_BUFFER_SIZE;
        count++;
    }

    dest_buffer[count] = '\0';
    return count; 
}

int main(){
    RPINR18bits.U1RXR = 0b1001011; // input map
    RPOR0bits.RP64R = 0b000001;    // output map

    uart1_standard_setup();

    int data;
    while(1){
        /* --- UART NONBLOCKING --- */
        
        data = uart1_read_char();
        if(data != RX_BUFFER_EMPTY){
            char echo_str[2];
            echo_str[0] = (char)data;
            echo_str[1] = '\0'; // Null terminator
            
            uart1_write(echo_str);
        }
        
        /* --- UART NONBLOCKING --- */
        
        // Other tasks
    }
    
    return 0;
}