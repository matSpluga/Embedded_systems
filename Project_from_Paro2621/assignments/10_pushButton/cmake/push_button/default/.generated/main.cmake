include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(push_button_default_library_list )

# Handle files with suffix s, for group default-XC16
if(push_button_default_default_XC16_FILE_TYPE_assemble)
add_library(push_button_default_default_XC16_assemble OBJECT ${push_button_default_default_XC16_FILE_TYPE_assemble})
    push_button_default_default_XC16_assemble_rule(push_button_default_default_XC16_assemble)
    list(APPEND push_button_default_library_list "$<TARGET_OBJECTS:push_button_default_default_XC16_assemble>")

endif()

# Handle files with suffix S, for group default-XC16
if(push_button_default_default_XC16_FILE_TYPE_assemblePreproc)
add_library(push_button_default_default_XC16_assemblePreproc OBJECT ${push_button_default_default_XC16_FILE_TYPE_assemblePreproc})
    push_button_default_default_XC16_assemblePreproc_rule(push_button_default_default_XC16_assemblePreproc)
    list(APPEND push_button_default_library_list "$<TARGET_OBJECTS:push_button_default_default_XC16_assemblePreproc>")

endif()

# Handle files with suffix c, for group default-XC16
if(push_button_default_default_XC16_FILE_TYPE_compile)
add_library(push_button_default_default_XC16_compile OBJECT ${push_button_default_default_XC16_FILE_TYPE_compile})
    push_button_default_default_XC16_compile_rule(push_button_default_default_XC16_compile)
    list(APPEND push_button_default_library_list "$<TARGET_OBJECTS:push_button_default_default_XC16_compile>")

endif()

# Handle files with suffix s, for group default-XC16
if(push_button_default_default_XC16_FILE_TYPE_dependentObject)
add_library(push_button_default_default_XC16_dependentObject OBJECT ${push_button_default_default_XC16_FILE_TYPE_dependentObject})
    push_button_default_default_XC16_dependentObject_rule(push_button_default_default_XC16_dependentObject)
    list(APPEND push_button_default_library_list "$<TARGET_OBJECTS:push_button_default_default_XC16_dependentObject>")

endif()

# Handle files with suffix elf, for group default-XC16
if(push_button_default_default_XC16_FILE_TYPE_bin2hex)
add_library(push_button_default_default_XC16_bin2hex OBJECT ${push_button_default_default_XC16_FILE_TYPE_bin2hex})
    push_button_default_default_XC16_bin2hex_rule(push_button_default_default_XC16_bin2hex)
    list(APPEND push_button_default_library_list "$<TARGET_OBJECTS:push_button_default_default_XC16_bin2hex>")

endif()


# Main target for this project
add_executable(push_button_default_image_zfdmPEKg ${push_button_default_library_list})

set_target_properties(push_button_default_image_zfdmPEKg PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${push_button_default_output_dir}")
target_link_libraries(push_button_default_image_zfdmPEKg PRIVATE ${push_button_default_default_XC16_FILE_TYPE_link})

# Add the link options from the rule file.
push_button_default_link_rule( push_button_default_image_zfdmPEKg)

# Call bin2hex function from the rule file
push_button_default_bin2hex_rule(push_button_default_image_zfdmPEKg)

