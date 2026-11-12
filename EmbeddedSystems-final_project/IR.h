#ifndef IR_H
#define IR_H

#include <xc.h>

// Reads IR distance 
double read_distance(void);

// Scans both IR and Battery 
void scan_read(float* battery, double* distance);

// SPI accelerometer initialization
void init_accelerometer(void);
void set_bandwidth(int bw_val);

#endif