set(DEPENDENT_MP_BIN2HEXuart_advanced_v2_default_5VT4L2cc "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFuart_advanced_v2_default_5VT4L2cc "${CMAKE_CURRENT_LIST_DIR}/../../../../out/uart_advanced_v2/production/default-production.elf")
set(DEPENDENT_TARGET_DIRuart_advanced_v2_default_5VT4L2cc "${CMAKE_CURRENT_LIST_DIR}/../../../../out/uart_advanced_v2/production")
set(DEPENDENT_BYPRODUCTSuart_advanced_v2_default_5VT4L2cc ${DEPENDENT_TARGET_DIRuart_advanced_v2_default_5VT4L2cc}/${sourceFileNameuart_advanced_v2_default_5VT4L2cc}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRuart_advanced_v2_default_5VT4L2cc}/${sourceFileNameuart_advanced_v2_default_5VT4L2cc}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXuart_advanced_v2_default_5VT4L2cc} ${DEPENDENT_DEPENDENT_TARGET_ELFuart_advanced_v2_default_5VT4L2cc} --image ${sourceFileNameuart_advanced_v2_default_5VT4L2cc} ${addressuart_advanced_v2_default_5VT4L2cc} ${modeuart_advanced_v2_default_5VT4L2cc} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRuart_advanced_v2_default_5VT4L2cc}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFuart_advanced_v2_default_5VT4L2cc})
add_custom_target(
    dependent_produced_source_artifactuart_advanced_v2_default_5VT4L2cc 
    DEPENDS ${DEPENDENT_TARGET_DIRuart_advanced_v2_default_5VT4L2cc}/${sourceFileNameuart_advanced_v2_default_5VT4L2cc}.s
    )
