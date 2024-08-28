# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(sphincs_plus VERSION 0.0.1 LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wpedantic -O3 -Wconversion -Wmissing-prototypes")

set(PARAMS "sphincs-haraka-128f")
set(THASH "robust")

target_include_directories(sphincs_plus PUBLIC
    "sphincsplus/ref")

set(SOURCES address.c randombytes.c merkle.c wots.c wotsx1.c utils.c utilsx1.c fors.c sign.c)
set(HEADERS params.h address.h randombytes.h merkle.h wots.h wotsx1.h utils.h utilsx1.h fors.h api.h hash.h thash.h)

if("${PARAMS}" MATCHES "shake")
    list(APPEND SOURCES fips202.c hash_shake.c thash_shake_${THASH}.c)
    list(APPEND HEADERS fips202.h)
endif()

if("${PARAMS}" MATCHES "haraka")
    list(APPEND SOURCES haraka.c hash_haraka.c thash_haraka_${THASH}.c)
    list(APPEND HEADERS haraka.h)
endif()

if("${PARAMS}" MATCHES "sha2")
    list(APPEND SOURCES sha2.c hash_sha2.c thash_sha2_${THASH}.c)
    list(APPEND HEADERS sha2.h)
endif()

add_library(sphincs_plus SHARED ${SOURCES})

set_target_properties(sphincs_plus PROPERTIES
  PUBLIC_HEADER api.h
  OUTPUT_NAME "api"
)

if(WIN32)
    set_target_properties(sphincs_plus PROPERTIES
        SUFFIX ".dll"
        PREFIX "")
elseif(APPLE)
    set_target_properties(sphincs_plus PROPERTIES
        SUFFIX ".dylib")
else()
    set_target_properties(sphincs_plus PROPERTIES
        SUFFIX ".so")
endif()

target_link_libraries(sphincs_plus crypto)

target_compile_definitions(sphincs_plus PUBLIC DART_SHARED_LIB)