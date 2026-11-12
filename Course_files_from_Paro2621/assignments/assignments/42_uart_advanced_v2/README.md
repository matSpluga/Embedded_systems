# 42 – Advanced UART Communication (Modular Version)

## Overview
This folder contains a modular implementation of the advanced UART exercise. It separates UART handling, button state management and utility functions into dedicated source and header files.

## Assignment Tasks
- Run a simulated 7 ms computation in a 100 Hz loop.
- Blink LD2 at 2.5 Hz and allow the blinking to be paused or resumed.
- Receive and count UART1 characters.
- Interpret `LD1` and `LD2` commands.
- Send the character count (`C=xx`) when T2 is pressed.
- Send the missed-deadline count (`D=yy`) when T3 is pressed.

## Source Files
- `main.c` – application loop, command handling and task coordination.
- `basic_uart.c` / `basic_uart.h` – UART configuration and buffered communication.
- `button.c` / `button.h` – button state and debounce handling.
- `timer.c` / `timer.h` – periodic timing utilities.
- `utils.c` / `utils.h` – shared helper functions.

## Design Notes
The code uses structures for button state, shared variables for interrupt/main communication, and short interrupt service routines. The modular layout makes peripheral code easier to reuse.

## Requirements
MPLAB X IDE, XC16 compiler, compatible dsPIC33 hardware, LEDs, buttons T2/T3 and a UART serial terminal.
