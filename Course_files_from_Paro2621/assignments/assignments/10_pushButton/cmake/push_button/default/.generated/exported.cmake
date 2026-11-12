set(DEPENDENT_MP_BIN2HEXpush_button_default_zfdmPEKg "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFpush_button_default_zfdmPEKg "${CMAKE_CURRENT_LIST_DIR}/../../../../out/push_button/default.elf")
set(DEPENDENT_TARGET_DIRpush_button_default_zfdmPEKg "${CMAKE_CURRENT_LIST_DIR}/../../../../out/push_button")
set(DEPENDENT_BYPRODUCTSpush_button_default_zfdmPEKg ${DEPENDENT_TARGET_DIRpush_button_default_zfdmPEKg}/${sourceFileNamepush_button_default_zfdmPEKg}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRpush_button_default_zfdmPEKg}/${sourceFileNamepush_button_default_zfdmPEKg}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXpush_button_default_zfdmPEKg} ${DEPENDENT_DEPENDENT_TARGET_ELFpush_button_default_zfdmPEKg} --image ${sourceFileNamepush_button_default_zfdmPEKg} ${addresspush_button_default_zfdmPEKg} ${modepush_button_default_zfdmPEKg} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRpush_button_default_zfdmPEKg}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFpush_button_default_zfdmPEKg})
add_custom_target(
    dependent_produced_source_artifactpush_button_default_zfdmPEKg 
    DEPENDS ${DEPENDENT_TARGET_DIRpush_button_default_zfdmPEKg}/${sourceFileNamepush_button_default_zfdmPEKg}.s
    )
