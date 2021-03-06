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
    jsoncpp
    VERSION
    "0.6.0-rc2"
    URL
    "http://jenkins-clone.v4core.os-n3.hw:8081/repository/hunter-projects/jsoncpp-0.6.0-rc2.tar.bz2"
    SHA1
    3b86f0589c84dff5082454e2d539dce7bc65db86
)

hunter_add_version(
    PACKAGE_NAME
    jsoncpp
    VERSION
    "1.8.0"
    URL
    "https://github.com/open-source-parsers/jsoncpp/archive/1.8.0.tar.gz"
    SHA1
    40f7f34551012f68e822664a0b179e7e6cac5a97
)

hunter_add_version(
    PACKAGE_NAME
    jsoncpp
    VERSION
    "1.7.7"
    URL
    "https://github.com/open-source-parsers/jsoncpp/archive/1.7.7.tar.gz"
    SHA1
    7bbb47e25b3aa7c4c8b579ca46b32d55f32cb46e
)

hunter_add_version(
    PACKAGE_NAME
    jsoncpp
    VERSION
    "0.7.0"
    URL
    "https://github.com/open-source-parsers/jsoncpp/archive/0.7.0.tar.gz"
    SHA1
    4fcb0e3275a1391856fc6ae21e36dce866b19393
)

hunter_cmake_args(
    jsoncpp
    CMAKE_ARGS
        JSONCPP_WITH_TESTS=OFF
        JSONCPP_WITH_PKGCONFIG_SUPPORT=OFF
        JSONCPP_WITH_CMAKE_PACKAGE=ON
)

string(COMPARE EQUAL "${HUNTER_jsoncpp_VERSION}" "FROM_LOCAL_PATH" hunter_package_local)

if(hunter_package_local)
  set(JSONCPP_FROM_LOCAL 1)
  set(JSONCPP_ROOT ${HUNTER_jsoncpp_LOCAL_DIR})
  set(JSONCPP_INCLUDE "${HUNTER_jsoncpp_LOCAL_DIR}/include/json")
  get_filename_component(SUBDIRECTORY_ABS ${JSONCPP_ROOT} ABSOLUTE)
  file(RELATIVE_PATH FOLDER ${CMAKE_CURRENT_SOURCE_DIR} ${SUBDIRECTORY_ABS})
  add_subdirectory("${FOLDER}" "${CMAKE_BINARY_DIR}/libs/jsoncpp")
else(hunter_package_local)
  # Pick a download scheme
  hunter_pick_scheme(DEFAULT url_sha1_cmake) # use scheme for cmake projects

  hunter_cacheable(jsoncpp)
  hunter_download(PACKAGE_NAME jsoncpp)
  set(JSONCPP_INCLUDE "${JSONCPP_ROOT}/include/json")
endif()

make_symlink("${JSONCPP_INCLUDE}" "${CMAKE_BINARY_DIR}/include/jsoncpp/json")
