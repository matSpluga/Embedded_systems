set(DEPENDENT_MP_BIN2HEXuart_advanced_v2_default_6cf7CXZt "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFuart_advanced_v2_default_6cf7CXZt "${CMAKE_CURRENT_LIST_DIR}/../../../../out/uart_advanced_v2/default.elf")
set(DEPENDENT_TARGET_DIRuart_advanced_v2_default_6cf7CXZt "${CMAKE_CURRENT_LIST_DIR}/../../../../out/uart_advanced_v2")
set(DEPENDENT_BYPRODUCTSuart_advanced_v2_default_6cf7CXZt ${DEPENDENT_TARGET_DIRuart_advanced_v2_default_6cf7CXZt}/${sourceFileNameuart_advanced_v2_default_6cf7CXZt}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRuart_advanced_v2_default_6cf7CXZt}/${sourceFileNameuart_advanced_v2_default_6cf7CXZt}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXuart_advanced_v2_default_6cf7CXZt} ${DEPENDENT_DEPENDENT_TARGET_ELFuart_advanced_v2_default_6cf7CXZt} --image ${sourceFileNameuart_advanced_v2_default_6cf7CXZt} ${addressuart_advanced_v2_default_6cf7CXZt} ${modeuart_advanced_v2_default_6cf7CXZt} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRuart_advanced_v2_default_6cf7CXZt}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFuart_advanced_v2_default_6cf7CXZt})
add_custom_target(
    dependent_produced_source_artifactuart_advanced_v2_default_6cf7CXZt 
    DEPENDS ${DEPENDENT_TARGET_DIRuart_advanced_v2_default_6cf7CXZt}/${sourceFileNameuart_advanced_v2_default_6cf7CXZt}.s
    )
