//Autore: Antonio
#include "state.h"
#include "pwm.h"

// Pin definitions for lights
#define LEFT_LIGHT   LATBbits.LATB8
#define RIGHT_LIGHT  LATFbits.LATF1
#define LOW_LIGHT    LATGbits.LATG1

// Internal state variables
static buggy_state_t current_state = STATE_HALTED;
static int light_blink_counter = 0;
static int light_on = 0;
static int button_was_pressed = 0;

// Sub-states for obstacle avoidance algorithm
typedef enum {
    OBS_TURN_CW,
    OBS_MOVE_FWD,
    OBS_TURN_CCW,
    OBS_CHECK
} obs_sub_state_t;

static obs_sub_state_t obs_state = OBS_TURN_CW;
static int obs_timer = 0;
static int obs_attempts = 0;

// Timing constants for a 500 Hz loop
#define BLINK_HALF_PERIOD 250
#define OBS_TURN_TIME     500  // Time for an approximate 90 degree turn
#define OBS_MOVE_TIME     1000 // Two seconds of forward movement



// Initializes the state machine to the Halted state and resets internal counters.
void state_init(void) {
    current_state = STATE_HALTED;
    light_blink_counter = 0;
    light_on = 0;
    button_was_pressed = 0;
}

/*
This algorithm manages the transitions between the three main states.
It must be called at 500 Hz frequency.
In the Halted state, motors are stopped and both side lights blink.
Pressing the button transitions the robot to the Moving state.
In the Moving state, the robot follows the speed and yawrate commands.
If an obstacle is detected, it enters the Obstacle Avoidance state.
 
The Obstacle Avoidance algorithm works as follows:
First, it rotates clockwise for a fixed time to perform a 90-degree turn.
Then, it moves forward for two seconds. If an obstacle is sensed during this time,
the robot immediately transitions to the Halted state.
After moving forward, it rotates counter-clockwise for the same fixed time to
return to the original heading.
Finally, it checks for obstacles. If none are sensed, it returns to the Moving state.
If an obstacle is still present, it repeats the avoidance procedure.
After three unsuccessful attempts, it enters the Halted state.
*/
buggy_state_t state_update(int button_pressed, int obstacle_sensed, int speed, int yawrate) {
    
    int button_edge = 0;
    
    if (button_pressed && !button_was_pressed) {
        button_edge = 1;
    }
    button_was_pressed = button_pressed;

    light_blink_counter++;
    if (light_blink_counter >= BLINK_HALF_PERIOD) {
        light_blink_counter = 0;
        light_on = !light_on;
    }

    switch (current_state) {
        
        case STATE_HALTED:
            LEFT_LIGHT = light_on;
            RIGHT_LIGHT = light_on;
            LOW_LIGHT = 0;
            set_motor_pwm(0, 0);

            if (button_edge) {
                current_state = STATE_MOVING;
            }
            break;

        case STATE_MOVING:
            LEFT_LIGHT = 0;
            RIGHT_LIGHT = 0;
            LOW_LIGHT = 1;
            set_motor_pwm(speed - yawrate, speed + yawrate);

            if (button_edge) {
                current_state = STATE_HALTED;
            } else if (obstacle_sensed) {
                current_state = STATE_OBSTACLE_AVOIDANCE;
                obs_state = OBS_TURN_CW;
                obs_timer = 0;
                obs_attempts = 0;
            }
            break;

        case STATE_OBSTACLE_AVOIDANCE:
            LEFT_LIGHT = 0;
            RIGHT_LIGHT = light_on;
            LOW_LIGHT = 1;
            
            if (button_edge) {
                current_state = STATE_HALTED;
                break;
            }

            switch (obs_state) {
                case OBS_TURN_CW:
                    set_motor_pwm(50, -50);
                    obs_timer++;
                    if (obs_timer >= OBS_TURN_TIME) {
                        obs_state = OBS_MOVE_FWD;
                        obs_timer = 0;
                    }
                    break;

                case OBS_MOVE_FWD:
                    set_motor_pwm(50, 50);
                    obs_timer++;
                    
                    if (obstacle_sensed) {
                        current_state = STATE_HALTED;
                    } else if (obs_timer >= OBS_MOVE_TIME) {
                        obs_state = OBS_TURN_CCW;
                        obs_timer = 0;
                    }
                    break;

                case OBS_TURN_CCW:
                    set_motor_pwm(-50, 50);
                    obs_timer++;
                    if (obs_timer >= OBS_TURN_TIME) {
                        obs_state = OBS_CHECK;
                        obs_timer = 0;
                    }
                    break;

                case OBS_CHECK:
                    set_motor_pwm(0, 0);
                    if (!obstacle_sensed) {
                        current_state = STATE_MOVING;
                    } else {
                        obs_attempts++;
                        if (obs_attempts < 3) {
                            obs_state = OBS_TURN_CW;
                            obs_timer = 0;
                        } else {
                            current_state = STATE_HALTED;
                        }
                    }
                    break;
            }
            break;
    }

    return current_state;
}