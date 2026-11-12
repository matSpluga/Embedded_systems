#include "timer.h"

/* TIMER SETUP
    Fcy
        Fcy = Fosc/2 w/ Fosc = 144MHz
        .: Fcy = 72MHz -> 72000000 Hz

    prescaler           
        max_ms_16bit = (2^16 -1)/(Fcy * prescaler)
        max_ms_32bit = (2^32 -1)/(Fcy * prescaler)

        prescaler       | max_ms_16bit  | max_ms_32bit
        0b00 -> 1/1     |   0.9         |   119000      [~20 min]
        0b01 -> 1/8     |   7           |   954000      [~160 min]
        0b10 -> 1/64    |  58           |  7635000      [~21 ore]
        0b11 -> 1/256   | 233           | 30541000      [~84 ore]

    PR1 counter
        PR1 = Fcy * timer_seconds* prescaler < 65535
*/

int tmr_setup_period(int tmr, int ms){
    /* REQUIREMENTS
    [x] setups the timer timer to count for the specified number of milliseconds. 
    [x] support values up to 200 millisecond. 
    [x] it should start the timer */

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
    
    switch(tmr){
        case TIMER1:
            T1CON = 0x0000; // reinitialize the timer (by default TGATE = 0 and TCS = 0)

            T1CONbits.TCKPS = prescaler; // set the prescaler

            PR1 = (int)(cpms * ms); // set the target
            TMR1 = 0;               // reset timer counter

            IFS0bits.T1IF = 0; // clear the flag
            T1CONbits.TON = 1; // start the timer
            break;

        case TIMER2:
            T2CON = 0x0000;

            T2CONbits.TCKPS = prescaler;

            PR2 = (int)(cpms * ms);
            TMR2 = 0;           

            IFS0bits.T2IF = 0;
            T2CONbits.TON = 1;
            break;

        default:
            return NOTMR;
    }
};

int tmr_wait_period(int tmr){
    /* REQUIREMENTS
    [x] use the timer flag to wait until it has expired */

    switch(tmr){
        case TIMER1:
            if (IFS0bits.T1IF == 1){ // Deadline missed: the period expired before we started waiting
                IFS0bits.T1IF = 0;   // Clear it before returning
                return TMREXP;       // Attention: i DO NO know how many time it has expired
            }

            while (IFS0bits.T1IF == 0){
                // Wait for the timer flag to trigger
            }

            IFS0bits.T1IF = 0;  // Reset the flag
            break;

        case TIMER2:
            if (IFS0bits.T2IF == 1){ 
                IFS0bits.T2IF = 0;
                return TMREXP;       
            }

            while (IFS0bits.T2IF == 0){}

            IFS0bits.T2IF = 0;
            break;

        default:
            return NOTMR;
    }

    return 0; // no error
};

void tmr_wait_ms(int tmr, int ms){ //use the timer to wait for a given number of milliseconds given as input. 
    /* REQUIREMENTS
    [x] setup the timer
    [x] wait for it to expire
    [x] stop the timer
    [x] support values up to 200 milliseconds
    [x] The function should ensure that the timer starts from zero. 
    Note: the timer might have been previously used */

    tmr_setup_period(tmr, ms);
    tmr_wait_period(tmr);
    T1CONbits.TON = 0;  // Stop the timer
    TMR1 = 0;           // Reset timer counter

    return;
};