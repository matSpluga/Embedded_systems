/**
 * @file main.c
 * @author ric
 * @date 2026-03-18
 * @brief Main function
 * 
 * flash uC: sudo mikroe-uhb -v --vendor=0x2dbc --product=0x0001 default-production.hex
*/

/* ASSIGNMENT 3
 * 1. Blink LD1 led at 1 Hz frequency (500ms time on, 500ms off) without using interrupts; 
 *     then make LD2 blink at 2 Hz frequency using interrupts.
 * 
 * 2. Blink LD1 led at 1 Hz frequency (500ms time on, 500ms off) without using interrupts; 
 *     every time the button T2 is pressed, toggle the led LD2 using interrupts.
 * 
*/

#include "timer.h"
#include <xc.h>

#define MAXITER 1000

#define LED_ON  1
#define LED_OFF 0

int c_TL1 = 0; // [could have also be defined inside the main] cumulative timer led 1 - (1 Hz)
int c_TL2 = 0; // cumulative timer led 2 - (2 Hz)

int main() {
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;

    TRISAbits.TRISA0 = 0;   // set LD1 as output 
    TRISGbits.TRISG9 = 0;   // set LD2 as output 

    tmr_setup_period(TIMER1, 100);
    tmr_setup_period(TIMER2, 100);

    IEC0bits.T2IE = 1; // enable interrupt 2
    
    /* Note:
     * Only enable the interrupt that you need, otherwise the uC will 
     * crash looking for an ISR that does not exists 
    */
    
    for(int it = 0; it<MAXITER; it++) {
        
        tmr_wait_period(TIMER1);
        c_TL1++;

        if (c_TL1 >= 5) {           // 5 ticks * 100ms = 500ms
            LATAbits.LATA0 ^= 1;    // XOR toggles the LED state (ON to OFF, OFF to ON)
            c_TL1 = 0;              // Reset the counter for the next 500ms phase
        }     
    }
}

void __attribute__((interrupt)) _T2Interrupt(void) {
    // 1. Perform the required urgent action
    c_TL2++;

    if (c_TL2 >= 10) {          // 10 ticks * 100ms = 1000ms
        LATGbits.LATG9 ^= 1;    // XOR toggles the LED state (ON to OFF, OFF to ON)
        c_TL2 = 0;              // Reset the counter for the next 500ms phase
    }   

    // 2. Clear the interrupt flag, otherwise the ISR will trigger again infinitely.
    IFS0bits.T2IF = 0;
}