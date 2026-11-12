#include "timer.h"
#include "uart.h"

struct circular_buffer { // circular buffer
    unsigned char data_buffer[UART_BUFFER_SIZE];
    volatile int idxW;  // The index we WRITE to
    volatile int idxR;  // The index we READ from
};

volatile struct circular_buffer U1RX_buffer;
volatile struct circular_buffer U1TX_buffer;

int uart1_mikrobus2_setup(){

    RPINR18bits.U1RXR = 0b1001011;  // MikroBus2 UART input map
    RPOR0bits.RP64R = 0b000001;     // MikroBus2 UART output map

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

int uart1_write(const char *msg) {
    int i = 0;
    
    while (msg[i] != '\0') {
        int next_idxW = (U1TX_buffer.idxW + 1) % UART_BUFFER_SIZE;
        
        if (next_idxW == U1TX_buffer.idxR) return TX_BUFFER_FULL;

        U1TX_buffer.data_buffer[U1TX_buffer.idxW] = msg[i];
        U1TX_buffer.idxW = next_idxW;
        i++;
    }
    if(!U1STAbits.UTXBF) IFS0bits.U1TXIF = 1;
    IEC0bits.U1TXIE = 1; 

    return i;
}

void __attribute__((__interrupt__)) _U1TXInterrupt(void){
    // AFTER A BYTE IS COPIED IN THE TX BUFFER, at least one location is empty in the transmit buffer.
    IFS0bits.U1TXIF = 0;

    U1TXREG = U1TX_buffer.data_buffer[U1TX_buffer.idxR];
    U1TX_buffer.idxR = (U1TX_buffer.idxR+1)%UART_BUFFER_SIZE;

    if(U1TX_buffer.idxR == U1TX_buffer.idxW) IEC0bits.U1TXIE = 0;
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
