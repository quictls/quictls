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
endfunction ()

foreach (SD ${SUBDIRS})
    add_subdirectory(${SD})
endforeach ()
add_custom_target(man DEPENDS ${SUBDIRS})
