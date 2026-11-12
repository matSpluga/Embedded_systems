# 20 – Hardware Timer Basics

## Overview
This exercise introduces periodic timing on the dsPIC33 using the timer utility declared in `timer.h`.

## Functionality
The program demonstrates two approaches to LED timing:
- Configure **TIMER1** with a 200 ms period and toggle LED LD1 after each timer period.
- Use `tmr_wait_ms()` to generate explicit ON and OFF intervals for LD1.

The source contains an alternative implementation (`main_1`) as well as the active `main()` function.

## Main Files
- `main.c` – LED timing examples.
- `timer.c` / `timer.h` – timer configuration and waiting functions.

## Timer API
- `tmr_setup_period(timer, ms)` configures a timer period.
- `tmr_wait_period(timer)` waits for the configured period and checks whether it has already expired.
- `tmr_wait_ms(timer, ms)` waits for a specified duration.

## Requirements
MPLAB X IDE, the XC16 compiler and a compatible dsPIC33 board.

## How to Run
Open the project in MPLAB X, build it for the target board, program the microcontroller and observe LD1.
