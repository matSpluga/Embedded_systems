#ifndef PWM_H
#define PWM_H

#include <stdint.h>
#include <stdbool.h>

void pwm_init(void);
int pwm_set_duty_cycle(unsigned int duty_cycle, int reg);

#endif // PWM_H