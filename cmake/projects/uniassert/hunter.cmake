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
    uniassert
    VERSION
    "0.0.1-draft"
    URL
    "https://core.2gis.one/hunter/uniassert-0.0.1-draft.tar.bz2"
    SHA1
    a78cabff03a17b257e2217a504c3e45318a0122e
)

hunter_add_version(
    PACKAGE_NAME
    uniassert
    VERSION
    "0.0.1"
    URL
    "https://core.2gis.one/hunter/uniassert-0.0.1.tar.bz2"
    SHA1
    5c210a019141a50fe90b6893969ede90fb1b56b1
)

hunter_add_version(
    PACKAGE_NAME
    uniassert
    VERSION
    "0.0.2"
    URL
    "https://core.2gis.one/hunter/uniassert-0.0.2.tar.bz2"
    SHA1
    e593e9935f3c764d53e56e4b61e93a13b516aa5f
)

string(COMPARE EQUAL "${HUNTER_uniassert_VERSION}" "FROM_LOCAL_PATH" hunter_package_version)

if(hunter_package_version)
  set(UNIASSERT_FROM_LOCAL 1)
  set(UNIASSERT_ROOT ${HUNTER_uniassert_LOCAL_DIR})
  set(UNIASSERT_INCLUDE "${HUNTER_uniassert_LOCAL_DIR}")
  get_filename_component(SUBDIRECTORY_ABS ${UNIASSERT_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_CURRENT_BINARY_DIR}/libs/uniassert")
  add_library(GTest::gtest ALIAS gtest )
else(test_hunter_package_version)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake) # use scheme for cmake projects

  hunter_cacheable(uniassert)
  hunter_download(PACKAGE_NAME uniassert)
  set(UNIASSERT_INCLUDE "${UNIASSERT_ROOT}/include/uniassert")
endif()

make_symlink("${UNIASSERT_ROOT}" "${CMAKE_CURRENT_BINARY_DIR}/include/uniassert")
