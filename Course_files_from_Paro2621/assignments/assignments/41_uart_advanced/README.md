# 41 – Advanced UART Communication

## Overview
This exercise combines UART communication, periodic timing, button inputs and LED control in a time-constrained embedded application.

## Assignment Tasks
- Simulate a computation lasting approximately **7 ms** inside a **100 Hz (10 ms)** loop.
- Blink LD2 at **2.5 Hz** (400 ms period).
- Receive UART1 characters and count them.
- Interpret the commands `LD1` (toggle LD1) and `LD2` (stop or resume LD2 blinking).
- On button T2, transmit `C=xx`, where `xx` is the received-character count.
- On button T3, transmit `D=yy`, where `yy` is the number of missed timer deadlines.

## Main Concepts
- UART1 interrupt-driven transmission and reception.
- Circular RX/TX buffers.
- Command parsing from a serial stream.
- Periodic execution and deadline monitoring.
- Button polling and debouncing.

## Main File
- `main.c` – contains the application logic and UART support implementation.

## Requirements
MPLAB X IDE, XC16 compiler, a compatible dsPIC33 board, two LEDs, buttons T2/T3 and a serial terminal.
