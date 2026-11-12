set(DEPENDENT_MP_BIN2HEX70_pwm_default_pD4Q0RJt "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELF70_pwm_default_pD4Q0RJt ${CMAKE_CURRENT_LIST_DIR}/../../../../out/70_pwm/production/default-production.elf)
set(DEPENDENT_TARGET_DIR70_pwm_default_pD4Q0RJt ${CMAKE_CURRENT_LIST_DIR}/../../../../out/70_pwm/production)
set(DEPENDENT_BYPRODUCTS70_pwm_default_pD4Q0RJt ${DEPENDENT_TARGET_DIR70_pwm_default_pD4Q0RJt}/${sourceFileName70_pwm_default_pD4Q0RJt}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIR70_pwm_default_pD4Q0RJt}/${sourceFileName70_pwm_default_pD4Q0RJt}.s
    COMMAND ${DEPENDENT_MP_BIN2HEX70_pwm_default_pD4Q0RJt} ${DEPENDENT_DEPENDENT_TARGET_ELF70_pwm_default_pD4Q0RJt} --image ${sourceFileName70_pwm_default_pD4Q0RJt} ${address70_pwm_default_pD4Q0RJt} ${mode70_pwm_default_pD4Q0RJt} -mdfp=/home/samuisa/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIR70_pwm_default_pD4Q0RJt}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELF70_pwm_default_pD4Q0RJt})
add_custom_target(
    dependent_produced_source_artifact70_pwm_default_pD4Q0RJt 
    DEPENDS ${DEPENDENT_TARGET_DIR70_pwm_default_pD4Q0RJt}/${sourceFileName70_pwm_default_pD4Q0RJt}.s
    )
