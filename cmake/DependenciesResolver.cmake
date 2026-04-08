# Find or download dependencies.
#
# Utility to try to find a package, or downloaad it, configure it, and install it inside
# the build tree.
# Based and fetch content, it avoids using `add_subdirectory` which exposes other project
# targets and errors as part of this project.

# Avoid warning about DOWNLOAD_EXTRACT_TIMESTAMP in CMake 3.24:
if (CMAKE_VERSION VERSION_GREATER_EQUAL "3.24.0")
	cmake_policy(SET CMP0135 NEW)
endif()
if(POLICY CMP0169)
	cmake_policy(SET CMP0169 OLD)
endif()

include(FetchContent)


# Where downloaded dependencies will be installed (in the build tree by default).
set(FETCHCONTENT_INSTALL_DIR "${FETCHCONTENT_BASE_DIR}/local")
option(ECOLE_FORCE_DOWNLOAD "Don't look for dependencies locally, rather always download them." OFF)


# Execute command at comfigure time and handle errors and output.
function(execute_process_handle_output)
	execute_process(
		${ARGV}
		RESULT_VARIABLE ERROR
		OUTPUT_VARIABLE STD_OUT
		ERROR_VARIABLE STD_ERR
	)
	if(ERROR)
		message(FATAL_ERROR "${STD_OUT} ${STD_ERR}")
	else()
		message(DEBUG "${STD_OUT}")
	endif()
endfunction()


# Configure, build and install the a CMake project
#
# The source of the project must have been made available prior to calling this function.
function(build_package)
	set(options)
	set(oneValueArgs SOURCE_DIR BUILD_DIR INSTALL_DIR)
	set(multiValueArgs CONFIGURE_ARGS)
	cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

	set(dep_cmake_prefix_path "${ARG_INSTALL_DIR}")
	if(CMAKE_PREFIX_PATH)
		list(APPEND dep_cmake_prefix_path ${CMAKE_PREFIX_PATH})
	endif()
	list(JOIN dep_cmake_prefix_path ";" dep_cmake_prefix_path)

	set(dep_forwarded_args)
	if(DEFINED Python_EXECUTABLE)
		list(APPEND dep_forwarded_args -D "Python_EXECUTABLE=${Python_EXECUTABLE}")
	endif()
	if(DEFINED PYTHON_EXECUTABLE)
		list(APPEND dep_forwarded_args -D "PYTHON_EXECUTABLE=${PYTHON_EXECUTABLE}")
	endif()
	if(DEFINED pybind11_DIR)
		list(APPEND dep_forwarded_args -D "pybind11_DIR=${pybind11_DIR}")
	endif()
	if(DEFINED Python_NumPy_INCLUDE_DIRS)
		list(JOIN Python_NumPy_INCLUDE_DIRS ";" dep_numpy_include_dirs)
	elseif(DEFINED Python_EXECUTABLE)
		execute_process(
			COMMAND "${Python_EXECUTABLE}" -c "import numpy; print(numpy.get_include())"
			RESULT_VARIABLE dep_numpy_error
			OUTPUT_VARIABLE dep_numpy_include_dirs
			ERROR_QUIET
			OUTPUT_STRIP_TRAILING_WHITESPACE
		)
		if(dep_numpy_error)
			unset(dep_numpy_include_dirs)
		endif()
	endif()
	if(DEFINED dep_numpy_include_dirs AND NOT dep_numpy_include_dirs STREQUAL "")
		list(APPEND dep_forwarded_args -D "NUMPY_INCLUDE_DIRS=${dep_numpy_include_dirs}")
	endif()

	message(DEBUG "${CMAKE_COMMAND}" -S "${ARG_SOURCE_DIR}" -B "${ARG_BUILD_DIR}" ${ARG_CONFIGURE_ARGS})
	execute_process_handle_output(
		COMMAND
			"${CMAKE_COMMAND}"
			-S "${ARG_SOURCE_DIR}"
			-B "${ARG_BUILD_DIR}"
			-G "${CMAKE_GENERATOR}"
			-D "CMAKE_PREFIX_PATH=${dep_cmake_prefix_path}"
			${dep_forwarded_args}
			${ARG_CONFIGURE_ARGS}
	)
	execute_process_handle_output(COMMAND "${CMAKE_COMMAND}" --build "${ARG_BUILD_DIR}" --parallel)
	execute_process_handle_output(COMMAND "${CMAKE_COMMAND}" --install "${ARG_BUILD_DIR}" --prefix "${ARG_INSTALL_DIR}")
endfunction()


# Try to find a package or downloads it at configure time.
#
# Use FetchContent to download a package if it was not found and build it inside the build tree.
# This is a macro so that find_package can export variables in the parent scope.
macro(find_or_download_package)
	set(options)
	set(oneValueArgs NAME URL URL_HASH)
	set(multiValueArgs CONFIGURE_ARGS)
	cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

	if(NOT ${ARG_NAME}_FOUND)
		if(NOT ECOLE_FORCE_DOWNLOAD)
			find_package(${ARG_NAME} QUIET)
		endif()

		if(${ARG_NAME}_FOUND)
			message(STATUS "Found ${ARG_NAME}")
		else()
			FetchContent_Declare(
				${ARG_NAME}
				URL ${ARG_URL}
				URL_HASH ${ARG_URL_HASH}
			)
			FetchContent_GetProperties(${ARG_NAME})
			if(NOT ${ARG_NAME}_POPULATED)
				message(STATUS "Downloading ${ARG_NAME}")
				FetchContent_Populate(${ARG_NAME})
				message(STATUS "Building ${ARG_NAME}")
				# FetchContent_Populate uses lower case name of FetchContent_Declare for directories
				string(TOLOWER "${ARG_NAME}" ARG_NAME_LOWER)
				build_package(
					CONFIGURE_ARGS ${ARG_CONFIGURE_ARGS}
					SOURCE_DIR "${${ARG_NAME_LOWER}_SOURCE_DIR}"
					BUILD_DIR "${${ARG_NAME_LOWER}_BINARY_DIR}"
					INSTALL_DIR "${FETCHCONTENT_INSTALL_DIR}"
				)
				find_package(${ARG_NAME} PATHS "${FETCHCONTENT_INSTALL_DIR}" NO_DEFAULT_PATH QUIET)
			endif()
		endif()
	endif()
endmacro()
