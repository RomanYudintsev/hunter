# Copyright (c) 2014-2015, Ruslan Baratov
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_version)
include(hunter_cacheable)
include(hunter_download)
include(hunter_local)
include(hunter_pick_scheme)
include(hunter_cmake_args)


string(COMPARE EQUAL "${HUNTER_JsonUtil_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(JSONUTIL_FROM_LOCAL 1)
  set(JSONUTIL_ROOT ${HUNTER_JsonUtil_LOCAL_DIR})
  set(JSONUTIL_INCLUDE "${HUNTER_JsonUtil_LOCAL_DIR}/")
  get_filename_component(SUBDIRECTORY_ABS ${JSONUTIL_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_CURRENT_BINARY_DIR}/libs/JsonUtil")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake)
  hunter_cacheable(JsonUtil)
  hunter_download(PACKAGE_NAME JsonUtil)
  set(JSONUTIL_INCLUDE "${JSONUTIL_ROOT}")
endif()

make_symlink("${JSONUTIL_INCLUDE}" "${CMAKE_CURRENT_BINARY_DIR}/include/JsonUtil")

