#!/bin/bash
pushd `dirname $0`
TARGET_ARCH_ABI=$1
DEST=`pwd`/build/x264
ANDROID_API_LEVEL=14
minimal_featureset=1

#NDK_ROOT=$(dirname $(which ndk-build))
NDK_ROOT=~/Desktop/ndk/android-ndk-r14b
PATH=$PATH:${NDK_ROOT}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/
NDK_SYSROOT=${NDK_ROOT}/platforms/android-$ANDROID_API_LEVEL/arch-arm
NDK_CROSS_PREFIX=arm-linux-androideabi-

FLAGS="--cross-prefix=$NDK_CROSS_PREFIX"



case "$TARGET_ARCH_ABI" in
	neon)
		EXTRA_CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon -fvisibility=hidden "
		EXTRA_LDFLAGS="-Wl,--fix-cortex-a8 -fvisibility=hidden "
		# Runtime choosing neon vs non-neon requires
		# renamed files
		ABI="armeabi-v7a-neon"
		;;
	armeabi-v7a)
		EXTRA_CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon -fvisibility=hidden "
		EXTRA_LDFLAGS="-Wl,--fix-cortex-a8 -fvisibility=hidden "
		ABI="armeabi-v7a"
		;;
	arm64-v8a)
        PATH=$PATH:${NDK_ROOT}/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/
        NDK_SYSROOT=${NDK_ROOT}/platforms/android-21/arch-arm64
        NDK_CROSS_PREFIX=aarch64-linux-android-
        FLAGS="--cross-prefix=$NDK_CROSS_PREFIX"

		EXTRA_CFLAGS=" -DANDROID -march=armv8-a"
		#EXTRA_LDFLAGS="-O3 -Wall -pipe -ffast-math -fstrict-aliasing -Werror=strict-aliasing -Wno-psabi -Wa,--noexecstack -DANDROID "
		ABI="arm64-v8a"
		;;
	x86)
		EXTRA_CFLAGS=""
		EXTRA_LDFLAGS=""
		ABI="x86"
		;;
	mips)
		EXTRA_CFLAGS=""
		EXTRA_LDFLAGS=""
		ABI="mips"
		;;
	*)
		EXTRA_CFLAGS="-DNDK_R8 -DANDROID -fvisibility=hidden -ffunction-sections -march=armv5te -mtune=xscale -msoft-float -fno-exceptions -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300"
		EXTRA_LDFLAGS=""
		ABI="armeabi"
		;;
esac

case "$TARGET_ARCH_ABI" in
	x86)
            FLAGS="$FLAGS --enable-pic --disable-asm --host=i686-linux"
	    ;;
	mips)
            FLAGS="$FLAGS --enable-pic --disable-asm --host=mips-linux"
	    ;;
	arm64-v8a)
            FLAGS="$FLAGS --enable-pic --host=aarch64-linux"
	    ;;
	*)
	    FLAGS="$FLAGS --enable-pic --host=arm-linux "
	    ;;
esac

pushd x264_src

FLAGS="$FLAGS --enable-static --disable-cli"
FLAGS="$FLAGS --sysroot=$NDK_SYSROOT"

DEST="$DEST/$ABI"
FLAGS="$FLAGS --prefix=$DEST"

echo "Build in $FLAGS --extra-cflags=\"$EXTRA_CFLAGS\" --extra-ldflags=\"$EXTRA_LDFLAGS\""
mkdir -p $DEST
./configure $FLAGS --extra-cflags="$EXTRA_CFLAGS" --extra-ldflags="$EXTRA_LDFLAGS" | tee $DEST/configuration.txt
make clean
make -j4 || exit 1
make install || exit 1

popd; popd
