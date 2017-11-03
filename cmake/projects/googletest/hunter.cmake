# Copyright (c) 2013, Ruslan Baratov
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_version)
include(hunter_cacheable)
include(hunter_download)
include(hunter_pick_scheme)
include(hunter_cmake_args)
include(dg_make_symlink)

hunter_add_version(
    PACKAGE_NAME
    googletest
    VERSION
    1.8.0-hunter-p2
    URL
    "https://github.com/hunter-packages/googletest/archive/1.8.0-hunter-p2.tar.gz"
    SHA1
    93148cb8850abe78b76ed87158fdb6b9c48e38c4
)

hunter_add_version(
    PACKAGE_NAME
    googletest
    VERSION
    1.8.0-hunter-p5
    URL https://github.com/hunter-packages/googletest/archive/1.8.0-hunter-p5.tar.gz
    SHA1 3325aa4fc8b30e665c9f73a60f19387b7db36f85
)

hunter_add_version(
    PACKAGE_NAME
    googletest
    VERSION
    1.8.0-hunter-p6
    URL
    "https://github.com/hunter-packages/googletest/archive/1.8.0-hunter-p6.tar.gz"
    SHA1
    f57096bd01c6f8cbef043b312d4d1e82f29648b6
)

hunter_add_version(
    PACKAGE_NAME
    googletest
    VERSION
    1.8.0-hunter-p7
    URL
    "https://github.com/hunter-packages/googletest/archive/1.8.0-hunter-p7.tar.gz"
    SHA1
    4fe083a96d7597f7dce6f453dca01e1d94a1e45b
)

set(_gtest_license "googletest/LICENSE")

hunter_cmake_args(
    googletest
    CMAKE_ARGS
    HUNTER_INSTALL_LICENSE_FILES=${_gtest_license}
)

string(COMPARE EQUAL "${HUNTER_googletest_VERSION}" "FROM_LOCAL_PATH" test_hunter_package_version)

if(test_hunter_package_version)
  set(GOOGLETEST_FROM_LOCAL 1)
  set(GOOGLETEST_ROOT ${HUNTER_googletest_LOCAL_DIR})
  set(GOOGLETEST_INCLUDE "${HUNTER_googletest_LOCAL_DIR}/googletest/include/gtest")
else(test_hunter_package_version)
  hunter_pick_scheme(DEFAULT url_sha1_cmake)
  hunter_cacheable(googletest)
  hunter_download(PACKAGE_NAME googletest PACKAGE_INTERNAL_DEPS_ID 1)
endif()

make_symlink(${GOOGLETEST_INCLUDE} "${CMAKE_CURRENT_BINARY_DIR}/include/gtest")
