set(DEPENDENT_MP_BIN2HEXpush_button_default_SmCNmhPV "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFpush_button_default_SmCNmhPV "${CMAKE_CURRENT_LIST_DIR}/../../../../out/push_button/production/default-production.elf")
set(DEPENDENT_TARGET_DIRpush_button_default_SmCNmhPV "${CMAKE_CURRENT_LIST_DIR}/../../../../out/push_button/production")
set(DEPENDENT_BYPRODUCTSpush_button_default_SmCNmhPV ${DEPENDENT_TARGET_DIRpush_button_default_SmCNmhPV}/${sourceFileNamepush_button_default_SmCNmhPV}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRpush_button_default_SmCNmhPV}/${sourceFileNamepush_button_default_SmCNmhPV}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXpush_button_default_SmCNmhPV} ${DEPENDENT_DEPENDENT_TARGET_ELFpush_button_default_SmCNmhPV} --image ${sourceFileNamepush_button_default_SmCNmhPV} ${addresspush_button_default_SmCNmhPV} ${modepush_button_default_SmCNmhPV} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRpush_button_default_SmCNmhPV}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFpush_button_default_SmCNmhPV})
add_custom_target(
    dependent_produced_source_artifactpush_button_default_SmCNmhPV 
    DEPENDS ${DEPENDENT_TARGET_DIRpush_button_default_SmCNmhPV}/${sourceFileNamepush_button_default_SmCNmhPV}.s
    )
