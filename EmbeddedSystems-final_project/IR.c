#include <xc.h>
#include "IR.h"
#include "config.h"

/*
 Converts the IR sensor voltage to a distance.
 The output of the IR sensor is not linear with respect to the distance.
 The numbers used in this function are the coefficients of a 4th-degree 
 polynomial regression that approximates the non-linear response curve 
 of the sensor, mapping the analog voltage directly to a distance value.
 */
static double convert_ir_voltage_to_distance(double v_ir) {
    double v_ir_2 = v_ir * v_ir;
    double v_ir_3 = v_ir_2 * v_ir;
    double v_ir_4 = v_ir_3 * v_ir;
    
    double distance = 2.34 
                    - (4.74 * v_ir) 
                    + (4.06 * v_ir_2) 
                    - (1.60 * v_ir_3) 
                    + (0.24 * v_ir_4);
                    
    return distance;
}

// Read IR sensor (Manual/Auto) 
double read_distance(void) {
    // Config: sampling=0 (manual), conversion=7 (auto), n_tad=16, tad_len=8 
    adc_config(0, 7, 16, 8, 0, 0);
    AD1CHS0bits.CH0SA = 5;       // AN5 (RB5) 
    
    AD1CON1bits.SAMP = 1;        // Start sampling 
    
    while (!AD1CON1bits.DONE);
    double v_ir = (ADC1BUF0 / 1023.0) * 3.3;
 
    return convert_ir_voltage_to_distance(v_ir);
}

/* 
 This function performs an active scan 
 It can be called every cycle to update the data
 */
void scan_read(float* battery, double* distance) {
    // Configure manual scan (sampling=1, conversion=7 for rapid auto-convert) 
    // Using SSRC=7 starts rapid scan of AN5 and AN11 
    adc_config(1, 7, 16, 8, 1, 2); 

    AD1CSSL = 0;
    AD1CSSLbits.CSS5 = 1;  // IR 
    AD1CSSLbits.CSS11 = 1; // Battery 

    // Start the scan 
    AD1CON1bits.SAMP = 1; 
    
    // Wait for both channels to complete 
    while (!AD1CON1bits.DONE);
    
    int raw_ir = ADC1BUF0;
    int raw_bat = ADC1BUF1;
#include <xc.h>
#include "IR.h"
#include "config.h"

/*
 Converts the IR sensor voltage to a distance.
 The output of the IR sensor is not linear with respect to the distance.
 The numbers used in this function are the coefficients of a 4th-degree 
 polynomial regression that approximates the non-linear response curve 
 of the sensor, mapping the analog voltage directly to a distance value.
 */
static double convert_ir_voltage_to_distance(double v_ir) {
    double v_ir_2 = v_ir * v_ir;
    double v_ir_3 = v_ir_2 * v_ir;
    double v_ir_4 = v_ir_3 * v_ir;
    
    double distance = 2.34 
                    - (4.74 * v_ir) 
                    + (4.06 * v_ir_2) 
                    - (1.60 * v_ir_3) 
                    + (0.24 * v_ir_4);
                    
    return distance;
}

// Read IR sensor (Manual/Auto) 
double read_distance(void) {
    // Config: sampling=0 (manual), conversion=7 (auto), n_tad=16, tad_len=8 
    adc_config(0, 7, 16, 8, 0, 0);
    AD1CHS0bits.CH0SA = 5;       // AN5 (RB5) 
    
    AD1CON1bits.SAMP = 1;        // Start sampling 
    
    while (!AD1CON1bits.DONE);
    double v_ir = (ADC1BUF0 / 1023.0) * 3.3;
 
    return convert_ir_voltage_to_distance(v_ir);
}

/* 
 This function performs an active scan 
 It can be called every cycle to update the data
 */
void scan_read(float* battery, double* distance) {
    // Configure manual scan (sampling=1, conversion=7 for rapid auto-convert) 
    // Using SSRC=7 starts rapid scan of AN5 and AN11 
    adc_config(1, 7, 16, 8, 1, 2); 

    AD1CSSL = 0;
    AD1CSSLbits.CSS5 = 1;  // IR 
    AD1CSSLbits.CSS11 = 1; // Battery 

    // Start the scan 
    AD1CON1bits.SAMP = 1; 
    
    // Wait for both channels to complete 
    while (!AD1CON1bits.DONE);
    
    int raw_ir = ADC1BUF0;
    int raw_bat = ADC1BUF1;

    // Convert the data 
    *battery = (raw_bat / 1023.0) * 3.3 * 3.0;
    double v_ir = (raw_ir / 1023.0) * 3.3;
    *distance = convert_ir_voltage_to_distance(v_ir);
    
    // Turn off to save power or reset state 
    AD1CON1bits.ADON = 0; 
}

#define CS_ACC LATBbits.LATB3

void init_accelerometer() {
    CS_ACC = 0;
    spi_write(0x0F); 
    spi_write(0x03); //Sets accelerometer range to +-2g.
    CS_ACC = 1;
}

void set_bandwidth(int bw_val) {
    CS_ACC = 0;
    spi_write(0x10);  
    spi_write(bw_val); 
    CS_ACC = 1;
}