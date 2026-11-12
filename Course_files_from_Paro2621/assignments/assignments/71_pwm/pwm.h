#ifndef PWM_H
#define PWM_H

#include <stdint.h>
#include <stdbool.h>

#define STRICTLY_FORWARD    0
#define STRICTLY_BACKWARD   1
#define TURN_LEFT_FORWARD   2
#define TURN_RIGHT_FORWARD  3
#define TURN_LEFT_BACKWARD  4
#define TURN_RIGHT_BACKWARD 5
#define STOP_MOTION         6

void pwm_init(void);
int pwm_set_duty_cycle(unsigned int duty_cycle, int reg);
void execute_motion(int command);

#endif // PWM_H