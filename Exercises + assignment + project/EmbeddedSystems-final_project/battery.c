#include <xc.h>
#include "battery.h"
#include "config.h"
#include "timer.h"

// Read battery voltage
float read_battery(void) {
    // Config: sampling=0 (manual), conversion=0 (manual)
    adc_config(0, 0, 0, 0, 0, 0); 
    AD1CHS0bits.CH0SA = 11;      // Select AN11
    
    AD1CON1bits.SAMP = 1;        // Start sampling
    tmr_wait_ms(TIMER2, 2);      
    AD1CON1bits.SAMP = 0;        // End sampling
    
    while (!AD1CON1bits.DONE);   // Wait until conversion done
    return (ADC1BUF0 / 1023.0) * 3.3 * 3.0;
}
