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

string(COMPARE EQUAL "${HUNTER_GTestExt_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(GTESTEXT_FROM_LOCAL 1)
  set(GTESTEXT_ROOT ${HUNTER_GTestExt_LOCAL_DIR})
  set(GTESTEXT_INCLUDE "${HUNTER_GTestExt_LOCAL_DIR}")
  get_filename_component(SUBDIRECTORY_ABS ${GTESTEXT_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_BINARY_DIR}/libs/GTestExt")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake) # use scheme for cmake projects

  hunter_cacheable(GTestExt)
  hunter_download(PACKAGE_NAME GTestExt)
  set(GTESTEXT_INCLUDE "${GTESTEXT_ROOT}/include/GTestExt")
endif()

make_symlink("${GTESTEXT_ROOT}" "${CMAKE_BINARY_DIR}/include/GTestExt")
