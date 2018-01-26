# Copyright (c) 2014-2015, Ruslan Baratov
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_version)
include(hunter_cacheable)
include(hunter_download)
include(hunter_local)
include(hunter_pick_scheme)
include(hunter_cmake_args)

hunter_add_version(
    PACKAGE_NAME
    ZLib
    VERSION
    "1.2.8-p3"
    URL
    "https://github.com/hunter-packages/zlib/archive/v1.2.8-p3.tar.gz"
    SHA1
    573dc28474be47d0c7abc1475a14aa12f0dfcadc
)

hunter_add_version(
    PACKAGE_NAME
    ZLib
    VERSION
    "1.2.8-p2"
    URL
    "https://github.com/hunter-packages/zlib/archive/v1.2.8-p2.tar.gz"
    SHA1
    bef3ee6d68a271dfcd2f659c80d721d4a6b39315
)

hunter_add_version(
    PACKAGE_NAME
    ZLib
    VERSION
    "1.2.8-hunter-1"
    URL
    "https://github.com/hunter-packages/zlib/archive/v1.2.8-hunter-1.tar.gz"
    SHA1
    24c89e4b193a56bb411fa9878968002ebe2c6209
)

hunter_add_version(
    PACKAGE_NAME
    ZLib
    VERSION
    "1.2.8-hunter"
    URL
    "https://github.com/hunter-packages/zlib/archive/v1.2.8-hunter.tar.gz"
    SHA1
    75a05fcc928ed52e1eeb93f07a1c78a7890860c0
)

string(COMPARE EQUAL "${HUNTER_ZLib_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(ZLIB_FROM_LOCAL 1)
  set(ZLIB_ROOT ${HUNTER_ZLib_LOCAL_DIR})
  set(ZLIB_INCLUDE "${HUNTER_ZLib_LOCAL_DIR}")
  get_filename_component(SUBDIRECTORY_ABS ${ZLIB_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_BINARY_DIR}/libs/ZLib")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake)
  hunter_cacheable(ZLib)
  hunter_download(PACKAGE_NAME ZLib)
  set(ZLIB_INCLUDE "${ZLIB_ROOT}")
endif()

make_symlink("${ZLIB_INCLUDE}" "${CMAKE_BINARY_DIR}/include/ZLib")

