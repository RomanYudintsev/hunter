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
    unicore
    VERSION
    "0.0.1"
    URL
    "https://core.2gis.one/hunter/unicore-0.0.1.tar.bz2"
    SHA1
    8eb99e43d4478fb596d6f7079b197c86e13e980b
)


string(COMPARE EQUAL "${HUNTER_unicore_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(UNICORE_FROM_LOCAL 1)
  set(UNICORE_ROOT ${HUNTER_unicore_LOCAL_DIR})
  set(UNICORE_INCLUDE "${HUNTER_unicore_LOCAL_DIR}")
  get_filename_component(SUBDIRECTORY_ABS ${UNICORE_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_CURRENT_BINARY_DIR}/libs/unicore")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake) # use scheme for cmake projects

  hunter_cacheable(unicore)
  hunter_download(PACKAGE_NAME unicore)
  set(UNICORE_INCLUDE "${UNICORE_ROOT}/include/unicore")
endif()

make_symlink("${UNICORE_ROOT}" "${CMAKE_CURRENT_BINARY_DIR}/include/unicore")
