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

    // === INITIALIZATION ===
    pwm_init();

    int move_state = 0;

    // Structure to monitor the status of the button
    static ButtonState btn;
    button_init(&btn);
    
    while (1){

        if(button_has_just_been_pressed(&btn, PORTEbits.RE8) && move_state == 0){

            execute_motion(0, 100, 100);
            move_state = 1;
        }
    }   
    return 0;
}