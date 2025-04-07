set(SUBDIRS man1 man3 man5 man7)

function (makeman SEC VARNAME)
    set(manX man${SEC})
    set(listvar ${${VARNAME}})
    set(MANPAGES)
    foreach (F ${listvar})
        set(in ${CMAKE_SOURCE_DIR}/doc/${manX}/${F})
        if (NOT EXISTS ${in})
            set(in ${CMAKE_BINARY_DIR}/doc/${manX}/${F})
        endif ()
        string(REPLACE .pod .${SEC} out ${F})
        add_custom_command(COMMENT "Generating ${out}"
            OUTPUT ${out} DEPENDS ${F}
            COMMAND ${POD2MAN} ${in} ${out}
            VERBATIM)
        list(APPEND MANPAGES ${out})
    endforeach ()
    add_custom_target(${manX} DEPENDS ${MANPAGES})
    install(FILES ${MANPAGES} TYPE MAN)
    installsymlinks(${MANPAGES} ${SEC})
endfunction ()

function(parse_manpage_name MANPAGE_PATH OUTPUT_VARIABLE)
    #file(READ "${MANPAGE_PATH}" MANPAGE_CONTENTS)
    file(STRINGS "${MANPAGE_PATH}" MANPAGE_CONTENTS
        LIMIT_COUNT 100 NEWLINE_CONSUME)

  string(REGEX MATCH "NAME\\s*\\n\\s*(.*)\\n" NAME_SECTION "${MANPAGE_CONTENTS}")
  if(NAME_SECTION)
    string(REGEX REPLACE "NAME\\s*\\n\\s*" "" NAME_SECTION "${NAME_SECTION}")
    string(REGEX REPLACE "\\n.*" "" NAME_SECTION "${NAME_SECTION}")
    string(STRIP "${NAME_SECTION}" PARSED_NAME)
    set("${OUTPUT_VARIABLE}" "${PARSED_NAME}" PARENT_SCOPE)
  else()
    set("${OUTPUT_VARIABLE}" "" PARENT_SCOPE)
  endif()
endfunction()

# Example Usage
#set(MANPAGE_FILE "path/to/your/manpage.1")
#parse_manpage_name("${MANPAGE_FILE}" MANPAGE_NAME)

#if(MANPAGE_NAME)
#  message("Manpage Name: ${MANPAGE_NAME}")
#else()
#  message(WARNING "Could not parse NAME section from ${MANPAGE_FILE}")
#endif()

function (installsymlinks MANPAGES SEC)
    #    install(CODE
    #    "execute_process( \
    #COMMAND ${CMAKE_COMMAND} -E create_symlink \
    #${target} \
    #${link}   \
    #)"
    #)
endfunction ()

foreach (SD ${SUBDIRS})
    add_subdirectory(${SD})
endforeach ()
add_custom_target(man DEPENDS ${SUBDIRS})
