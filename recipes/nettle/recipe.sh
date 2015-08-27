#!/bin/bash

VERSION_nettle=2.7.1
URL_nettle=https://ftp.gnu.org/gnu/nettle/nettle-${VERSION_nettle}.tar.gz
DEPS_nettle=(libgmp)
BUILD_nettle=$BUILD_PATH/nettle/$(get_directory $URL_nettle)
RECIPE_nettle=$RECIPES_PATH/nettle

function prebuild_nettle() {
	true
}

function shouldbuild_nettle() {
	if [ -e "$LIBS_PATH/libhogweed.so" ]; then
		DO_BUILD=0
	fi
}

function build_nettle() {
	cd $BUILD_nettle
	push_arm
	OLD_LDFLAGS=$LDFLAGS
	OLD_CPPFLAGS=$CPPFLAGS
	export LDFLAGS="-L$BUILD_libgmp/build/lib $LDFLAGS"
	export CPPFLAGS="-I$BUILD_libgmp/build/include"
	try ./configure --build=i686-pc-linux-gnu --host=arm-linux-eabi --prefix=$BUILD_nettle/build/
	try make install
    	libtool --finish $BUILD_nettle/build/
	try cp -L $BUILD_nettle/build/lib/*.so* $LIBS_PATH
	export LDFLAGS=$OLD_LDFLAGS
	export CPPFLAGS=$OLD_CPPFLAGS
	pop_arm
}

function postbuild_nettle() {
	true
}
