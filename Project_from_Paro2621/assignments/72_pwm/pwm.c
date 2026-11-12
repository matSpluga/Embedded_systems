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

    // Configurazione registri duty cycle
    // RD1 and RD3 mapping (backward)
    RPOR0bits.RP65R = 0x10;  // RD1 left
    RPOR1bits.RP67R = 0x12;  // RD3 right

    // RD2 and RD4 mapping (forward)
    RPOR1bits.RP66R = 0x11;     // RD2 left
    RPOR2bits.RP68R = 0x13;     // RD4 right

    // --- RESET DEI MODULI  ---
    OC1CON1 = 0; OC1CON2 = 0; 
    OC2CON1 = 0; OC2CON2 = 0;
    OC3CON1 = 0; OC3CON2 = 0;
    OC4CON1 = 0; OC4CON2 = 0;

    // --- IMPOSTAZIONE PERIODO INIZIALE (Frequenza PWM) ---
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

int pwm_set_duty_cycle(int mag, int reg){
    if(mag >= 0 && mag <40) mag = 40;
    if(mag > 100) mag = 100;

    return ((unsigned long)reg * mag) / 100;
}

int clamp(int value){
    if(value > 100) value = 100;
    if(value < -100) value = -100;

    return value;
}

void execute_motion(int speed, int yaw, int mag) {

    int left_motor_power  = clamp(speed + yaw) * mag / 100;
    int right_motor_power = clamp(speed - yaw) * mag / 100;

    // If speed > 0 the buggy moves straigth forward
    if (speed > 0){
        OC1R = 0;
        OC2R = pwm_set_duty_cycle(left_motor_power, OC2RS);
        OC3R = 0;
        OC4R = pwm_set_duty_cycle(right_motor_power, OC4RS);
    }
    // If speed < 0 the buggy moves straigth backward
    else if(speed < 0){
        OC1R = pwm_set_duty_cycle(left_motor_power, OC1RS);
        OC2R = 0;
        OC3R = pwm_set_duty_cycle(right_motor_power, OC3RS);
        OC4R = 0;
    }
    // If speed = 0 the buggy spins on itself, with yaw angular velocity
    else{
        // If yaw > 0 the buggy moves clockwise
        if(yaw > 0){
            OC1R = 0;
            OC2R = pwm_set_duty_cycle(left_motor_power, OC2RS);         
            OC3R = pwm_set_duty_cycle(right_motor_power, OC3RS);     
            OC4R = 0;   
        }
        // If yaw > 0 the buggy moves counterclockwise
        else if(yaw < 0){
            OC1R = pwm_set_duty_cycle(left_motor_power, OC1RS);
            OC2R = 0;         
            OC3R = 0;   
            OC4R = pwm_set_duty_cycle(right_motor_power, OC3RS);  
        }
        // If speed = 0 and yaw = 0 the buggy stops
        else{
            OC1R = 0;
            OC2R = 0;         
            OC3R = 0;   
            OC4R = 0;  
        }

    }
}