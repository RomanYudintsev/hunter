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

string(COMPARE EQUAL "${HUNTER_BoostStubAssertHandler_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(BOOSTSTUBASSERTHANDLER_FROM_LOCAL 1)
  set(BOOSTSTUBASSERTHANDLER_ROOT ${HUNTER_BoostStubAssertHandler_LOCAL_DIR})
  set(BOOSTSTUBASSERTHANDLER_INCLUDE "${HUNTER_BoostStubAssertHandler_LOCAL_DIR}")
  get_filename_component(SUBDIRECTORY_ABS ${BOOSTSTUBASSERTHANDLER_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_BINARY_DIR}/libs/BoostStubAssertHandler")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake) # use scheme for cmake projects

  hunter_cacheable(BoostStubAssertHandler)
  hunter_download(PACKAGE_NAME BoostStubAssertHandler)
  set(BOOSTSTUBASSERTHANDLER_INCLUDE "${BOOSTSTUBASSERTHANDLER_ROOT}/include/BoostStubAssertHandler")
endif()

make_symlink("${BOOSTSTUBASSERTHANDLER_ROOT}" "${CMAKE_BINARY_DIR}/include/BoostStubAssertHandler")
