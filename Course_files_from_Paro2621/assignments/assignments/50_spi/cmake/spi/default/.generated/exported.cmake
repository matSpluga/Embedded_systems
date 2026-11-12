set(DEPENDENT_MP_BIN2HEXspi_default_1mMqNWkM "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFspi_default_1mMqNWkM "${CMAKE_CURRENT_LIST_DIR}/../../../../out/spi/default.elf")
set(DEPENDENT_TARGET_DIRspi_default_1mMqNWkM "${CMAKE_CURRENT_LIST_DIR}/../../../../out/spi")
set(DEPENDENT_BYPRODUCTSspi_default_1mMqNWkM ${DEPENDENT_TARGET_DIRspi_default_1mMqNWkM}/${sourceFileNamespi_default_1mMqNWkM}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRspi_default_1mMqNWkM}/${sourceFileNamespi_default_1mMqNWkM}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXspi_default_1mMqNWkM} ${DEPENDENT_DEPENDENT_TARGET_ELFspi_default_1mMqNWkM} --image ${sourceFileNamespi_default_1mMqNWkM} ${addressspi_default_1mMqNWkM} ${modespi_default_1mMqNWkM} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRspi_default_1mMqNWkM}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFspi_default_1mMqNWkM})
add_custom_target(
    dependent_produced_source_artifactspi_default_1mMqNWkM 
    DEPENDS ${DEPENDENT_TARGET_DIRspi_default_1mMqNWkM}/${sourceFileNamespi_default_1mMqNWkM}.s
    )
