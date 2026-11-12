#include "config.h"
#include <xc.h>

#define CS_ACC LATBbits.LATB3

// Input as digital
void input_config() {
    // Set all pins as digital
    ANSELA = ANSELB = ANSELC = ANSELD = ANSELE = ANSELG = 0x0000;
}

void uart_config() {
    TRISDbits.TRISD11 = 1; // RX pin
    TRISDbits.TRISD0 = 0;  // TX pin
    RPINR18bits.U1RXR = 75; // Map U1RX to RP75
    RPOR0bits.RP64R = 0x01; // Map U1TX to RP64
    U1MODEbits.BRGH = 0;    
    U1BRG = 468; 

    // Interrupt configurations
    IPC2bits.U1RXIP = 5;
    IFS0bits.U1RXIF = 0;
    IEC0bits.U1RXIE = 1;

    IPC3bits.U1TXIP = 5;
    IFS0bits.U1TXIF = 0;
    IEC0bits.U1TXIE = 1;

    U1MODEbits.UARTEN = 1; // Enable UART
    U1STAbits.UTXEN = 1;  // Enable Transmitter
}

void spi_config() {
    TRISAbits.TRISA1 = 1;  // SDI
    TRISFbits.TRISF12 = 0; // SCK
    TRISFbits.TRISF13 = 0; // SDO
    RPINR20bits.SDI1R = 17;
    RPOR12bits.RP109R = 5;
    RPOR11bits.RP108R = 6;

    SPI1CON1bits.MSTEN = 1;
    SPI1CON1bits.MODE16 = 0;
    SPI1CON1bits.CKP = 1;
    SPI1CON1bits.CKE = 0;
    SPI1CON1bits.PPRE = 3;
    SPI1CON1bits.SPRE = 3;
    SPI1STATbits.SPIEN = 1;
    
    // SPI Chip Select Pins
    TRISDbits.TRISD6 = 0; // MAG
    TRISBbits.TRISB4 = 0; // GYRO
    TRISBbits.TRISB3 = 0; // ACC
    
    // Initialize all CS to High (inactive) 
    LATDbits.LATD6 = 1; 
    LATBbits.LATB4 = 1;
    LATBbits.LATB3 = 1;
}

unsigned int spi_write(unsigned int data) {
    while (SPI1STATbits.SPITBF == 1); // Wait until TX buffer is not full
    SPI1BUF = data;
    while (SPI1STATbits.SPIRBF == 0); // Wait until RX is complete
    return SPI1BUF;
}

void init_accelerometer() {
    CS_ACC = 0;
    spi_write(0x0F); 
    spi_write(0x03); //Sets accelerometer range to �2g.
    CS_ACC = 1;
}

void set_bandwidth(int bw_val) {
    CS_ACC = 0;
    spi_write(0x10);  
    spi_write(bw_val); 
    CS_ACC = 1;
}

// adc setup (manual/automatic/scan)
void adc_config(int sampling, int conversion, int n_tad, int tad_length, int scan, int n_channels) {
    AD1CON1bits.ADON = 0;       // Configuration while off
    
    AD1CON1bits.AD12B = 0;      // 10-bits
    AD1CON1bits.FORM = 0;       
    
    AD1CON1bits.ASAM = sampling;   
    AD1CON1bits.SSRC = conversion; 

    if (conversion == 7) {
        if (n_tad < 0) AD1CON3bits.SAMC = 0; 
        else if (n_tad > 31) AD1CON3bits.SAMC = 31;
        else AD1CON3bits.SAMC = n_tad;
        
        if (tad_length < 1) AD1CON3bits.ADCS = 1;
        else if (tad_length > 64) AD1CON3bits.ADCS = 64;
        else AD1CON3bits.ADCS = tad_length;
    }
    
    if (scan == 1) {
        AD1CON2bits.CSCNA = 1;    // Scan mode 
        AD1CON1bits.SIMSAM = 0;   // Sequential sampling 

        if (n_channels > 0)
            AD1CON2bits.SMPI = n_channels - 1; 
        else 
            AD1CON2bits.SMPI = 0;
    } else {
        AD1CON2bits.CSCNA = 0;
        AD1CON2bits.SMPI = 0;
    }
    
    AD1CON1bits.ADON = 1;       // Turn on adc
}

void pwm_config(int div,int pwm_fc){
    PTCONbits.PTEN = 1;             // turns on the PWM time base module 
    PTCON2bits.PCLKDIV = 0b100;     // division by 16

    IOCON1bits.PENH = 1; // Enable as PWM output 
    IOCON1bits.PENL = 1; // Enable as PWM output 
    
    PTPER = (144000000 / (pwm_fc * 16)) - 1;   // Specify duty cycle  

    PDC1 = 0;
}

void oc_config(int compare_mode) {
    
    if (compare_mode == 1) {
        // Edge-aligned mode 
        // OC1RS resets the timer 
        // OC1R decides duty cycle
        
        OC1CON1bits.OCTSEL = 0b111; 
        OC1CON2bits.SYNCSEL = 0x1F; 
        
        OC1CON1bits.OCM = 0b110;    // 0b110 = Edge-Aligned PWM mode
    } 
    else if (compare_mode == 2) {
        // Dual compare mode 
                
        OC1CON1bits.OCTSEL = 0b000; // Esempio: usiamo Timer2 come sorgente di clock
        OC1CON2bits.SYNCSEL = 0x0C; // Sincronizzato con il periodo di Timer2 (0x0C indica Timer2)
        
        OC1CON1bits.OCM = 0b101;    // 0b101 = Continuous Pulse mode (Dual Compare)
    }
    else if (compare_mode == 3) {
        // Single compare mode 
        // Il pin cambia stato (es. fa un Toggle, cambia da 0 a 1 o viceversa) 
        // SOLO quando il timer incontra il valore in OC1R. 
        // Non gli importa del valore di OC1RS.
        
        OC1CON1bits.OCTSEL = 0b000; // Sempre agganciato a un Timer esterno (es. Timer2)
        
        OC1CON1bits.OCM = 0b011;    // 0b011 = Toggle profile (Single Compare)
    }
    else {
        // Spegne il modulo
        OC1CON1bits.OCM = 0b000;    // Output Compare disattivato
    }
}