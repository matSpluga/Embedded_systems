set(DEPENDENT_MP_BIN2HEXuart_basic_default_sBMSNuID "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFuart_basic_default_sBMSNuID "${CMAKE_CURRENT_LIST_DIR}/../../../../out/uart_basic/production/default-production.elf")
set(DEPENDENT_TARGET_DIRuart_basic_default_sBMSNuID "${CMAKE_CURRENT_LIST_DIR}/../../../../out/uart_basic/production")
set(DEPENDENT_BYPRODUCTSuart_basic_default_sBMSNuID ${DEPENDENT_TARGET_DIRuart_basic_default_sBMSNuID}/${sourceFileNameuart_basic_default_sBMSNuID}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRuart_basic_default_sBMSNuID}/${sourceFileNameuart_basic_default_sBMSNuID}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXuart_basic_default_sBMSNuID} ${DEPENDENT_DEPENDENT_TARGET_ELFuart_basic_default_sBMSNuID} --image ${sourceFileNameuart_basic_default_sBMSNuID} ${addressuart_basic_default_sBMSNuID} ${modeuart_basic_default_sBMSNuID} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRuart_basic_default_sBMSNuID}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFuart_basic_default_sBMSNuID})
add_custom_target(
    dependent_produced_source_artifactuart_basic_default_sBMSNuID 
    DEPENDS ${DEPENDENT_TARGET_DIRuart_basic_default_sBMSNuID}/${sourceFileNameuart_basic_default_sBMSNuID}.s
    )
