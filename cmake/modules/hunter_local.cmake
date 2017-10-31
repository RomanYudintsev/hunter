# Copyright (c) 2013-2017, Ruslan Baratov
# Copyright (c) 2015, Aaditya Kalsi
# All rights reserved.

include(CMakeParseArguments) # cmake_parse_arguments

include(hunter_create_args_file)
include(hunter_find_licenses)
include(hunter_find_stamps)
include(hunter_internal_error)
include(hunter_jobs_number)
include(hunter_load_from_cache)
include(hunter_print_cmd)
include(hunter_read_http_credentials)
include(hunter_register_dependency)
include(hunter_save_to_cache)
include(hunter_status_debug)
include(hunter_status_print)
include(hunter_test_string_not_empty)
include(hunter_user_error)

# Note: 'hunter_find_licenses' should be called before each return point
function(hunter_local)
  set(one PACKAGE_NAME PACKAGE_COMPONENT PACKAGE_INTERNAL_DEPS_ID PACKAGE_LOCAL_DIR)
  set(multiple PACKAGE_UNRELOCATABLE_TEXT_FILES)

  cmake_parse_arguments(HUNTER "" "${one}" "${multiple}" ${ARGV})
  # -> HUNTER_PACKAGE_NAME
  # -> HUNTER_PACKAGE_COMPONENT
  # -> HUNTER_PACKAGE_INTERNAL_DEPS_ID
  # -> PACKAGE_LOCAL_DIR
  # -> HUNTER_PACKAGE_UNRELOCATABLE_TEXT_FILES
  if(HUNTER_UNPARSED_ARGUMENTS)
    hunter_internal_error("Unparsed: ${HUNTER_UNPARSED_ARGUMENTS}")
  endif()

  get_cmake_property(_variableNames VARIABLES)
  foreach (_variableName ${_variableNames})
      message(STATUS "${_variableName}=${${_variableName}}")
  endforeach()

  hunter_test_string_not_empty("${HUNTER_SELF}")
  hunter_test_string_not_empty("${HUNTER_INSTALL_PREFIX}")
  hunter_test_string_not_empty("${HUNTER_PACKAGE_NAME}")

  string(COMPARE NOTEQUAL "${HUNTER_BINARY_DIR}" "" hunter_has_binary_dir)
  string(COMPARE NOTEQUAL "${HUNTER_PACKAGE_COMPONENT}" "" hunter_has_component)
  string(COMPARE NOTEQUAL "${CMAKE_TOOLCHAIN_FILE}" "" hunter_has_toolchain)
  string(
      COMPARE
      NOTEQUAL
      "${HUNTER_PACKAGE_INTERNAL_DEPS_ID}"
      ""
      has_internal_deps_id
  )
  string(
      COMPARE
      NOTEQUAL
      "${HUNTER_PACKAGE_UNRELOCATABLE_TEXT_FILES}"
      ""
      has_unrelocatable_text_files
  )

  if(hunter_has_component)
    set(HUNTER_EP_NAME "${HUNTER_PACKAGE_NAME}-${HUNTER_PACKAGE_COMPONENT}")
  else()
    set(HUNTER_EP_NAME "${HUNTER_PACKAGE_NAME}")
  endif()

  # Set <LIB>_ROOT variables
  set(h_name "${HUNTER_PACKAGE_NAME}") # Foo
  string(TOUPPER "${HUNTER_PACKAGE_NAME}" root_name) # FOO
  set(root_name "${root_name}_ROOT") # FOO_ROOT

  set(HUNTER_PACKAGE_VERSION "${HUNTER_${h_name}_VERSION}")
  set(ver "${HUNTER_PACKAGE_VERSION}")

  set(
      HUNTER_PACKAGE_CONFIGURATION_TYPES
      "${HUNTER_${h_name}_CONFIGURATION_TYPES}"
  )
  string(COMPARE EQUAL "${HUNTER_PACKAGE_CONFIGURATION_TYPES}" "" no_types)
  if(no_types)
    set(HUNTER_PACKAGE_CONFIGURATION_TYPES ${HUNTER_CACHED_CONFIGURATION_TYPES})
  endif()

  hunter_test_string_not_empty("${HUNTER_PACKAGE_CONFIGURATION_TYPES}")

  # Check that only one scheme is set to 1
  set(all_schemes "")
  set(all_schemes "${all_schemes}${HUNTER_PACKAGE_SCHEME_LOCAL_CMAKE}")

  string(COMPARE EQUAL "${all_schemes}" "1" is_good)
  if(NOT is_good)
    hunter_internal_error(
        "Incorrect schemes:"
        "  HUNTER_PACKAGE_SCHEME_LOCAL_CMAKE = ${HUNTER_PACKAGE_SCHEME_LOCAL_CMAKE}"
    )
  endif()



  # Set:
  #   * HUNTER_PACKAGE_SETUP_DIR
  #   * HUNTER_GLOBAL_SCRIPT_DIR
  #   * HUNTER_PACKAGE_SCRIPT_DIR
  #   * HUNTER_PACKAGE_SOURCE_DIR
  #   * HUNTER_PACKAGE_DONE_STAMP
  #   * HUNTER_PACKAGE_BUILD_DIR
  #   * HUNTER_PACKAGE_HOME_DIR
  set(HUNTER_PACKAGE_SETUP_DIR "${CMAKE_CURRENT_BINARY_DIR}/deps/${HUNTER_PACKAGE_NAME}")
  set(HUNTER_GLOBAL_SCRIPT_DIR "${HUNTER_SELF}/scripts")
  set(HUNTER_PACKAGE_SCRIPT_DIR "${HUNTER_PACKAGE_LOCAL_DIR}/scripts/")
  set(HUNTER_PACKAGE_SOURCE_DIR "${HUNTER_PACKAGE_LOCAL_DIR}")
  set(HUNTER_PACKAGE_HOME_DIR "${HUNTER_PACKAGE_SETUP_DIR}/Build")
  set(HUNTER_PACKAGE_INSTALL_PREFIX "${HUNTER_PACKAGE_HOME_DIR}/Install")
  set(HUNTER_PACKAGE_LICENSE_DIR "${HUNTER_PACKAGE_INSTALL_PREFIX}/licenses/${HUNTER_PACKAGE_NAME}")
  set(HUNTER_PACKAGE_LICENSE_SEARCH_DIR "${HUNTER_INSTALL_PREFIX}/licenses/${HUNTER_PACKAGE_NAME}")
  set(
      HUNTER_PACKAGE_HOME_DIR
      "${HUNTER_PACKAGE_HOME_DIR}/${HUNTER_PACKAGE_NAME}"
  )
  if(hunter_has_component)
    set(
        HUNTER_PACKAGE_HOME_DIR
        "${HUNTER_PACKAGE_HOME_DIR}/__${HUNTER_PACKAGE_COMPONENT}"
    )
  endif()
  if(hunter_has_binary_dir)
    set(
        HUNTER_PACKAGE_BUILD_DIR
        "${HUNTER_BINARY_DIR}/${HUNTER_PACKAGE_NAME}"
    )
    if(hunter_has_component)
      set(
          HUNTER_PACKAGE_BUILD_DIR
          "${HUNTER_PACKAGE_BUILD_DIR}/__${HUNTER_PACKAGE_COMPONENT}"
      )
    endif()
  else()
    set(HUNTER_PACKAGE_BUILD_DIR "${HUNTER_PACKAGE_HOME_DIR}/Build")
  endif()

  if(HUNTER_PACKAGE_SCHEME_LOCAL_CMAKE)
    set(${root_name} "${HUNTER_INSTALL_PREFIX}")
    hunter_status_debug("Install to: ${HUNTER_INSTALL_PREFIX}")
  else()
    hunter_internal_error("Invalid scheme")
  endif()

  set(${root_name} "${${root_name}}" PARENT_SCOPE)
  set(ENV{${root_name}} "${${root_name}}")
  hunter_status_print("${root_name}: ${${root_name}} (ver.: ${ver})")

  hunter_status_debug(
      "Default arguments: ${HUNTER_${h_name}_DEFAULT_CMAKE_ARGS}"
  )
  hunter_status_debug("User arguments: ${HUNTER_${h_name}_CMAKE_ARGS}")

  # Same for the "snake case"
  string(REPLACE "-" "_" snake_case_root_name "${root_name}")
  set(${snake_case_root_name} "${${root_name}}" PARENT_SCOPE)
  set(ENV{${snake_case_root_name}} "${${root_name}}")

  # temp toolchain file to set variables and include real toolchain
  set(HUNTER_DOWNLOAD_TOOLCHAIN "${HUNTER_PACKAGE_HOME_DIR}/toolchain.cmake")

  # separate file with build options
  set(HUNTER_ARGS_FILE "${HUNTER_PACKAGE_HOME_DIR}/args.cmake")

  # Registering dependency (before return!)
  # Note: there will be no dependency registration on cache run.
  # HUNTER_PARENT_PACKAGE set to empty string in 'hunter_cache_run'
  hunter_register_dependency(
      PACKAGE "${HUNTER_PARENT_PACKAGE}"
      DEPENDS_ON_PACKAGE "${HUNTER_PACKAGE_NAME}"
      DEPENDS_ON_COMPONENT "${HUNTER_PACKAGE_COMPONENT}"
  )

  if(EXISTS "${HUNTER_PACKAGE_DONE_STAMP}")
    hunter_status_debug("Package already installed: ${HUNTER_PACKAGE_NAME}")
    if(hunter_has_component)
      hunter_status_debug("Component: ${HUNTER_PACKAGE_COMPONENT}")
    endif()

    # In:
    # * HUNTER_PACKAGE_HOME_DIR
    # * HUNTER_PACKAGE_LICENSE_SEARCH_DIR
    # * HUNTER_PACKAGE_NAME
    # * HUNTER_PACKAGE_SCHEME_UNPACK
    # * HUNTER_PACKAGE_SHA1
    # Out:
    # * ${HUNTER_PACKAGE_NAME}_LICENSES (parent scope)
    hunter_find_licenses()

    return()
  endif()

  get_cmake_property(_variableNames VARIABLES)
  foreach (_variableName ${_variableNames})
      message(STATUS "${_variableName}=${${_variableName}}")
  endforeach()

  hunter_lock_directory(
      "${HUNTER_PACKAGE_LOCAL_DIR}" HUNTER_ALREADY_LOCKED_DIRECTORIES
  )
  if(hunter_has_binary_dir)
    hunter_lock_directory(
        "${HUNTER_BINARY_DIR}" HUNTER_ALREADY_LOCKED_DIRECTORIES
    )
  endif()
  if(hunter_lock_sources)
    hunter_lock_directory(
        "${hunter_lock_sources_dir}" HUNTER_ALREADY_LOCKED_DIRECTORIES
    )
  endif()

  # While locking other instance can finish package building
  if(EXISTS "${HUNTER_PACKAGE_DONE_STAMP}")
    hunter_status_debug("Package already installed: ${HUNTER_PACKAGE_NAME}")
    if(hunter_has_component)
      hunter_status_debug("Component: ${HUNTER_PACKAGE_COMPONENT}")
    endif()

    # In:
    # * HUNTER_PACKAGE_HOME_DIR
    # * HUNTER_PACKAGE_LICENSE_SEARCH_DIR
    # * HUNTER_PACKAGE_NAME
    # * HUNTER_PACKAGE_SCHEME_UNPACK
    # * HUNTER_PACKAGE_SHA1
    # Out:
    # * ${HUNTER_PACKAGE_NAME}_LICENSES (parent scope)
    hunter_find_licenses()

    return()
  endif()

  # load from cache using SHA1 of args.cmake file
  file(REMOVE "${HUNTER_ARGS_FILE}")
  hunter_create_args_file(
      "${HUNTER_${h_name}_DEFAULT_CMAKE_ARGS};${HUNTER_${h_name}_CMAKE_ARGS}"
      "${HUNTER_ARGS_FILE}"
  )

  file(REMOVE_RECURSE "${HUNTER_PACKAGE_BUILD_DIR}")
  file(REMOVE "${HUNTER_PACKAGE_HOME_DIR}/CMakeLists.txt")
  file(REMOVE "${HUNTER_DOWNLOAD_TOOLCHAIN}")

  file(WRITE "${HUNTER_DOWNLOAD_TOOLCHAIN}" "")

  hunter_jobs_number(HUNTER_JOBS_OPTION "${HUNTER_DOWNLOAD_TOOLCHAIN}")
  hunter_status_debug("HUNTER_JOBS_NUMBER: ${HUNTER_JOBS_NUMBER}")
  hunter_status_debug("HUNTER_JOBS_OPTION: ${HUNTER_JOBS_OPTION}")

  # support for toolchain file forwarding
  if(hunter_has_toolchain)
    # Fix windows path
    get_filename_component(x "${CMAKE_TOOLCHAIN_FILE}" ABSOLUTE)
    file(APPEND "${HUNTER_DOWNLOAD_TOOLCHAIN}" "include(\"${x}\")\n")
  endif()

  # After toolchain! (toolchain may already have this variables)
  file(
      APPEND
      "${HUNTER_DOWNLOAD_TOOLCHAIN}"
      "set(HUNTER_PARENT_PACKAGE \"${HUNTER_PACKAGE_NAME};${HUNTER_PACKAGE_COMPONENT}\" CACHE INTERNAL \"\")\n"
  )
  file(
      APPEND
      "${HUNTER_DOWNLOAD_TOOLCHAIN}"
      "set(HUNTER_ALREADY_LOCKED_DIRECTORIES \"${HUNTER_ALREADY_LOCKED_DIRECTORIES}\" CACHE INTERNAL \"\")\n"
  )
  file(
      APPEND
      "${HUNTER_DOWNLOAD_TOOLCHAIN}"
      "set(HUNTER_DISABLE_BUILDS \"${HUNTER_DISABLE_BUILDS}\" CACHE INTERNAL \"\")\n"
  )
  file(
      APPEND
      "${HUNTER_DOWNLOAD_TOOLCHAIN}"
      "set(HUNTER_USE_CACHE_SERVERS \"${HUNTER_USE_CACHE_SERVERS}\" CACHE INTERNAL \"\")\n"
  )
  file(
      APPEND
      "${HUNTER_DOWNLOAD_TOOLCHAIN}"
      "list(APPEND HUNTER_CACHE_SERVERS ${HUNTER_CACHE_SERVERS})\n"
  )
  file(
      APPEND
      "${HUNTER_DOWNLOAD_TOOLCHAIN}"
      "set(HUNTER_PASSWORDS_PATH \"${HUNTER_PASSWORDS_PATH}\" CACHE INTERNAL \"\")\n"
  )
  file(
      APPEND
      "${HUNTER_DOWNLOAD_TOOLCHAIN}"
      "set(HUNTER_KEEP_PACKAGE_SOURCES \"${HUNTER_KEEP_PACKAGE_SOURCES}\" CACHE INTERNAL \"\")\n"
  )
  file(
      APPEND
      "${HUNTER_DOWNLOAD_TOOLCHAIN}"
      "set(HUNTER_SUPPRESS_LIST_OF_FILES \"${HUNTER_SUPPRESS_LIST_OF_FILES}\" CACHE INTERNAL \"\")\n"
  )

  string(COMPARE NOTEQUAL "${CMAKE_MAKE_PROGRAM}" "" has_make)
  if(has_make)
    file(
        APPEND
        "${HUNTER_DOWNLOAD_TOOLCHAIN}"
        "set(CMAKE_MAKE_PROGRAM \"${CMAKE_MAKE_PROGRAM}\" CACHE INTERNAL \"\")\n"
    )
  endif()

  if(hunter_no_url)
    set(avail ${HUNTER_${h_name}_VERSIONS})
    hunter_internal_error(
        "${h_name} version(${ver}) not found. Available: [${avail}]"
    )
  endif()

  # print info before start generation/run
  hunter_status_debug("Add package: ${HUNTER_PACKAGE_NAME}")
  if(hunter_has_component)
    hunter_status_debug("Component: ${HUNTER_PACKAGE_COMPONENT}")
  endif()
  if(HUNTER_PACKAGE_SCHEME_INSTALL)
    hunter_status_debug(
        "Configuration types: ${HUNTER_PACKAGE_CONFIGURATION_TYPES}"
    )
  endif()

  if(has_internal_deps_id)
    hunter_status_debug(
        "Internal dependencies ID: ${HUNTER_PACKAGE_INTERNAL_DEPS_ID}"
    )
  endif()

  set(_hunter_schemes_search_dirs "")

  set(
      download_scheme
      "${HUNTER_PACKAGE_SETUP_DIR}/schemes/${HUNTER_DOWNLOAD_SCHEME}.cmake.in"
  )
  set(_hunter_schemes_search_dirs "${_hunter_schemes_search_dirs}, ${download_scheme}")

  if(NOT EXISTS "${download_scheme}")
    set(
      download_scheme
      "${HUNTER_SELF}/cmake/schemes/${HUNTER_DOWNLOAD_SCHEME}.cmake.in"
    )
    set(_hunter_schemes_search_dirs "${_hunter_schemes_search_dirs}, ${download_scheme}")
    if(NOT EXISTS "${download_scheme}")
      hunter_internal_error("Download scheme `${download_scheme}` not found. Search locations: ${_hunter_schemes_search_dirs}")
    endif()
  endif()

  hunter_status_debug(
      "Scheme file used: ${download_scheme}"
  )

  configure_file(
      "${download_scheme}"
      "${HUNTER_PACKAGE_HOME_DIR}/CMakeLists.txt"
      @ONLY
  )

  set(build_message "Building ${HUNTER_PACKAGE_NAME}")
  if(hunter_has_component)
    set(
        build_message
        "${build_message} (component: ${HUNTER_PACKAGE_COMPONENT})"
    )
  endif()
  hunter_status_print("${build_message}")

  set(allow_builds TRUE)
  if(HUNTER_DISABLE_BUILDS)
    set(allow_builds FALSE)
  endif()
  string(COMPARE EQUAL "${HUNTER_USE_CACHE_SERVERS}" "ONLY" only_server)
  if(only_server)
    set(allow_builds FALSE)
  endif()

  # Always allow builds of submodules
  get_property(submodule_projects GLOBAL PROPERTY HUNTER_SUBMODULE_PROJECTS)
  if(submodule_projects)
    list(FIND submodule_projects "${HUNTER_PACKAGE_NAME}" submodule_found)
    if(NOT submodule_found EQUAL -1)
      set(allow_builds TRUE)
      if(hunter_has_component)
        hunter_internal_error("Submodule with components")
      endif()
    endif()
  endif()

  if(NOT allow_builds AND HUNTER_PACKAGE_SCHEME_INSTALL)
    hunter_fatal_error(
        "Building package from source is disabled (dir: ${HUNTER_PACKAGE_HOME_DIR})"
        WIKI "error.build.disabled"
    )
  endif()

  if(HUNTER_STATUS_DEBUG)
    set(logging_params "")
  elseif(HUNTER_STATUS_PRINT)
    set(logging_params "")
  else()
    set(logging_params "OUTPUT_QUIET")
  endif()

  set(
      cmd
      "${CMAKE_COMMAND}"
      "-C${HUNTER_ARGS_FILE}" # After cache (high priority for user's variable)
      "-H${HUNTER_PACKAGE_HOME_DIR}"
      "-B${HUNTER_PACKAGE_BUILD_DIR}"
      "-DCMAKE_TOOLCHAIN_FILE=${HUNTER_DOWNLOAD_TOOLCHAIN}"
      "-G${CMAKE_GENERATOR}"
  )
  string(COMPARE NOTEQUAL "${CMAKE_GENERATOR_TOOLSET}" "" has_toolset)
  if(has_toolset)
    list(APPEND cmd "-T" "${CMAKE_GENERATOR_TOOLSET}")
  endif()

  if(has_make)
    list(APPEND cmd "-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}")
  endif()

  string(COMPARE NOTEQUAL "${CMAKE_GENERATOR_PLATFORM}" "" has_gen_platform)
  if(has_gen_platform)
    list(APPEND cmd "-A" "${CMAKE_GENERATOR_PLATFORM}")
  endif()

  hunter_print_cmd("${HUNTER_PACKAGE_HOME_DIR}" "${cmd}")

  # Configure and build downloaded project
  execute_process(
      COMMAND ${cmd}
      WORKING_DIRECTORY "${HUNTER_PACKAGE_HOME_DIR}"
      RESULT_VARIABLE generate_result
      ${logging_params}
  )

  if(generate_result EQUAL 0)
    hunter_status_debug(
        "Configure step successful (dir: ${HUNTER_PACKAGE_HOME_DIR})"
    )
  else()
    hunter_fatal_error(
        "Configure step failed (dir: ${HUNTER_PACKAGE_HOME_DIR})"
        WIKI "error.external.build.failed"
    )
  endif()

  set(
      cmd
      "${CMAKE_COMMAND}"
      --build
      "${HUNTER_PACKAGE_BUILD_DIR}"
  )
  hunter_print_cmd("${HUNTER_PACKAGE_HOME_DIR}" "${cmd}")

  execute_process(
      COMMAND ${cmd}
      WORKING_DIRECTORY "${HUNTER_PACKAGE_HOME_DIR}"
      RESULT_VARIABLE build_result
      ${logging_params}
  )

  if(build_result EQUAL 0)
    hunter_status_print(
        "Build step successful (dir: ${HUNTER_PACKAGE_HOME_DIR})"
    )
  else()
    hunter_fatal_error(
        "Build step failed (dir: ${HUNTER_PACKAGE_HOME_DIR}"
        WIKI "error.external.build.failed"
    )
  endif()

  if(HUNTER_PACKAGE_SCHEME_DOWNLOAD)
    # This scheme not using ExternalProject_Add so there will be no stamps
  else()
    hunter_find_stamps("${HUNTER_PACKAGE_BUILD_DIR}")
  endif()

  hunter_status_debug("Cleaning up build directories...")

  file(REMOVE_RECURSE "${HUNTER_PACKAGE_BUILD_DIR}")

  file(REMOVE "${HUNTER_PACKAGE_HOME_DIR}/CMakeLists.txt")
  file(REMOVE "${HUNTER_DOWNLOAD_TOOLCHAIN}")
  file(REMOVE "${HUNTER_ARGS_FILE}")

  hunter_status_debug("Clean up done")

  file(WRITE "${HUNTER_PACKAGE_DONE_STAMP}" "")

  # In:
  # * HUNTER_PACKAGE_HOME_DIR
  # * HUNTER_PACKAGE_LICENSE_SEARCH_DIR
  # * HUNTER_PACKAGE_NAME
  # * HUNTER_PACKAGE_SCHEME_UNPACK
  # * HUNTER_PACKAGE_SHA1
  # Out:
  # * ${HUNTER_PACKAGE_NAME}_LICENSES (parent scope)
  hunter_find_licenses()
endfunction()
