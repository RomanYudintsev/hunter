# Copyright (c) 2014-2015, Ruslan Baratov
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_version)
include(hunter_cacheable)
include(hunter_download)
include(hunter_local)
include(hunter_pick_scheme)
include(hunter_cmake_args)


macro(SET_OPTION option value)
  set(${option} ${value} CACHE INTERNAL "" FORCE)
endmacro()

hunter_cmake_args(
    Cryptopp
    CMAKE_ARGS
    "-DDISABLE_ASM=ON DDISABLE_ASM=ON BUILD_STATIC=OFF BUILD_SHARED=OFF BUILD_TESTING=OFF BUILD_INTERFACE=ON"
)

SET_OPTION(DDISABLE_ASM  ON)
SET_OPTION(DISABLE_SSSE3  ON)
SET_OPTION(BUILD_STATIC  OFF)
SET_OPTION(BUILD_SHARED  OFF)
SET_OPTION(BUILD_INTERFACE  ON)
SET_OPTION(BUILD_TESTING  OFF)

string(COMPARE EQUAL "${HUNTER_Cryptopp_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(CRYPTOPP_FROM_LOCAL 1)
  set(CRYPTOPP_ROOT ${HUNTER_Cryptopp_LOCAL_DIR})
  set(CRYPTOPP_INCLUDE "${HUNTER_Cryptopp_LOCAL_DIR}/")
  get_filename_component(SUBDIRECTORY_ABS ${CRYPTOPP_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_BINARY_DIR}/libs/Cryptopp")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake)
  hunter_cacheable(Cryptopp)
  hunter_download(PACKAGE_NAME Cryptopp)
  set(CRYPTOPP_INCLUDE "${CRYPTOPP_ROOT}")
endif()

make_symlink("${CRYPTOPP_INCLUDE}" "${CMAKE_BINARY_DIR}/include/Cryptopp")

