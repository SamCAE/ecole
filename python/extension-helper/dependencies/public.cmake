find_package(Python COMPONENTS Interpreter Development NumPy REQUIRED)

find_or_download_package(
	NAME pybind11
	URL https://github.com/pybind/pybind11/archive/v2.13.6.tar.gz
	URL_HASH SHA256=e08cb87f4773da97fa7b5f035de8763abc656d87d5773e62f6da0587d1f0ec20
	CONFIGURE_ARGS
		-D PYBIND11_TEST=OFF
		-D "Python_EXECUTABLE=${Python_EXECUTABLE}"
		-D "PYTHON_EXECUTABLE=${Python_EXECUTABLE}"
)

find_or_download_package(
	NAME xtensor-python
	URL https://github.com/xtensor-stack/xtensor-python/archive/0.29.0.tar.gz
	URL_HASH SHA256=2915b220bd11b70fdd9fbb2db5f313e751189fec083e406228c8e5a31dfaa4a2
	CONFIGURE_ARGS
		-D BUILD_TESTS=OFF
		-D "Python_EXECUTABLE=${Python_EXECUTABLE}"
		-D "PYTHON_EXECUTABLE=${Python_EXECUTABLE}"
)
