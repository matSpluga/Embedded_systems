#import "/setup.typ": *

#pagebreak()

= Lesson 3.1: Oscillator
An electronic oscillator is an electronic circuit that converts direct current energy into a periodic, alternating current signal. The most common variation is the crystal oscillator, in which the output frequency is governed by a piezoelectric resonator, typically a vibrating quartz crystal. In digital electronics, this circuit is widely used to provide a precise periodic signal to a microcontroller to act as its system clock.

== Oscillator Circuit for dsPIC33

#grid(
    columns: (1fr, 1fr),
    align: center + horizon,

    [#align(center, image("../images/30/oscillatorCircuit.png", width: 86%))],
    [#align(center, image("../images/30/clockSelection.png", width: 100%)) 
    #blueBox[MikroE `clicker2` for dsPIC33 board has an XT oscillator at 8MHz, we will use this configuration with PLL (Oscillator Source: S3)]]
)

=== Clock System Architecture:
- *Multiplexed Clock Sources:* Four distinct time bases to drive the system clock (*`FOSC`*):
    - *`POSC`* (Primary Oscillator): For external high-frequency crystals, resonators, or external clock inputs.
    - *`SOSC`* (Secondary Oscillator): For low-power, low-frequency external crystals (typ. 32.768 kHz for RTC functionality).
    - *`FRC `* (Fast RC Oscillator): Internal high-frequency oscillator for fast-startup time base without external components.
    - *`LPRC`* (Low-Power RC Oscillator): Internal ultra-low-power, low-frequency oscillator, typically utilized for Deep Sleep modes and Watchdog Timer (WDT) operation.

- *`PLL`* (On-Chip Phase-Locked Loop): Integrated PLL circuitry permits frequency multiplication of the primary or internal fast oscillators to achieve maximum instruction execution rates.

- *Dynamic Clock Switching:* Hardware-managed multiplexing that allows on-the-fly transitions between clock sources during runtime, enabling firmware to dynamically scale performance and power consumption.

// - Programmable Clock Postscaler: Configurable divider network that scales down the system clock frequency prior to peripheral and CPU distribution, reducing dynamic power dissipation during low-demand states.

- *`FSCM`* (Fail-Safe Clock Monitor): Dedicated hardware fault-detection circuit that continuously monitors the primary clock edge. Upon detecting a signal loss or oscillator failure, the FSCM triggers a non-maskable interrupt (NMI) and automatically executes a failover to the internal FRC to ensure continuous, safe system operation.

=== $F_("OSC")$ and $F_("CY")$ 

In microcontroller architecture, the system clock is derived from a primary oscillator ($F_("OSC")$). However, the central processing unit (CPU) and synchronous internal peripherals operate on the instruction cycle frequency ($F_("CY")$). $F_("CY")$ represents the execution rate of a single, single-cycle machine instruction.

The relationship between $F_("OSC")$ and $F_("CY")$ is strictly architecture-dependent and must be explicitly verified within the specific device's datasheet. For example, in the Microchip dsPIC33 architecture, the instruction clock is derived as follows:

#grid(
    columns: (1fr, 1fr),
    align: center + horizon,

    [#align(center, image("../images/30/Fosc_Fcy.png", width: 90%))],
    [#align(center, image("../images/30/Fosc_Fcy_doc.png", width: 80%))
      
    #align(left, [_Note: Other architectures may employ different prescalers or utilize Phase-Locked Loops (PLLs) to synthesize higher internal clock frequencies_])
    ]
)

*Critical Role of $F_("CY")$ in System Configuration*\
Accurate determination of $F_("CY")$ is a prerequisite for firmware development, as it functions as the absolute temporal reference for the microcontroller. Miscalculating $F_("CY")$ propagates systemic timing errors across all time-dependent and frequency-dependent subsystems.

$F_("CY")$ governs the quantitative configuration of the following components:
- *Timers and Counters:* Establishes the fundamental increment rate before prescaling.
- *Communication Interfaces (UART, SPI, I2C, CAN):* Serves as the dividend in equations calculating Baud Rate Generator (BRG) register values.
- *Pulse Width Modulation (PWM):* Determines both the maximum switching frequency and the duty cycle resolution.
- *Deterministic Software Delays:* Required to compute exact cycle counts for blocking delay functions.

=== $F_("OSC")$ and $F_("IN")$
#grid(
    columns: (3fr, 4fr),
    align: center + horizon,

    [#align(center, image("../images/30/Fosc_Fin.png", width: 100%))],
    [#align(center, image("../images/30/Fosc_Fin_calc.png", width: 93.5%))]
)

#redBox([$F_("IN")$ is the frequency of the source before entering the PLL (8MHz for the XT source)])

#table(
  columns: (auto, auto, 1fr),
  align: (center + horizon, left + horizon, left + horizon),
  stroke: 0.5pt,
  fill: (col, row) => if row == 0 { luma(240) } else { none },
  
  [*Acronym*], 
  [*Component Name*], 
  [*Technical Description & Operational Mechanism*],
  
  [*`PFD`*], 
  [Phase Frequency \ Detector], 
  [Acts as the closed-loop error comparator. It continuously measures the phase and frequency differential between the input reference clock ($F_("REF")$) and the divided-down feedback clock from the VCO. It generates discrete "up" or "down" pulses proportional to this error, which a loop filter integrates into an analog DC control voltage.],
  
  [*`VCO`*], 
  [Voltage-Controlled \ Oscillator], 
  [A high-frequency analog signal generator. Its instantaneous output frequency ($F_("VCO")$) is strictly dictated by the incoming DC control voltage from the PFD. It actively adjusts its oscillation rate to drive the PFD's measured error to zero, operating within strict hardware-defined frequency bounds (e.g., $100 "MHz" < F_("VCO") < 200 "MHz"$).],

  [*`LOCK`*],
  [Phase-Locked \ State],
  [The stable equilibrium condition of the PLL. This state is achieved when the PFD detects zero phase and frequency error between the reference and feedback clocks. The control voltage stabilizes, forcing the VCO to maintain a mathematically precise, constant high-frequency output.]
)

#redBox([
Only for this course, the configuration is set by the booloader and cannot be changed. It is the following one
```
    PLLFBD = 70; // M = 72
    CLKDIVbits.PLLPOST = 0x00; // N1 = 2
    CLKDIVbits.PLLPRE = 0x00;  // N2 = 2
```
thus, `F_CY = 72MHz`
])

#pagebreak()

= Lesson 3.2: Timers

9 16-bit timers available:
#table(
    columns: (1fr, 1fr, 1fr),
    [T1: *Type A*],[T2, T4, T6, T8: *Type B*],[T3, T5, T7, T9: *Type C*], 
    
    [- can be operated also by the LPRC 
    - can work in asynchronous counter mode],
     
    [- can be concatenated with C-type leading to a 32-bit timer],
    
    [- T3 and T5 can trigger an A/D conversion]
)

Functions performed:
#table(
    columns: (0.3fr, 1fr, 3fr),
    align: (center, center, left),
    [ST], [Synchronous Timer], [increments at every internal clock cycle (A,B,C)],
    [SC], [Synchronous Counter], [increments at every external clock cycle (A,B,C)],
    [AC], [Asynchronous Counter], [increments at every external raising signal (A)],
    [GT], [Gated Timer], [counts the number of clock cycles an external signal is “high” (A,B,C)]
)

=== Counter and Gated Mode

*Counter Mode*
In Counter Mode, the timer module increments its counter register (`TMRx`) based on edge transitions detected on a dedicated external input pin (typically designated as `TxCK`), rather than the internal instruction cycle clock ($F_("CY")$). This mode is utilized to count discrete external events.
- *Synchronous Counter:* The external signal is synchronized with the internal system clock before incrementing the timer. The external frequency must comply with the limit relative to $F_("CY")$.
- *Asynchronous Counter (Type A / Timer 1 only):* The timer increments on the external signal entirely independent of the internal system clock. This architectural feature allows Timer 1 to continue functioning and generating interrupts even when the CPU and main oscillator are disabled in Sleep mode (e.g., functioning as a Real-Time Clock using a 32.768 kHz external crystal).

*Gated Timer Mode (Time Accumulation)*
In Gated Time Accumulation Mode, the timer utilizes the internal instruction clock ($F_("CY")$) as its time base, but the counting operation is strictly governed by the logic state of an external pin.
- The `TMRx` register accumulates internal clock pulses exclusively while the designated external gate signal is asserted (typically driven to a logic "High").
- Upon the external signal transitioning to a de-asserted state (logic "Low"), the timer halts. The accumulated integer value residing in `TMRx` provides a highly accurate, cycle-exact measurement of the external signal's temporal duration (pulse width). This mode is essential for measuring external pulse durations, such as ultrasonic sensor echo returns or decoding external PWM inputs.

#blueBox([Use case: This is a hardware feature used to measure exactly how long an external pulse lasts (e.g., measuring the echo pulse from an ultrasonic distance sensor) without needing to write complex interrupt code.])

#redBox([*16-bit Hardware Limitation* \
    The mathematical requirement that the calculated timer steps must be less than or equal to 65,535 is a strict physical constraint of the microcontroller's architecture. 

    The Period Register (`PRx`) and Timer Counter (`TMRx`) are physically implemented as 16-bit memory registers. The absolute maximum integer value a 16-bit register can hold is 65,535. 

    Attempting to load a computed value larger than this threshold (such as 400,000) will result in silent integer truncation—the hardware will discard the most significant bits and only store the remainder. Consequently, your timer will overflow at an arbitrary, drastically shorter interval, entirely destabilizing the system's timing. 
    
    If a required time delay yields a step count greater than 65,535, you can:
    - mathematically reduce it by increasing the prescaler (`TCKPS`) 
    - concatenate two 16-bit timers into a single 32-bit timer.
    - reuse the same timer multiple times anc count the number of completed cycles of it ]
)

=== Timer registers

#align(center, image("../images/30/timerRegister.png", width: 70%))

The configuration, scaling, and runtime execution of the hardware timers are governed by three primary Special Function Registers (SFRs) per timer module:

- *`TxCON`* (Timer x Control Register): The primary control register that dictates the operational mode, clock source, and prescaler division. Critical bitfields include:
    - *`TON`* (Timer On): Enables (1) or disables (0) the timer module. To prevent false triggers, this must be the final bit asserted during the initialization sequence.
    - *`TCS`* (Timer Clock Source Select): Multiplexes the input time base between the internal instruction cycle clock ($F_("CY")$) (0) or an external transition on the dedicated `TxCK` pin (1).
    - *`TGATE`* (Timer Gated Time Accumulation Enable): Enables (1) or disables (0) the gated counting mode when `TCS` is set to the internal clock. This bit turns the timer into a pulse-width measurer. It allows an external signal to act as a physical "pause/play" button for the timer.
        - *`TGATE = 0`*: The timer counts continuously as long as it is turned on (TON = 1). It doesn't care about what is happening on the outside world.
        - *`TGATE = 1`*: The timer is hooked up to an external pin (TxCK). Even if the timer is turned on (TON = 1), it will only count while that external pin is receiving a HIGH voltage signal. The moment the external signal drops to LOW, the timer pauses.

    - *`TCKPS<1:0>`* (Timer Input Clock Prescale Select): Configures the integer prescaler ratio (typically 1:1, 1:8, 1:64, or 1:256) applied to the selected clock source before it increments the core counter, allowing the timer to span longer durations without overflowing.

- *`PRx`* (Period Register): A 16-bit holding register containing the target temporal threshold. While the timer operates, the hardware continuously compares the `TMRx` value against `PRx`. Upon a strict mathematical match, the hardware automatically resets `TMRx` to zero on the subsequent clock cycle and asserts the Timer Interrupt Flag (`TxIF`, accessible at `IFSxbits.TxIF`).

- *`TMRx`* (Timer Register): The actual 16-bit counter variable that increments according to the prescaled clock source. Firmware can synchronously read from or write to this register to poll the elapsed time or force a specific phase offset.

*Note on 32-bit Concatenation:*
When a Type B timer (even-numbered, e.g., Timer 2) is concatenated with a Type C timer (odd-numbered, e.g., Timer 3) to synthesize a 32-bit timer, the Type B module provides the Least Significant Word (LSW) and the Type C module provides the Most Significant Word (MSW). Consequently, the core registers physically combine into `TMR3:TMR2` and `PR3:PR2`. During this mode, the configuration and control logic are entirely managed via the Type B control register (`T2CON`).

#pagebreak()

#grid(
    columns: (1fr, 1fr),
    row-gutter: 2em, // Adds vertical space between the rows
    align: center + horizon, 
    
    [#align(center, image("../images/30/timer1.png", width: 100%))],
    [#align(center + horizon)[
        #box(width: 90%)[
            #align(left)[
                Before setup:
                #set text(size: 8pt)
                ```c
                TxCON = 0x0000; // Disable timer and clear configs
                TMRx = 0;       // Clear the counter register
                ```
                #set text(size: 9pt)
            ]
            #table(
                columns: (0.3fr, 3fr),
                align:(center, left),
                [ST], [`TCS = 0`, `TGATE = 0`],
                [SC], [`TCS = 1`, `TGATE = 0`, `TSYNC = 1`],
                [AC], [`TCS = 1`, `TGATE = 0`, `TSYNC = 0` *(A only)*],
                [GT], [`TCS = 0`, `TGATE = 1`]
            )
            #align(left)[
                After setup:
                #set text(size: 8pt)
                ```c
                TxCONbits.TON = 1; // Start the timer
                ```
                #set text(size: 9pt)
            ]
        ]
    ]],
    [#align(center, image("../images/30/timerB.png", width: 100%))],
    [#align(center, image("../images/30/timerC.png", width: 94%))],
    [#align(center, image("../images/30/timer32bit.png", width: 100%))],
    [#align(center + horizon)[
        #box(width: 90%)[
            #align(left)[
                Enable 32-bit timer (e.g., T2 + T3):
                #set text(size: 8pt)
                ```c
                // Set 32-bit mode in Type B control reg
                T2CONbits.T32 = 1; 
                
                // Example of combined Period Register setup
                PR3 = 0xDEAD;      // Most Significant Word (MSW)
                PR2 = 0xBEEF;      // Least Significant Word (LSW)
                ```
                #set text(size: 9pt)
            ]
        ]
    ]],
)
