set(DEPENDENT_MP_BIN2HEXdebouncing_default_BTINploz "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFdebouncing_default_BTINploz "${CMAKE_CURRENT_LIST_DIR}/../../../../out/debouncing/default.elf")
set(DEPENDENT_TARGET_DIRdebouncing_default_BTINploz "${CMAKE_CURRENT_LIST_DIR}/../../../../out/debouncing")
set(DEPENDENT_BYPRODUCTSdebouncing_default_BTINploz ${DEPENDENT_TARGET_DIRdebouncing_default_BTINploz}/${sourceFileNamedebouncing_default_BTINploz}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRdebouncing_default_BTINploz}/${sourceFileNamedebouncing_default_BTINploz}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXdebouncing_default_BTINploz} ${DEPENDENT_DEPENDENT_TARGET_ELFdebouncing_default_BTINploz} --image ${sourceFileNamedebouncing_default_BTINploz} ${addressdebouncing_default_BTINploz} ${modedebouncing_default_BTINploz} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRdebouncing_default_BTINploz}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFdebouncing_default_BTINploz})
add_custom_target(
    dependent_produced_source_artifactdebouncing_default_BTINploz 
    DEPENDS ${DEPENDENT_TARGET_DIRdebouncing_default_BTINploz}/${sourceFileNamedebouncing_default_BTINploz}.s
    )
