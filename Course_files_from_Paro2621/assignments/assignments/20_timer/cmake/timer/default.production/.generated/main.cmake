include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(timer_default_library_list )

# Handle files with suffix s, for group default-XC16
if(timer_default_default_XC16_FILE_TYPE_assemble)
add_library(timer_default_default_XC16_assemble OBJECT ${timer_default_default_XC16_FILE_TYPE_assemble})
    timer_default_default_XC16_assemble_rule(timer_default_default_XC16_assemble)
    list(APPEND timer_default_library_list "$<TARGET_OBJECTS:timer_default_default_XC16_assemble>")

endif()

# Handle files with suffix S, for group default-XC16
if(timer_default_default_XC16_FILE_TYPE_assemblePreproc)
add_library(timer_default_default_XC16_assemblePreproc OBJECT ${timer_default_default_XC16_FILE_TYPE_assemblePreproc})
    timer_default_default_XC16_assemblePreproc_rule(timer_default_default_XC16_assemblePreproc)
    list(APPEND timer_default_library_list "$<TARGET_OBJECTS:timer_default_default_XC16_assemblePreproc>")

endif()

# Handle files with suffix c, for group default-XC16
if(timer_default_default_XC16_FILE_TYPE_compile)
add_library(timer_default_default_XC16_compile OBJECT ${timer_default_default_XC16_FILE_TYPE_compile})
    timer_default_default_XC16_compile_rule(timer_default_default_XC16_compile)
    list(APPEND timer_default_library_list "$<TARGET_OBJECTS:timer_default_default_XC16_compile>")

endif()

# Handle files with suffix s, for group default-XC16
if(timer_default_default_XC16_FILE_TYPE_dependentObject)
add_library(timer_default_default_XC16_dependentObject OBJECT ${timer_default_default_XC16_FILE_TYPE_dependentObject})
    timer_default_default_XC16_dependentObject_rule(timer_default_default_XC16_dependentObject)
    list(APPEND timer_default_library_list "$<TARGET_OBJECTS:timer_default_default_XC16_dependentObject>")

endif()

# Handle files with suffix elf, for group default-XC16
if(timer_default_default_XC16_FILE_TYPE_bin2hex)
add_library(timer_default_default_XC16_bin2hex OBJECT ${timer_default_default_XC16_FILE_TYPE_bin2hex})
    timer_default_default_XC16_bin2hex_rule(timer_default_default_XC16_bin2hex)
    list(APPEND timer_default_library_list "$<TARGET_OBJECTS:timer_default_default_XC16_bin2hex>")

endif()


# Main target for this project
add_executable(timer_default_image_NLlE6Wss ${timer_default_library_list})

set_target_properties(timer_default_image_NLlE6Wss PROPERTIES
    OUTPUT_NAME "default-production"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${timer_default_output_dir}")
target_link_libraries(timer_default_image_NLlE6Wss PRIVATE ${timer_default_default_XC16_FILE_TYPE_link})

# Add the link options from the rule file.
timer_default_link_rule( timer_default_image_NLlE6Wss)

# Call bin2hex function from the rule file
timer_default_bin2hex_rule(timer_default_image_NLlE6Wss)

