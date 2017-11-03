# make_symlink(srcdirectory destinationdirectory)
#
#
#TODO Добавить описание
function(make_symlink SRCDIRECTORY DSTDIRECTORY)
    message (STATUS "test")
    
	message(STATUS "${DSTDIRECTORY}")
    get_filename_component(SRCDIRECTORY_ABS ${SRCDIRECTORY} ABSOLUTE)
    get_filename_component(DSTDIRECTORY_ABS ${DSTDIRECTORY} ABSOLUTE)
    file(TO_NATIVE_PATH "${SRCDIRECTORY_ABS}" SRCDIRECTORY_NATIVE)
	file(TO_NATIVE_PATH "${DSTDIRECTORY_ABS}" DSTDIRECTORY_NATIVE)

	file(REMOVE_RECURSE "${DSTDIRECTORY_ABS}")
	file(MAKE_DIRECTORY "${DSTDIRECTORY_ABS}")
	file(REMOVE_RECURSE "${DSTDIRECTORY_ABS}")

    message(STATUS WIN32)
    if (WIN32)
        set (LINKS_COMMAND cmd /c mklink /j)
    else(WIN32)
        set (LINKS_COMMAND "")
    endif()

    message(STATUS "call now --> " ${LINKS_COMMAND} ${DSTDIRECTORY_NATIVE} ${SRCDIRECTORY_NATIVE})
    execute_process(COMMAND ${LINKS_COMMAND} "${DSTDIRECTORY_NATIVE}" "${SRCDIRECTORY_NATIVE}" RESULT_VARIABLE MKLINK_RESULT OUTPUT_VARIABLE MKLINK_OUTPUT)
	message(STATUS "-->> MKLINK_OUTPUT :: ${MKLINK_OUTPUT}")
	message(STATUS "-->> MKLINK_RESULT :: ${MKLINK_RESULT}")
endfunction()