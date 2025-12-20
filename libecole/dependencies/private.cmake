find_or_download_package(
	NAME range-v3
	URL https://github.com/ericniebler/range-v3/archive/0.12.0.tar.gz
	URL_HASH SHA256=015adb2300a98edfceaf0725beec3337f542af4915cec4d0b89fa0886f4ba9cb
	CONFIGURE_ARGS
		-D RANGE_V3_TESTS=OFF
		-D RANGE_V3_EXAMPLES=OFF
		-D RANGE_V3_PERF=OFF
		-D RANGE_V3_DOCS=OFF
)

find_or_download_package(
	NAME fmt
	URL https://github.com/fmtlib/fmt/archive/12.0.0.tar.gz
	URL_HASH SHA256=aa3e8fbb6a0066c03454434add1f1fc23299e85758ceec0d7d2d974431481e40
	CONFIGURE_ARGS
		-D FMT_TEST=OFF
		-D FMT_DOC=OFF
		-D FMT_INSTALL=ON
		-D CMAKE_BUILD_TYPE=Release
		-D BUILD_SHARED_LIBS=OFF
		-D CMAKE_POSITION_INDEPENDENT_CODE=${CMAKE_POSITION_INDEPENDENT_CODE}
)

find_or_download_package(
	NAME robin_hood
	URL https://github.com/martinus/robin-hood-hashing/archive/refs/tags/3.11.5.tar.gz
	URL_HASH SHA256=3693e44dda569e9a8b87ce8263f7477b23af448a3c3600c8ab9004fe79c20ad0
	CONFIGURE_ARGS -D RH_STANDALONE_PROJECT=OFF
)
