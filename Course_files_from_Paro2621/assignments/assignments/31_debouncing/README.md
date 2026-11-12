# 31 – Push-Button Debouncing with Interrupts

## Overview
This exercise implements a simple interrupt-based button debounce mechanism on a dsPIC33.

## Operation
- The external interrupt **INT1** is mapped to the button input.
- When a button event is detected, the INT1 ISR clears its flag and starts TIMER2 with a 10 ms period.
- The TIMER2 ISR stops the timer and checks the input state.
- If the button is still in the expected pressed state, LED LD1 is toggled.

This two-stage approach avoids reacting immediately to short electrical transitions caused by mechanical button bounce.

## Main File
- `main.c` – contains the INT1 and TIMER2 interrupt service routines and the hardware initialization.

## Supporting Files
- `timer.c` / `timer.h` – timer configuration and waiting utilities included in the project.

## Requirements
MPLAB X IDE, XC16 compiler and a compatible dsPIC33 board with a button connected to the configured INT1 input and an LED on RA0.
