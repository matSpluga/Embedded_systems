# 71 – PWM Motor Motion Commands

## Overview
This exercise builds on the PWM motor-output setup and introduces named motion commands for controlling a differential-drive platform.

## Functionality
- Configure four 10 kHz PWM outputs for the motor driver.
- Use button T2 (RE8) to alternate between a motion command and stopping.
- Call `execute_motion()` with predefined commands such as `TURN_RIGHT_FORWARD` and `STOP_MOTION`.
- Encapsulate motor direction and duty-cycle handling in the PWM driver.

## Source Files
- `main.c` – button-controlled motion-state selection.
- `pwm.c` / `pwm.h` – PWM setup and predefined motion commands.
- `button.c` / `button.h` – button debounce logic.
- Additional timer, UART, ADC, SPI and BMX055 modules are included as supporting drivers.

## Requirements
MPLAB X IDE, XC16 compiler, compatible dsPIC33 board, H-bridge motor driver and a differential-drive motor setup.
