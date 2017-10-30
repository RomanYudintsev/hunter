include(CMakeParseArguments) # cmake_parse_arguments

include(hunter_internal_error)
include(hunter_status_debug)

set(_HUNTER_TEMPLATE_SCHEME_DIR "${CMAKE_CURRENT_LIST_DIR}/../templates")

function(hunter_pack_local_dir)
  set(PACKAGE_NAME "${_hunter_current_project}")
  string(COMPARE EQUAL "${PACKAGE_NAME}" "" is_empty)
  if(is_empty)
    hunter_internal_error("_hunter_current_project is empty")
  endif()

  set(optional "")
  set(one LOCAL_DIR PROJECT_FILE VERSION)
  set(multiple "")

  # Introduce:
  # * x_LOCAL_DIR
  # * x_PROJECT_FILE
  # * x_VERSION
  cmake_parse_arguments(x "${optional}" "${one}" "${multiple}" "${ARGV}")

  string(COMPARE NOTEQUAL "${x_UNPARSED_ARGUMENTS}" "" has_unparsed)
  if(has_unparsed)
    hunter_internal_error("Unparsed arguments: ${x_UNPARSED_ARGUMENTS}")
  endif()

  string(COMPARE EQUAL "${x_LOCAL_DIR}" "" is_empty)
  if(is_empty)
    hunter_internal_error("LOCAL_DIR is empty")
  endif()

  set(archives_directory "${CMAKE_CURRENT_BINARY_DIR}/_locals/Hunter/archives")
  set(archive "${archives_directory}/${PACKAGE_NAME}.tar.bz2")

  hunter_status_debug("Creating archive '${archive}'")
  hunter_pack_directory( "${LOCAL_DIR}" "${archives_directory}" archive_sha1)

  file(RENAME "${archives_directory}/cache.tar.bz2" "${archive}")

  set(version_file "${archives_directory}/${PACKAGE_NAME}-version.cmake")
  set(download_file "${archives_directory}/${PACKAGE_NAME}-download.cmake")

  file(SHA1 "${archive}" PACKAGE_SHA1)
  set(PACKAGE_URL "file://${archive}")

  # Use:
  # * PACKAGE_NAME
  configure_file(
      "${_HUNTER_TEMPLATE_SCHEME_DIR}/package-download.cmake.in"
      "${download_file}"
      @ONLY
  )

  # Use:
  # * PACKAGE_NAME
  # * PACKAGE_SHA1
  # * PACKAGE_URL
  configure_file(
      "${_HUNTER_TEMPLATE_SCHEME_DIR}/package-version.cmake.in"
      "${version_file}"
      @ONLY
  )

  set("${x_VERSION}" "${PACKAGE_SHA1}" PARENT_SCOPE)
endfunction()
