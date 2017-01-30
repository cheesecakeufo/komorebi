
option (GSETTINGS_COMPILE "Compile GSettings Schemas after installation" ON)

if(GSETTINGS_COMPILE)
    message(STATUS "GSettings shemas will be compiled.")
endif()

macro(add_schema SCHEMA_NAME)

    set(PKG_CONFIG_EXECUTABLE pkg-config)
    # Have an option to not install the schema into where GLib is
        execute_process (COMMAND ${PKG_CONFIG_EXECUTABLE} glib-2.0 --variable prefix OUTPUT_VARIABLE _glib_prefix OUTPUT_STRIP_TRAILING_WHITESPACE)
        SET (GSETTINGS_DIR "${_glib_prefix}/share/glib-2.0/schemas/")

    # Run the validator and error if it fails
    execute_process (COMMAND ${PKG_CONFIG_EXECUTABLE} gio-2.0 --variable glib_compile_schemas  OUTPUT_VARIABLE _glib_comple_schemas OUTPUT_STRIP_TRAILING_WHITESPACE)
    execute_process (COMMAND ${_glib_comple_schemas} --dry-run --schema-file=${CMAKE_CURRENT_SOURCE_DIR}/${SCHEMA_NAME} ERROR_VARIABLE _schemas_invalid OUTPUT_STRIP_TRAILING_WHITESPACE)

    if (_schemas_invalid)
      message (SEND_ERROR "Schema validation error: ${_schemas_invalid}")
    endif (_schemas_invalid)

    # Actually install and recomple schemas
    message (STATUS "Found ${SCHEMA_NAME}")
    message (STATUS "I'll compile and install it to ${GSETTINGS_DIR}")
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/${SCHEMA_NAME} DESTINATION ${GSETTINGS_DIR} OPTIONAL)

    if (GSETTINGS_COMPILE)
        install (CODE "message (STATUS \"running glib-compile-schemas for ${SCHEMA_NAME}\")")
        install (CODE "execute_process (COMMAND ${_glib_comple_schemas} ${GSETTINGS_DIR})")
    endif ()
endmacro()
