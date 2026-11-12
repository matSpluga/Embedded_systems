#ifndef ADC_H
#define ADC_H

#include <xc.h>
#include <stdint.h>
#include <stdbool.h>
#include "timer.h"
#include <math.h>

#define MANUAL 0
#define AUTO   1

typedef struct{
    float battery_voltage;
    float ir_distance;
} adcState;

extern adcState adc;

void adc_init(int sample, int conversion, uint8_t channel);
float adc_read_manual_manual(void);
float adc_read_manual_auto(void);

float adc_scan_auto(void);

void adc_data_converter(adcState *adc_ptr);

#endif // ADC_H