set(DEPENDENT_MP_BIN2HEXinterrupt_default_wx3KJVUv "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFinterrupt_default_wx3KJVUv "${CMAKE_CURRENT_LIST_DIR}/../../../../out/interrupt/default.elf")
set(DEPENDENT_TARGET_DIRinterrupt_default_wx3KJVUv "${CMAKE_CURRENT_LIST_DIR}/../../../../out/interrupt")
set(DEPENDENT_BYPRODUCTSinterrupt_default_wx3KJVUv ${DEPENDENT_TARGET_DIRinterrupt_default_wx3KJVUv}/${sourceFileNameinterrupt_default_wx3KJVUv}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRinterrupt_default_wx3KJVUv}/${sourceFileNameinterrupt_default_wx3KJVUv}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXinterrupt_default_wx3KJVUv} ${DEPENDENT_DEPENDENT_TARGET_ELFinterrupt_default_wx3KJVUv} --image ${sourceFileNameinterrupt_default_wx3KJVUv} ${addressinterrupt_default_wx3KJVUv} ${modeinterrupt_default_wx3KJVUv} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRinterrupt_default_wx3KJVUv}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFinterrupt_default_wx3KJVUv})
add_custom_target(
    dependent_produced_source_artifactinterrupt_default_wx3KJVUv 
    DEPENDS ${DEPENDENT_TARGET_DIRinterrupt_default_wx3KJVUv}/${sourceFileNameinterrupt_default_wx3KJVUv}.s
    )
