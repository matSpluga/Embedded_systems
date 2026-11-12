set(DEPENDENT_MP_BIN2HEXtimer_default_NLlE6Wss "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFtimer_default_NLlE6Wss "${CMAKE_CURRENT_LIST_DIR}/../../../../out/timer/production/default-production.elf")
set(DEPENDENT_TARGET_DIRtimer_default_NLlE6Wss "${CMAKE_CURRENT_LIST_DIR}/../../../../out/timer/production")
set(DEPENDENT_BYPRODUCTStimer_default_NLlE6Wss ${DEPENDENT_TARGET_DIRtimer_default_NLlE6Wss}/${sourceFileNametimer_default_NLlE6Wss}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRtimer_default_NLlE6Wss}/${sourceFileNametimer_default_NLlE6Wss}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXtimer_default_NLlE6Wss} ${DEPENDENT_DEPENDENT_TARGET_ELFtimer_default_NLlE6Wss} --image ${sourceFileNametimer_default_NLlE6Wss} ${addresstimer_default_NLlE6Wss} ${modetimer_default_NLlE6Wss} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRtimer_default_NLlE6Wss}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFtimer_default_NLlE6Wss})
add_custom_target(
    dependent_produced_source_artifacttimer_default_NLlE6Wss 
    DEPENDS ${DEPENDENT_TARGET_DIRtimer_default_NLlE6Wss}/${sourceFileNametimer_default_NLlE6Wss}.s
    )
