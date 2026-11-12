# Embedded Systems – Final Project

## Project Overview

This project implements embedded firmware for a small differential-drive mobile robot (buggy) using a **Microchip dsPIC33 microcontroller**.

The firmware brings together motor control, analog sensor acquisition, UART communication, periodic execution and basic robot-state handling. The current `main.c` implements a 500 Hz control loop, drives two motors through PWM signals, reads an infrared distance sensor and the battery voltage, and exchanges commands and telemetry over UART.

## Main Features

### 1. Differential-Drive Motor Control
- Four Output Compare channels (OC1–OC4) generate the motor drive PWM signals.
- PWM frequency is configured to **10 kHz**.
- `set_motor_pwm(left_pwm, right_pwm)` accepts signed left- and right-wheel commands.
- Each command is saturated to the range **-100% to +100%**.
- Positive and negative values select the corresponding direction output for each motor.

### 2. Periodic Main Loop
- Timer 1 is configured for a **2 ms period**, corresponding to a nominal **500 Hz** loop.
- The main loop updates the robot state, lights and motor outputs.
- Sensor acquisition and related UART telemetry are executed every 50 loop iterations, i.e. at **10 Hz**.
- A separate counter sends battery measurements once every ten sensor cycles, i.e. at **1 Hz**.

### 3. Sensors and ADC
The ADC scan reads two analog channels:
- **AN5:** infrared distance sensor.
- **AN11:** battery-voltage measurement.

The battery reading is scaled by a factor of 3 to account for the voltage-sensing circuit. The IR sensor voltage is converted to distance using a fourth-degree polynomial approximation implemented in `IR.c`.

The project also contains functions for reading the battery independently and for initializing/configuring the BMX055 accelerometer over SPI.

### 4. UART Communication
UART1 is configured for serial communication and uses interrupt-driven transmission and reception with circular buffers.

The main application handles the following message formats:

| Message | Direction | Purpose |
|---|---|---|
| `$PCREF,speed,yawrate*` | PC → robot | Set the linear speed and yaw-rate command values. |
| `$MDIST,value*` | Robot → PC | Send the measured IR distance. |
| `$MANGLE,0,0,0*` | Robot → PC | Send the angle message; the current main loop transmits placeholder zero values. |
| `$MBATT,value*` | Robot → PC | Send the battery voltage, approximately once per second. |
| `$MBUF,tx,rx*` | Robot → PC | Report the number of available bytes in the TX and RX software buffers when button RE9 is released. |

Messages are delimited by `$` at the beginning and `*` at the end. The UART receive interrupt places incoming characters in the RX circular buffer; the main loop parses complete messages.

### 5. Operating States and Indicators
The main application defines three states:
- **HALTED:** motors are stopped and the two lateral lights blink.
- **MOVING:** the low light is enabled and the motor commands are calculated as `left = speed - yawrate` and `right = speed + yawrate`.
- **OBSTACLE_AVOIDANCE:** a state is declared, but the obstacle-avoidance behavior in the current `main.c` is still marked as TODO.

Button behavior in the current `main.c`:
- **RE8:** toggles between HALTED and MOVING; if the obstacle-avoidance state is active, it forces HALTED.
- **RE9:** sends the `$MBUF,tx,rx*` buffer-status message.

LED A0 blinks at 1 Hz as an indication that the main loop is running.

> **Implementation note:** `state.c` and `state.h` contain a separate state-machine implementation with a timed obstacle-avoidance sequence. However, the current `main.c` does not call `state_init()` or `state_update()`; its state handling is implemented locally, and the obstacle-avoidance branch remains unfinished there.

## Repository Structure

```text
EmbeddedSystems-final_project/
├── main.c                # Main application loop and message parsing
├── config.c / config.h   # MCU peripheral and pin configuration
├── pwm.c / pwm.h         # Motor PWM initialization and control
├── timer.c / timer.h     # Timer period and wait utilities
├── UART.c / UART.h       # UART setup, interrupts and string transmission
├── circular_buffer.c/.h  # Circular buffers for UART RX and TX
├── IR.c / IR.h           # IR distance acquisition and ADC scan
├── battery.c / battery.h # Battery-voltage acquisition
└── state.c / state.h     # Separate buggy state-machine implementation
```

## How to Build and Run

1. Open the firmware project in **MPLAB X IDE**.
2. Select the correct dsPIC33 device and toolchain configuration for the target hardware.
3. Ensure that all `.c` source files are included in the project.
4. Build the project using the **Microchip XC16 compiler**.
5. Program the microcontroller and connect the UART interface to a serial terminal or the companion PC application.
6. Send commands using the `$PCREF,speed,yawrate*` format and monitor the telemetry messages.

The ZIP contains source and header files; it does not include a complete MPLAB project configuration. Device selection, clock configuration and hardware pin compatibility should therefore be checked in the local MPLAB project before programming.

## Hardware and Software Requirements

- Microchip dsPIC33 microcontroller board compatible with the peripheral registers used in the source.
- MPLAB X IDE.
- Microchip XC16 compiler.
- Motor driver and two DC motors connected to the four PWM outputs.
- Infrared distance sensor connected to AN5.
- Battery-voltage sensing circuit connected to AN11.
- Buttons connected to RE8 and RE9.
- UART connection to a PC or serial terminal.

The firmware also contains SPI configuration and BMX055 accelerometer helper functions.

## Notes and Current Limitations

- The `$MANGLE` telemetry currently contains fixed zero values; attitude estimation is not implemented in the active main loop.
- The `STATE_OBSTACLE_AVOIDANCE` branch in `main.c` contains a TODO rather than an active avoidance sequence.
- A more complete timed obstacle-avoidance state machine is present in `state.c`, but it is not integrated into `main.c` in the supplied source.
- The IR distance conversion uses a polynomial approximation; its accuracy depends on the sensor and calibration range.
- Verify the pin mapping, peripheral configuration, oscillator frequency and motor-driver wiring against the exact target board before running the firmware.

## Authors

The source files include individual author comments in some modules. No complete project author list is specified in the supplied source archive.
