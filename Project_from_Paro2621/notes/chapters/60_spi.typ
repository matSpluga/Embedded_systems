#import "/setup.typ": *

#pagebreak()

= Lesson 6: SPI

== Overview

Serial Peripheral Interface (SPI) is a de facto standard (with many variants) for synchronous serial communication, used primarily in embedded systems for short-distance wired communication between integrated circuits. 

*Synchronous serial communication*:
- The transmitter puts the data byte it wants to send into an internal shift register 
- The transmitter uses a clock to shift the data bits out of its shift register onto an external data pin
- The receiver uses the input clock from the transmitter to sample incoming data
- The receiver puts the data on the input pin on an internal shift register.

*Full-duplex communication*:
- Two data lines are used: MISO (Master In Slave Out) and MOSI (Master Out Slave In)
- The master generates a clock signal and send it to the slave
- Both master and slave transmit data at the same time
- After transmission, the contents of the two shift registers are swapped.

*Multi-node communication*:
- A master can talk to many different slaves (a slave select signal may be used for guaranteeing that only one slave is enabled to write on the MISO line)
- Alternatively, nodes can be connected in a daisy-chain topology,

#grid(
  columns: (2.5fr, 2.5fr, 4fr),
  align: horizon,
  [#align(center, image("../images/60/SPI_ms_conn.png", width: 80%))],
  [#align(center, image("../images/60/SPI_comm.png", width: 100%))], 
  [#align(center, image("../images/60/SPI_top.png", width: 95%))]
)

#blueBox([*daisy chain configuration*: the first slave's output is connected to the second slave's input, and so on with subsequent slaves, until the final slave, whose output is connected back to the master's input. This effectively merges the individual communication shift registers of each slave to form a single larger combined shift register that shifts data through the chain. This configuration only requires a single SS line from the master, rather than a separate SS line for each slave.])

#table(
  columns: (1fr, 1fr),
  [Main advantages over RS232],[Main disadvantages over RS232], 
  [- High throughput (up to 70 Mbps)
  - High bandwidth
  - Transmission not limited to 8-bit words
  - Slaves use the master's clock, thus there is no need for precision oscillators
  - Multi-node communication available],
  [- More expensive for clock generation circuitry
  - More pins and wires required
  - Supports only one master device at a given time
  - Less robust to noise
  - No flow control or parity check
  - Only handles short distances]
)

=== Applications
SPI is used to talk to a variety of peripherals, such as:
- Sensors: IMU, temperature, magnetometer, pressure, ADC, touchscreens, video game controllers
- Control devices: audio codecs, digital potentiometers, DACs
- Camera lenses: Canon EF lens mount
- Memory: flash and EEPROMs
- Real-time clocks
- LCDs, sometimes even for managing image data
- Any MMC or SD card (including SDIO variant[note 3])
- Shift registers for additional I/O[8][9]

== dsPIC33F SPI Module
#align(center, image("../images/60/SPI.png", width: 70%))
=== SPIxBUF Register
The `SPIxTXB` and the `SPIxRXB` are unidirectional, 16-bit registers that share the SFR address of the `SPIxBUF` register. If the user application writes data to be transmitted to the `SPIxBUF` register, internally the data is written to the `SPIxTXB` register. Similarly, when the user application reads the received data from the `SPIxBUF` register, internally the data is read from the `SPIxRXB` register.

=== SPIxSTAT Register

#align(center, image("../images/60/SPIxSTAT.png", width: 75%))

`SPIxSTAT`: SPI Status registers, contains the flags that notify the program of certain events.
- `sSPIEN` needed to enable the SPI peripheral.
- `SPITBF` tells if the transmit buffer is full
- `SPIRBF` tells if the receiver buffer is full
- `SPIROV` tells if a receiver buffer overrun has occurred

=== SPIxCON1 Register

#align(center, image("../images/60/SPIxCON1.png", width: 75%))

#grid(
  columns: (1fr, 2fr),
  align: horizon,
  [- `MSTEN`: enables SPI master mode
  - `MODE16`: selects 16/8 bits mode
  - `PPRE`: primary prescaler
  - `SPRE`: secondary prescaler
  - `CKP` specifies the idle value of the clock],
  [#redBox([SPI prescalers are different from timer prescalers!])]
)

=== SPI Overflow
If a new data word has been shifted into the SPIxSR register and the previous SPIxBUF register contents have not been read, the SPIROV bit (inside SPIxSTAT) is set. Any received data in the SPIxSR register is not transferred, and further data reception is disabled until the SPIROV bit is cleared. The SPIROV bit is not cleared automatically by the module; it must be cleared by the user application.

=== SPI Example
Example: writing one character to the SPI (Fcy = 2 MHz, SPI clock 400 KHz)


#set text(size: 8pt)
#zebraw(```c
#define MAG_CS LATDbits.LATD6 // pin associated to the Slave Select (SS)

unsigned int spi_write(unsigned int data) {
    while (SPI1STATbits.SPITBF == 1); // Wait until TX buffer is empty
    SPI1BUF = data;                   // Send the byte
    while (SPI1STATbits.SPIRBF == 0); // Wait until RX buffer is full
    return SPI1BUF;                   // Return the received byte
}

// Writing example: write 0x01 at 0x4B
MAG_CS = 0;
spi_write(0x4B); // MSB è già 0 -> non ho bisogno di azzerarlo manualmente
spi_write(0x01);
MAG_CS = 1;


// Reading example: read data from address 0x80
MAG_CS = 0;
spi_write(read_addr | 0x80); // MSB = 1 (must be done manually)
value_from_chip = spi_write(0x00); // sends zeroes to generate clock to retrieve data
MAG_CS = 1;
```)
#set text(size: 9pt)

== `BOSCH BMX055` SPI interface
_Small, versatile 9-axis sensor module_