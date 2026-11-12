# 50 – SPI Communication with the BMX055 Magnetometer

## Overview
This exercise introduces the **Serial Peripheral Interface (SPI)** on a dsPIC33 and uses it to communicate with the magnetometer in the Bosch BMX055 inertial measurement unit.

## Exercises
1. Implement an SPI transfer function that transmits a value and returns the received value.
2. Configure SPI in master mode and 8-bit format.
3. Switch the magnetometer from its suspended state to sleep mode and then to active mode.
4. Read the magnetometer Chip ID and send it over UART.
5. Read the magnetometer X-axis value and transmit it over UART at **10 Hz**, using the `$MAGX=xxx*` message format.

## Main Concepts
- SPI pin remapping and chip-select control.
- SPI master configuration and clock polarity/phase.
- Full-duplex SPI transfers.
- BMX055 register access and sensor wake-up sequence.
- UART output of sensor data.

## Main File
- `main.c` – SPI setup, sensor register transactions and UART reporting.

## Requirements
MPLAB X IDE, XC16 compiler, dsPIC33 board, BMX055 sensor hardware and UART serial terminal.
