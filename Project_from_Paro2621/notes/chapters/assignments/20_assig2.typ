#import "/setup.typ": *

#pagebreak()
= Assignment 2: Timers
== `timer.c`
```c
#include "timer.h"

void tmr_setup_period(int tmr, int ms){
    float cpms;
    int prescaler;

    if(ms < 7){
        cpms = 9000.00;     // Fcy * prescaler * 0.001 (ms) -> fino a quanto devo contare per avere 1ms
        prescaler = 0b01;

    } else if (ms < 58){
        cpms = 1125.00;
        prescaler = 0b10;

    } else if (ms < 233){
        cpms = 281.25;
        prescaler = 0b11;
    }
    
    T1CONbits.TCKPS = prescaler;    // set the prescaler
    T1CONbits.TGATE = 0;            // Timer Gated Time Accumulation Enable Bit
    T1CONbits.TCS = 0;              // Timer Clock Source -> internal clock

    PR1 = (int)(cpms * ms);         // set the target

    TMR1 = 0;           // reset timer counter
    IFS0bits.T1IF = 0;  // clear the flag
    T1CONbits.TON = 1;  // start the timer
};

int tmr_wait_period(int tmr){

    if (IFS0bits.T1IF == 1){ // Deadline missed: the period expired before we started waiting
        IFS0bits.T1IF = 0;   // Clear it before returning
        return TMREXP;       // Attention: i DO NO know how many time it has expired
    }

    while (IFS0bits.T1IF == 0){} // Wait for the timer flag to trigger

    IFS0bits.T1IF = 0;  // Reset the flag
    return 0; // no error
};

void tmr_wait_ms(int tmr, int ms){ //use the timer to wait for a given number of milliseconds given as input. 
    tmr_setup_period(tmr, ms);
    tmr_wait_period(tmr);
    T1CONbits.TON = 0;  // Stop the timer
    TMR1 = 0;           // Reset timer counter

    return;
};
```
#set text(size: 9pt)

=== TCS (Timer Clock Source Select Bit)

This bit tells the timer what to use as its clock (its "tick").

- *`TCS = 0 (Internal Clock):`*\
  The timer ticks using the microcontroller's internal system instruction clock (Fcy​). In your previous code, you noted Fcy​ is 72MHz. This means every time the system clock pulses, the timer increments (divided by your prescaler). This is what you want for keeping track of actual time (milliseconds, seconds).

- *`TCS = 1 (External Clock):`*\
  The timer ignores the internal 72MHz clock and instead connects to a physical pin on the microcontroller (usually labeled T1CK). The timer will only increment when it sees a physical voltage pulse on that pin. You would use this if you were building something like a Geiger counter or a tachometer, where you need to count external physical events.

== `timer.h`

Include guard are a technique to prevent multiple inclusions of the same header file in a C program. Those guards avoids "redefinition" errors during compilation.

If a header file is included multiple times (directly or indirectly), the compiler
would process its contents repeatedly. This can cause conflicts, especially with type definitions, constants, and function declarations.

```c
#ifndef TIMER_H_
#define TIMER_H_

#include <xc.h>

#define TMREXP -1   // timer expired flag

// Function prototypes
void tmr_setup_period(int tmr, int ms);
int tmr_wait_period(int tmr);
void tmr_wait_ms(int tmr, int ms);

#endif // TIMER_H_
```

== `main.c` for the exercise 1
```c
/**
 * @file main.c
 * @author ric
 * @date 2026-03-05
 * @brief Main function
*/

#include "timer.h"
#include <xc.h>

#define MAXITER 100

#define LED_ON  1
#define LED_OFF 0

#define TIMER1 1
#define TIMER2 2

int main() {
    // --- setup ---
    
    // disable all Analog pins
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;

    TRISAbits.TRISA0 = 0;   // set the pin as output [LD1]
    
    tmr_setup_period(TIMER1, 200);
    
    // --- loop ---
    for(int it = 0; it<MAXITER; it++){

        if(LATAbits.LATA0 == 1){
            LATAbits.LATA0 = LED_OFF; // Turn LED OFF
        } else {
            LATAbits.LATA0 = LED_ON; // Turn LED On
        }

        tmr_wait_period(TIMER1);
    }

    while(1){
        LATAbits.LATA0 = LED_ON; // Turn LED On
    }
}
```