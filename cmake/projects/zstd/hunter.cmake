# Copyright (c) 2014-2015, Ruslan Baratov
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_version)
include(hunter_cacheable)
include(hunter_download)
include(hunter_local)
include(hunter_pick_scheme)
include(hunter_cmake_args)



string(COMPARE EQUAL "${HUNTER_zstd_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(ZSTD_FROM_LOCAL 1)
  set(ZSTD_ROOT ${HUNTER_zstd_LOCAL_DIR})
  set(ZSTD_INCLUDE "${HUNTER_zstd_LOCAL_DIR}")
  get_filename_component(SUBDIRECTORY_ABS ${ZSTD_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_CURRENT_BINARY_DIR}/libs/zstd")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake)
  hunter_cacheable(zstd)
  hunter_download(PACKAGE_NAME zstd)
  set(ZSTD_INCLUDE "${ZSTD_ROOT}")
endif()

make_symlink("${ZSTD_INCLUDE}" "${CMAKE_CURRENT_BINARY_DIR}/include/zstd")

