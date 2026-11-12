# 51 – SPI Communication with the BMX055 (Modular Version)

## Overview
This folder provides a modular version of the SPI sensor exercise. SPI, UART, button handling and utility functions are separated into reusable modules.

## Functionality
- Configure SPI1 as an 8-bit master.
- Configure the SPI pins and chip-select lines for the BMX055.
- Set the SPI clock mode required by the Bosch sensor.
- Wake up the magnetometer.
- Read sensor registers, including the magnetometer X-axis.
- Send measurements over UART using the `$MAGX=xxx` message format.

## Source Files
- `main.c` – application sequence and periodic sensor reporting.
- `spi.c` / `spi.h` – SPI initialization and byte transfer.
- `BOSCH_BMX055.c` / `BOSCH_BMX055.h` – sensor setup and data acquisition.
- `uart.c` / `uart.h` – buffered UART communication.
- `button.c` / `button.h` – button state handling.
- `timer.c` / `timer.h` – timing utilities.
- `utils.c` / `utils.h` – helper functions.

## Requirements
MPLAB X IDE, XC16 compiler, compatible dsPIC33 board, BMX055 sensor and UART serial terminal.
