cmake_minimum_required(VERSION 3.16)

# Adapt compiler flags if using Conda compiler packages. Before project so they are not modified.
include(cmake/Conda.cmake)

# Make packages installed in the active conda environment discoverable by CMake and nested
# dependency builds. SCIP's exported config depends on GMP, which is typically located in
# the same prefix.
if(DEFINED ENV{CONDA_PREFIX})
	list(PREPEND CMAKE_PREFIX_PATH "$ENV{CONDA_PREFIX}")
	if(NOT DEFINED GMP_DIR)
		set(GMP_DIR "$ENV{CONDA_PREFIX}" CACHE PATH "Path to a GMP installation.")
	endif()
endif()

# Read the version from file
include(cmake/Version.cmake)
read_version("VERSION" Ecole_VERSION)

# Set default parameters. Assumes Ecole user,
include(cmake/DefaultSettings.cmake)

project(
	Ecole
	VERSION "${Ecole_VERSION}"
	LANGUAGES CXX
	DESCRIPTION "Extensible Combinatorial Optimization Learning Environments"
)

# Add option to enable interprocedural optimization
include(cmake/InterproceduralOptimization.cmake)

# Define a target Ecole::warnings with all compiler warnings.
include(cmake/CompilerWarnings.cmake)

# Define a target Ecole::sanitizers with enabled sanitizers.
include(cmake/Sanitizers.cmake)

# Define a target Ecole::coverage with coverage options.
include(cmake/Coverage.cmake)

# Utilities to automatically download missing dependencies
include(cmake/DependenciesResolver.cmake)

# Adapt which Python is found
include(cmake/Python.cmake)

# Enable CTest for registering tests
include(CTest)

# Ecole library
if(ECOLE_BUILD_LIB)
	# Build the Ecole library
	add_subdirectory(libecole)
else()
	# Find the Ecole library of same version already installed
	option(ECOLE_DOWNLOAD_DEPENDENCIES "Download the static and header libraries used in Ecole public interface" ON)
	find_package(Ecole ${Ecole_VERSION} EXACT REQUIRED)
endif()

# Ecole Python extension
if(ECOLE_BUILD_PY_EXT)
	add_subdirectory(python/extension-helper)
	add_subdirectory(python/ecole)
endif()
