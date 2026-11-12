#include <xc.h>
#include <math.h>
#include <stdio.h>

#include "timer.h" 
#include "uart.h"
#include "adc.h"
#include "button.h"
#include "pwm.h"
#include "spi.h"
#include "BOSCH_BMX055.h"

#define isPushed 0

int main(){
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;

    // RD1 and RD3 mapping (backward)
    RPOR0bits.RP65R = 0x10;  // RD1 left
    RPOR1bits.RP67R = 0x12;  // RD3 right

    // RD2 and RD4 mapping (forward)
    RPOR1bits.RP66R = 0x11;     // RD2 left
    RPOR2bits.RP68R = 0x13;     // RD4 right

    // === INITIALIZATION ===
    pwm_init();

    int move_state = 0;

    // Structure to monitor the status of the button
    static ButtonState btn;
    button_init(&btn);
    
    while (1){

        if(button_has_just_been_pressed(&btn, PORTEbits.RE8)){

            move_state++;

            // If it's moving 
            if(move_state > 1){
                move_state = 0;
            }

            switch(move_state) {

                case 0: // Stop
                    OC1R = 0;
                    OC2R = 0;
                    OC3R = 0;
                    OC4R = 0;
                    break;
                    
                case 1: // Move forward
                    OC1R = 0;
                    OC2R = pwm_set_duty_cycle(100, OC2RS);
                    OC3R = 0;
                    OC4R = pwm_set_duty_cycle(100, OC4RS); 
                    break;
                    
                default:
                    break;
            }
        }
    }   
    return 0;
}