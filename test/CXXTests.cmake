
# Get just the headers we want.
file(GLOB headers
    RELATIVE ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/include/openssl/*.h)
list(REMOVE_ITEM headers openssl/asn1_mac.h openssl/opensslconf.h)
set(filtered)
foreach (h ${headers})
    string(REGEX MATCH ".*err\.h" m ${h})
    if (NOT m)
        list(APPEND filtered ${h})
    endif ()
endforeach ()

# UNUSED.  List of build list of source files.
set(CXXTESTS)
macro(cxxbuild src)
    set(prog test/test${src})
    add_executable(${prog} ${prog}.cpp)
    list(APPEND CXXPROGS ${prog})
    target_include_directories(${prog} PUBLIC
        -I${CMAKE_SOURCE_DIR}/include -I${CMAKE_BINARY_DIR}/include)
endmacro ()

foreach (h ${filtered})
    string(REGEX REPLACE "openssl/(.*)\.h" "\\1" x ${h})
    string(TOUPPER ${x} simplename)
    string(CONCAT source "
#include <openssl/configuration.h>
#ifndef OPENSSL_NO_STDIO
# include <stdio.h>
#endif
#ifndef OPENSSL_NO_" ${simplename} "
# include <" ${h} ">
#endif

int main(void)
{
    return 0;
}
")
    set(in ${CMAKE_BINARY_DIR}/test/test${x}.cpp)
    file(WRITE ${in} "${source}")
    #cxxbuild(${x})
    try_run(run_result_unused compile_result
        ${CMAKE_BINARY_DIR} ${in}
        COMPILE_DEFINITIONS
            -I${CMAKE_SOURCE_DIR}/include -I${CMAKE_BINARY_DIR}/include
        )
    if (NOT compile_result)
        message(WARNING "${h} did not compile with C++")
    endif ()
endforeach ()

add_custom_target(testcxxprogs COMMENT "C++ compatiblity"
    DEPENDS ${CXXPROGS})
