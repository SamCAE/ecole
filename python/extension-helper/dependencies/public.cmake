find_package(Python COMPONENTS Interpreter Development NumPy REQUIRED)

if(CMAKE_VERSION VERSION_GREATER_EQUAL "3.24.0")
	cmake_policy(SET CMP0135 NEW)
endif()
if(POLICY CMP0169)
	cmake_policy(SET CMP0169 OLD)
endif()

find_or_download_package(
	NAME pybind11
	URL https://github.com/pybind/pybind11/archive/v3.0.3.tar.gz
	URL_HASH SHA256=787459e1e186ee82001759508fefa408373eae8a076ffe0078b126c6f8f0ec5e
	CONFIGURE_ARGS
		-D PYBIND11_TEST=OFF
		-D "Python_EXECUTABLE=${Python_EXECUTABLE}"
		-D "PYTHON_EXECUTABLE=${Python_EXECUTABLE}"
)

find_package(xtensor-python QUIET)

if(NOT TARGET xtensor-python)
	execute_process(
		COMMAND "${Python_EXECUTABLE}" -c "import numpy; print(numpy.get_include())"
		RESULT_VARIABLE xtensor_python_numpy_error
		OUTPUT_VARIABLE xtensor_python_numpy_include
		OUTPUT_STRIP_TRAILING_WHITESPACE
	)
	if(xtensor_python_numpy_error)
		message(FATAL_ERROR "Failed to locate NumPy include path with ${Python_EXECUTABLE}.")
	endif()

	FetchContent_Declare(
		xtensor-python
		URL https://github.com/xtensor-stack/xtensor-python/archive/0.29.0.tar.gz
		URL_HASH SHA256=2915b220bd11b70fdd9fbb2db5f313e751189fec083e406228c8e5a31dfaa4a2
	)
	FetchContent_GetProperties(xtensor-python)
	if(NOT xtensor-python_POPULATED)
		message(STATUS "Downloading xtensor-python")
		FetchContent_Populate(xtensor-python)
		message(STATUS "Building xtensor-python")
		build_package(
			CONFIGURE_ARGS
				-D BUILD_TESTS=OFF
				-D "NUMPY_INCLUDE_DIRS=${xtensor_python_numpy_include}"
				-D "Python_EXECUTABLE=${Python_EXECUTABLE}"
				-D "PYTHON_EXECUTABLE=${Python_EXECUTABLE}"
			SOURCE_DIR "${xtensor-python_SOURCE_DIR}"
			BUILD_DIR "${xtensor-python_BINARY_DIR}"
			INSTALL_DIR "${FETCHCONTENT_INSTALL_DIR}"
		)
		find_package(xtensor-python PATHS "${FETCHCONTENT_INSTALL_DIR}" NO_DEFAULT_PATH QUIET)
	endif()
endif()
