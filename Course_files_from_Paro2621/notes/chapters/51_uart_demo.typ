#import "/setup.typ": *

= dsPIC33 UART echo implementation
*Task*
```c
/* TASK: Configure the UART1 to use the MikroBUS2.
 *  [ ] First find out the remappable I/O pins corresponding to the RD11 
 *     and RD0 registers, then perform the remapping of UART1.
 *      
 * input mapping
 *   - RD11 -> RPI75 -> 0b100 1011
 *   - UART1 receive -> RPINR18.U1RXR
 * 
 * output mapping
 *   - RD0  -> RP64  -> RPOR0bits.RP64R
 *   - UART1 transmit-> 0b000001
 * 
 * thus,
 *   RPINR18bits.U1RXR = 0b100 1011; // input map
 *   RPOR0bits.RP64R = 0b000001;     // output map
 *          
 *  [ ] Configure the UART1 to work at 9600 bps.
 *  [ ] Read a character from UART1 and send it back to the UART1
*/

```

*Step 1: gathering the ingredients*

#set text(size: 8pt)
#zebraw(
```c
#include <xc.h>

int uart1_setup(){
    U1STA = 0x00;   // reset control and status register

    U1STAbits.UTXISEL0 = 0;  // UARTx Transmission Interrupt Mode Selection bits 
    U1STAbits.UTXISEL1 = 0;
    U1STAbits.UTXBRK = 0;   // UARTx Transmit Break bit
    U1STAbits.UTXEN = 0;    // UARTx Transmit Enable bit
    // U1STAbits.UTXBF - UARTx Transmit Buffer Full Status bit (read-only)
    // U1STAbits.TRMT  - Transmit Shift Register Empty bit (read-only) 

    
    U1STAbits.URXISEL = 0;  // UARTx Receive Interrupt Mode Selection bits
    // U1STAbits.PERR  - Parity Error Status bit (read-only)
    // U1STAbits.FERR  - Framing Error Status bit (read-only)
    // U1STAbits.OERR  - Receive Buffer Overrun Error Status bit (read/clear only)
    // U1STAbits.URXDA - Receive Buffer Data Available bit (read-only)

    /*---------------------------------------------------------------------------------*/
    U1MODE = 0x00;  // reset mode register

    U1MODEbits.UARTEN = 0;  // UARTx Enable bit
    U1MODEbits.PDSEL = 0;   // Parity and Data Selection bits
    U1MODEbits.STSEL = 0;   // Stop Bit Selection bit
    U1MODEbits.BRGH = 0;    // High Baud Rate Enable bit

    /*---------------------------------------------------------------------------------*/
    U1BRG = 0;  // Baud
}

int uart1_blocking_read(){ // polling mode, read could (should) be implemented via *UART1 transimission interrupt*
    return U1RXREG; // pulls a characterfrom the RX FIFO (read)
}

int uart1_blocking_write(int data_byte){
    U1TXREG = data_byte;    // pushes a character to the TX FIFO (write)
}

int main(){
    RPINR18bits.U1RXR = 0b1001011; // input map
    RPOR0bits.RP64R = 0b000001;    // output map

    uart1_setup();
    // send back every received character
    return 0;
}
```)

#set text(size: 9pt)

#pagebreak()
*Step 2: reframe*

#set text(size: 8pt)
#zebraw(```c
#include <xc.h>

int uart1_setup(){
    U1STA = 0x00;   // reset control and status register
    U1MODE = 0x00;  // reset mode register
    U1BRG = 0;      // Baud

    /* UTXISEL<1:0> SETTINGS:
    If UTXISEL<1:0> = 00
        the UxTXIF is set when a character is transferred from the transmit
        buffer to the Transmit Shift register (UxTSR). This implies that at 
        least one location is empty in the transmit buffer.
    If UTXISEL<1:0> = 01
        the UxTXIF is set when the last character is shifted out of the UxTSR 
        register. This implies that all the transmit operations are completed.
    If UTXISEL<1:0> = 10
        the UxTXIF is set when the character is transferred to the UxTSR
        register and the transmit buffer is empty.*/

    U1STAbits.UTXISEL0 = 0;  // UARTx Transmission Interrupt Mode Selection bits 
    U1STAbits.UTXISEL1 = 0;

    U1STAbits.UTXBRK  = 0;  // UARTx Transmit Break bit
    U1STAbits.UTXEN   = 0;  // UARTx Transmit Enable bit
    U1STAbits.URXISEL = 0;  // UARTx Receive Interrupt Mode Selection bits

    U1MODEbits.UARTEN = 0;  // UARTx Enable bit
    U1MODEbits.PDSEL  = 0;  // Parity and Data Selection bits
    U1MODEbits.STSEL  = 0;  // Stop Bit Selection bit
    U1MODEbits.BRGH   = 0;  // High Baud Rate Enable bit
}

int uart1_blocking_read(){ // polling mode, read could (should?) be implemented via *UART1 transimission interrupt*
    // U1STAbits.PERR  - Parity Error Status bit (read-only)
    // U1STAbits.FERR  - Framing Error Status bit (read-only)
    // U1STAbits.OERR  - Receive Buffer Overrun Error Status bit (read/clear only)
    // U1STAbits.URXDA - Receive Buffer Data Available bit (read-only)

    return U1RXREG; // pulls a characterfrom the RX FIFO (read)
}

int uart1_blocking_write(int data_byte){
    // U1STAbits.UTXBF - UARTx Transmit Buffer Full Status bit (read-only)
    // U1STAbits.TRMT  - Transmit Shift Register Empty bit (read-only) 


    U1TXREG = data_byte;    // pushes a character to the TX FIFO (write)
    return 0;
}

int main(){
    RPINR18bits.U1RXR = 0b1001011; // input map
    RPOR0bits.RP64R = 0b000001;    // output map

    uart1_setup();
    // send back every received character
    return 0;
}
```)
#set text(size: 9pt)

#pagebreak();
*Step 3: implementing a basic driver*

#set text(size: 8pt)
#zebraw(```c
#include <xc.h>
#include "timer.h"

#define FCY 72000000UL
#define BAUDRATE 9600
#define BRGVAL ((FCY/BAUDRATE)/16)-1 // only for slow speed mode

int uart1_setup(){
    U1STA = 0x00;   // reset control and status register
    U1MODE = 0x00;  // reset mode register
    U1BRG = BRGVAL;         // Baud

    U1MODEbits.UARTEN = 1;  // First UARTx Enable bit...
    U1STAbits.UTXEN   = 1;  // ...then UARTx Transmit Enable bit

    // wait at least 1/9600 s before sending first char
    tmr_wait_ms(TIMER1, 0.1);
    return 0;
}

int uart1_bloking_read(){ // wait until a character is available, then returns it
    while(!U1STAbits.URXDA); // Wait until Data Available flag is 1
    return U1RXREG;
}

void uart1_bloking_write(int data_byte){ // wait until there is room in the buffer, then writes
    while(U1STAbits.UTXBF);  // Wait here as long as Transmit Buffer is Full
    U1TXREG = data_byte;
}

int main(){
    RPINR18bits.U1RXR = 0b1001011; // input map
    RPOR0bits.RP64R = 0b000001;    // output map

    uart1_setup();

    int data;
    while(1){
        if(U1STAbits.URXDA){
            data = uart1_bloking_read();
            uart1_bloking_write(data);
        }
    }
    return 0;
}
```)
#set text(size: 9pt)

#pagebreak();
*Step 4: implementing a nonblocking driver*

#set text(size: 8pt)
#zebraw(```c
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
        
        if (next_idxW == U1TX_buffer.idxR) return TX_BUFFER_FULL;
        // do not try to write 64+ bytes at once
        
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
    IFS0bits.U1RXIF = 0; 

    if(U1STAbits.OERR == 1)U1STAbits.OERR = 0; 

    while(U1STAbits.URXDA){
        unsigned char received_byte = U1RXREG; 
        int next_idxW = (U1RX_buffer.idxW + 1) % UART_BUFFER_SIZE;
        
        if(next_idxW != U1RX_buffer.idxR){
            U1RX_buffer.data_buffer[U1RX_buffer.idxW] = received_byte;
            U1RX_buffer.idxW = next_idxW;
        } else {
            // Software buffer is full, data discarded
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
```)
#set text(size: 9pt)