#import "/setup.typ": *

// RIVEDI LE SEQUENZE DELLE IMMAGINI

#pagebreak()

= Lesson 2: Digital I/O
In the following schematics active-low logic convention is used: 
Logic High is 0 and Logic Low is 1

== Working with ports
#align(center)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    align: center + horizon, 
    
    // Left Column
    figure(
      image("../images/20/dsPIC33EP512MU810.png", width: 100%),
      caption: [dsPIC33EP512MU810 pinout]
    ),
    
    // Right Column
    stack(
      dir: ttb,
      spacing: 20pt,
      figure(
        image("../images/20/SharedPortStructure.png", width: 90%),
        caption: [Typical shared port structure]
      ),
      figure(
        image("../images/20/three-state-logic.png", width: 80%),
        caption: [Three state logic]
      ),
    )
  )
]

=== Digital IO port register
- `TRISx` is the register used to select which pins of a register are to be used as input and which one as output;
- `PORTx` is the register used to read the voltage value of the pins;
- `LATx` is register is used to write a logic value as pins output;

A read of the port latch register returns the settings of the output drivers, whilst a read of the port register returns the logic levels seen on the pins.

The `x` stands for any of the available I/O Registers: A,B,C,D,E,F. So we have TRISA register and TRISAbits bit field data structure, and so on.

=== Multiplexed I/O pins
Modern microcontrollers possess a vast array of internal hardware peripherals (like UART, SPI, ADC, or Timers) but are physically limited by the number of external pins on their package. To solve this bottleneck, Multiplexed I/O allows a single physical pin to serve multiple, selectable functions. 

Internally, the physical pin is connected to an electronic multiplexer (MUX). Based on the values written to specific configuration registers, this MUX routes the pin's electrical signal either to the standard Digital I/O logic (controlled by `TRIS`, `PORT`, and `LAT`) or directly to an alternative peripheral module. 

*Why it is used:* It drastically reduces the chip's package size and manufacturing cost while giving designers the flexibility to tailor the microcontroller to the specific needs of their application. 

Before using a multiplexed pin as a standard Digital I/O, you must explicitly disable its alternate functions via software. Crucially, *pins with analog capabilities default to analog inputs* upon reset to prevent excess current draw from floating signals. To use them digitally, you must clear the corresponding bit in the `ANSELx` (Analog Select) register. 

For advanced digital routing, dsPIC devices also utilize *Peripheral Pin Select (PPS)* registers, which allow you to dynamically map specific digital peripherals to designated "remappable" pins at runtime.

#pagebreak()

=== PinMode write
Objective: output the logic value stored in the Data Latch

#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 20pt,
    align: top, 

    // First row
    figure(image("../images/20/reading_1.png"),
      caption: [Base state],
      numbering: none,
    ),
    figure(image("../images/20/reading_2.png"),
      caption: [WR TRIS = 0],
      numbering: none,
    ),
    figure(image("../images/20/reading_3.png"),
      caption: [WR TRIS = 1],
      numbering: none,
    ),
    figure(image("../images/20/reading_4.png"),
      caption: [Final state],
      numbering: none,
    ),
  )
]

When the instruction is done, the DATA Latch (memory element) keeps the pin to 0

=== Data Latch change (write)
Objective: while PinMode is set to write, change the value stored in the Data Latch with the one in Data Bus

#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 20pt,
    align: top,    
    // Second row
    figure(image("../images/20/reading_4.png"),
      caption: [Initial state],
      numbering: none,
    ),
    figure(image("../images/20/reading_5.png"),
      caption: [WR LAT = 0],
      numbering: none,
    ),
    figure(image("../images/20/reading_6.png"),
      caption: [WR LAT = 1],
      numbering: none,
    ),
    figure(image("../images/20/writing_1.png"),
      caption: [Final state],
      numbering: none,
    ),
  )
]

=== Switch to PinMode read
Objective: disable the writing-mode

#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 20pt,
    align: top, 

    // First row
    figure(image("../images/20/writing_1.png"),
      caption: [Initial state],
      numbering: none,
    ),
    figure(image("../images/20/writing_2.png"),
      caption: [WR TRIS = 0],
      numbering: none,
    ),
    figure(image("../images/20/writing_3.png"),
      caption: [WR TRIS = 1],
      numbering: none,
    ),

    figure(image("../images/20/writing_4.png"),
      caption: [Final state],
      numbering: none,
    ),
  )
]

=== DigitalRead
Objective: write the logic value of the pin in the Data Bus (Input buffer)

#align(center)[
  #grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 20pt,
    align: top, 

    // First row
    figure(image("../images/20/writing_4.png", width: 65%),
      caption: [Initial state],
      numbering: none,
    ),
    figure(image("../images/20/readPin_1.png", width: 65%),
      caption: [Read Port = 0],
      numbering: none,
    ),
    figure(image("../images/20/readPin_2.png", width: 65%),
      caption: [Data bus],
      numbering: none,
    )

  )
]



