include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(uart_advanced_v2_default_library_list )

# Handle files with suffix s, for group default-XC16
if(uart_advanced_v2_default_default_XC16_FILE_TYPE_assemble)
add_library(uart_advanced_v2_default_default_XC16_assemble OBJECT ${uart_advanced_v2_default_default_XC16_FILE_TYPE_assemble})
    uart_advanced_v2_default_default_XC16_assemble_rule(uart_advanced_v2_default_default_XC16_assemble)
    list(APPEND uart_advanced_v2_default_library_list "$<TARGET_OBJECTS:uart_advanced_v2_default_default_XC16_assemble>")

endif()

# Handle files with suffix S, for group default-XC16
if(uart_advanced_v2_default_default_XC16_FILE_TYPE_assemblePreproc)
add_library(uart_advanced_v2_default_default_XC16_assemblePreproc OBJECT ${uart_advanced_v2_default_default_XC16_FILE_TYPE_assemblePreproc})
    uart_advanced_v2_default_default_XC16_assemblePreproc_rule(uart_advanced_v2_default_default_XC16_assemblePreproc)
    list(APPEND uart_advanced_v2_default_library_list "$<TARGET_OBJECTS:uart_advanced_v2_default_default_XC16_assemblePreproc>")

endif()

# Handle files with suffix c, for group default-XC16
if(uart_advanced_v2_default_default_XC16_FILE_TYPE_compile)
add_library(uart_advanced_v2_default_default_XC16_compile OBJECT ${uart_advanced_v2_default_default_XC16_FILE_TYPE_compile})
    uart_advanced_v2_default_default_XC16_compile_rule(uart_advanced_v2_default_default_XC16_compile)
    list(APPEND uart_advanced_v2_default_library_list "$<TARGET_OBJECTS:uart_advanced_v2_default_default_XC16_compile>")

endif()

# Handle files with suffix s, for group default-XC16
if(uart_advanced_v2_default_default_XC16_FILE_TYPE_dependentObject)
add_library(uart_advanced_v2_default_default_XC16_dependentObject OBJECT ${uart_advanced_v2_default_default_XC16_FILE_TYPE_dependentObject})
    uart_advanced_v2_default_default_XC16_dependentObject_rule(uart_advanced_v2_default_default_XC16_dependentObject)
    list(APPEND uart_advanced_v2_default_library_list "$<TARGET_OBJECTS:uart_advanced_v2_default_default_XC16_dependentObject>")

endif()

# Handle files with suffix elf, for group default-XC16
if(uart_advanced_v2_default_default_XC16_FILE_TYPE_bin2hex)
add_library(uart_advanced_v2_default_default_XC16_bin2hex OBJECT ${uart_advanced_v2_default_default_XC16_FILE_TYPE_bin2hex})
    uart_advanced_v2_default_default_XC16_bin2hex_rule(uart_advanced_v2_default_default_XC16_bin2hex)
    list(APPEND uart_advanced_v2_default_library_list "$<TARGET_OBJECTS:uart_advanced_v2_default_default_XC16_bin2hex>")

endif()


# Main target for this project
add_executable(uart_advanced_v2_default_image_6cf7CXZt ${uart_advanced_v2_default_library_list})

set_target_properties(uart_advanced_v2_default_image_6cf7CXZt PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${uart_advanced_v2_default_output_dir}")
target_link_libraries(uart_advanced_v2_default_image_6cf7CXZt PRIVATE ${uart_advanced_v2_default_default_XC16_FILE_TYPE_link})

# Add the link options from the rule file.
uart_advanced_v2_default_link_rule( uart_advanced_v2_default_image_6cf7CXZt)

# Call bin2hex function from the rule file
uart_advanced_v2_default_bin2hex_rule(uart_advanced_v2_default_image_6cf7CXZt)

