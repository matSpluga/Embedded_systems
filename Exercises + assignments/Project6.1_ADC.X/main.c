#include <xc.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h> 
#include "config.h"
#include "timer.h"

// Circular buffers
#define BUF_SIZE 64
volatile char rx_buffer[BUF_SIZE];
volatile int rx_head = 0;
volatile int rx_tail = 0;

#define TX_BUF_SIZE 256 
volatile char tx_buffer[TX_BUF_SIZE];
volatile int tx_head = 0;
volatile int tx_tail = 0;

#define CS_ACC LATBbits.LATB3
#define IR_EN_TRIS TRISGbits.TRISG1 // Pin EN del sensore IR (RG1)
#define IR_EN_LAT  LATGbits.LATG1

// Constants for calculations
#define ADC_MAX 1023.0              // 10-bit ADC
#define VREF 3.3                    // Reference Voltage
#define BATTERY_DIVIDER 2.0         // Voltage divider factor

// UART Interrupts
void __attribute__((interrupt, no_auto_psv)) _U1RXInterrupt(void) {
    if (U1STAbits.OERR) U1STAbits.OERR = 0;
    while (U1STAbits.URXDA) {
        char c = U1RXREG;
        int next = (rx_head + 1) % BUF_SIZE;
        if (next != rx_tail) {
            rx_buffer[rx_head] = c;
            rx_head = next;
        }
    }
    IFS0bits.U1RXIF = 0;
}

void __attribute__((interrupt, no_auto_psv)) _U1TXInterrupt(void) {
    while (!U1STAbits.UTXBF && tx_tail != tx_head) {
        U1TXREG = tx_buffer[tx_tail];
        tx_tail = (tx_tail + 1) % TX_BUF_SIZE;
    }
    IFS0bits.U1TXIF = 0;
}

void send_string(char* str) {
    for (int i = 0; str[i] != '\0'; i++) {
        int next = (tx_head + 1) % TX_BUF_SIZE;
        while (next == tx_tail);
        tx_buffer[tx_head] = str[i];
        tx_head = next;
    }
    if (IFS0bits.U1TXIF == 0) IFS0bits.U1TXIF = 1;
}

// Assignment 1: Read battery (Manual/Manual)
float read_battery() {
    // Config: sampling=0 (manual), conversion=0 (manual)
    adc_config(0, 0, 0, 0, 0, 0); 
    AD1CHS0bits.CH0SA = 11;      // Seleziona AN11
    
    AD1CON1bits.SAMP = 1;        // Start sampling 
    tmr_wait_ms(TIMER2, 2);      
    AD1CON1bits.SAMP = 0;        // End sampling
    
    while (!AD1CON1bits.DONE);   // Wait until conversion done 
    return (ADC1BUF0 / 1023.0) * 3.3 * 2.0;
}

// Assignment 2: Read IR sensor (Manual/Auto)
double read_distance() {
    // Config: sampling=0 (manual), conversion=7 (auto), n_tad=16, tad_len=8
    adc_config(0, 7, 16, 8, 0, 0);
    AD1CHS0bits.CH0SA = 5;       // AN5 (RB5)
    
    AD1CON1bits.SAMP = 1;        // Start sampling 
    
    while (!AD1CON1bits.DONE);
    double v_ir = (ADC1BUF0 / 1023.0) * 3.3;
 
    return 2.34 - 4.74*v_ir + 4.06*v_ir*v_ir - 1.60*v_ir*v_ir*v_ir + 0.24*v_ir*v_ir*v_ir*v_ir;
}

// 1. Questa funzione ESEGUE lo scan attivamente
// La chiamiamo ogni 1ms o ad ogni ciclo del loop per aggiornare i dati
void scan_read(float* battery, double* distance) {
    // Configura lo scan manuale (sampling=1, conversion=7 per auto-convert rapido)
    // Usiamo SSRC=7 così quando diamo il via, lui fa AN5 e AN11 a raffica
    adc_config(1, 7, 16, 8, 1, 2); 

    AD1CSSL = 0;
    AD1CSSLbits.CSS5 = 1;  // IR
    AD1CSSLbits.CSS11 = 1; // Batteria

    // Fai partire lo scan
    AD1CON1bits.SAMP = 1; 
    
    // Aspetta che l'hardware finisca entrambi i canali
    while (!AD1CON1bits.DONE);
    
    int raw_ir = ADC1BUF0;
    int raw_bat = ADC1BUF1;

    // Converti i dati
    *battery = (raw_bat / 1023.0) * 3.3 * 2.0;
    double v_ir = (raw_ir / 1023.0) * 3.3;
    *distance = 2.34 - 4.74*v_ir + 4.06*v_ir*v_ir - 1.60*v_ir*v_ir*v_ir + 0.24*v_ir*v_ir*v_ir*v_ir;
    
    // Spegni per risparmiare energia o resettare lo stato (opzionale)
    AD1CON1bits.ADON = 0; 
}

int main(void) {
    input_config();
    uart_config();
    spi_config();
    
    // Pin setup
    ANSELBbits.ANSB11 = 1; 
    TRISBbits.TRISB11 = 1; 
    ANSELBbits.ANSB5 = 1; 
    TRISBbits.TRISB5 = 1; 
    
    IR_EN_TRIS = 0; 
    IR_EN_LAT = 1;

    // Timer per il loop di controllo (1ms = 1kHz)
    tmr_setup_period(TIMER1, 1); 
    
    int main_counter = 0;
    char out_buf[256];
    float current_bat;
    double current_dist;

    while (1) {
        // 1. SCANSIONE: Questa avviene ogni 1ms (1kHz)
        // La funzione viene chiamata "a turno" per i canali
        scan_read(&current_bat, &current_dist);

        // 2. UART: Questa avviene ogni 100ms (10Hz)
        // main_counter arriva a 100 perché il loop è da 1ms
        if (main_counter % 100 == 0) { 
            sprintf(out_buf, "$BAT,%.2f* $DIST,%.2f*\r\n", (double)current_bat, current_dist);
            send_string(out_buf);
        }

        main_counter++;
        if (main_counter >= 1000) main_counter = 0;

        tmr_wait_period(TIMER1); // Aspetta 1ms
    }
}