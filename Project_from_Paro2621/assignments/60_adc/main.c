#include <xc.h>
#include <math.h>
#include <stdio.h>

#include "timer.h" 
#include "uart.h"
#include "adc.h"
#include "button.h"
#include "spi.h"
#include "BOSCH_BMX055.h"

char tx_buffer[128];

adcState adc;

int main(){
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;

    uart1_mikrobus2_setup();   
    
    adc_init(1, 1);
    adc_init(1, 1);
 
    int steps = 0;
    
    while (1){

        tmr_wait_ms(TIMER2, 1);
        adc.battery_voltage = adc_scan_auto(11); 
        adc.ir_distance     = adc_scan_auto(15);

        if(steps >= 100 && steps % 100 == 0){ 

            adc_data_converter(&adc);

            sprintf(tx_buffer, "$SENS: %.2f V, %.1f cm\n\r", adc.battery_voltage, adc.ir_distance); 
            uart1_write(tx_buffer);

        }
        steps++;
    }   
    return 0;
}