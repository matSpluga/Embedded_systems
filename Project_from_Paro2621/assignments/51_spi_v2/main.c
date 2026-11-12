/**
 * @file main.c
 * @author ric
 * @date 2026-04-05
 * @brief Main function for spi
 */

/* Assignment
    Exercise 1: 
        create a function ```unsigned int spi_write(unsigned int data);``` that
        writes the data to the SPI, and returns the value read from the other device. 
        
        Then use the function to solve the following exercise:
        1.  Configure SPI;
        2.  Make the magnetometer switch to Sleep mode; then make it go to active mode;
        3.  Acquire the Chip ID and send it to the UART.

    Exercise 2:
        1.  Configure SPI;
        2.  Make the magnetometer switch to Sleep mode; then make it go to active mode;
        3.  Acquire the x-axis of the magnetometer and send it to the
            UART at 10 Hz using the protocol $MAGX=xxx*, where xxx is the value.
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
#include "uart.h"
#include "spi.h"
#include "button.h"
#include "utils.h"

volatile char tx_string[11];

void formatWrite_spi(int number, char* tx_buffer) {   
    tx_buffer[0] = 'M';   
    tx_buffer[1] = 'A';   
    tx_buffer[2] = 'G';   
    tx_buffer[3] = 'X';   
    tx_buffer[4] = '=';  
    tx_buffer[5] = ' '; 

    if (number < 0) {
        tx_buffer[5] = '-'; 
        number = -number; // Get absolute value
    }

    int hund = ((int) number / 100) % 10;
    int tens = ((int) number / 10) % 10;
    int ones = (int) number % 10;
 
    tx_buffer[6] = '0' + hund; 
    tx_buffer[7] = '0' + tens;  
    tx_buffer[8] = '0' + ones;  
    tx_buffer[9] = '\n';        
    tx_buffer[10] = '\0';        
}

/* --- pheriperal specific --- */

#define ACC_CS LATBbits.LATB3 // RB3 accelerometer
#define GYR_CS LATBbits.LATB4 // RB4 gyroscope
#define MAG_CS LATDbits.LATD6 // RD6 magnetometer 

void BOSCH_BMX055_setup(){
    // Bosch BMX055 SPI protocol require idle LOW 

    SPI1STATbits.SPIEN = 0;     // disable SPI to change settings

            // protocol SPI
    SPI1CON1bits.MSTEN = 1;     // master mode
    SPI1CON1bits.MODE16 = 0;    // 8-bit mode
    SPI1CON1bits.PPRE = 3;      // 1:1 primary prescaler
    SPI1CON1bits.SPRE = 3;      // 5:1 secondary prescaler

    SPI1CON1bits.CKE = 1;       // Output data changes on transition from active to idle
    SPI1CON1bits.CKP = 0;       // Idle state for clock is a low level

    SPI1STATbits.SPIEN = 1;     // re-enable SPI

    tmr_wait_ms(TIMER1, 100);
}

int main(){
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;
    
    uart1_mikrobus2_setup();    // UART on mikrobus2 setup
    spi1_mikrobus1_setup();      // SPI on mikrobus1 setup

    BOSCH_BMX055_setup();

    // --- wakeup magnetometer

        // 1. Suspend -> Sleep Mode (write 0x01 at 0x4B)
    MAG_CS = 0;
    spi1_write(0x4B); // MSB è già 0 -> non ho bisogno di azzerarlo manualmente
    spi1_write(0x01);
    MAG_CS = 1;
    tmr_wait_ms(TIMER1, 100); // sleep time for power mode switching

        // 2. Sleep Mode -> Active Mode (write 0x00 at 0x4C)
    MAG_CS = 0;
    spi1_write(0x4C); // MSB è già 0 -> non ho bisogno di azzerarlo manualmente
    spi1_write(0x00);        
    MAG_CS = 1;
    tmr_wait_ms(TIMER1, 100); // sleep time for power mode switching

    // --- handshake
    uint8_t read_addr = 0x40;
    int value_from_chip;

    MAG_CS = 0;
    spi1_write(read_addr | 0x80); // MSB = 1 per leggere, in questo caso va fatto manualmente
    value_from_chip = spi1_write(0x00);
    MAG_CS = 1;

    formatWrite_spi(value_from_chip, tx_string);
    uart1_write(tx_string);

    if (value_from_chip == 0x32)  uart1_write("Handshake confermato!");
    else uart1_write("Errore!");

    tmr_setup_period(TIMER1, 200); // for 10Hz 

    unsigned int DATA_X_LSB, DATA_X_MSB;
    int out;

    while (1){
        MAG_CS = 0;
        spi1_write(0x42| 0x80); // MSB = 1 per leggere
        DATA_X_LSB = spi1_write(0x00);
        DATA_X_MSB = spi1_write(0x00);
        MAG_CS = 1;

        DATA_X_LSB = DATA_X_LSB & 0b11111000;
        DATA_X_MSB = DATA_X_MSB << 8;
        
        out = (int) DATA_X_MSB | DATA_X_LSB;
        
        out = out / 8;

        formatWrite_spi(out, tx_string);
        uart1_write(tx_string);

        tmr_wait_period(TIMER1);
    }
    return 0;
}
