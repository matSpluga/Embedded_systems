#import "/setup.typ": *

= Lesson 1: Introduction

== Embedded system definition
#grayQuote("An embedded system is a special-purpose computer system designed to perform one or a few dedicated functions, often with real-time computing constraints. It is usually embedded as part of a complete device including hardware and mechanical parts", "Wikipedia")

*Embedded Systems*, compared with general purpose computers, are _application-oriented cost-sensitive highly-optimized_ devices

#table(
  columns: (1fr, 1fr),
  fill: (col, row) => if row == 0 { luma(240) } else { none },

  [Positive aspects:],[Example of possible requirements],

  [- Lower cost
  - Higher reliability
  - Smaller size
  - Reduced power consumption
  - Less produced heat],

  [- Small-size devices
  - Difficult environmental conditions
  - Portable devices
  - Reliability devices
  - On-line failure-detection
  - Absence human intervention],
)

== Hardware basics
*PCB*: (Printed Circuit Board) Board used for realizing electronic circuits. It is made of dielectric layers laminated with epoxy resins and provides conductive paths and mechanical support to components.

*Electronic Components*: Basic electronic elements of various nature, constituting electronic circuits, packaged in a discrete form with two or more connecting pads (or pins)

*Integrated Circuit* (CHIP): Miniaturized electronic circuit contained inside a single component.

General characteristics are:
- Nature: analog, digital, mixed
- Package: SIP (Single-In-line Package), DIP (Dual-In-line Package), QFP (Quad Flat Package), PGA (Pin Grid Array)
- Mounting technique: through holes, sockets, SMD (Sourface Mounting Devices)

*Logic Gate*: The basic building block of any processing device
implementing a logic function

Main features:
- Can be implemented with different transistor technologies (CMOS, TTL, ...).
- Have at least one (usually more) input and one output
- Input and output values are the logical values true `1` and false `0`
- Have no memory (i.e. the output depends only on the current value of the inputs)
- Can be described through a truth table. If $n$ is the number of inputs of a logic gate, its truth table has $2n$ rows and $n+1$ columns

*Basic memory elements*\
Latch, Flip-flop: circuit elements whose output depends not only on the current inputs, but also on previous inputs and/or outputs.
Main features:
- many kinds of latches and flip-flop do exist (SR, D, T, JK, …)
- they can be synchronous or asynchronous
- they are made of basic gates
- with feedback signals
- can not be described through a truth table

#redBox("Clock is introduced")

#pagebreak()
== Embedded system architectures
=== `ASIC - `Application-Specific Integrated Circuit
An integrated circuit specifically designed for a special single purpose/application.
- It is not a general-purpose device (application specific)
- ASIC is built for one and only one customer.
- The intellectual property, design database, and deployment of an ASIC are usually controlled by just a single entity (i.e. it is not available to the public.)

=== `ASSP - `Application-Specific Standard Product 
An integrated circuit specifically designed for a special application market.
- It is not a general-purpose device (application specific).
- ASSP is built for more than one customer (standard product)
- The intellectual property, design database, and deployment of an  ASIC are available to a certain level

*Characteristics of ASICs and ASSPs*\
- Fixed Hardware: Internal logic is fixed by manufacturers.
- No Programmable Software: The IC may include sequential elements (like microcontrollers) but their instructions are fixed (firmware) and not modifiable by user (apart from updates, eventually available from manufacturers)

#table(
  columns: (1fr, 1fr),
  fill: (col, row) => if row == 0 { luma(240) } else { none },

  [Main pros:],[Main cons:],

  [Design optimized for the application:
  - number of gates tailored to the application needs
  - reduced power consumption
  - reduced IC size
  - improved performances
  Low costs for replica production (they just “contain” what needed)
  ],

  [High design costs (hundreds of k€) for producing IC masks (an IC mask is a glass plate with a pattern of transparent and opaque areas used to photolithographically create patterns on wafers)

  Low flexibility: no option for circuit modification during fabrication life-cycle of an ASIC/ASSP linked with life-cycle of target products],
)

*Final conclusion on ASIC and ASSP*\
Fixed logic nonprogrammable devices (ASICs and ASSPs) are optimal solutions for high-volume productions. They can be found inside several objects of common use (consumer electronics, house appliances,...)

For medium- or small-volume productions a better (i.e. more cost- effective) solution is using standard components, such as small sequential devices (like DSPs or microcontrollers) or hardware- reconfigurable devices (like PLDs or FPGAs).

=== `PLD  - `Programmable Logic Device
An integrated circuit whose internal logic is not rigid but can be configured to some extent according to the user needs.
- PLDs are standard products sold as COTS (commercial-off-the-shelf).
- A PLD has an undefined function at the time of manufacture and before it can be used in a circuit it must be programmed (i.e. internally configured).
- PLDs have been developed since 70s. Originally, they were used for implementing glue logics (i.e. custom electronic circuitries interfacing two or more different ICs).

They are often preferred to sets of gates, since they allow to reduce the number of employed components, save PCB space and are generally more power-efficient 

*PROM technologies*\
#align(center, image("../images/10/PLD.png", width: 60%))
- OTP: One Time Programmable (fuse or antifuse)
- MTP: Multiple Times Programmables (floating-gate transistor, SRAM,Flash)

=== `CPLD - `Complex PLD 
#grid(
  columns: (1fr, 1fr),

  [A PLD made up of contains a bunch of PLD blocks whose inputs and outputs are connected by a global programmable interconnection matrix
  
  Two levels of programmability
  - each PLD block (logic block)
  - the interconnections between the PLDs (Programmable Interconnection Matrix, PIM)
  ],

  [ #align(center, image("../images/10/CPLD.png", width: 90%))]
)


=== `FPGA - `Field Programmable Gate Array
#grid(
  columns: (4fr, 3fr),

  [A PLD made up of a bunch of simple, configurable logic and I/O blocks arranged in an array with interspersed switches that can rearrange the interconnections between the logic and I/O blocks.

  FPGA has is a “fine-grain” device
  - FPGA has two levels of programmability:
  - each logic and I/O block
  - the interconnections between blocks

  Each logic block has (at least):
  - a 4- or 6-input LUT
  - 1 flip-flop
  - a mux for selecting combinatorial or registered output Logic blocks can be interconnected in different ways
  ],

  [
  #image("../images/10/FPGA.png", width: 80%)
  #image("../images/10/FPGA_block.png", width: 80%)
  ]
)

#figure(
  image("../images/10/VDHL.png", width: 53%),
  caption: [FPGA pipeline]
)

#pagebreak()
*FPGAs PROs and CONs*\
#table(
  columns: (4fr, 3fr),
  fill: (col, row) => if row == 0 { luma(240) } else { none },

  [Pros],[Cons],

  [- Lower design costs and lower design risks than with ASICs/ASSPs.
  - Flexibility.
  - Highly parallel processing (hundreds/thousands of “operations”).
  - High level of SoC (system-on-chip) integration (built-in features can reduce the number of components on the board).
  - High density (top FPGAs have 20k six-input logic functions).
  - High performance (modern FPGAs operate on frequencies of as high as 550 MHz i.e. only few times less than typical custom ASIC top frequency).],

  [- Relatively power-hungry devices
  - Higher costs (from around one hundred to thousands dollars) than ASICs/ASSPs for high-volume production
  - For “simple” applications lower-cost devices do exist
  - For control-oriented applications MCUs and DSPs may be better solutions]
)

*Conclusion on CPLDs and FPGAs*\
#align(center)[
  #table(
    columns: (auto, 1fr, 1fr),
    align: left,
    fill: (col, row) => if row == 0 { luma(240) } else { none },
    
    [*Feature*], [*FPGA*], [*CPLD*],
    
    [Logic Blocks], [Up to 100,000 (tiny blocks)], [A few to a few thousand],
    [Architecture], [Fine-grain], [Coarse-grain],
    [Memory Base], [RAM-based], [EEPROM-based],
    [Signal Delays], [Less predictable], [Highly predictable],
    [Cost], [Generally more expensive], [Much cheaper]
  )
]

=== `MCUs - `MicroController Unit
A single-chip microcomputer; i.e. a small computer on a single IC consisting of a relatively simple CPU combined with internal memory blocks and I/O control units.
- Unlike PLDs, MCUs have fixed wiring (i.e. the connections between its constituent gates are fixed)
- MCUs are sequentially programmable devices (i.e. they are re-programmed by changing a sequence of fixed operations, instructions, stored in memory)
- In contrast to general-purpose microprocessors, MCUs are simpler, lower-cost, lower-size and less power-hungry.
- Microcontrollers are primarily used in control-oriented applications (often interrupt- driven), for sensing and controlling external events

#table(
  columns: (3fr, 4fr),
  fill: (col, row) => if row == 0 { luma(240) } else { none },

  [8-bit MCU], [bigger MCU], 
  [ #align(center, image("../images/10/8-bitMCU.png", width: 85%))],
  [ #align(center, image("../images/10/biggerMCU.png", width: 85%))]
)

*Typical MCUs Resources*\
#table(
  columns: (3fr, 4fr),
  [- CPU core (ranging from small and simple 4-other serial communications interfaces bit processors to complex 32- or 64-bitlike I²C, SPI and CAN processors)
  - CPU registers and SFRs (Special Function Registers) for controlling other peripherals
  - volatile memory (RAM) for data storage
  - timers
  ],

  [- watchdog
  - non-volatile memory (ROM, EPROM, EEPROMclock generator circuitry (driven by or Flash memory) for program storageinternal oscillators or external crystals)
  - programmable GPIO pins and specialADC and DAC
  - functions pinsin-circuit programming and debugging
  - serial I/O such as serial ports (UARTs)support
  - PWM generators]
)

#pagebreak()

*Programming MCUs*\
- MCUs typically do not have a FPU or a math coprocessor, so both fixed point and floating-point arithmetic are performed by program code.
- Peripherals programming skills are required (i.e. a deeper hardware knowledge than what needed for desktop applications)
- Event-driven programming skills
- MCUs were originally programmed only in assembly language.
- Various high-level programming languages (like C) are now also in common use to target microcontrollers.
- High-level compilers typically have some restrictions as well as enhancements to better support the unique characteristics of microcontrollers.
- An MCU instruction set usually has many instructions intended for bit-wise operations. (For example, a general-purpose processor might require several low-level instructions to test a bit in a register and branch if the bit is set, where a MCU could have a single instruction to provide that commonly-required function.)

=== `DSP  - `Digital Signal Processor
A type of fast and powerful microprocessor whose architecture is optimized for performing intense “number crunching” applications
- Like MCUs, DSPs have fixed wiring (i.e. the connections between its constituent gates are fixed)
- DSPs are sequentially programmable devices (i.e. they are re-programmed by changing a sequence of fixed operations, instructions, stored in memory)
- In contrast to MCUs, DSPs have an architecture optimized for intensive number crunching operations.
- DSPs have typically fewer on-chip peripherals than MCUs.
- DSPs are primarily used in systems that require the precision processing of analog or digital signals. 

*DSPs Peculiarities*\
#grid(
  columns: (3fr, 4fr),
  gutter: 20pt,
  [- fast multipliers (dedicated circuitry for MAC (multiply accumulation))
  - multiple execution units (such as ALUs working in parallel with MAC units)
  - special SIMD (single instruction, multiple data) operations
  - circular buffers
  - efficient memory access
  - Harvard or mod-Harvard architecture
  - more data-buses
  ],

  [- dedicated AGU (Address Generation Units)
  - few-bit data format (16 to 32 bit architecture with accumulator registers)
  - efficient looping
  - streamlined I/O (low-latency interrupt, on-chip DMAs)
  - deep instruction pipeline
  - floating point operations (optionally)
  - multicore (optionally)]
)

*Conclusion on MCU vs DSP*\
#table(
  columns: (3fr, 4fr),
  fill: (col, row) => if row == 0 { luma(240) } else { none },

  [MCU], [DSP], 
  [- General-purpose embedded controller
  - Rich peripherals (ADC, UART, SPI, CAN, computation timers)
  - Good for control logic + system
  - Lower cost and power
  - Suitable for kHz-range control loops
  ],

  [- Designed for filtering, FFT, motor control, power electronics management
  - Fast MAC units, SIMD, Harvard architecture
  - Optimized for numerical
  - Deterministic high-frequency loops
  - Higher computational throughput]
)