# Add a subdirectory if not disabled
macro (maybe_add_directory def dir)
    if (NOT "${${def}}")
        list(APPEND SUBDIRS ${dir})
    endif ()
endmacro ()

macro (look_for_assembler algo target defn)
    set(FOUND 0)
    if (DEFINED ${algo}asm_${ARCH})
#       message("FOUND ${algo}asm_${ARCH} ${${algo}asm_${ARCH}}")
        list(APPEND SOURCE ${${algo}asm_${ARCH}})
        target_compile_definitions(${target} PUBLIC ${defn})
        list(APPEND ASM_DEFS ${defn})
        set(FOUND 1)
    endif ()
endmacro ()

# Simple foo.pl generates foo.s (or foo.S)
macro (generate_asm_from_perl ASfile PLfile)
    add_custom_command(COMMENT "Generating ${ASfile}"
        OUTPUT ${ASfile} DEPENDS ${PLfile}
        COMMAND ${PERL} -I.. ${PLfile}
        VERBATIM)
endmacro ()

# Simple foo.pl generates foo.s (or foo.S)
macro (generate_asm_from_m4 ASfile M4file)
    add_custom_command(COMMENT "Generating ${ASfile} from m4"
        OUTPUT ${ASfile} DEPENDS ${M4file}
        COMMAND m4 -B 8192 ${M4file} >${ASfile}
        VERBATIM)
endmacro ()
