#include "pwm.h"
#include "config.h"

/*
 Initializes the Output Compare modules for the four motor PWM signals.
 Configures pins RD1-RD4 for OC1-OC4, and sets them to Edge-Aligned PWM mode.
 The period is configured to 10 kHz in the config functions.
*/
void pwm_init(void) {
    motor_pwm_pins_config();
    oc_config(1, 1);
    oc_config(2, 1);
    oc_config(3, 1);
    oc_config(4, 1);
}

/*
 Sets the output duty cycle for the four motor PWM signals.
 It takes the desired left and right PWM values, saturates them
 to the range between -100 and +100, and sets the correct Output Compare peripherals
 according to the project specifications.
*/
void set_motor_pwm(int left_pwm, int right_pwm) {

    if (left_pwm > 100) 
        left_pwm = 100;

    if (left_pwm < -100) 
        left_pwm = -100;

    if (right_pwm > 100) 
        right_pwm = 100;
    
    if (right_pwm < -100) 
        right_pwm = -100;

    if (left_pwm > 0) {
        oc_set_duty(2, left_pwm);  // RD2 = left_pwm
        oc_set_duty(1, 0);         // RD1 = 0
    } else if (left_pwm < 0) {
        oc_set_duty(1, -left_pwm); // RD1 = -left_pwm
        oc_set_duty(2, 0);         // RD2 = 0
    } else {
        oc_set_duty(1, 0);
        oc_set_duty(2, 0);
    }

    if (right_pwm > 0) {
        oc_set_duty(4, right_pwm);  // RD4 = right_pwm
        oc_set_duty(3, 0);          // RD3 = 0
    } else if (right_pwm < 0) {
        oc_set_duty(3, -right_pwm); // RD3 = -right_pwm
        oc_set_duty(4, 0);          // RD4 = 0
    } else {
        oc_set_duty(3, 0);
        oc_set_duty(4, 0);
    }
}
