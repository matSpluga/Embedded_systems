set(DEPENDENT_MP_BIN2HEXinterrupt_default_GlbFaJS6 "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFinterrupt_default_GlbFaJS6 "${CMAKE_CURRENT_LIST_DIR}/../../../../out/interrupt/production/default-production.elf")
set(DEPENDENT_TARGET_DIRinterrupt_default_GlbFaJS6 "${CMAKE_CURRENT_LIST_DIR}/../../../../out/interrupt/production")
set(DEPENDENT_BYPRODUCTSinterrupt_default_GlbFaJS6 ${DEPENDENT_TARGET_DIRinterrupt_default_GlbFaJS6}/${sourceFileNameinterrupt_default_GlbFaJS6}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRinterrupt_default_GlbFaJS6}/${sourceFileNameinterrupt_default_GlbFaJS6}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXinterrupt_default_GlbFaJS6} ${DEPENDENT_DEPENDENT_TARGET_ELFinterrupt_default_GlbFaJS6} --image ${sourceFileNameinterrupt_default_GlbFaJS6} ${addressinterrupt_default_GlbFaJS6} ${modeinterrupt_default_GlbFaJS6} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRinterrupt_default_GlbFaJS6}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFinterrupt_default_GlbFaJS6})
add_custom_target(
    dependent_produced_source_artifactinterrupt_default_GlbFaJS6 
    DEPENDS ${DEPENDENT_TARGET_DIRinterrupt_default_GlbFaJS6}/${sourceFileNameinterrupt_default_GlbFaJS6}.s
    )
