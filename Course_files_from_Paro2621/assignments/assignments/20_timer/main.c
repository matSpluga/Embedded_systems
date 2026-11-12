/**
 * @file main.c
 * @author ric
 * @date 2026-03-05
 * @brief Main function
 * 
 * flash uC: sudo mikroe-uhb -v --vendor=0x2dbc --product=0x0001 default-production.hex
*/

#include "timer.h"
#include <xc.h>

#define MAXITER 1000

#define LED_ON  1
#define LED_OFF 0

int main_1() {
    // disable all Analog pins
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;

    TRISAbits.TRISA0 = 0;   // set the pin as output [LD1]
    
    tmr_setup_period(TIMER1, 200);
    
    for(int it = 0; it<MAXITER; it++){

        if(LATAbits.LATA0 == 1){
            LATAbits.LATA0 = LED_OFF; // Turn LED OFF
        } else {
            LATAbits.LATA0 = LED_ON; // Turn LED On
        }

        tmr_wait_period(TIMER1);
    }

    while(1){
        LATAbits.LATA0 = LED_ON; // Turn LED On
    }
}

int main() {
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;

    TRISAbits.TRISA0 = 0;   // set the pin as output [LD1]
    
    for(int it = 0; it<MAXITER; it++) {
        LATAbits.LATA0 = LED_ON;
        tmr_wait_ms(TIMER2, 20);

        LATAbits.LATA0 = LED_OFF;
        tmr_wait_ms(TIMER2, 200);
    }
}