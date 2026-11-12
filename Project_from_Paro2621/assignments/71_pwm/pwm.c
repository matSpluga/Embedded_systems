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
    return ((unsigned long)reg * percentage) / 100;
}

void execute_motion(int command) {
    switch(command) {
        case STRICTLY_FORWARD:
            OC1R = 0;
            OC2R = pwm_set_duty_cycle(100, OC2RS);
            OC3R = 0;
            OC4R = pwm_set_duty_cycle(100, OC4RS);
            
            break;
        case STRICTLY_BACKWARD:
            OC1R = pwm_set_duty_cycle(100, OC1RS);
            OC2R = 0;
            OC3R = pwm_set_duty_cycle(100, OC3RS);
            OC4R = 0;

            break;

        case TURN_LEFT_FORWARD:
            OC1R = 0;            
            OC2R = pwm_set_duty_cycle(40, OC2RS);    
            OC3R = 0;            
            OC4R = pwm_set_duty_cycle(100, OC4RS);   
            
            break;

        case TURN_RIGHT_FORWARD: 
            OC1R = 0;            
            OC2R = pwm_set_duty_cycle(100, OC2RS);   
            OC3R = 0;
            OC4R = pwm_set_duty_cycle(40, OC4RS);    
            
            break;

        case TURN_LEFT_BACKWARD:
            OC1R = pwm_set_duty_cycle(40, OC1RS);
            OC2R = 0;            
            OC3R = pwm_set_duty_cycle(100, OC3RS);     
            OC4R = 0;         

            break;

        case TURN_RIGHT_BACKWARD:
            OC1R = pwm_set_duty_cycle(100, OC1RS);
            OC2R = 0;
            OC3R = pwm_set_duty_cycle(40, OC3RS);
            OC4R = 0;

            break;

        case STOP_MOTION:
            OC1R = 0;
            OC2R = 0;
            OC3R = 0;
            OC4R = 0;

            break;

        default:
            OC1R = 0;
            OC2R = 0;
            OC3R = 0;
            OC4R = 0;

            break;
    }
}