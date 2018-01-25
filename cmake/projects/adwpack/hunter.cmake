# Copyright (c) 2014-2015, Ruslan Baratov
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_version)
include(hunter_cacheable)
include(hunter_download)
include(hunter_local)
include(hunter_pick_scheme)
include(hunter_cmake_args)


string(COMPARE EQUAL "${HUNTER_adwpack_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(ADWPACK_FROM_LOCAL 1)
  set(ADWPACK_ROOT ${HUNTER_adwpack_LOCAL_DIR})
  set(ADWPACK_INCLUDE "${HUNTER_adwpack_LOCAL_DIR}/")
  get_filename_component(SUBDIRECTORY_ABS ${ADWPACK_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_CURRENT_BINARY_DIR}/libs/adwpack")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake)
  hunter_cacheable(adwpack)
  hunter_download(PACKAGE_NAME adwpack)
  set(ADWPACK_INCLUDE "${ADWPACK_ROOT}")
endif()

make_symlink("${ADWPACK_INCLUDE}" "${CMAKE_CURRENT_BINARY_DIR}/include/adwpack")

