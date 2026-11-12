set(DEPENDENT_MP_BIN2HEX71_pwm_default__rl0ioAj "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELF71_pwm_default__rl0ioAj ${CMAKE_CURRENT_LIST_DIR}/../../../../out/71_pwm/production/default-production.elf)
set(DEPENDENT_TARGET_DIR71_pwm_default__rl0ioAj ${CMAKE_CURRENT_LIST_DIR}/../../../../out/71_pwm/production)
set(DEPENDENT_BYPRODUCTS71_pwm_default__rl0ioAj ${DEPENDENT_TARGET_DIR71_pwm_default__rl0ioAj}/${sourceFileName71_pwm_default__rl0ioAj}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIR71_pwm_default__rl0ioAj}/${sourceFileName71_pwm_default__rl0ioAj}.s
    COMMAND ${DEPENDENT_MP_BIN2HEX71_pwm_default__rl0ioAj} ${DEPENDENT_DEPENDENT_TARGET_ELF71_pwm_default__rl0ioAj} --image ${sourceFileName71_pwm_default__rl0ioAj} ${address71_pwm_default__rl0ioAj} ${mode71_pwm_default__rl0ioAj} -mdfp=/home/samuisa/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIR71_pwm_default__rl0ioAj}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELF71_pwm_default__rl0ioAj})
add_custom_target(
    dependent_produced_source_artifact71_pwm_default__rl0ioAj 
    DEPENDS ${DEPENDENT_TARGET_DIR71_pwm_default__rl0ioAj}/${sourceFileName71_pwm_default__rl0ioAj}.s
    )
