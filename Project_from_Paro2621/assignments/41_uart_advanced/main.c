/**
 * @file main.c
 * @author ric
 * @date 2026-04-05
 * @brief Main function
 */

/* Assignment
1.  Simulate a function call that needs 7 ms for its execution and needs to work at 100 Hz (10ms).
2.  Make LD2 blink at 2.5 Hz -> 400ms
3.  Read characters from UART1. Keep a counter of how many chars you have received. If a
    string “LD1” is received, toggle the status of LD1. If a string “LD2” is received stop or resume
    the blinking of LD2.
4.  Whenever button T2 is pressed, send “C=xx”, where xx is the current number of chars
    received to the UART1
5.  Whenever button T3 is pressed, send “D=yy”, where yy is the number of times the deadline
    of the tmr_wait_period() was missed.
6.  Follow the template provided in the next slide.
*/

#include <xc.h>
#include "timer.h"

#define FCY 72000000UL
#define BAUDRATE 115200
#define BRGVAL ((FCY/BAUDRATE)/16)-1 // only for slow speed mode

#define UART_BUFFER_SIZE 64
#define TX_BUFFER_FULL -1
#define RX_BUFFER_EMPTY -1

struct circular_buffer { // circular buffer
    unsigned char data_buffer[UART_BUFFER_SIZE];
    volatile int idxW;  // The index we WRITE to
    volatile int idxR;  // The index we READ from
};

struct circular_buffer U1RX_buffer;
struct circular_buffer U1TX_buffer;

int uart1_standard_setup();
int uart1_write(const char *msg);
int uart1_read_char(void);
int uart1_read_string(char *dest_buffer, int max_len);
void __attribute__((__interrupt__)) _U1TXInterrupt(void);
void __attribute__((__interrupt__)) _U1RXInterrupt(void);

void algorithm(){
    tmr_wait_ms(TIMER3, 7);
}

int deadlineMissed;
int charReceived;    
int step = 0;   // hyperloop step counter

#define MAXDEBCYCLE 1 // (10ms)
int debRE8 = MAXDEBCYCLE; // debouncing counter (10ms)
int debRE9 = MAXDEBCYCLE; // debouncing counter (10ms)

int RE8_prev = 1;
int RE9_prev = 1;

int blink_enable = 1;

char tx_string[6];

void formatWrite(char type, int number, char* tx_buffer) {
    int tens = (number / 10) % 10;
    int ones = number % 10;

    tx_buffer[0] = type;
    tx_buffer[1] = '=';
    tx_buffer[2] = '0' + tens;  
    tx_buffer[3] = '0' + ones;  
    tx_buffer[4] = '\n';        
    tx_buffer[5] = '\0';        
}

int main(){
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;
   
    char cmd[4] = "000";
    RPINR18bits.U1RXR = 0b1001011;  // UART input map
    RPOR0bits.RP64R = 0b000001;     // UART output map
    uart1_standard_setup();         // UART setup

    TRISAbits.TRISA0 = 0;   // set LD1 as output
    TRISGbits.TRISG9 = 0;   // set LD2 as output

    TRISEbits.TRISE8 = 1;   // LD1 button as input
    TRISEbits.TRISE9 = 1;   // LD2 button as input

    tmr_setup_period(TIMER1, 10);

    while (1){
        algorithm();
        
        // --- 1. read data --- //
        int data = uart1_read_char();

        if(data != RX_BUFFER_EMPTY){
            cmd[2] = data;
            char echo_str[2];
            echo_str[0] = (char) data;
            echo_str[1] = '\0'; // Null terminator
            uart1_write(echo_str);
        } 

        if((cmd[0] == 'L') && (cmd[1] == 'D')){
            if (cmd[2] == '1'){
                LATAbits.LATA0 ^= 1;    // XOR toggles the LED state (ON to OFF, OFF to ON)
            } else if (cmd[2] == '2'){
                blink_enable ^= 1;      // XOR toggles the LED state (ON to OFF, OFF to ON)
            }
        }
        
        cmd[0] = cmd[1];
        cmd[1] = cmd[2];

        // --- 2. blink --- //
        if (step == 40) {   // 40 ticks * 10ms = 400ms
            if (blink_enable == 1) LATGbits.LATG9 ^= 1;	
            step = 0;		// Reset the counter for the next 400ms phase
        }

        // --- 3. first button --- //
        if ((PORTEbits.RE8 == 0) && (RE8_prev == 1)){
            if (debRE8 == 0){
                formatWrite('C', charReceived, tx_string);
                uart1_write(tx_string);
                debRE8 = MAXDEBCYCLE;
                RE8_prev = 0;
            }else{
                debRE8--;
            }
        } else if ((PORTEbits.RE8 == 1) && (RE8_prev == 0)){
            if (debRE8 == 0){
                debRE8 = MAXDEBCYCLE;
                RE8_prev = 1;
            }else{
                debRE8--;
            }
        }

        // --- 4. second button --- //
        if ((PORTEbits.RE9 == 0)&& (RE9_prev == 1)){
            if (debRE9 == 0){
                formatWrite('D', deadlineMissed, tx_string);
                uart1_write(tx_string);
                debRE9 = MAXDEBCYCLE;
                RE9_prev = 0;
            }else{
                debRE9--;
            }
        } else if ((PORTEbits.RE9 == 1) && (RE9_prev == 0)){
            if (debRE9 == 0){
                debRE9 = MAXDEBCYCLE;
                RE9_prev = 1;
            }else{
                debRE9--;
            }
        }

        step++;

        // --- 5. missed deadlone check --- //
        if (tmr_wait_period(TIMER1) == TMREXP)
            deadlineMissed++;
    }
    return 0;
}

/*------------------------------------------------------------------------*/

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

    if(U1TX_buffer.idxR == U1TX_buffer.idxW){
        IEC0bits.U1TXIE = 0;
    }
}

void __attribute__((__interrupt__)) _U1RXInterrupt(void){
    IFS0bits.U1RXIF = 0; // clear interrupt flag

    if(U1STAbits.OERR == 1) U1STAbits.OERR = 0; // in case of error, discard everything (data loss)

    while(U1STAbits.URXDA){ // as long as there are data to read
        unsigned char received_byte = U1RXREG; 
        
        // assignment specific
        charReceived++;

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
