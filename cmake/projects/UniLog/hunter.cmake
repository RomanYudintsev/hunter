# Copyright (c) 2014-2015, Ruslan Baratov
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_version)
include(hunter_cacheable)
include(hunter_download)
include(hunter_local)
include(hunter_pick_scheme)
include(hunter_cmake_args)


string(COMPARE EQUAL "${HUNTER_UniLog_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(UNILOG_FROM_LOCAL 1)
  set(UNILOG_ROOT ${HUNTER_UniLog_LOCAL_DIR})
  set(UNILOG_INCLUDE "${HUNTER_UniLog_LOCAL_DIR}/")
  get_filename_component(SUBDIRECTORY_ABS ${UNILOG_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_CURRENT_BINARY_DIR}/libs/UniLog")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake)
  hunter_cacheable(UniLog)
  hunter_download(PACKAGE_NAME UniLog)
  set(UNILOG_INCLUDE "${UNILOG_ROOT}")
endif()

make_symlink("${UNILOG_INCLUDE}" "${CMAKE_CURRENT_BINARY_DIR}/include/UniLog")

