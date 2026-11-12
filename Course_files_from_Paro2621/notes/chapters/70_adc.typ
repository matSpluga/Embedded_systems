#import "/setup.typ": *

#pagebreak()

= Lesson 7: ADC

== Overview
#grid(
  columns: (1fr, 1fr),
  align: horizon,
  [#align(center, image("../images/70/sampling_conversion_sequence.png", width: 100%)) 
  The analog-to-digital conversion constitutes a two-phase sequential process: *Sampling* (acquisition of the analog signal via the sample-and-hold amplifier) and *Conversion* (successive approximation translation into the digital domain)],
  [#align(center, image("../images/70/adc.png", width: 90%))]
)

== dsPIC33 ADC Modules

#grid(
  columns: (1fr, 1fr),
  align: horizon,
  [#align(center, image("../images/70/module_block_diagram.png", width: 70%))],
  [
    - Two independent ADC modules
    - Up to 1 Msps conversion rate
    - Selectable 10-bit or 12-bit operation modes
    - Up to 32 analog pins (ADC 1)
    - Up to 16 analog pins (ADC 2)
    - 4 differential Sample/Hold (S/H) amplifiers (channels)
    - 1 shared Successive Approximation converter
    - Channel scan mode
    - 16-word deep buffer for conversion results
    - Selectable hardware or software conversion trigger sources
  ], 
)

=== Timing Parameters
#table(
  columns: (1fr, 2fr, 4fr, 2fr),
  align: (center + horizon, left + horizon, left + horizon, center + horizon),
  fill: (col, row) => if row == 0 { luma(240) } else { none },
  [], [*Name*], [*Description*], [*Formula*],

  [$T_("CY")$], [Instruction Cycle Period], [The fundamental execution timebase of the microcontroller, derived from the system oscillator.], [System defined],

  [`TAD`], [ADC Clock Period], [The internal timebase strictly governing the ADC's successive approximation register (SAR) timing. It is a scaled derivative of $T_("CY")$.], [`T_CY * (ADCS + 1)`],

  [$T_("SMP")$], [Sample Time], [The temporal window during which the analog input channel is electrically coupled to the sample-and-hold (S&H) capacitor. Must exceed the hardware-defined minimum to ensure capacitor equilibrium.], [Auto: `SAMC * TAD` \ Manual: SW defined],

  [$T_("CONV")$], [Conversion Time], [The rigid hardware latency required to fully translate the captured analog voltage into a binary word, strictly dependent on hardware resolution.], [10-bit: `12 * TAD` \ 12-bit: `14 * TAD`],

  [$F_("SAMP")$], [Sampling Rate], [The absolute maximum throughput frequency of the ADC pipeline for a single channel.], [`1 / (T_SMP + T_CONV)`]
)

=== ADC Configuration Registers
The temporal configuration of the sampling and conversion phases is dictated by specific bitfields within the ADC Special Function Registers (SFRs):
- *`ADCS<7:0>`* (ADC Conversion Clock Select bits): A divider network parameter that scales the instruction cycle clock ($T_("CY")$) to synthesize the required `TAD` period.
- *`SAMC<4:0>`* (Auto-Sample Time bits): Determines the integer number of `TAD` periods allocated to the sampling phase ($T_("SMP")$) when auto-sampling is enabled.

#redBox([
    *Hardware Timing Violations* \
    The structural integrity of the analog-to-digital conversion strictly relies on meeting minimum time thresholds defined in the specific device's "Electrical Characteristics".
    - *Minimum `TAD`*: Accelerating the ADC clock beyond the silicon limit compromises the successive approximation process.
    - *Minimum $T_("SMP")$*: Insufficient sampling time prevents the internal holding capacitor from fully stabilizing at the external voltage level, causing aliasing and reading inaccuracies.
])

#blueBox([
    *Design Objective:* \
    For accurate A/D conversions, the physical hardware mandates a minimum `TAD` (e.g., 154 nsec for VDD = 5V). The firmware designer must computationally derive the correct `ADCS` prescaler to satisfy this absolute physical constraint before establishing the final sampling rate ($F_("SAMP")$).
])

== ADC Triggers

#table(
  columns: (1fr, 2fr),
  align: (horizon, horizon),
  fill: (col, row) => if row == 0 { luma(240) } else { none },
  [Sampling period *start*], [Sampling period *end* (= conversion time start)],

  [- automatic (at the end of previous conversion)
   - manual (by setting the `SAMP` bit in software)],

  [- automatic (if $T_("SMP")$ is fixed via the internal timer)
   - manual (by clearing the `SAMP` bit in software)
   - driven by other hardware events (e.g., Timers, external interrupts)]

)

=== manual sample - manual conversion
#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [*Application Example:* Reading a simple analog sensor exactly once triggered by a user action or a call inside a periodic task. Precise timing between readings is not critical, and software control is sufficient.

  #align(center, image("../images/70/msmc.png", width: 100%))], 
  
  [#set text(size: 8pt)
  #zebraw(```c
  // --- ADC Setup Phase ---
  AD1CON1bits.ASAM = 0;     // Manual sampling
  AD1CON1bits.SSRC = 0b000; // Manual conversion trigger

  // --- Execution Phase ---
  // Start sampling
  AD1CON1bits.SAMP = 1;      

  // Wait for sampling time (10us)
  DelayUs(10);

  // Start the conversion (ends sampling)
  AD1CON1bits.SAMP = 0;      

  // Wait for the conversion to complete
  while (!AD1CON1bits.DONE); 

  // Clear the conversion done flag
  AD1CON1bits.DONE = 0;

  // Read the conversion result
  ADCValue = ADC1BUF0;       
  ```)
  #set text(size: 9pt)]
)

#pagebreak()
=== manual sample - automatic conversion
*Application Example:* Event-driven acquisitions where you want to start a measurement immediately after a specific software state, but cannot afford blocking `DelayUs()` loops. The hardware accurately enforces the minimum required sampling time, freeing the CPU to execute a few other instructions.
#set text(size: 8pt)
  #zebraw(```c
  // --- ADC Setup Phase ---
  AD1CON1bits.ASAM = 0;     // Manual sampling
  AD1CON1bits.SSRC = 0b111; // Auto-conversion (internal counter)
  AD1CON3bits.SAMC = 16;    // Auto-Sample Time = 16 * TAD

  // --- Execution Phase ---
  // Manually initiate the sampling phase
  AD1CON1bits.SAMP = 1;      

  // Hardware automatically waits for SAMC duration
  // Hardware automatically clears SAMP and starts conversion

  // Wait for the conversion to complete
  while (!AD1CON1bits.DONE); 

  // Clear the conversion done flag
  AD1CON1bits.DONE = 0;

  // Read the conversion result
  ADCValue = ADC1BUF0;       
  ```)
  #set text(size: 9pt)


=== automatic sample - manual conversion
#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [*Application Example:* Reading high-impedance sensors (e.g., specific environmental probes) that require exceptionally long charging times for the sample-and-hold capacitor. This pattern continuously charges the capacitor while the CPU manages a custom, long-duration delay.

  #align(center, image("../images/70/asmc.png", width: 90%))],
  [#set text(size: 8pt)
    #zebraw(```c
    // --- ADC Setup Phase ---
    AD1CON1bits.ASAM = 1;     // Auto-sampling (starts immediately)
    AD1CON1bits.SSRC = 0b000; // Manual conversion trigger

    // --- Execution Phase ---
    while (1){
      // Wait for custom sampling time (100ms)
      DelayNmSec(100); 
      
      // Start the conversion (ends sampling)
      AD1CON1bits.SAMP = 0;
      
      while (!AD1CON1bits.DONE);
      AD1CON1bits.DONE = 0;
      ADCValue = ADC1BUF0;
    }      
    ```)
    #set text(size: 9pt)
  ]
)

=== automatic sample - automatic conversion
#grid(
  columns: (1fr, 1fr),
  align: horizon,
  gutter: 2em,
  [*Application Example:* Continuous digital signal processing, such as audio filtering, AC power waveform analysis, or direct memory streaming via DMA. The hardware automatically takes a sample, converts it, and immediately starts the next sample in an endless loop, without needing any CPU intervention.

  - *Maximum Speed:* It operates independently of software instruction delays.
  - *Perfect Timing (No Jitter):* The hardware guarantees perfectly equally-spaced samples.
  - *Continuous Streaming:* It is optimal for applications requiring a high-speed flow of data.],

  [#align(center, image("../images/70/asac.png", width: 100%))]
)

#pagebreak()
#set text(size: 7.5pt)
#zebraw(```c
// --- ADC Setup Phase ---
AD1CON1bits.ADON = 0;     // Disable ADC during configuration

// 1. Configure Pin (e.g., AN0)
TRISAbits.TRISA0 = 1;     // Set pin as digital input
ANSELAbits.ANSA0 = 1;     // Enable analog pin mode
AD1CHS0bits.CH0SA = 0;    // Route AN0 to Channel 0

// 2. Configure Timing
AD1CON3bits.ADCS = 10;    // Set TAD clock prescaler
AD1CON3bits.SAMC = 15;    // Auto-Sample Time = 15 * TAD

// 3. Enable Auto-Auto Mode
AD1CON1bits.ASAM = 1;     // Trigger: Auto-Sample immediately
AD1CON1bits.SSRC = 0b111; // Trigger: Auto-Convert (internal counter)

// Turn ADC back on
AD1CON1bits.ADON = 1;     

// --- Execution Phase ---
while (1){
    // Wait for hardware to finish both phases
    while (!AD1CON1bits.DONE);  
    
    // Clear the conversion done flag
    AD1CON1bits.DONE = 0;       
    
    // Read the conversion result
    ADCValue = ADC1BUF0;        
}      
```)
#set text(size: 9pt)

== ADC Multiple Channels
#blueBox([check Simultaneous Sampling and Sequential Sampling])

== `ADxCON1` Register
#align(center, image("../images/70/ADxCON1.png", width: 70%))
`ADxCON1`: ADC Control register 1.
- `ADON`: turns on the ADC module
- `SSRC`: selects how the conversion should start (0 = manual, 7 = internal counter)
- `ASAM`: selects how the sampling should start
- `SAMP`: sample enable bit
- `DONE`: tells when the A/D conversion is done

== `ADxCON2` Register
#align(center, image("../images/70/ADxCON2.png", width: 70%))
`ADxCON2`: ADC Control register 2:
- `CSCNA`: selects if inputs should be scanned
- `CHPS`: selects the channels
- `SMPI`: after how many conversions when the IF should be set to 1

== `ADxCON3` Register
#align(center, image("../images/70/ADxCON3.png", width: 70%))
`ADxCON3`: ADC Control register 3:
- `SAMC`: how long the sampling should last [0 Tad - 31 Tad] (it matters only if SSRC = 7)
- `ADCS`: selects how long is one Tad [1 Tcy - 64 Tcy]

== `ADxCHS0` Register
#align(center, image("../images/70/ADxCHS0.png", width: 70%))
`ADxCHS0`: selects the inputs to channel 0

== `ADxCHS123` Register
#align(center, image("../images/70/ADxCHS123.png", width: 70%))
`ADxCHS123`: selects the inputs to channels 1, 2 and 3 Results will be found in registers `ADCxBUF0` through `ADCxBUFF` 1

== Other Registers
#align(center, image("../images/70/other_reg.png", width: 70%))
1 = scan, 0 = do not scan

== Scan Mode
#align(center, image("../images/70/scan.png", width: 70%))

== `ANSELx` Register
`ANSELx`: sets pins as analog (1) or digital (0). As a thumb rule, always set each ANSELx to 0 and then toggle to 1 only the pins required to be analog

These registers are important, failing to configure them will result in errors during the conversion

== Configuring the ADC
1. select your Tad ADC time and set `ADxCON3bits.ADCS` (suggested value is 8 for our board)
2. select how sampling begins
  - manual: `ADxCON1bits.ASAM = 0;`
  - automatic: `ADxCON1bits.ASAM = 1;`
3. select how sampling ends and conversion begins
  - manual: `ADxCON1bits.SSRC = 0;`
  - automatic: `ADxCON1bits.SSRC = 7;` and then choose how long sampling lasts by setting `ADxCON3bits.SAMC`;
4. choose how many channels you want to use setting `ADxCON2bits.CHPS`
5. choose the positive input to the channels by setting `ADxCHS0bits.CH0SA`; and `ADxCHS123bits.CH123SA;`
6. set the input pins as analog (value 1) in `ANSELx` and the rest as digital (value 0)
7. if more than 1 channel is used, choose sequential or simultaneous sampling using `AxDCON1bits.SIMSAM`
8. if sequential set `ADxCON2bits.SMPI`; to number of inputs - 1; if simultaneous consider the number of channels used
9. finally, turn ADC on with `ADxCON1bits.ADON = 1`;

== DONE bit
The DONE bit is only cleared at the start of each conversion and is set at the completion of the conversion, but remains set indefinitely, even through the next sample phase until the next conversion begins.

If application code is monitoring the DONE bit in any kind of software loop, the user must consider this behavior because the CPU code execution is faster than the ADC.

As a result, in Manual Sample mode, particularly where the user's code is setting the SAMP bit, the DONE bit should also be cleared by the user application just before setting the SAMP bit.