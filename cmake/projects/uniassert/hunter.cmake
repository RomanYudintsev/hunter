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
    "0.0.1-draft"
    URL
    "https://core.2gis.one/hunter/uniassert-0.0.1.tar.bz2"
    SHA1
    70cf207e29ad1f2de3a0b946e5199fb2d250cf06
)

hunter_cmake_args(
    uniassert
)

message(STATUS ${HUNTER_uniassert_VERSION})
string(COMPARE EQUAL "${HUNTER_uniassert_VERSION}" "FROM_LOCAL_PATH" test_hunter_package_version)
message(STATUS "HUNTER_uniassert_LOCAL_DIR :: ${HUNTER_uniassert_LOCAL_DIR}")

if(test_hunter_package_version)
  set(UNIASSERT_ROOT ${HUNTER_uniassert_LOCAL_DIR})
else(test_hunter_package_version)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake) # use scheme for cmake projects

  hunter_cacheable(uniassert)
  hunter_download(PACKAGE_NAME uniassert)
endif()

make_symlink("${UNIASSERT_ROOT}" "${CMAKE_CURRENT_BINARY_DIR}/include/uniassert")
