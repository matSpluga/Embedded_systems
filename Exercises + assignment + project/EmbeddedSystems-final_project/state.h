//Autore: Antonio
#ifndef STATE_H
#define STATE_H

#include "config.h"

// Define the main states of the buggy 
typedef enum {
    STATE_HALTED = 0,
    STATE_MOVING,
    STATE_OBSTACLE_AVOIDANCE
} buggy_state_t;

// Initialize the state machine variables 
void state_init(void);

// Update the state machine, to be called at 500 Hz 
buggy_state_t state_update(int button_pressed, int obstacle_sensed, int speed, int yawrate);

#endif