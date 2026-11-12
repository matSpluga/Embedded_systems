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
#include "basic_uart.h"
#include "button.h"
#include "utils.h"

volatile char tx_string[5];

void formatWrite_spi(int number, char* tx_buffer) {
    int hund = ((int) number / 100) % 10;
    int tens = ((int) number / 10) % 10;
    int ones = (int) number % 10;

    tx_buffer[0] = '0' + hund; 
    tx_buffer[1] = '0' + tens;  
    tx_buffer[2] = '0' + ones;  
    tx_buffer[3] = '\n';        
    tx_buffer[4] = '\0';        
}

unsigned int spi_write(unsigned int data) {
    while (SPI1STATbits.SPITBF == 1); // Wait until TX buffer is empty
    SPI1BUF = data;                   // Send the byte
    while (SPI1STATbits.SPIRBF == 0); // Wait until RX buffer is full
    return SPI1BUF;                   // Return the received byte
}

int main(){
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;
    
    RPINR18bits.U1RXR = 0b1001011;  // UART input map
    RPOR0bits.RP64R = 0b000001;     // UART output map
    uart1_standard_setup();         // UART setup

    /* --- danger zone begins ---*/

    // --- SPI pin remap 

        // MISO
    TRISAbits.TRISA1 = 1;   // RA1-RPI17
    RPINR20bits.SDI1R = 0b0010001;  // (SDI1) - RPI17

        // MOSI
    TRISFbits.TRISF13 = 0;  // RF13-RP109
    RPOR12bits.RP109R = 0b000101;   // (SDO1) - RF13

        // SCK  
    TRISFbits.TRISF12 = 0;  // RF12-RP108
    RPOR11bits.RP108R = 0b000110;   // SCK1

        //CS
    TRISBbits.TRISB3 = 0; // RB3 accelerometer
    TRISBbits.TRISB4 = 0; // RB4 gyroscope
    TRISDbits.TRISD6 = 0; // RD6 magnetometer 

    #define ACC_CS LATBbits.LATB3
    #define GYR_CS LATBbits.LATB4
    #define MAG_CS LATDbits.LATD6

    ACC_CS = 1;
    GYR_CS = 1;
    MAG_CS = 1;
    
    // --- SPI setup
    SPI1CON1bits.MSTEN = 1;     // master mode
    SPI1CON1bits.MODE16 = 0;    // 8-bit mode
    SPI1CON1bits.PPRE = 3;      // 1:1 primary prescaler
    SPI1CON1bits.SPRE = 3;      // 5:1 secondary prescaler
    
        // Bosch SPI require idle LOW 
    SPI1CON1bits.CKE = 1; // Output data changes on transition from active to idle
    SPI1CON1bits.CKP = 0; // Idle state for clock is a low level

    SPI1STATbits.SPIEN = 1;     // enable SPI

    // --- wakeup magnetometer

        // 1. Suspend -> Sleep Mode (write 0x01 at 0x4B)
    MAG_CS = 0;
    spi_write(0x4B); // MSB è già 0 -> non ho bisogno di azzerarlo manualmente
    spi_write(0x01);
    MAG_CS = 1;

        // 2. Sleep Mode -> Active Mode (write 0x00 at 0x4C)
    MAG_CS = 0;
    spi_write(0x4C); // MSB è già 0 -> non ho bisogno di azzerarlo manualmente
    spi_write(0x00);        
    MAG_CS = 1;

    // --- handshake
    uint8_t read_addr = 0x40;
    int value_from_chip;

    MAG_CS = 0;
    spi_write(read_addr | 0x80); // MSB = 1 per leggere, in questo caso va fatto manualmente
    value_from_chip = spi_write(0x00);
    MAG_CS = 1;

    formatWrite_spi(value_from_chip, tx_string);
    uart1_write(tx_string);

    /* --- safe zone again --- */
    if (value_from_chip == 0x32)  uart1_write("SIUM");
    else uart1_write("DIO PORCO!");

    while (1){}
    return 0;
}
