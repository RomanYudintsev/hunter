# cmake/projects/jsoncpp/hunter.cmake

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

# Load used modules
include(hunter_add_version)
include(hunter_cacheable)
include(hunter_download)
include(hunter_local)
include(hunter_pick_scheme)
include(hunter_cmake_args)

# List of versions:

hunter_add_version(
    PACKAGE_NAME
    tp_util
    VERSION
    "0.0.1"
    URL
    "https://core.2gis.one/hunter/tp_util-0.0.1.tar.bz2"
    SHA1
    f8fec8d5bf11a0d7b52545b43080c8a0b936aa41
)


string(COMPARE EQUAL "${HUNTER_tp_util_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(TP_UTIL_FROM_LOCAL 1)
  set(TP_UTIL_ROOT ${HUNTER_tp_util_LOCAL_DIR})
  set(TP_UTIL_INCLUDE "${HUNTER_tp_util_LOCAL_DIR}")
  get_filename_component(SUBDIRECTORY_ABS ${TP_UTIL_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_CURRENT_BINARY_DIR}/libs/tp_util")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake) # use scheme for cmake projects

  hunter_cacheable(tp_util)
  hunter_download(PACKAGE_NAME tp_util)
  set(TP_UTIL_INCLUDE "${TP_UTIL_ROOT}/include/tp_util")
endif()

make_symlink("${TP_UTIL_ROOT}" "${CMAKE_CURRENT_BINARY_DIR}/include/tp_util")
