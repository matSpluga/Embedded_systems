/**
 * @file main.c
 * @author ric
 * @date 2026-04-05
 * @brief Main function
 */

/* Assignment
    1.  Simulate a function call that needs 7 ms for its execution and needs to work at 100 Hz (10ms).
    2.  Make LD2 blink at 2.5 Hz -> 400ms
    3.  Read characters from UART1. Keep a counter of how many chars you have received. If a
        string “LD1” is received, toggle the status of LD1. If a string “LD2” is received stop or resume
        the blinking of LD2.
    4.  Whenever button T2 is pressed, send “C=xx”, where xx is the current number of chars
        received to the UART1
    5.  Whenever button T3 is pressed, send “D=yy”, where yy is the number of times the deadline
        of the tmr_wait_period() was missed.
    6.  Follow the template provided in the next slide.
*/

/* Note per il prossimo progetto:
    1.  Niente logica di basso livello nel main.
    2.  Librerie -> riutilizzabilità.
    3.  Lista di #define per le periferiche: più facile da modificare e meno pesante da riportare.
    4.  Codice non bloccante: Mai usare delay() nel loop principale; usa sempre i timer.
    5.  Incapsulamento: Usa 'static' per nascondere variabili/funzioni esclusive di un file .c.
    6.  Usa le Struct: Raggruppa le variabili correlate (es. lo stato e i counter di un bottone).
    7.  ISR corte e veloci: Negli interrupt leggi i dati e imposta flag, fai il lavoro pesante nel main.
    8.  Usa 'volatile': Obbligatorio per tutte le variabili condivise tra un interrupt e il main.
*/

#include <xc.h>
#include "timer.h"
#include "basic_uart.h"
#include "button.h"
#include "utils.h"

#define LED1_TRIS   TRISAbits.TRISA0
#define LED2_TRIS   TRISGbits.TRISG9
#define LED1_LAT    LATAbits.LATA0
#define LED2_LAT    LATGbits.LATG9

#define BTN_T1_TRIS TRISEbits.TRISE9
#define BTN_T1_PORT PORTEbits.RE9

#define BTN_T2_TRIS TRISEbits.TRISE8
#define BTN_T2_PORT PORTEbits.RE8

#define MAXDEBCYCLE 1 // x*10ms

volatile int deadlineMissed;
volatile int charReceived;    

volatile int step = 0;   // hyperloop step counter

ButtonState btn_1 = {1, MAXDEBCYCLE};
ButtonState btn_2 = {1, MAXDEBCYCLE};

volatile int blink_enable = 1;

volatile char tx_string[6];
volatile char echo_str[2];

void algorithm(){
    tmr_wait_ms(TIMER3, 7);
}

int main(){
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;
   
    char cmd[3] = "--";
    RPINR18bits.U1RXR = 0b1001011;  // UART input map
    RPOR0bits.RP64R = 0b000001;     // UART output map
    uart1_standard_setup();         // UART setup

    LED1_TRIS = 0;   // set LD1 as output
    LED2_TRIS = 0;   // set LD2 as output

    BTN_T2_TRIS = 1;   // LD1 button as input
    BTN_T1_TRIS = 1;   // LD2 button as input

    tmr_setup_period(TIMER1, 10);

    while (1){
        // --- 0. perform heavy computation --- //
        algorithm();
        
        // --- 1. read data (empty buffer) --- //
        int data = uart1_read_char();
        
        while(data != RX_BUFFER_EMPTY){
            charReceived++;
            
            // --- 1.1 echo --- //
            echo_str[0] = (char) data;
            echo_str[1] = '\0'; // Null terminator
            uart1_write(echo_str);

            // --- 1.2 cmd interpretation --- //
            if((cmd[0] == 'L') && (cmd[1] == 'D')){
                if (data == '1'){
                    LED1_LAT ^= 1;    // XOR toggles the LED state (ON to OFF, OFF to ON)
                } else if (data == '2'){
                    blink_enable ^= 1;      // XOR toggles the LED state (ON to OFF, OFF to ON)
                }
            }

            // --- 1.3 cmd update --- // 
            cmd[0] = cmd[1];
            cmd[1] = data;

            data = uart1_read_char();
        }

        // --- 2. blink --- //
        if (step == 40) {   // 40 ticks * 10ms = 400ms
            if (blink_enable == 1) LED2_LAT ^= 1;	
            step = 0;		// Reset the counter for the next 400ms phase
        }

        // --- 3. first button --- //
        if (button_has_just_been_pressed(&btn_1, BTN_T1_PORT)) {
            formatWrite('C', charReceived, tx_string);
            uart1_write(tx_string);
        }

        // --- 4. second button --- //
        if (button_has_just_been_pressed(&btn_2, BTN_T2_PORT)) {
            formatWrite('D', deadlineMissed, tx_string);
            uart1_write(tx_string);
        }

        // --- 5. increment hyperloop counter --- //
        step++;

        // --- 6. missed deadlone check --- //
        if (tmr_wait_period(TIMER1) == TMREXP)
            deadlineMissed++;
    }
    return 0;
}
