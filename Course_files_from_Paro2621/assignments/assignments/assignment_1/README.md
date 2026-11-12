# Assignment 1 – IMU Acquisition and Attitude Estimation

## Overview
This assignment integrates UART and SPI communication with the **Bosch BMX055 IMU** on a dsPIC33 microcontroller. It periodically acquires accelerometer data, estimates roll and pitch angles, and sends sensor measurements and status information over UART.

## Main Functionality
- Configure UART1 and SPI1 using the board's mikroBUS connections.
- Initialize the BMX055 and wake up its magnetometer.
- Configure the accelerometer bandwidth through its register interface.
- Run a periodic main loop with a 10 ms (100 Hz) timer period.
- Read accelerometer X, Y and Z data.
- Convert raw accelerometer readings into acceleration values.
- Estimate roll and pitch using accelerometer measurements and trigonometric relations.
- Transmit accelerometer and angle information over UART.
- Parse serial commands to configure accelerometer bandwidth and output rate.
- Report invalid command values and missed deadlines.

## Serial Commands
The program recognizes command frames in the form `$XX,YY*`.

- `BW` selects the accelerometer bandwidth setting, with accepted values from 8 to 15.
- `HZ` selects the accelerometer message output rate. Supported values in the source are 0, 1, 2, 5 and 10 Hz.

The firmware also transmits accelerometer data (`$ACC`), attitude angles (`$ANG`) and missed-deadline information (`$MSD`).

## Source Files
- `main.c` – periodic execution, command parsing, sensor acquisition, attitude calculation and UART reporting.
- `BOSCH_BMX055.c` / `.h` – BMX055 configuration and sensor data reading.
- `spi.c` / `.h` – SPI setup and transfers.
- `uart.c` / `.h` – buffered UART communication and interrupt handlers.
- `button.c` / `.h` – button handling.
- `timer.c` / `.h` – periodic timing utilities.

## Requirements
MPLAB X IDE, XC16 compiler, compatible dsPIC33 board, BMX055 IMU connected through SPI and a UART serial terminal.

## Notes
The source contains a comment about a deliberate override of the sensor data-ready waiting interval to match the assignment requirements. Consult `main.c` and the BMX055 datasheet when changing this behavior.
