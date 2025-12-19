find_or_download_package(
	NAME xtl
	URL https://github.com/xtensor-stack/xtl/archive/0.8.1.tar.gz
	URL_HASH SHA256=e69a696068ccffd2b435539d583665981b6c6abed596a72832bffbe3e13e1f49
	CONFIGURE_ARGS -D BUILD_TESTS=OFF
)

find_or_download_package(
	NAME xsimd
	URL https://github.com/xtensor-stack/xsimd/archive/14.0.0.tar.gz
	URL_HASH SHA256=17de0236954955c10c09d6938d4c5f3a3b92d31be5dadd1d5d09fc1b15490dce
	CONFIGURE_ARGS -D BUILD_TESTS=OFF
)

find_or_download_package(
	NAME xtensor
	URL https://github.com/xtensor-stack/xtensor/archive/0.27.1.tar.gz
	URL_HASH SHA256=117c192ae3b7c37c0156dedaa88038e0599a6b264666c3c6c2553154b500fe23
	CONFIGURE_ARGS -D BUILD_TESTS=OFF
)

find_or_download_package(
	NAME span-lite
	URL https://github.com/martinmoene/span-lite/archive/v0.11.0.tar.gz
	URL_HASH SHA256=ef4e028e18ff21044da4b4641ca1bc8a2e2d656e2028322876c0e1b9b6904f9d
	CONFIGURE_ARGS
		-D SPAN_LITE_OPT_BUILD_TESTS=OFF
		-D SPAN_LITE_OPT_BUILD_EXAMPLES=OFF
)
