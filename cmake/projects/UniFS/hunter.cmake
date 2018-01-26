# Copyright (c) 2014-2015, Ruslan Baratov
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_version)
include(hunter_cacheable)
include(hunter_download)
include(hunter_local)
include(hunter_pick_scheme)
include(hunter_cmake_args)

string(COMPARE EQUAL "${HUNTER_UniFS_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(UNIFS_FROM_LOCAL 1)
  set(UNIFS_ROOT ${HUNTER_UniFS_LOCAL_DIR})
  set(UNIFS_INCLUDE "${HUNTER_UniFS_LOCAL_DIR}")
  get_filename_component(SUBDIRECTORY_ABS ${UNIFS_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_BINARY_DIR}/libs/UniFS")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake)
  hunter_cacheable(UniFS)
  hunter_download(PACKAGE_NAME UniFS)
  set(UNIFS_INCLUDE "${UNIFS_ROOT}")
endif()

make_symlink("${UNIFS_INCLUDE}" "${CMAKE_BINARY_DIR}/include/UniFS")

