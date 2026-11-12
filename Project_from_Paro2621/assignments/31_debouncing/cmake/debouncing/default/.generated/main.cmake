include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(debouncing_default_library_list )

# Handle files with suffix s, for group default-XC16
if(debouncing_default_default_XC16_FILE_TYPE_assemble)
add_library(debouncing_default_default_XC16_assemble OBJECT ${debouncing_default_default_XC16_FILE_TYPE_assemble})
    debouncing_default_default_XC16_assemble_rule(debouncing_default_default_XC16_assemble)
    list(APPEND debouncing_default_library_list "$<TARGET_OBJECTS:debouncing_default_default_XC16_assemble>")

endif()

# Handle files with suffix S, for group default-XC16
if(debouncing_default_default_XC16_FILE_TYPE_assemblePreproc)
add_library(debouncing_default_default_XC16_assemblePreproc OBJECT ${debouncing_default_default_XC16_FILE_TYPE_assemblePreproc})
    debouncing_default_default_XC16_assemblePreproc_rule(debouncing_default_default_XC16_assemblePreproc)
    list(APPEND debouncing_default_library_list "$<TARGET_OBJECTS:debouncing_default_default_XC16_assemblePreproc>")

endif()

# Handle files with suffix c, for group default-XC16
if(debouncing_default_default_XC16_FILE_TYPE_compile)
add_library(debouncing_default_default_XC16_compile OBJECT ${debouncing_default_default_XC16_FILE_TYPE_compile})
    debouncing_default_default_XC16_compile_rule(debouncing_default_default_XC16_compile)
    list(APPEND debouncing_default_library_list "$<TARGET_OBJECTS:debouncing_default_default_XC16_compile>")

endif()

# Handle files with suffix s, for group default-XC16
if(debouncing_default_default_XC16_FILE_TYPE_dependentObject)
add_library(debouncing_default_default_XC16_dependentObject OBJECT ${debouncing_default_default_XC16_FILE_TYPE_dependentObject})
    debouncing_default_default_XC16_dependentObject_rule(debouncing_default_default_XC16_dependentObject)
    list(APPEND debouncing_default_library_list "$<TARGET_OBJECTS:debouncing_default_default_XC16_dependentObject>")

endif()

# Handle files with suffix elf, for group default-XC16
if(debouncing_default_default_XC16_FILE_TYPE_bin2hex)
add_library(debouncing_default_default_XC16_bin2hex OBJECT ${debouncing_default_default_XC16_FILE_TYPE_bin2hex})
    debouncing_default_default_XC16_bin2hex_rule(debouncing_default_default_XC16_bin2hex)
    list(APPEND debouncing_default_library_list "$<TARGET_OBJECTS:debouncing_default_default_XC16_bin2hex>")

endif()


# Main target for this project
add_executable(debouncing_default_image_BTINploz ${debouncing_default_library_list})

set_target_properties(debouncing_default_image_BTINploz PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${debouncing_default_output_dir}")
target_link_libraries(debouncing_default_image_BTINploz PRIVATE ${debouncing_default_default_XC16_FILE_TYPE_link})

# Add the link options from the rule file.
debouncing_default_link_rule( debouncing_default_image_BTINploz)

# Call bin2hex function from the rule file
debouncing_default_bin2hex_rule(debouncing_default_image_BTINploz)

