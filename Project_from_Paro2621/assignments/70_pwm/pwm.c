#include "pwm.h"
#include "uart.h"
#include <xc.h>
#include <stdint.h>
#include <stdbool.h>

void pwm_init(void){
    // --- CONFIGURAZIONE PULSANTE ---
    TRISEbits.TRISE8 = 1;   // RE8 come input

    // --- CONFIGURAZIONE DIREZIONI PIN MOTORI (OUTPUT) ---
    TRISDbits.TRISD1 = 0;   // RD1 -> Output (Marcia Avanti - Ruota Sinistra / Destra a seconda del cablaggio)
    TRISDbits.TRISD2 = 0;   // RD2 -> Output (Marcia Indietro - Ruota Sinistra)
    TRISDbits.TRISD3 = 0;   // RD3 -> Output (Marcia Avanti - Ruota Destra)
    TRISDbits.TRISD4 = 0;   // RD4 -> Output (Marcia Indietro - Ruota Destra)

    // Spegniamo tutte le uscite logicamente all'avvio per sicurezza
    LATD = 0x0000; 

    // --- RESET COMPLETO DEI MODULI OC (1, 2, 3, 4) ---
    OC1CON1 = 0; OC1CON2 = 0; 
    OC2CON1 = 0; OC2CON2 = 0;
    OC3CON1 = 0; OC3CON2 = 0;
    OC4CON1 = 0; OC4CON2 = 0;

    // --- IMPOSTAZIONE PERIODO INIZIALE (Frequenza PWM) ---
    // Calcoliamo il registro di periodo basato su FCY per tutti e 4 i moduli
    unsigned int pwm_period = (FCY / 10000) - 1; 
    
    OC1RS = pwm_period;
    OC2RS = pwm_period;
    OC3RS = pwm_period;
    OC4RS = pwm_period;

    // Inizializziamo il Duty Cycle di tutti i moduli a 0 (Fermati)
    OC1R = 0; 
    OC2R = 0;
    OC3R = 0;
    OC4R = 0;

    // --- SORGENTE CLOCK (Peripheral Clock FP/FCY -> valore 7) ---
    OC1CON1bits.OCTSEL = 7; 
    OC2CON1bits.OCTSEL = 7;
    OC3CON1bits.OCTSEL = 7;
    OC4CON1bits.OCTSEL = 7;

    // --- SINCRONIZZAZIONE (Nessuna Sincronizzazione / Self-Sync -> valore 0x1F) ---
    OC1CON2bits.SYNCSEL = 0x1F; 
    OC2CON2bits.SYNCSEL = 0x1F; 
    OC3CON2bits.SYNCSEL = 0x1F; 
    OC4CON2bits.SYNCSEL = 0x1F; 

    // --- MODALITÀ PWM (Edge-Aligned PWM Mode -> valore 6) ---
    OC1CON1bits.OCM = 6; 
    OC2CON1bits.OCM = 6;
    OC3CON1bits.OCM = 6;
    OC4CON1bits.OCM = 6;
}

int pwm_set_duty_cycle(unsigned int percentage, int reg){
    if(percentage >= 0 && percentage <40) percentage = 40;
    if(percentage > 100) percentage = 100;

    // FIX OVERFLOW: Cast a unsigned long (32 bit) per evitare il troncamento
    return ((unsigned long)PTPER * percentage) / 100;
}