include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(uart_basic_default_library_list )

# Handle files with suffix s, for group default-XC16
if(uart_basic_default_default_XC16_FILE_TYPE_assemble)
add_library(uart_basic_default_default_XC16_assemble OBJECT ${uart_basic_default_default_XC16_FILE_TYPE_assemble})
    uart_basic_default_default_XC16_assemble_rule(uart_basic_default_default_XC16_assemble)
    list(APPEND uart_basic_default_library_list "$<TARGET_OBJECTS:uart_basic_default_default_XC16_assemble>")

endif()

# Handle files with suffix S, for group default-XC16
if(uart_basic_default_default_XC16_FILE_TYPE_assemblePreproc)
add_library(uart_basic_default_default_XC16_assemblePreproc OBJECT ${uart_basic_default_default_XC16_FILE_TYPE_assemblePreproc})
    uart_basic_default_default_XC16_assemblePreproc_rule(uart_basic_default_default_XC16_assemblePreproc)
    list(APPEND uart_basic_default_library_list "$<TARGET_OBJECTS:uart_basic_default_default_XC16_assemblePreproc>")

endif()

# Handle files with suffix c, for group default-XC16
if(uart_basic_default_default_XC16_FILE_TYPE_compile)
add_library(uart_basic_default_default_XC16_compile OBJECT ${uart_basic_default_default_XC16_FILE_TYPE_compile})
    uart_basic_default_default_XC16_compile_rule(uart_basic_default_default_XC16_compile)
    list(APPEND uart_basic_default_library_list "$<TARGET_OBJECTS:uart_basic_default_default_XC16_compile>")

endif()

# Handle files with suffix s, for group default-XC16
if(uart_basic_default_default_XC16_FILE_TYPE_dependentObject)
add_library(uart_basic_default_default_XC16_dependentObject OBJECT ${uart_basic_default_default_XC16_FILE_TYPE_dependentObject})
    uart_basic_default_default_XC16_dependentObject_rule(uart_basic_default_default_XC16_dependentObject)
    list(APPEND uart_basic_default_library_list "$<TARGET_OBJECTS:uart_basic_default_default_XC16_dependentObject>")

endif()

# Handle files with suffix elf, for group default-XC16
if(uart_basic_default_default_XC16_FILE_TYPE_bin2hex)
add_library(uart_basic_default_default_XC16_bin2hex OBJECT ${uart_basic_default_default_XC16_FILE_TYPE_bin2hex})
    uart_basic_default_default_XC16_bin2hex_rule(uart_basic_default_default_XC16_bin2hex)
    list(APPEND uart_basic_default_library_list "$<TARGET_OBJECTS:uart_basic_default_default_XC16_bin2hex>")

endif()


# Main target for this project
add_executable(uart_basic_default_image_xDJH6Ck_ ${uart_basic_default_library_list})

set_target_properties(uart_basic_default_image_xDJH6Ck_ PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${uart_basic_default_output_dir}")
target_link_libraries(uart_basic_default_image_xDJH6Ck_ PRIVATE ${uart_basic_default_default_XC16_FILE_TYPE_link})

# Add the link options from the rule file.
uart_basic_default_link_rule( uart_basic_default_image_xDJH6Ck_)

# Call bin2hex function from the rule file
uart_basic_default_bin2hex_rule(uart_basic_default_image_xDJH6Ck_)

