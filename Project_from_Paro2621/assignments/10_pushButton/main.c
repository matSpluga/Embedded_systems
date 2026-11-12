/**
 * @file main.c
 * @author ric
 * @date 2026-03-03
 * @brief Main function
 */

#include <xc.h>
#define LED_ON  1
#define LED_OFF 0

#define isPushed 0

int main(void) {
    // disable all Analog pins
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;

    // --- setup ---
    TRISAbits.TRISA0 = 0;   // set the pin as output
    TRISEbits.TRISE8 = 1;   // set the pin as input

    int LedState = LED_ON;
    
    // --- infinite loop ---
    while(1) {
        if(PORTEbits.RE8 == isPushed){ // 0 -> true
            if(LedState == LED_ON){
                LATAbits.LATA0 = LED_OFF; // Turn LED OFFs
                LedState = LED_OFF;
            } else {
                LATAbits.LATA0 = LED_ON; // Turn LED OFFs
                LedState = LED_ON;
            }

            for(int i=0; i<10000; i++){
                for(int j=0; j<1000; j++){
                
                }
            }
        }
    }
    return 0; 
}