# 40 – Basic UART Communication

## Overview
This exercise introduces asynchronous serial communication using **UART1** on a dsPIC33 microcontroller.

## Main Topics
- UART1 configuration, including baud-rate generation.
- UART transmit and receive operations.
- UART receive and transmit interrupts.
- Circular buffers for incoming and outgoing characters.
- Character echo and basic serial communication.

The source includes basic and advanced examples; comments in the code indicate that the two alternative implementations should not be enabled simultaneously when building.

## Main File
- `main.c` – UART setup, communication routines and exercise logic.

## Requirements
- MPLAB X IDE and XC16 compiler.
- Compatible dsPIC33 development board.
- USB-to-UART or board serial connection and a serial terminal configured with the baud rate selected in the source.

## How to Run
Build and flash the project, open the corresponding serial port in a terminal, and send/receive characters to test the UART implementation.
