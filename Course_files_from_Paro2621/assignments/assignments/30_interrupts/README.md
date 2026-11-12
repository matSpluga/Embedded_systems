# 30 – Timer and External Interrupts

## Overview
This exercise explores interrupt-driven embedded programming on a dsPIC33. It compares periodic LED control using polling with LED control triggered by hardware interrupts.

## Exercises
1. Blink LD1 at 1 Hz without interrupts and blink LD2 at 2 Hz using a timer interrupt.
2. Keep LD1 blinking at 1 Hz and toggle LD2 when button T2 is pressed, using an interrupt.

## Main Concepts
- Timer configuration and interrupt enable flags.
- External interrupt input mapping.
- Interrupt service routines (ISRs).
- Clearing interrupt flags after servicing an interrupt.
- Separation between polling-based and interrupt-driven tasks.

## Main Files
- `main.c` – configures the LEDs, timers and interrupt sources.
- `timer.c` / `timer.h` – timer helper functions.

## Requirements
MPLAB X IDE, XC16 compiler and a compatible dsPIC33 development board.

## How to Run
Build and flash the project, then observe LD1 and LD2. The expected behavior depends on the exercise configuration in `main.c`.
