#include "adc.h"


void adc_init(int sample, int conversion) {

    AD1CON1bits.ADON = 0; 

    AD1CON1bits.AD12B = 0b00; // Output format: 10-bit

    ANSELBbits.ANSB11 = 1;    // Set RB11 as analog input (Battery)
    TRISBbits.TRISB11 = 1;    // Set RB11 as input

    ANSELBbits.ANSB15 = 1;    // Set RB15 as analog input (IR Sensor)
    TRISBbits.TRISB15 = 1;    // Set RB15 as input

    if(sample == 0 && conversion == 0){
        AD1CON1bits.SSRC = 0b000;
        AD1CON1bits.ASAM = 0;
    } else if(sample == 0 && conversion == 1){
        AD1CON1bits.SSRC = 0b111;
        AD1CON3bits.SAMC = 16; // Sample time in TAD
        AD1CON1bits.ASAM = 0;
    } else if(sample == 1 && conversion == 0){
        AD1CON1bits.SSRC = 0b000;
        AD1CON1bits.ASAM = 1;
    } else if(sample == 1 && conversion == 1){
        AD1CON1bits.SSRC = 0b111;
        AD1CON3bits.SAMC = 16; // Sample time in TAD
        AD1CON1bits.ASAM = 1;
    } 
    else {
        AD1CON1bits.SSRC = 0b111;
        AD1CON1bits.ASAM = 1;
    }

    AD1CON1bits.ADON = 1; 
}

float adc_read_manual_manual(void) {
    
    AD1CON1bits.SAMP = 1;     // Start sampling

    for(volatile int i = 0; i < 1000; i++); 
    
    AD1CON1bits.SAMP = 0;     // Stop sampling
    while (!AD1CON1bits.DONE); // Wait conversion
    
    return ADC1BUF0;           
}

float adc_read_manual_auto(void) {

    AD1CON1bits.SAMP = 1;

    while (!AD1CON1bits.DONE);
    return ADC1BUF0;
}

float adc_scan_auto(uint8_t channel){

    switch(channel) {
        case 11:
            AD1CHS0bits.CH0SA = 11; // RB11 for ADC input
            break;
        case 15:
            AD1CHS0bits.CH0SA = 15; // RB15 for ADC input
            break;
        default:
            AD1CHS0bits.CH0SA = 11;
    }

    AD1CON1bits.DONE = 0;
    
    while(!AD1CON1bits.DONE);
    
    return ADC1BUF0;
}

void adc_data_converter(adcState *adc_ptr){
    float raw_batt = adc_ptr->battery_voltage;
    float raw_ir = adc_ptr->ir_distance;

    adc_ptr->battery_voltage = (raw_batt / 1024.0f) * 3.3f * 3.0f; 
    
    float ir_pin_voltage = (raw_ir / 1024.0f) * 3.3f; 
    float ir_result = 2.34 - (4.74 * ir_pin_voltage) 
                            + (4.06 * powf(ir_pin_voltage, 2)) 
                            - (1.60 * powf(ir_pin_voltage, 3)) 
                            + (0.24 * powf(ir_pin_voltage, 4));

    adc_ptr->ir_distance = ir_result * 100.0;
}