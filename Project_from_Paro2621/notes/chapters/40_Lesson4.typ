#import "/setup.typ": *

#pagebreak()

= Lesson 4.1: Interrupts
*Interrupt*: an asynchronous signal from hardware indicating the need for attention (hardware interrupt) or a synchronous event in software indicating the need for a change in execution (software interrupt or software trap)
- *Synchronous* means that the interrupt depends on the instruction we are currently executing (e.g. a divide by zero trap)
- *Asynchronous* means that it does have any temporal relation to which part of the code the microcontroller is executing (the timer expires independently of which point the program has currently reached)

== ISR (Interrupt Service Routine)
An ISR is like any other C function with some special rules:
- Each ISR has a special name which is used for linking its code to the IVT
- No parameters can be passed to the ISR
- No parameters can be returned by an ISR (void return type is mandatory)
- the flag generating the interrupt should be generally cleared in the ISR
- ISR code should not contain blocking sections
- ISRs should not be called by main line code
- Care must be taken with shared data

```c
void __attribute__((__interrupt__, __auto_psv__)) _INT0Interrupt() {
  IFS0bits.INT0IF = 0; // reset interrupt flag
  [...] // do some action
}
```
== Interrupts: How They Work
// --- Helper functions for the flowchart ---
#let process-box(body) = box(
  width: 80%,
  stroke: stroke,
  radius: std_radius,
  inset: 10pt,
  align(center)[*#body*]
)


// --- Interrupt Process Scheme (Flipped Two-Column) ---
#grid(
  columns: (1fr, 1.5fr), // Boxes on the left, text on the right
  row-gutter: 0.8em,
  align: (center + horizon, left + horizon), // Center the boxes/arrows, left-align the text

  // Step 1
  process-box[Hardware Event],
  [*1. Hardware Event* \ A special event occurs and the peripheral hardware sets its interrupt flag(s).],
  
  $arrow.b$, [], // Arrow on the left, empty cell on the right
  
  // Step 2
  process-box[Sampling],
  [*2. Sampling* \ Interrupt flags are sampled at the beginning of each instruction cycle.],
  
  $arrow.b$, [],
  
  // Step 3
  process-box[Condition Check],
  [*3. Condition Check* \ *IF* (request is pending) *AND* (interrupt generation is enabled): \ An interrupt is presented to the processor.],
  
  $arrow.b$, [],
  
  // Step 4
  process-box[Context Switch],
  [*4. Context Switch* \ The processor saves the current state to the software stack: \ - Current Program Counter (PC) value \ - Processor Status register],
  
  $arrow.b$, [],
  
  // Step 5
  process-box[Priority Update],
  [*5. Priority Update* \ The CPU sets its priority level equal to that of the pending interrupt.],
  
  $arrow.b$, [],
  
  // Step 6 (NEW: The IVT Lookup)
  process-box[Vector Fetch (IVT)],
  [*6. Vector Fetch (IVT)* \ The CPU uses the specific interrupt source to look up the correct "slot" in the Interrupt Vector Table, retrieving the exact memory address of the ISR.],
  
  $arrow.b$, [],
  
  // Step 7 (Updated: The ISR Execution)
  process-box[ISR Execution],
  [*7. ISR Execution* \ The CPU jumps to the address provided by the IVT and executes your Interrupt Service Routine (ISR) code.],
  
  $arrow.b$, [],
  
  // Step 8
  process-box[Context Restore],
  [*8. Context Restore* \ The previous context is recovered from the stack, and the main program execution continues.]
)

#pagebreak()
=== The Interrupt Vector Table (IVT) and ISR Mapping

When a hardware interrupt occurs, the CPU needs to know exactly *where* in the program memory the corresponding code (the Interrupt Service Routine) is located. This linkage is strictly managed by the *Interrupt Vector Table (IVT)* and the compiler.

- *The IVT:* A dedicated, fixed array in the microcontroller's lowest program memory. It acts like a directory. Each peripheral's interrupt source has a hardcoded, pre-assigned "slot" (or Vector) in this table.
- *The Content:* Each slot in the IVT doesn't contain code; it contains a `GOTO` instruction pointing to the actual memory address where your ISR function lives.
- *The ISR Name:* To tell the compiler which IVT slot to populate, you must use the exact *ISR Name* specified in the microcontroller's documentation (e.g., `_T1Interrupt`). 

// --- Visual Mapping of the IVT Process ---
#align(center)[
  #grid(
    columns: (1fr, 0.2fr, 1.2fr, 0.2fr, 1.5fr),
    align: center + horizon,
    
    // Step 1: Hardware
    box(fill: std_gray, stroke: stroke, inset: 10pt, radius: std_radius)[
      *1. Hardware Event* \ 
      Timer 1 matches PR1 \ 
      `T1IF` becomes `1`
    ],
    
    $-->$,
    
    // Step 2: IVT
    box(fill: std_gray, stroke: stroke, inset: 10pt, radius: std_radius)[
      *2. The IVT* \ 
      CPU jumps to Vector #11 \
      *(Points to `0x1A00`)*
    ],
    
    $-->$,
    
    // Step 3: Program Memory
    box(fill: std_gray, stroke: stroke, inset: 10pt, radius: std_radius, align(left)[
      *3. Program Memory (`0x1A00`)* \ 
      `void _T1Interrupt() {` \
      `  // ISR Code executes` \
      `}`
    ])
  )
]

#redBox([
  *Naming Rule:* \ 
  A misspell in the ISR name won't raise any flag during compilation, but it will treat it as a standard C function. The IVT slot will remain empty or point to a default error handler. When the interrupt triggers, the microcontroller will likely reset or crash

  Note also that almost all XC16 interrupt names start with a single underscore (`_`)
])

*Standard ISR Code Example (XC16 Compiler):*
```c
void __attribute__((interrupt, no_auto_psv)) _T1Interrupt(void) {
    // 1. Perform the required urgent action
    // 2. Clear the interrupt flag, otherwise the ISR will trigger again infinitely.
    IFS0bits.T1IF = 0; 
}
```

=== Where to find ISR Names?
The hardware datasheet describes the physical Interrupt Vector Table, but the exact C-function names are defined by the XC16 Compiler. 

The list of ISR names for a specific microcontroller can be found in the XC16 installation directory:\
`/opt/microchip/xc16/v2.10/docs/vector_docs`

#grid(
  columns: (3fr, 4fr),
  align: center + horizon,

  [#align(center, image("../images/40/InterruptVectorNames.png", width: 100%))],

  [#blueBox([Visualize the website in case Firefox is _sandboxed_ : the Local Web Server Trick

  Since Firefox is blocking a local file path (`file:///`), we can trick Firefox by turning that folder into a temporary website. Almost all Linux systems come with Python pre-installed, which has a built-in mini web server.

  + Open your Terminal.
  + Navigate to the documentation folder by pasting this command and hitting Enter:\
    `   cd /opt/microchip/xc16/v2.10/docs/`
  + Start the temporary server by running this command:\
    `   python3 -m http.server 8000`
  + Now, go back to Firefox and type this exact address into the URL bar:\
    `   http://localhost:8000/XC16MasterIndex.htm`

  When you are done reading, just go back to the terminal and press Ctrl + C to stop the server
  ])]
)

*Common interrupts for th dsPIC33*
#table(
  columns: (1fr, 2fr, 2fr),
  align: (center, left, left),
  [*Peripheral*], [*Interrupt Flag (IFSx)*], [*Required XC16 ISR Name*],
  [Timer 1], [`T1IF`], [`void _T1Interrupt(void)`],
  [Timer 2], [`T2IF`], [`void _T2Interrupt(void)`],
  [Timer 3], [`T3IF`], [`void _T3Interrupt(void)`],
  [UART 1 RX], [`U1RXIF`], [`void _U1RXInterrupt(void)`],
  [UART 1 TX], [`U1TXIF`], [`void _U1TXInterrupt(void)`],
  [ADC 1], [`AD1IF`], [`void _ADC1Interrupt(void)`],
  [External Int 0], [`INT0IF`], [`void _INT0Interrupt(void)`]
)

== Nested Interrupts
A strictly higher-priority interrupt will preempt an active Interrupt Service Routine (ISR), elevating the CPU's execution priority and creating a nested interrupt. Once the higher-priority routine finishes, the CPU resumes the preempted ISR. Conversely, equal or lower-priority interrupts cannot preempt an active routine; they are instead pended (delayed). If a pended interrupt's conditions are triggered multiple times during this delay, the events are coalesced into a single ISR execution when the current routine completes.

== Interrupt Flag Status Registers

#align(center, image("../images/40/IFSR.png", width: 65%))

*`IFSx`*: Interrupt Flag Status registers, contains the flags that notify th program of certain events. For example IFS0bits.T1IF tells if the Timer 1 has expired. These flags are set to `1` automatically, but must be set to `0` by the user.

_Page 58 of the datasheet shows the location of all the IFs_

== Interrupt Enable Control Registers

#align(center, image("../images/40/IECR.png", width: 65%))

*`IECx`*: Interrupt Enable Control example, it is used to enable an interrupt. For example `IEC0bits.T1IE = 1` tells that we want an interrupt every time that IFS0bits.T1IF becomes `1`.

_see Chapter 6, pag. 148 of the reference manual_

#pagebreak()

== Interrupts and Shared Variables

//--RIVEDI--RIVEDI--RIVEDI--RIVEDI--RIVEDI--RIVEDI--
When the main program and an Interrupt Service Routine (ISR) need to exchange information (such as a hardware flag, a sensor reading, or a timer tick), they must use global shared variables. Because ISRs execute asynchronously, sharing data introduces specific compiler and hardware level risks.

*1. The `volatile` Keyword: Breaking the Single-Thread Illusion* \
In standard C programming, the compiler analyzes your code and aggressively optimizes it. For example, if it sees a loop like `while(flag == 0);` and nothing *inside* that loop modifies `flag`, the compiler assumes `flag` will never change. To save time, it reads `flag` once, caches it in a CPU register, and turns your code into an inescapable infinite loop.

Embedded systems, however, are non-deterministic. Variables can change without the compiler's knowledge. The `volatile` keyword is a strict warning to the compiler: *"Do not optimize or cache this variable. Its value can change at any time, outside of the current execution flow."*

The `volatile` qualifier is mandatory in three generic embedded scenarios:
- *Global Variables Shared with ISRs:* Hardware interrupts can pause the main loop at any microsecond and alter shared data invisibly to the compiler.
- *Memory-Mapped Hardware Registers:* The value of peripheral registers (like `PORTB` or `T1IF`) changes based on physical electrical signals or peripheral hardware logic, not software instructions.
- *Multithreading/RTOS:* When multiple tasks share the same memory space in a Real-Time Operating System.

By declaring a variable as `volatile`, you force the CPU to physically fetch the value from RAM (or the hardware register) on *every single read*, guaranteeing the code always acts on the true, real-time state of the system.

```c
volatile uint16_t timer_ticks = 0; // The compiler will not cache this
```

*2. The Read-Modify-Write Vulnerability* \
Even when using `volatile`, modifying shared data is dangerous. A simple C statement like `timer_ticks++` or `timer_ticks += 5` is not executed in a single clock cycle. It is translated by the compiler into multiple assembly instructions:
+ *Read:* Fetch the current value from RAM into a working register.
+ *Modify:* Perform the ALU operation (e.g., add 1).
+ *Write:* Store the updated value back into RAM.

*The Crash Scenario:* \
If an interrupt triggers exactly after the *Read* step but before the *Write* step, the main program is suspended holding a "stale" copy of the variable. If the ISR then modifies that same variable in RAM and returns, the main program will blindly overwrite the ISR's new data with its own stale data. 

This unpredictable data corruption is what necessitates the use of specialized protections, known as *Critical Regions*.

//--RIVEDI--RIVEDI--RIVEDI--RIVEDI--RIVEDI--RIVEDI--

== Critical Regions
A critical section is a segment of code that accesses shared resources where preemption by an ISR could cause data corruption or race conditions. To protect these regions, interrupts are temporarily masked (disabled) during their execution. If a triggering event occurs while masked, the hardware still sets the Interrupt Flag (IF), creating a pending interrupt that executes immediately once the interrupt is re-enabled. However, because the IF is a single bit, multiple occurrences of the same event during this masked period are coalesced; the flag remains 1, and only a single ISR execution will occur upon unmasking, resulting in the loss of the intermediate events.

#blueBox([
A statement can also be protected from interrupt using the `INTERRUPT_PROTECT` macro.
```
INTERRUPT_PROTECT(LATGbits.LATG15 ^= 1); 
// Not interruptible by level 1-7 interrupt requests and safe at any optimization level
```
_Pag 175 MPLAB XC16 C Compiler User Guide_
])


#pagebreak()
= Lesson 4.2: Peripheral Pin Select (PPS)
Here is an expanded, highly technical explanation based on Option 2. It provides the necessary architectural depth while setting up a clear transition to your next topics (input and output mapping).

== Architectural Overview: Peripheral Pin Select (PPS)
Unlike microcontrollers with statically assigned pin functions, the `dsPIC33EP512MU810` utilizes an internal routing matrix: a software-configurable crossbar switch. This matrix decouples the internal digital peripherals (such as UARTs, SPI modules, Timers, and External Interrupts) from the physical General Purpose I/O (GPIO) pins.

== Hardware Implications and Constraints
The primary advantage of PPS is significant PCB layout optimization. Hardware engineers can route physical traces based on spatial convenience and signal integrity rather than being constrained by a rigid, factory-defined pinout. 

However, this architecture introduces two critical design constraints:
- *Software Dependency:* By default, remapable peripherals are disconnected from the physical pins. The physical hardware (like the button wired to *`RE8`*) will remain inert until the firmware explicitly initializes the routing matrix during boot.
- *Digital Exclusivity:* PPS multiplexing applies strictly to *digital* signals. Analog peripherals (such as ADCs or analog comparators) and specialized pins (like I2C, power, or oscillators) remain physically hardwired and cannot be remapped. 

== Implementation Mechanism
To bridge the gap between the physical PCB layout and the microcontroller's internal logic (e.g., assigning the trace at *`RE8`* to the *`INT1`* module), the firmware must configure dedicated PPS Special Function Registers (SFRs). 

Because signal direction dictates how the internal multiplexers route the data, this configuration must be explicitly handled in two distinct phases: *Input Mapping* and *Output Mapping*. 

#table(
  columns: (1fr, 1fr),
  align: left + horizon,
  fill: (col, row) => if row == 0 { luma(240) } else { none },

  [#align(center, [Input Mapping])],[#align(center, [Output Mapping])],

  [#align(center, image("../images/40/remappableInput.png", width: 90%))
  #align(bottom, redBox([`Functionality = Remappable Input Pin`]))],

  [#align(center, image("../images/40/remappableOutput.png", width: 95%))
  #align(bottom, redBox([`Remappable Output Pin = Functionality (Peripheral output)`]))]
)

#pagebreak()
=== Input mapping example: Assigning External Interrupt 1 to the Left Button
_*Objective:* route the physical signal from the left button (wired to pin *RE8*) to the internal module *INT1* so that pressing the button triggers an interrupt without any software polling._

To route a physical signal to an internal module using Peripheral Pin Select (PPS), we must first gather two crucial pieces of information from our documentation: the *PPS Pin Identifier* and the *Peripheral Designator*. 

+ *Determine the physical pin and its PPS identifier*
  - *Hardware Schematic:* First, we consult the development board's manual (`clicker-2-for-dspic33-manual-v100.pdf`). The circuit schematic indicates that the left button is physically hardwired to the microcontroller pin labeled *RE8* (numeric pin 18).
  
  #table(
    columns: (1fr),
    align: center,
    [#align(center, image("../images/40/physicalConnection.png", width: 80%))]
  )
  

  - *Microcontroller Datasheet:* Next, we cross-reference pin 18 in the dsPIC33 datasheet's pinout diagram. The device multiplexes several functions onto this pin, listing it as `AN20/RPI88/RE8`. 

  #table(
    columns: (1fr, 1fr),
    gutter: 1em,

    [#align(center, image("../images/40/pin18.png", width: 100%))],
    [#align(center, image("../images/40/PIS.png", width: 100%))]
  )

  Because we are mapping an *input* signal, we will refer to this pin in our software configuration by its Remappable Pin Input identifier: *RPI88*.

+ *Determine the internal peripheral designator*
  - Now we need the official mnemonic for the internal module we want to trigger. 
  - Inside the dsPIC33 datasheet, navigate to *TABLE 1-1: PINOUT I/O DESCRIPTIONS*. Searching for "External Interrupt 1" reveals that the manufacturer designates this peripheral as *INT1*.

  #table(
    columns: (1fr, 1fr),
    gutter: 1em,

    [#align(center, image("../images/40/INT1.png", width: 100%))],
    [#align(center, image("../images/40/SIS.png", width: 100%))]
  )

+ *Finalize the configuration* 
#redBox([`Functionality = Remappable Input Pin`])

With the source (`RPI88`) and the destination (`INT1`) identified, we now have the required parameters to configure the PPS Input Mapping registers in our C code.

```c
RPINR0bits.INT1R = 0b1011000;
IFS1bits.INT1IF = 0; // clear interrupt flag
IEC1bits.INT1IE = 1; // enable interrupt
```

#pagebreak()
=== Output mapping example: 
_*Objective:* remap the output of Timer 1 to the physical pin * `RA0`* (numeric pin 16) to create a blinking LED effect without using any software toggling._

+ *Get the PPS Output Identifier*: _(same procedure as previous case)_ `RPI16`

#redBox([
  *ATTENTION:* \
  If you look closely at the dsPIC33 datasheet, `RA0` is labeled as `RPI16`, not `RP16`. 
  - *`RP` (Remappable Pin):* Can be used for Input OR Output mapping.
  - *`RPI` (Remappable Pin Input):* Physically lacks the internal multiplexing circuitry for outputs. It can be used for Input ONLY.

  Because `RA0` is strictly an `RPI` pin, *it is physically impossible to route a peripheral output to it via PPS.* The compiler will not find an `RPOR` (Remappable Pin Output Register) for it because it doesn't exist in the silicon! 

  _To make this hardware-blink example work, we must choose a pin that supports output mapping. For this exercise, let's assume we are remapping to `RD6`, which has the identifier `RP70`._
])

+ *Understand Timer Outputs vs. Output Compare* \
  There is a second architectural rule to remember: standard Timers (like Timer 1) do not have direct physical output pins that can be routed via the routing matrix. To blink an LED entirely in hardware, we must use an *Output Compare (OC)* module. The OC module can be configured to toggle an output automatically every time a designated timer (usually Timer 2 or Timer 3) matches a specific period.

+ *Determine the Output Function Number*
  - We need the specific numeric code for the peripheral we want to output. 
  - Inside the dsPIC33 datasheet, navigate to *TABLE 4-37: PERIPHERAL PIN SELECT OUTPUT REGISTER MAP*. 
  - Searching for "Output Compare 1" (`OC1`) reveals its 6-bit output value is `0b010000` (`0x10`).

#table(
  columns: (1fr, 1fr),
  gutter: 1em,

  [#align(center, image("../images/40/RP.png", width: 100%))],
  [#align(center, image("../images/40/OSRP.png", width: 100%))]
)

+ *Finalize the configuration* 
#redBox([`Remappable Output Pin = Functionality (Peripheral output)`])
```c
// 1. Output Mapping: Route Output Compare 1 (0x10) to physical pin RP80 (RE0)
RPOR4bits.RP80R = 0x10; 

// 2. Peripheral Setup: Configure Timer 2 and OC1 to blink the LED
// PR2 = ...                 // Set Timer 2 period 
OC1CON1bits.OCTSEL = 0b000; // Select Timer 2 as the clock source for OC1
OC1CON2bits.SYNCSEL = 0x1F; // Free-running mode (No hardware sync required)
OC1CON1bits.OCM = 0b011;    // Configure OC1 in Toggle mode (hardware blink)
T2CONbits.TON = 1;          // Start Timer 2
```