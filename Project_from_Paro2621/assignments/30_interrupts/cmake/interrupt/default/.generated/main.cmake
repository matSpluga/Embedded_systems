include("${CMAKE_CURRENT_LIST_DIR}/rule.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/file.cmake")

set(interrupt_default_library_list )

# Handle files with suffix s, for group default-XC16
if(interrupt_default_default_XC16_FILE_TYPE_assemble)
add_library(interrupt_default_default_XC16_assemble OBJECT ${interrupt_default_default_XC16_FILE_TYPE_assemble})
    interrupt_default_default_XC16_assemble_rule(interrupt_default_default_XC16_assemble)
    list(APPEND interrupt_default_library_list "$<TARGET_OBJECTS:interrupt_default_default_XC16_assemble>")

endif()

# Handle files with suffix S, for group default-XC16
if(interrupt_default_default_XC16_FILE_TYPE_assemblePreproc)
add_library(interrupt_default_default_XC16_assemblePreproc OBJECT ${interrupt_default_default_XC16_FILE_TYPE_assemblePreproc})
    interrupt_default_default_XC16_assemblePreproc_rule(interrupt_default_default_XC16_assemblePreproc)
    list(APPEND interrupt_default_library_list "$<TARGET_OBJECTS:interrupt_default_default_XC16_assemblePreproc>")

endif()

# Handle files with suffix c, for group default-XC16
if(interrupt_default_default_XC16_FILE_TYPE_compile)
add_library(interrupt_default_default_XC16_compile OBJECT ${interrupt_default_default_XC16_FILE_TYPE_compile})
    interrupt_default_default_XC16_compile_rule(interrupt_default_default_XC16_compile)
    list(APPEND interrupt_default_library_list "$<TARGET_OBJECTS:interrupt_default_default_XC16_compile>")

endif()

# Handle files with suffix s, for group default-XC16
if(interrupt_default_default_XC16_FILE_TYPE_dependentObject)
add_library(interrupt_default_default_XC16_dependentObject OBJECT ${interrupt_default_default_XC16_FILE_TYPE_dependentObject})
    interrupt_default_default_XC16_dependentObject_rule(interrupt_default_default_XC16_dependentObject)
    list(APPEND interrupt_default_library_list "$<TARGET_OBJECTS:interrupt_default_default_XC16_dependentObject>")

endif()

# Handle files with suffix elf, for group default-XC16
if(interrupt_default_default_XC16_FILE_TYPE_bin2hex)
add_library(interrupt_default_default_XC16_bin2hex OBJECT ${interrupt_default_default_XC16_FILE_TYPE_bin2hex})
    interrupt_default_default_XC16_bin2hex_rule(interrupt_default_default_XC16_bin2hex)
    list(APPEND interrupt_default_library_list "$<TARGET_OBJECTS:interrupt_default_default_XC16_bin2hex>")

endif()


# Main target for this project
add_executable(interrupt_default_image_wx3KJVUv ${interrupt_default_library_list})

set_target_properties(interrupt_default_image_wx3KJVUv PROPERTIES
    OUTPUT_NAME "default"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${interrupt_default_output_dir}")
target_link_libraries(interrupt_default_image_wx3KJVUv PRIVATE ${interrupt_default_default_XC16_FILE_TYPE_link})

# Add the link options from the rule file.
interrupt_default_link_rule( interrupt_default_image_wx3KJVUv)

# Call bin2hex function from the rule file
interrupt_default_bin2hex_rule(interrupt_default_image_wx3KJVUv)

