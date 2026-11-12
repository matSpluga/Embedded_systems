set(DEPENDENT_MP_BIN2HEX72_pwm_default_u1qTtjWk "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELF72_pwm_default_u1qTtjWk ${CMAKE_CURRENT_LIST_DIR}/../../../../out/72_pwm/default.elf)
set(DEPENDENT_TARGET_DIR72_pwm_default_u1qTtjWk ${CMAKE_CURRENT_LIST_DIR}/../../../../out/72_pwm)
set(DEPENDENT_BYPRODUCTS72_pwm_default_u1qTtjWk ${DEPENDENT_TARGET_DIR72_pwm_default_u1qTtjWk}/${sourceFileName72_pwm_default_u1qTtjWk}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIR72_pwm_default_u1qTtjWk}/${sourceFileName72_pwm_default_u1qTtjWk}.s
    COMMAND ${DEPENDENT_MP_BIN2HEX72_pwm_default_u1qTtjWk} ${DEPENDENT_DEPENDENT_TARGET_ELF72_pwm_default_u1qTtjWk} --image ${sourceFileName72_pwm_default_u1qTtjWk} ${address72_pwm_default_u1qTtjWk} ${mode72_pwm_default_u1qTtjWk} -mdfp=/home/samuisa/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIR72_pwm_default_u1qTtjWk}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELF72_pwm_default_u1qTtjWk})
add_custom_target(
    dependent_produced_source_artifact72_pwm_default_u1qTtjWk 
    DEPENDS ${DEPENDENT_TARGET_DIR72_pwm_default_u1qTtjWk}/${sourceFileName72_pwm_default_u1qTtjWk}.s
    )
