# 70 – PWM Motor Output

## Overview
This exercise introduces motor actuation using the dsPIC33 **Output Compare (OC) modules** configured for Pulse Width Modulation (PWM).

## Functionality
- Configure four PWM channels for the left and right motor drive signals.
- Set the PWM base frequency to **10 kHz**.
- Initialize all motor outputs with zero duty cycle for a safe stopped state.
- Read button T2 (RE8) and alternate between stopping and driving forward.
- Set the motor duty cycles through the Output Compare registers.

## Source Files
- `main.c` – button-controlled start/stop behavior and PWM pin mapping.
- `pwm.c` / `pwm.h` – PWM initialization, duty-cycle calculation and motion commands.
- `button.c` / `button.h` – button debounce support.
- `timer`, `uart`, `adc`, `spi` and BMX055 modules – supporting drivers included in the project.

## Requirements
MPLAB X IDE, XC16 compiler, compatible dsPIC33 board, motor driver/H-bridge and motors connected to the configured PWM outputs.
