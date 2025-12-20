# Set some variables to find the proper Python version

# scikit-build-core sets Python paths automatically via CMake's FindPython.
# For standalone builds, find Python from the path.
if(NOT SKBUILD AND NOT DEFINED Python_EXECUTABLE)
	execute_process(
		COMMAND "python3" "-c" "import sys; print(sys.executable)"
		OUTPUT_VARIABLE Python_EXECUTABLE
		OUTPUT_STRIP_TRAILING_WHITESPACE
	)
endif()
