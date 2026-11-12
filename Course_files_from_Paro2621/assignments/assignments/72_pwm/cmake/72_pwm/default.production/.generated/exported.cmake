set(DEPENDENT_MP_BIN2HEX72_pwm_default__GufEYhG "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELF72_pwm_default__GufEYhG ${CMAKE_CURRENT_LIST_DIR}/../../../../out/72_pwm/production/default-production.elf)
set(DEPENDENT_TARGET_DIR72_pwm_default__GufEYhG ${CMAKE_CURRENT_LIST_DIR}/../../../../out/72_pwm/production)
set(DEPENDENT_BYPRODUCTS72_pwm_default__GufEYhG ${DEPENDENT_TARGET_DIR72_pwm_default__GufEYhG}/${sourceFileName72_pwm_default__GufEYhG}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIR72_pwm_default__GufEYhG}/${sourceFileName72_pwm_default__GufEYhG}.s
    COMMAND ${DEPENDENT_MP_BIN2HEX72_pwm_default__GufEYhG} ${DEPENDENT_DEPENDENT_TARGET_ELF72_pwm_default__GufEYhG} --image ${sourceFileName72_pwm_default__GufEYhG} ${address72_pwm_default__GufEYhG} ${mode72_pwm_default__GufEYhG} -mdfp=/home/samuisa/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIR72_pwm_default__GufEYhG}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELF72_pwm_default__GufEYhG})
add_custom_target(
    dependent_produced_source_artifact72_pwm_default__GufEYhG 
    DEPENDS ${DEPENDENT_TARGET_DIR72_pwm_default__GufEYhG}/${sourceFileName72_pwm_default__GufEYhG}.s
    )
