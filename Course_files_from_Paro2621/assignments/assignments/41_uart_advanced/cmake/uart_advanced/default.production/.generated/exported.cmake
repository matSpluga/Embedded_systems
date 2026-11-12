set(DEPENDENT_MP_BIN2HEXuart_advanced_default_QS3nr4S_ "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFuart_advanced_default_QS3nr4S_ "${CMAKE_CURRENT_LIST_DIR}/../../../../out/uart_advanced/production/default-production.elf")
set(DEPENDENT_TARGET_DIRuart_advanced_default_QS3nr4S_ "${CMAKE_CURRENT_LIST_DIR}/../../../../out/uart_advanced/production")
set(DEPENDENT_BYPRODUCTSuart_advanced_default_QS3nr4S_ ${DEPENDENT_TARGET_DIRuart_advanced_default_QS3nr4S_}/${sourceFileNameuart_advanced_default_QS3nr4S_}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRuart_advanced_default_QS3nr4S_}/${sourceFileNameuart_advanced_default_QS3nr4S_}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXuart_advanced_default_QS3nr4S_} ${DEPENDENT_DEPENDENT_TARGET_ELFuart_advanced_default_QS3nr4S_} --image ${sourceFileNameuart_advanced_default_QS3nr4S_} ${addressuart_advanced_default_QS3nr4S_} ${modeuart_advanced_default_QS3nr4S_} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRuart_advanced_default_QS3nr4S_}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFuart_advanced_default_QS3nr4S_})
add_custom_target(
    dependent_produced_source_artifactuart_advanced_default_QS3nr4S_ 
    DEPENDS ${DEPENDENT_TARGET_DIRuart_advanced_default_QS3nr4S_}/${sourceFileNameuart_advanced_default_QS3nr4S_}.s
    )
