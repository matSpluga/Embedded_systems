set(DEPENDENT_MP_BIN2HEXuart_basic_default_xDJH6Ck_ "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFuart_basic_default_xDJH6Ck_ "${CMAKE_CURRENT_LIST_DIR}/../../../../out/uart_basic/default.elf")
set(DEPENDENT_TARGET_DIRuart_basic_default_xDJH6Ck_ "${CMAKE_CURRENT_LIST_DIR}/../../../../out/uart_basic")
set(DEPENDENT_BYPRODUCTSuart_basic_default_xDJH6Ck_ ${DEPENDENT_TARGET_DIRuart_basic_default_xDJH6Ck_}/${sourceFileNameuart_basic_default_xDJH6Ck_}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRuart_basic_default_xDJH6Ck_}/${sourceFileNameuart_basic_default_xDJH6Ck_}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXuart_basic_default_xDJH6Ck_} ${DEPENDENT_DEPENDENT_TARGET_ELFuart_basic_default_xDJH6Ck_} --image ${sourceFileNameuart_basic_default_xDJH6Ck_} ${addressuart_basic_default_xDJH6Ck_} ${modeuart_basic_default_xDJH6Ck_} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRuart_basic_default_xDJH6Ck_}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFuart_basic_default_xDJH6Ck_})
add_custom_target(
    dependent_produced_source_artifactuart_basic_default_xDJH6Ck_ 
    DEPENDS ${DEPENDENT_TARGET_DIRuart_basic_default_xDJH6Ck_}/${sourceFileNameuart_basic_default_xDJH6Ck_}.s
    )
