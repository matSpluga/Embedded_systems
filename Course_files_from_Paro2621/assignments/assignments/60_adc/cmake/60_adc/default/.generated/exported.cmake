set(DEPENDENT_MP_BIN2HEX60_adc_default_PoBH9Ot9 "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELF60_adc_default_PoBH9Ot9 ${CMAKE_CURRENT_LIST_DIR}/../../../../out/60_adc/default.elf)
set(DEPENDENT_TARGET_DIR60_adc_default_PoBH9Ot9 ${CMAKE_CURRENT_LIST_DIR}/../../../../out/60_adc)
set(DEPENDENT_BYPRODUCTS60_adc_default_PoBH9Ot9 ${DEPENDENT_TARGET_DIR60_adc_default_PoBH9Ot9}/${sourceFileName60_adc_default_PoBH9Ot9}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIR60_adc_default_PoBH9Ot9}/${sourceFileName60_adc_default_PoBH9Ot9}.s
    COMMAND ${DEPENDENT_MP_BIN2HEX60_adc_default_PoBH9Ot9} ${DEPENDENT_DEPENDENT_TARGET_ELF60_adc_default_PoBH9Ot9} --image ${sourceFileName60_adc_default_PoBH9Ot9} ${address60_adc_default_PoBH9Ot9} ${mode60_adc_default_PoBH9Ot9} -mdfp=/home/samuisa/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIR60_adc_default_PoBH9Ot9}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELF60_adc_default_PoBH9Ot9})
add_custom_target(
    dependent_produced_source_artifact60_adc_default_PoBH9Ot9 
    DEPENDS ${DEPENDENT_TARGET_DIR60_adc_default_PoBH9Ot9}/${sourceFileName60_adc_default_PoBH9Ot9}.s
    )
