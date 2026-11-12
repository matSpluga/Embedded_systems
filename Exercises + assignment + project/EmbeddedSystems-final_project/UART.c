#include "UART.h"
#include "circular_buffer.h"
#include <xc.h>

// Buffer dimensionati sul baud rate (9600 baud -> 960 byte/s max):
// - RX_BUF_SIZE (32): comandi corti ($PCREF,speed,yawrate*)
// - TX_BUF_SIZE (128): assorbe il jitter di 1-2 messaggi ($MBATT/$MDIST/$MANGLE)
#define RX_BUF_SIZE 32
#define TX_BUF_SIZE 128

volatile char rx_storage[RX_BUF_SIZE];
volatile char tx_storage[TX_BUF_SIZE];
circular_buffer_t rx_cb;
circular_buffer_t tx_cb;

void uart_init_buffers() {
    cb_init(&rx_cb, rx_storage, RX_BUF_SIZE);
    cb_init(&tx_cb, tx_storage, TX_BUF_SIZE);
}

// UART RX INTERRUPT: ricezione non bloccante tramite buffer circolare.
void __attribute__((interrupt, no_auto_psv)) _U1RXInterrupt(void) {
    if (U1STAbits.OERR) U1STAbits.OERR = 0; // clear overflow error se il buffer HW e' pieno
    while (U1STAbits.URXDA) {
        char c = U1RXREG;
        cb_push(&rx_cb, c); // se il buffer software e' pieno il byte viene scartato
    }
    IFS0bits.U1RXIF = 0;
}

// UART TX INTERRUPT: svuota il buffer software finche' il registro HW non e' pieno.
void __attribute__((interrupt, no_auto_psv)) _U1TXInterrupt(void) {
    char c;
    while (!U1STAbits.UTXBF && cb_pop(&tx_cb, &c) == 0) {
        U1TXREG = c;
    }
    IFS0bits.U1TXIF = 0;
}

// Invio non bloccante: spinge i dati nel buffer circolare software
// e forza manualmente l'interrupt TX se il trasmettitore e' idle.
void send_string(char* str) {
    for (int i = 0; str[i] != '\0'; i++) {
        while (cb_push(&tx_cb, str[i]) != 0); // blocca solo se il buffer e' davvero pieno
    }
    if (IFS0bits.U1TXIF == 0) IFS0bits.U1TXIF = 1;
}
