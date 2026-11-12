set(DEPENDENT_MP_BIN2HEXuart_advanced_default_LvagnN1m "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFuart_advanced_default_LvagnN1m "${CMAKE_CURRENT_LIST_DIR}/../../../../out/uart_advanced/default.elf")
set(DEPENDENT_TARGET_DIRuart_advanced_default_LvagnN1m "${CMAKE_CURRENT_LIST_DIR}/../../../../out/uart_advanced")
set(DEPENDENT_BYPRODUCTSuart_advanced_default_LvagnN1m ${DEPENDENT_TARGET_DIRuart_advanced_default_LvagnN1m}/${sourceFileNameuart_advanced_default_LvagnN1m}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRuart_advanced_default_LvagnN1m}/${sourceFileNameuart_advanced_default_LvagnN1m}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXuart_advanced_default_LvagnN1m} ${DEPENDENT_DEPENDENT_TARGET_ELFuart_advanced_default_LvagnN1m} --image ${sourceFileNameuart_advanced_default_LvagnN1m} ${addressuart_advanced_default_LvagnN1m} ${modeuart_advanced_default_LvagnN1m} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRuart_advanced_default_LvagnN1m}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFuart_advanced_default_LvagnN1m})
add_custom_target(
    dependent_produced_source_artifactuart_advanced_default_LvagnN1m 
    DEPENDS ${DEPENDENT_TARGET_DIRuart_advanced_default_LvagnN1m}/${sourceFileNameuart_advanced_default_LvagnN1m}.s
    )
