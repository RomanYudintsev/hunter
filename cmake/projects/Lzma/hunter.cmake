# Copyright (c) 2014-2015, Ruslan Baratov
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_version)
include(hunter_cacheable)
include(hunter_download)
include(hunter_local)
include(hunter_pick_scheme)
include(hunter_cmake_args)


string(COMPARE EQUAL "${HUNTER_Lzma_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(LZMA_FROM_LOCAL 1)
  set(LZMA_ROOT ${HUNTER_Lzma_LOCAL_DIR})
  set(LZMA_INCLUDE "${HUNTER_Lzma_LOCAL_DIR}/sdk/C")
  get_filename_component(SUBDIRECTORY_ABS ${LZMA_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_CURRENT_BINARY_DIR}/libs/Lzma")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake)
  hunter_cacheable(Lzma)
  hunter_download(PACKAGE_NAME Lzma)
  set(LZMA_INCLUDE "${LZMA_ROOT}")
endif()

make_symlink("${LZMA_INCLUDE}" "${CMAKE_CURRENT_BINARY_DIR}/include/Lzma")

