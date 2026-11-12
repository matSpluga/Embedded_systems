#import "/setup.typ": *

#pagebreak()
= Debouncing pattern: Interrupts and PPS

#set text(size: 8pt)
#zebraw(```c
#include <xc.h>
#include "timer.h"

void __attribute__((interrupt)) _INT1Interrupt(){
    IFS1bits.INT1IF = 0;  // Clear INT1 flag
    IEC0bits.T2IE = 1;    // Enable T2Interrupt
    tmr_setup_period(TIMER2, 10);
}

void __attribute__((interrupt)) _T2Interrupt(){
    IFS0bits.T2IF = 0;    // Clear Timer 2 flag
    IEC0bits.T2IE = 0;    // Disable Timer 2 interrupt
    T2CONbits.TON = 0;    // Turn off Timer 2

    if (PORTEbits.RE8 == 1) {
        LATAbits.LATA0 ^= 1;
    }
}

int main() {
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;

    TRISAbits.TRISA0 = 0;   // set the pin RA0 as output
    TRISEbits.TRISE8 = 1;   // set the pin RE8 as input

    RPINR0bits.INT1R = 0b1011000;
    IFS1bits.INT1IF = 0; // clear interrupt flag
    IEC1bits.INT1IE = 1; // enable interrupt

    while(1){}
}
```)
#set text(size: 8pt)