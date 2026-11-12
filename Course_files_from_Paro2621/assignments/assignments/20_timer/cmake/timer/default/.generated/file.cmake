# The following variables contains the files used by the different stages of the build process.
set(timer_default_default_XC16_FILE_TYPE_assemble)
set_source_files_properties(${timer_default_default_XC16_FILE_TYPE_assemble} PROPERTIES LANGUAGE ASM)

# For assembly files, add "." to the include path for each file so that .include with a relative path works
foreach(source_file ${timer_default_default_XC16_FILE_TYPE_assemble})
        set_source_files_properties(${source_file} PROPERTIES INCLUDE_DIRECTORIES "$<PATH:NORMAL_PATH,$<PATH:REMOVE_FILENAME,${source_file}>>")
endforeach()

set(timer_default_default_XC16_FILE_TYPE_assemblePreproc)
set_source_files_properties(${timer_default_default_XC16_FILE_TYPE_assemblePreproc} PROPERTIES LANGUAGE ASM)

# For assembly files, add "." to the include path for each file so that .include with a relative path works
foreach(source_file ${timer_default_default_XC16_FILE_TYPE_assemblePreproc})
        set_source_files_properties(${source_file} PROPERTIES INCLUDE_DIRECTORIES "$<PATH:NORMAL_PATH,$<PATH:REMOVE_FILENAME,${source_file}>>")
endforeach()

set(timer_default_default_XC16_FILE_TYPE_compile
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../main.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../timer.c")
set_source_files_properties(${timer_default_default_XC16_FILE_TYPE_compile} PROPERTIES LANGUAGE C)
set(timer_default_default_XC16_FILE_TYPE_link)
set(timer_default_default_XC16_FILE_TYPE_bin2hex)
set(timer_default_image_name "default.elf")
set(timer_default_image_base_name "default")

# The output directory of the final image.
set(timer_default_output_dir "${CMAKE_CURRENT_SOURCE_DIR}/../../../out/timer")

# The full path to the final image.
set(timer_default_full_path_to_image ${timer_default_output_dir}/${timer_default_image_name})
