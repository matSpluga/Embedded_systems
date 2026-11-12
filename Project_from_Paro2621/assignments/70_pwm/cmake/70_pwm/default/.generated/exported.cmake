set(DEPENDENT_MP_BIN2HEX70_pwm_default_0bVtI0Ye "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELF70_pwm_default_0bVtI0Ye ${CMAKE_CURRENT_LIST_DIR}/../../../../out/70_pwm/default.elf)
set(DEPENDENT_TARGET_DIR70_pwm_default_0bVtI0Ye ${CMAKE_CURRENT_LIST_DIR}/../../../../out/70_pwm)
set(DEPENDENT_BYPRODUCTS70_pwm_default_0bVtI0Ye ${DEPENDENT_TARGET_DIR70_pwm_default_0bVtI0Ye}/${sourceFileName70_pwm_default_0bVtI0Ye}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIR70_pwm_default_0bVtI0Ye}/${sourceFileName70_pwm_default_0bVtI0Ye}.s
    COMMAND ${DEPENDENT_MP_BIN2HEX70_pwm_default_0bVtI0Ye} ${DEPENDENT_DEPENDENT_TARGET_ELF70_pwm_default_0bVtI0Ye} --image ${sourceFileName70_pwm_default_0bVtI0Ye} ${address70_pwm_default_0bVtI0Ye} ${mode70_pwm_default_0bVtI0Ye} -mdfp=/home/samuisa/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIR70_pwm_default_0bVtI0Ye}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELF70_pwm_default_0bVtI0Ye})
add_custom_target(
    dependent_produced_source_artifact70_pwm_default_0bVtI0Ye 
    DEPENDS ${DEPENDENT_TARGET_DIR70_pwm_default_0bVtI0Ye}/${sourceFileName70_pwm_default_0bVtI0Ye}.s
    )
