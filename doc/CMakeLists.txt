set(SUBDIRS man1 man3 man5 man7)

# Put a list of all the names into ${OUTPUT_VARIABLE}
function (get_manpage_names filename OUTPUT_VARIABLE)
    file(STRINGS ${filename} LINES LIMIT_COUNT 30 NEWLINE_CONSUME)
    list(JOIN LINES "" MANPAGE_CONTENTS)
    string(REGEX MATCH "=head1 NAME([^=]*)=head1" dummy ${MANPAGE_CONTENTS})
    string(REGEX REPLACE "[\n, ]+" " " NAMES ${CMAKE_MATCH_1})
    string(REGEX REPLACE " - .*" "" NAMES ${NAMES})
    string(STRIP ${NAMES} NAMES)
    string(REPLACE " " ";" NAMES ${NAMES})
    set(${OUTPUT_VARIABLE} ${NAMES} PARENT_SCOPE)
endfunction ()

# The variable named in ${VARNAME} has all the files for section ${SEC}.
# Run pod2man and turn foo.pod into pod.${SEC}
function (makeman SEC VARNAME)
    set(manX man${SEC})
    set(listvar ${${VARNAME}})
    set(MANPAGES)
    foreach (F ${listvar})
        # Look for each file in source or binary (if generated) directory.
        set(in ${CMAKE_SOURCE_DIR}/doc/${manX}/${F})
        if (NOT EXISTS ${in})
            set(in ${CMAKE_BINARY_DIR}/doc/${manX}/${F})
        endif ()
        string(REPLACE .pod .${SEC} out ${F})
        add_custom_command(COMMENT "Generating ${out}"
            OUTPUT ${out} DEPENDS ${in}
            COMMAND ${POD2MAN} ${in} ${out}
            VERBATIM)
        list(APPEND MANPAGES ${out})
        if (${SEC} MATCHES "[37]")
           # Now create .so files for all alternate names
           get_manpage_names(${in} NAMES)
           cmake_path(GET in STEM main)
           foreach (name ${NAMES})
               if (NOT name STREQUAL main)
                   set(target "${name}.${SEC}")
                   add_custom_command(COMMENT "Symlinking ${target}"
                       OUTPUT ${target}
                       COMMAND ${CMAKE_COMMAND} -E create_symlink ${out} ${target})
                   list(APPEND MANPAGES ${target})
                endif ()
             endforeach ()
        endif ()
    endforeach ()
    add_custom_target(${manX} DEPENDS ${MANPAGES})
    install(FILES ${MANPAGES} DESTINATION ${MANDIR}/${manX})
endfunction ()

foreach (SD ${SUBDIRS})
    add_subdirectory(${SD})
endforeach ()
add_custom_target(man DEPENDS ${SUBDIRS})
