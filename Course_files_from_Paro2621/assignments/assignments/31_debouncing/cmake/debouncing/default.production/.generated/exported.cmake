set(DEPENDENT_MP_BIN2HEXdebouncing_default__JszyNGv "/opt/microchip/xc16/v2.10/bin/xc16-bin2hex")
set(DEPENDENT_DEPENDENT_TARGET_ELFdebouncing_default__JszyNGv "${CMAKE_CURRENT_LIST_DIR}/../../../../out/debouncing/production/default-production.elf")
set(DEPENDENT_TARGET_DIRdebouncing_default__JszyNGv "${CMAKE_CURRENT_LIST_DIR}/../../../../out/debouncing/production")
set(DEPENDENT_BYPRODUCTSdebouncing_default__JszyNGv ${DEPENDENT_TARGET_DIRdebouncing_default__JszyNGv}/${sourceFileNamedebouncing_default__JszyNGv}.s)
add_custom_command(
    OUTPUT ${DEPENDENT_TARGET_DIRdebouncing_default__JszyNGv}/${sourceFileNamedebouncing_default__JszyNGv}.s
    COMMAND ${DEPENDENT_MP_BIN2HEXdebouncing_default__JszyNGv} ${DEPENDENT_DEPENDENT_TARGET_ELFdebouncing_default__JszyNGv} --image ${sourceFileNamedebouncing_default__JszyNGv} ${addressdebouncing_default__JszyNGv} ${modedebouncing_default__JszyNGv} -mdfp=/home/ric/.mchp_packs/Microchip/dsPIC33E-GM-GP-MC-GU-MU_DFP/1.6.297/xc16 
    WORKING_DIRECTORY ${DEPENDENT_TARGET_DIRdebouncing_default__JszyNGv}
    DEPENDS ${DEPENDENT_DEPENDENT_TARGET_ELFdebouncing_default__JszyNGv})
add_custom_target(
    dependent_produced_source_artifactdebouncing_default__JszyNGv 
    DEPENDS ${DEPENDENT_TARGET_DIRdebouncing_default__JszyNGv}/${sourceFileNamedebouncing_default__JszyNGv}.s
    )
