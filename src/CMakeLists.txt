cmake_minimum_required(VERSION 3.10)

project(sphincs_plus VERSION 1.0.0 LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(REF_DIR "sphincsplus/ref")

set(
    BASE_SOURCES
    ${REF_DIR}/address.c
    ${REF_DIR}/randombytes.c
    ${REF_DIR}/merkle.c
    ${REF_DIR}/wots.c
    ${REF_DIR}/wotsx1.c
    ${REF_DIR}/utils.c
    ${REF_DIR}/utilsx1.c
    ${REF_DIR}/fors.c
    ${REF_DIR}/sign.c
)

set(
    BASE_HEADERS
    ${REF_DIR}/params.h
    ${REF_DIR}/address.h
    ${REF_DIR}/randombytes.h
    ${REF_DIR}/merkle.h
    ${REF_DIR}/wots.h
    ${REF_DIR}/wotsx1.h
    ${REF_DIR}/utils.h
    ${REF_DIR}/utilsx1.h
    ${REF_DIR}/fors.h
    ${REF_DIR}/api.h
    ${REF_DIR}/hash.h
    ${REF_DIR}/thash.h
)

foreach(
    PARAMS

    "sphincs-haraka-128f" "sphincs-haraka-128s"
    "sphincs-haraka-192f" "sphincs-haraka-192s"
    "sphincs-haraka-256f" "sphincs-haraka-256s"

    "sphincs-shake-128f" "sphincs-shake-128s"
    "sphincs-shake-192f" "sphincs-shake-192s"
    "sphincs-shake-256f" "sphincs-shake-256s"

    "sphincs-sha2-128f" "sphincs-sha2-128s"
    "sphincs-sha2-192f" "sphincs-sha2-192s"
    "sphincs-sha2-256f" "sphincs-sha2-256s"
)
    foreach(THASH "robust" "simple")
        if("${PARAMS}" MATCHES "shake")
            set(SOURCES ${BASE_SOURCES} ${REF_DIR}/fips202.c ${REF_DIR}/hash_shake.c ${REF_DIR}/thash_shake_${THASH}.c)
            set(HEADERS ${BASE_HEADERS} ${REF_DIR}/fips202.h)
        endif()

        if("${PARAMS}" MATCHES "haraka")
            set(SOURCES ${BASE_SOURCES} ${REF_DIR}/haraka.c ${REF_DIR}/hash_haraka.c ${REF_DIR}/thash_haraka_${THASH}.c)
            set(HEADERS ${BASE_HEADERS} ${REF_DIR}/haraka.h)
        endif()

        if("${PARAMS}" MATCHES "sha2")
            set(SOURCES ${BASE_SOURCES} ${REF_DIR}/sha2.c ${REF_DIR}/hash_sha2.c ${REF_DIR}/thash_sha2_${THASH}.c)
            set(HEADERS ${BASE_HEADERS} ${REF_DIR}/sha2.h)
        endif()

        add_library(${PARAMS}-${THASH} SHARED ${SOURCES})

        target_include_directories(${PARAMS}-${THASH} PUBLIC "sphincsplus/ref")

        set_target_properties(${PARAMS}-${THASH} PROPERTIES
            PUBLIC_HEADER api.h
            OUTPUT_NAME "-${PARAMS}-${THASH}"
        )

        if(WIN32)
            set_target_properties(${PARAMS}-${THASH} PROPERTIES SUFFIX ".dll")
        elseif(APPLE)
            set_target_properties(${PARAMS}-${THASH} PROPERTIES SUFFIX ".dylib")
        else()
            set_target_properties(${PARAMS}-${THASH} PROPERTIES SUFFIX ".so")
        endif()

        target_compile_options(
            ${PARAMS}-${THASH} PRIVATE 
            -Wall -Wextra -Wpedantic -O3 -Wconversion -Wmissing-prototypes
            -DPARAMS=${PARAMS}
        )

        target_compile_definitions(${PARAMS}-${THASH} PUBLIC DART_SHARED_LIB)
    endforeach()    
endforeach()
