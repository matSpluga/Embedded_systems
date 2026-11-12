set(DEPENDENT_MP_BIN2HEX60_adc_default_5eDyRHqd "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELF60_adc_default_5eDyRHqd ${CMAKE_CURRENT_LIST_DIR}/../../../../out/60_adc/production/default-production.elf)
set(DEPENDENT_TARGET_DIR60_adc_default_5eDyRHqd ${CMAKE_CURRENT_LIST_DIR}/../../../../out/60_adc/production)
set(DEPENDENT_BYPRODUCTS60_adc_default_5eDyRHqd ${DEPENDENT_TARGET_DIR60_adc_default_5eDyRHqd}/${sourceFileName60_adc_default_5eDyRHqd}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIR60_adc_default_5eDyRHqd}/${sourceFileName60_adc_default_5eDyRHqd}.s
    COMMAND ${DEPENDENT_MP_BIN2HEX60_adc_default_5eDyRHqd} ${DEPENDENT_DEPENDENT_TARGET_ELF60_adc_default_5eDyRHqd} --image ${sourceFileName60_adc_default_5eDyRHqd} ${address60_adc_default_5eDyRHqd} ${mode60_adc_default_5eDyRHqd} -mdfp=/home/samuisa/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIR60_adc_default_5eDyRHqd}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELF60_adc_default_5eDyRHqd})
add_custom_target(
    dependent_produced_source_artifact60_adc_default_5eDyRHqd 
    DEPENDS ${DEPENDENT_TARGET_DIR60_adc_default_5eDyRHqd}/${sourceFileName60_adc_default_5eDyRHqd}.s
    )
