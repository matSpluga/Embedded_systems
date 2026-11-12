set(DEPENDENT_MP_BIN2HEXtimer_default_NVDudf79 "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFtimer_default_NVDudf79 "${CMAKE_CURRENT_LIST_DIR}/../../../../out/timer/default.elf")
set(DEPENDENT_TARGET_DIRtimer_default_NVDudf79 "${CMAKE_CURRENT_LIST_DIR}/../../../../out/timer")
set(DEPENDENT_BYPRODUCTStimer_default_NVDudf79 ${DEPENDENT_TARGET_DIRtimer_default_NVDudf79}/${sourceFileNametimer_default_NVDudf79}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRtimer_default_NVDudf79}/${sourceFileNametimer_default_NVDudf79}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXtimer_default_NVDudf79} ${DEPENDENT_DEPENDENT_TARGET_ELFtimer_default_NVDudf79} --image ${sourceFileNametimer_default_NVDudf79} ${addresstimer_default_NVDudf79} ${modetimer_default_NVDudf79} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRtimer_default_NVDudf79}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFtimer_default_NVDudf79})
add_custom_target(
    dependent_produced_source_artifacttimer_default_NVDudf79 
    DEPENDS ${DEPENDENT_TARGET_DIRtimer_default_NVDudf79}/${sourceFileNametimer_default_NVDudf79}.s
    )
