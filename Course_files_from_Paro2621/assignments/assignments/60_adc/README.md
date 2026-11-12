# 60 – Analog-to-Digital Conversion (ADC)

## Overview
This exercise uses the dsPIC33 ADC module to acquire analog measurements from the battery-voltage input and an infrared (IR) distance sensor.

## Functionality
- Configure the ADC for 10-bit conversions.
- Read the battery measurement from analog channel 11.
- Read the IR sensor from analog channel 15.
- Convert raw ADC readings into physical quantities.
- Periodically transmit the battery voltage and estimated distance over UART.

The main loop samples at approximately 1 ms intervals and reports converted values periodically.

## Source Files
- `main.c` – ADC sampling loop and serial reporting.
- `adc.c` / `adc.h` – ADC configuration, conversion routines and measurement conversion.
- `uart.c` / `uart.h` – UART communication.
- `timer.c` / `timer.h` – timing utilities.
- `button`, `spi` and BMX055 files – supporting peripheral modules included in the project.

## Output
The application formats the converted measurements as a serial text message containing battery voltage (V) and IR distance (cm).

## Requirements
MPLAB X IDE, XC16 compiler, compatible dsPIC33 board, battery-voltage and IR sensor analog inputs, and a UART serial terminal.
