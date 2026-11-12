set(DEPENDENT_MP_BIN2HEXspi_v2_default_rWB_LZ0e "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFspi_v2_default_rWB_LZ0e "${CMAKE_CURRENT_LIST_DIR}/../../../../out/spi_v2/production/default-production.elf")
set(DEPENDENT_TARGET_DIRspi_v2_default_rWB_LZ0e "${CMAKE_CURRENT_LIST_DIR}/../../../../out/spi_v2/production")
set(DEPENDENT_BYPRODUCTSspi_v2_default_rWB_LZ0e ${DEPENDENT_TARGET_DIRspi_v2_default_rWB_LZ0e}/${sourceFileNamespi_v2_default_rWB_LZ0e}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRspi_v2_default_rWB_LZ0e}/${sourceFileNamespi_v2_default_rWB_LZ0e}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXspi_v2_default_rWB_LZ0e} ${DEPENDENT_DEPENDENT_TARGET_ELFspi_v2_default_rWB_LZ0e} --image ${sourceFileNamespi_v2_default_rWB_LZ0e} ${addressspi_v2_default_rWB_LZ0e} ${modespi_v2_default_rWB_LZ0e} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRspi_v2_default_rWB_LZ0e}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFspi_v2_default_rWB_LZ0e})
add_custom_target(
    dependent_produced_source_artifactspi_v2_default_rWB_LZ0e 
    DEPENDS ${DEPENDENT_TARGET_DIRspi_v2_default_rWB_LZ0e}/${sourceFileNamespi_v2_default_rWB_LZ0e}.s
    )
