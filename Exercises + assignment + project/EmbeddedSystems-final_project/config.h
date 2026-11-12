#ifndef XC_HEADER_TEMPLATE_H
#define XC_HEADER_TEMPLATE_H

#include <xc.h> // include processor files - each processor file is guarded.  

void input_config(void);
void uart_config(void);
void spi_config(void);
unsigned int spi_write(unsigned int data);

void adc_config(int sampling, int conversion, int n_tad, int tad_length, int scan, int n_channels);
void pwm_config(int div, int pwm_fc);
void motor_pwm_pins_config(void);
void oc_config(int channel, int compare_mode);
void oc_set_duty(int channel, int duty_percent);

#endif  // XC_HEADER_TEMPLATE_H 