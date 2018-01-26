# Copyright (c) 2014-2015, Ruslan Baratov
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_version)
include(hunter_cacheable)
include(hunter_download)
include(hunter_local)
include(hunter_pick_scheme)
include(hunter_cmake_args)

hunter_cmake_args(
    Cryptopp
    CMAKE_ARGS
    DISABLE_ASM=1 DISABLE_SSSE3=1
)

set(DISABLE_ASM ON BOOL "Disable ASM")
set(DISABLE_SSSE3 ON BOOL "Disable SSSE3")

set(BUILD_STATIC OFF BOOL "Build static library")
set(BUILD_SHARED ON BOOL "Build shared library")

string(COMPARE EQUAL "${HUNTER_Cryptopp_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(CRYPTOPP_FROM_LOCAL 1)
  set(CRYPTOPP_ROOT ${HUNTER_Cryptopp_LOCAL_DIR})
  set(CRYPTOPP_INCLUDE "${HUNTER_Cryptopp_LOCAL_DIR}/")
  get_filename_component(SUBDIRECTORY_ABS ${CRYPTOPP_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_CURRENT_BINARY_DIR}/libs/Cryptopp")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake)
  hunter_cacheable(Cryptopp)
  hunter_download(PACKAGE_NAME Cryptopp)
  set(CRYPTOPP_INCLUDE "${CRYPTOPP_ROOT}")
endif()

make_symlink("${CRYPTOPP_INCLUDE}" "${CMAKE_CURRENT_BINARY_DIR}/include/Cryptopp")

