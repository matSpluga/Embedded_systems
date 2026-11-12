#include <xc.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "config.h"
#include "timer.h"
#include "circular_buffer.h"
#include "UART.h"
#include "battery.h"
#include "IR.h"
#include "pwm.h"

// Pin mapping
#define LEFT_LIGHT   LATBbits.LATB8   // RB8
#define RIGHT_LIGHT  LATFbits.LATF1   // RF1
#define LOW_LIGHT    LATGbits.LATG1   // RG1
#define LOOP_LED     LATAbits.LATA0   // LED A0

#define BTN_RE8      PORTEbits.RE8
#define BTN_RE9      PORTEbits.RE9



typedef enum {
    STATE_HALTED = 0,
    STATE_MOVING,
    STATE_OBSTACLE_AVOIDANCE
} buggy_state;



int main(void) {
    input_config();
    uart_config();
    spi_config();

    // Output pins per luci e LED
    TRISBbits.TRISB8 = 0;
    TRISFbits.TRISF1 = 0;
    TRISGbits.TRISG1 = 0;
    TRISAbits.TRISA0 = 0;

    // Input pulsanti 
    TRISEbits.TRISE8 = 1;
    TRISEbits.TRISE9 = 1;

    // Initialize circular buffers 
    uart_init_buffers();

    // Motor PWM: RD1-RD4 -> OC1-OC4, Edge-Aligned PWM at 10kHz
    pwm_init();

    // Loop di controllo a 500Hz -> periodo 2ms
    tmr_setup_period(TIMER1, 2);

    buggy_state state = STATE_HALTED;

    int button_press = 0;      // flag for button toggle on release (RE8) 
    int button_re9_press = 0;  // flag for button toggle on release (RE9) 
    int light_blink_counter = 0;
    int loop_led_counter = 0;
    int sensor_10hz_counter = 0;
    int light_on = 0;          // current blink state of the lateral lights (1Hz) 

    int speed = 0;
    int yawrate = 0;
    int left_pwm, right_pwm;

    int bat_1hz_counter = 0;
    float current_battery = 0.0;
    
    char rx_msg[32];
    int rx_index = 0;
    int parsing = 0;

    // 1Hz at 500Hz loop -> half period = 250 cycles 
    #define BLINK_HALF_PERIOD 250
    // 10Hz at 500Hz loop -> period = 50 cycles 
    #define SENSOR_10HZ_PERIOD 50

    while (1) {

        // --- RE8 button: toggle Halted <-> Moving --- 
        if (BTN_RE8 == 0) {
            button_press = 1;
        }
        if (BTN_RE8 == 1 && button_press == 1) {
            button_press = 0;
            if (state == STATE_HALTED) {
                state = STATE_MOVING;
            } else if (state == STATE_MOVING) {
                state = STATE_HALTED;
            }
            // if in OBSTACLE_AVOIDANCE, the button forces Halted
            else if (state == STATE_OBSTACLE_AVOIDANCE) {
                state = STATE_HALTED;
            }
        }

        // --- RE9 button: trigger $MBUF,tx,rx* message --- 
        if (BTN_RE9 == 0) {
            button_re9_press = 1;
        }
        if (BTN_RE9 == 1 && button_re9_press == 1) {
            button_re9_press = 0;
            
            char msg[32];
            int tx_avail = cb_available(&tx_cb);
            int rx_avail = cb_available(&rx_cb);
            sprintf(msg, "$MBUF,%d,%d*", tx_avail, rx_avail);
            
            for (int i = 0; msg[i] != '\0'; i++) {
                cb_push(&tx_cb, msg[i]);
            }
            // Trigger TX interrupt manually to start sending if needed 
            IFS0bits.U1TXIF = 1; 
        }

        // --- shared 1Hz blink for the lateral lights --- 
        if (++light_blink_counter >= BLINK_HALF_PERIOD) {
            light_blink_counter = 0;
            light_on = !light_on;
        }

        // --- output handling depending on the state ---
        switch (state) {
            case STATE_HALTED:
                LEFT_LIGHT  = light_on;
                RIGHT_LIGHT = light_on;
                LOW_LIGHT   = 0;
                set_motor_pwm(0, 0);
                break;

            case STATE_MOVING:
                LEFT_LIGHT  = 0;
                RIGHT_LIGHT = 0;
                LOW_LIGHT   = 1;

                // left_pwm = speed - yawrate, right_pwm = speed + yawrate, saturated to +-100%
                left_pwm = speed - yawrate;
                right_pwm = speed + yawrate;
                set_motor_pwm(left_pwm, right_pwm);
                break;

            case STATE_OBSTACLE_AVOIDANCE:
                LEFT_LIGHT  = 0;
                RIGHT_LIGHT = light_on;
                LOW_LIGHT   = 1;
                // TODO: rotate/forward/rotate sequence and obstacle sensor logic
                break;
        }

        // --- LED A0: always blinks at 1Hz, shows the main loop is running --- 
        if (++loop_led_counter >= BLINK_HALF_PERIOD) {
            loop_led_counter = 0;
            LOOP_LED = !LOOP_LED;
        }

        // --- 10 Hz Tasks: Sensors and UART TX --- 
        if (++sensor_10hz_counter >= SENSOR_10HZ_PERIOD) {
            sensor_10hz_counter = 0;
            
            double distance;
            scan_read(&current_battery, &distance);
            
            char msg[64];
            sprintf(msg, "$MDIST,%d*", (int)distance);
            send_string(msg);
            
            // Dummy angles as sensor reading is missing
            sprintf(msg, "$MANGLE,0,0,0*");
            send_string(msg);
            
            if (++bat_1hz_counter >= 10) {
                bat_1hz_counter = 0;
                int b_int = (int)current_battery;
                int b_dec = (int)((current_battery - b_int) * 100);
                if (b_dec < 0) b_dec = -b_dec;
                sprintf(msg, "$MBATT,%d.%02d*", b_int, b_dec);
                send_string(msg);
            }
        }

        // --- UART RX Parsing --- 
        char rx_char;
        while (cb_available(&rx_cb) > 0) {
            cb_pop(&rx_cb, &rx_char);
            if (rx_char == '$') {
                parsing = 1;
                rx_index = 0;
            } else if (parsing && rx_char == '*') {
                rx_msg[rx_index] = '\0';
                parsing = 0;
                if (strncmp(rx_msg, "PCREF,", 6) == 0) {
                    sscanf(rx_msg + 6, "%d,%d", &speed, &yawrate);
                }
            } else if (parsing) {
                if (rx_index < sizeof(rx_msg) - 1) {
                    rx_msg[rx_index++] = rx_char;
                } else {
                    parsing = 0; // buffer overflow
                }
            }
        }

        tmr_wait_period(TIMER1); // wait for the 2ms period to end 
    }
}