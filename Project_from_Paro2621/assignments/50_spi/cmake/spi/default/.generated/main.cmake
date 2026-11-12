include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(spi_default_library_list )

# Handle files with suffix s, for group default-XC16
if(spi_default_default_XC16_FILE_TYPE_assemble)
add_library(spi_default_default_XC16_assemble OBJECT ${spi_default_default_XC16_FILE_TYPE_assemble})
    spi_default_default_XC16_assemble_rule(spi_default_default_XC16_assemble)
    list(APPEND spi_default_library_list "$<TARGET_OBJECTS:spi_default_default_XC16_assemble>")

endif()

# Handle files with suffix S, for group default-XC16
if(spi_default_default_XC16_FILE_TYPE_assemblePreproc)
add_library(spi_default_default_XC16_assemblePreproc OBJECT ${spi_default_default_XC16_FILE_TYPE_assemblePreproc})
    spi_default_default_XC16_assemblePreproc_rule(spi_default_default_XC16_assemblePreproc)
    list(APPEND spi_default_library_list "$<TARGET_OBJECTS:spi_default_default_XC16_assemblePreproc>")

endif()

# Handle files with suffix c, for group default-XC16
if(spi_default_default_XC16_FILE_TYPE_compile)
add_library(spi_default_default_XC16_compile OBJECT ${spi_default_default_XC16_FILE_TYPE_compile})
    spi_default_default_XC16_compile_rule(spi_default_default_XC16_compile)
    list(APPEND spi_default_library_list "$<TARGET_OBJECTS:spi_default_default_XC16_compile>")

endif()

# Handle files with suffix s, for group default-XC16
if(spi_default_default_XC16_FILE_TYPE_dependentObject)
add_library(spi_default_default_XC16_dependentObject OBJECT ${spi_default_default_XC16_FILE_TYPE_dependentObject})
    spi_default_default_XC16_dependentObject_rule(spi_default_default_XC16_dependentObject)
    list(APPEND spi_default_library_list "$<TARGET_OBJECTS:spi_default_default_XC16_dependentObject>")

endif()

# Handle files with suffix elf, for group default-XC16
if(spi_default_default_XC16_FILE_TYPE_bin2hex)
add_library(spi_default_default_XC16_bin2hex OBJECT ${spi_default_default_XC16_FILE_TYPE_bin2hex})
    spi_default_default_XC16_bin2hex_rule(spi_default_default_XC16_bin2hex)
    list(APPEND spi_default_library_list "$<TARGET_OBJECTS:spi_default_default_XC16_bin2hex>")

endif()


# Main target for this project
add_executable(spi_default_image_1mMqNWkM ${spi_default_library_list})

set_target_properties(spi_default_image_1mMqNWkM PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${spi_default_output_dir}")
target_link_libraries(spi_default_image_1mMqNWkM PRIVATE ${spi_default_default_XC16_FILE_TYPE_link})

# Add the link options from the rule file.
spi_default_link_rule( spi_default_image_1mMqNWkM)

# Call bin2hex function from the rule file
spi_default_bin2hex_rule(spi_default_image_1mMqNWkM)

