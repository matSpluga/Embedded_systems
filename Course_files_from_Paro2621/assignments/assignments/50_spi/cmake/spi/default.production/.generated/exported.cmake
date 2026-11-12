set(DEPENDENT_MP_BIN2HEXspi_default_ntTjqj2j "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFspi_default_ntTjqj2j "${CMAKE_CURRENT_LIST_DIR}/../../../../out/spi/production/default-production.elf")
set(DEPENDENT_TARGET_DIRspi_default_ntTjqj2j "${CMAKE_CURRENT_LIST_DIR}/../../../../out/spi/production")
set(DEPENDENT_BYPRODUCTSspi_default_ntTjqj2j ${DEPENDENT_TARGET_DIRspi_default_ntTjqj2j}/${sourceFileNamespi_default_ntTjqj2j}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRspi_default_ntTjqj2j}/${sourceFileNamespi_default_ntTjqj2j}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXspi_default_ntTjqj2j} ${DEPENDENT_DEPENDENT_TARGET_ELFspi_default_ntTjqj2j} --image ${sourceFileNamespi_default_ntTjqj2j} ${addressspi_default_ntTjqj2j} ${modespi_default_ntTjqj2j} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRspi_default_ntTjqj2j}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFspi_default_ntTjqj2j})
add_custom_target(
    dependent_produced_source_artifactspi_default_ntTjqj2j 
    DEPENDS ${DEPENDENT_TARGET_DIRspi_default_ntTjqj2j}/${sourceFileNamespi_default_ntTjqj2j}.s
    )
