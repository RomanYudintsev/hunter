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

  find_package(Git)
  if(${GIT_EXECUTABLE} AND GIT_VERSION_STRING VERSION_LESS "2.5.0")
    hunter_status_debug("Using git executable: ${GIT_EXECUTABLE}")

    set(cmd "${GIT_EXECUTABLE}" status -- .)
    execute_process(
        COMMAND ${cmd}
        WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
        RESULT_VARIABLE result
        OUTPUT_VARIABLE output
        ERROR_VARIABLE error
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )

    if(NOT result EQUAL 0)
        hunter_internal_error(
          "Command failed: ${cmd} (${result}, ${output}, ${error})"
        )
    endif()
  endif()

  set("${x_VERSION}" "MAY_BE_LOCAL" PARENT_SCOPE)
endfunction()
