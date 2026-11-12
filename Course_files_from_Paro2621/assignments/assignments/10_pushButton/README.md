# 10 – Push Button and LED Toggle

## Overview
This exercise introduces basic digital I/O on a Microchip dsPIC33 microcontroller. A push button connected to input pin **RE8** controls an LED connected to output pin **RA0**.

## Functionality
- Configure the relevant pins as digital I/O.
- Set RA0 as an output and RE8 as an input.
- Read the button state continuously.
- Toggle the LED state when the button is pressed.
- Use a software delay loop to reduce repeated toggling while the button remains pressed.

## Main File
- `main.c` – contains the pin configuration and the main button-reading loop.

## Requirements
- MPLAB X IDE and the XC16 compiler.
- A compatible dsPIC33 development board.
- A push button connected to RE8 and an LED on RA0.

## Notes
This is a basic polling-based implementation. The delay is implemented as a nested software loop rather than a hardware timer or interrupt.
