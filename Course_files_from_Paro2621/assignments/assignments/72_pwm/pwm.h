#ifndef PWM_H
#define PWM_H

#include <stdint.h>
#include <stdbool.h>

void pwm_init(void);
int pwm_set_duty_cycle(int duty_cycle, int reg);

void execute_motion(int speed, int yaw, int mag);

#endif // PWM_H