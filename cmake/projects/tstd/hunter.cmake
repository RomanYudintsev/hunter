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
    tstd
    VERSION
    "0.0.1"
    URL
    "https://core.2gis.one/hunter/tstd-0.0.1.tar.bz2"
    SHA1
    5f780366c653d9bf2bfda9ba790bffd13e67a337
)


string(COMPARE EQUAL "${HUNTER_tstd_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(TSTD_FROM_LOCAL 1)
  set(TSTD_ROOT ${HUNTER_tstd_LOCAL_DIR})
  set(TSTD_INCLUDE "${HUNTER_tstd_LOCAL_DIR}")
  get_filename_component(SUBDIRECTORY_ABS ${TSTD_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_BINARY_DIR}/libs/tstd")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake) # use scheme for cmake projects

  hunter_cacheable(tstd)
  hunter_download(PACKAGE_NAME tstd)
  set(TSTD_INCLUDE "${TSTD_ROOT}/include/tstd")
endif()

make_symlink("${TSTD_ROOT}" "${CMAKE_BINARY_DIR}/include/tstd")
