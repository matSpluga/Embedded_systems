# 72 – PWM Differential-Drive Command Interface

## Overview
This exercise extends the motor PWM driver by using a speed-and-yaw command interface for differential-drive motion.

## Functionality
- Initialize the four PWM channels used by the motor driver.
- Detect a debounced press of button T2 (RE8).
- Issue a motion request through `execute_motion(speed, yaw, magnitude)`.
- Use the PWM driver to combine linear and angular command components into left- and right-motor actuation.

The current `main.c` starts a motion command after the button press. The implementation of the motion mapping is encapsulated in `pwm.c`.

## Source Files
- `main.c` – initializes the PWM driver and triggers the motion command.
- `pwm.c` / `pwm.h` – PWM configuration, duty-cycle limiting and differential-drive command mapping.
- `button.c` / `button.h` – button debounce support.
- ADC, UART, SPI, timer and BMX055 modules – supporting drivers included in the folder.

## Requirements
MPLAB X IDE, XC16 compiler, compatible dsPIC33 board and a motor driver connected to the configured PWM outputs.
