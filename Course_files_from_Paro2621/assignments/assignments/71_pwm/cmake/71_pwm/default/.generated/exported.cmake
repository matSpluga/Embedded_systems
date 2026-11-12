set(DEPENDENT_MP_BIN2HEX71_pwm_default_Tj7XgInR "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELF71_pwm_default_Tj7XgInR ${CMAKE_CURRENT_LIST_DIR}/../../../../out/71_pwm/default.elf)
set(DEPENDENT_TARGET_DIR71_pwm_default_Tj7XgInR ${CMAKE_CURRENT_LIST_DIR}/../../../../out/71_pwm)
set(DEPENDENT_BYPRODUCTS71_pwm_default_Tj7XgInR ${DEPENDENT_TARGET_DIR71_pwm_default_Tj7XgInR}/${sourceFileName71_pwm_default_Tj7XgInR}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIR71_pwm_default_Tj7XgInR}/${sourceFileName71_pwm_default_Tj7XgInR}.s
    COMMAND ${DEPENDENT_MP_BIN2HEX71_pwm_default_Tj7XgInR} ${DEPENDENT_DEPENDENT_TARGET_ELF71_pwm_default_Tj7XgInR} --image ${sourceFileName71_pwm_default_Tj7XgInR} ${address71_pwm_default_Tj7XgInR} ${mode71_pwm_default_Tj7XgInR} -mdfp=/home/samuisa/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIR71_pwm_default_Tj7XgInR}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELF71_pwm_default_Tj7XgInR})
add_custom_target(
    dependent_produced_source_artifact71_pwm_default_Tj7XgInR 
    DEPENDS ${DEPENDENT_TARGET_DIR71_pwm_default_Tj7XgInR}/${sourceFileName71_pwm_default_Tj7XgInR}.s
    )
