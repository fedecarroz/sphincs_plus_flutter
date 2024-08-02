# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(sphincs_plus_library VERSION 0.0.1 LANGUAGES C)

add_library(sphincs_plus SHARED
  "sphincs_plus.c"
)

set_target_properties(sphincs_plus PROPERTIES
  PUBLIC_HEADER sphincs_plus.h
  OUTPUT_NAME "sphincs_plus"
)

target_compile_definitions(sphincs_plus PUBLIC DART_SHARED_LIB)
