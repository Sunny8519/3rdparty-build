#!/bin/bash
pushd `dirname $0`
TARGET_ARCH_ABI=$1
DEST=`pwd`/build/ffmpeg
ANDROID_API_LEVEL=14
minimal_featureset=1
USE_STAGEFRIGHT=0

#1 audio ;2 video; 3 audio+video
BUILD_FLAG=3

# NDK_ROOT=$(dirname $(which ndk-build))
NDK_ROOT=~/Desktop/ndk/android-ndk-r14b

PATH=$PATH:$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/
NDK_SYSROOT=$NDK_ROOT/platforms/android-$ANDROID_API_LEVEL/arch-arm
NDK_CROSS_PREFIX=arm-linux-androideabi-

FLAGS="--cross-prefix=$NDK_CROSS_PREFIX"

case "$TARGET_ARCH_ABI" in
	x86)
		FLAGS="$FLAGS --enable-pic --target-os=android --arch=x86 --disable-asm "
		;;
	mips)
		FLAGS="$FLAGS --target-os=android --arch=mips --disable-asm "
		;;
	armeabi-v7a)
		FLAGS="$FLAGS --enable-pic --target-os=android --arch=arm --cpu=armv7-a"
		;;
    arm64-v8a)
        PATH=$PATH:$NDK_ROOT/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/
        NDK_SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm64
        NDK_CROSS_PREFIX=aarch64-linux-android-

        FLAGS="--cross-prefix=$NDK_CROSS_PREFIX"
        FLAGS="$FLAGS --enable-pic --target-os=android --arch=aarch64 --cpu=armv8-a"
        ;;
	armeabi)
		FLAGS="$FLAGS --enable-pic --target-os=android --arch=arm "
		;;
esac
pushd ffmpeg_src

ANDROID_SOURCE=./android-source
ANDROID_LIBS=./android-libs

# stagefright only for armeabi-v7a
if [[ "$TARGET_ARCH_ABI" != "armeabi-v7a" ]]; then
USE_STAGEFRIGHT=0
fi

if [ $USE_STAGEFRIGHT -eq 1 ]; then

if [ ! -d "$ANDROID_SOURCE/frameworks/base" ]; then 
    echo "Fetching Android system base headers"
    git clone --depth=1 --branch gingerbread-release git://github.com/CyanogenMod/android_frameworks_base.git $ANDROID_SOURCE/frameworks/base
fi
if [ ! -d "$ANDROID_SOURCE/system/core" ]; then
    echo "Fetching Android system core headers"
    git clone --depth=1 --branch gingerbread-release git://github.com/CyanogenMod/android_system_core.git $ANDROID_SOURCE/system/core
fi
if [ ! -d "$ANDROID_LIBS" ]; then
    # Libraries from any froyo/gingerbread device/emulator should work
    # fine, since the symbols used should be available on most of them.
    echo "Fetching Android libraries for linking"
    if [ ! -f "./update-cm-7.0.3-N1-signed.zip" ]; then
        wget http://download.cyanogenmod.com/get/update-cm-7.0.3-N1-signed.zip -P./
    fi
    unzip ./update-cm-7.0.3-N1-signed.zip system/lib/* -d./
    mv ./system/lib $ANDROID_LIBS
    rmdir ./system
fi

fi


# actual build
FLAGS="$FLAGS --sysroot=$NDK_SYSROOT"

FLAGS="$FLAGS --enable-cross-compile \
--disable-debug \
--disable-programs \
--disable-doc \
--disable-network \
--disable-decoders \
--disable-encoders \
--disable-muxers \
--disable-demuxers \
--disable-devices \
--disable-parsers \
--disable-protocols \
--disable-bsfs \
--disable-iconv \
--enable-pic \
--enable-gpl \
--enable-nonfree \
--enable-version3 \
--enable-protocol=file \
--enable-filter=overlay \
--enable-filter=movie \
--enable-filter=scale"

if [ $BUILD_FLAG -eq 1 -o $BUILD_FLAG -eq 3 ]; then
#For libmp3lame 1
FLAGS="$FLAGS --enable-libmp3lame \
--enable-encoder=libmp3lame \
--enable-decoder=mp3 \
--enable-muxer=mp3 \
--enable-demuxer=mp3 \
--enable-encoder=wmav1 \
--enable-encoder=wmav2 \
--enable-encoder=libfaac \
--enable-libfdk_aac \
--enable-encoder=libfdk_aac \
--enable-decoder=libfdk_aac \
--enable-encoder=aac \
--enable-encoder=libaacplus \
--enable-encoder=libfdk_aac \
--enable-encoder=flac \
--enable-decoder=wmav1 \
--enable-decoder=wmav2 \
--enable-decoder=wmavoice \
--enable-decoder=libfdk_aac \
--enable-decoder=aac \
--enable-decoder=aac_latm \
--enable-decoder=flac \
--enable-parser=aac \
--enable-parser=mpegaudio \
--enable-muxer=flac \
--enable-demuxer=asf \
--enable-demuxer=aac \
--enable-demuxer=aiff \
--enable-demuxer=mov \
--enable-demuxer=flac \
--enable-bsf=mp3_header_decompress"


#For libmp3lame 2
MP3LAME_LIBS=$(pwd)/../../../../../lame/lib/android/$TARGET_ARCH_ABI
MP3LAME_INCLUDE=$(pwd)/../../../../../lame/include
fi

if [ $BUILD_FLAG -eq 2 -o $BUILD_FLAG -eq 3 ]; then
#For merge mp4
# H265
#FLAGS="$FLAGS \
#--enable-decoder=bmp \
#--enable-jni \
#    --enable-mediacodec \
#    --enable-libx265 \
#    --enable-encoder=mjpeg \
#    --enable-encoder=png \
#    --enable-decoder=mjpeg \
#    --enable-decoder=png \
#    --enable-decoder=mpeg4_mediacodec \
#    --enable-demuxer=image2 \
#    --enable-demuxer=avi \
#    --enable-demuxer=mpc \
#    --enable-demuxer=mov \
#    --enable-parser=ac3 \
#    --enable-muxer=avi \
#    --enable-muxer=mov \
#    --enable-muxer=mp3 \
#    --enable-muxer=mp4 \
#    --enable-avresample \
#    --enable-small \
#    --enable-avfilter \
#    --enable-gpl \
#    --enable-muxer=mp4"

#--enable-decoder=hevc_mediacodec

# H264
FLAGS="$FLAGS \
--enable-encoder=libx264rgb \
--enable-decoder=bmp \
--enable-jni \
    --enable-mediacodec \
    --enable-libx264 \
    --enable-encoder=libx264 \
    --enable-decoder=libx264 \
    --enable-encoder=mjpeg \
    --enable-encoder=png \
    --enable-decoder=mjpeg \
    --enable-decoder=png \
    --enable-decoder=h264_mediacodec \
    --enable-decoder=hevc_mediacodec \
    --enable-decoder=mpeg4_mediacodec \
    --enable-demuxer=image2 \
    --enable-demuxer=h264 \
    --enable-demuxer=avi \
    --enable-demuxer=mpc \
    --enable-demuxer=mov \
    --enable-parser=ac3 \
    --enable-parser=h264 \
    --enable-muxer=h264 \
    --enable-muxer=avi \
    --enable-muxer=mov \
    --enable-muxer=mp3 \
    --enable-muxer=mp4 \
    --enable-avresample \
    --enable-small \
    --enable-avfilter \
    --enable-gpl \
    --enable-muxer=mp4"




#For libmp3lame 2
MP3LAME_LIBS=$(pwd)/../../../../../lame/lib/android/$TARGET_ARCH_ABI
MP3LAME_INCLUDE=$(pwd)/../../../../../lame/include

X264_LIBS=$(pwd)/../build/x264/$TARGET_ARCH_ABI/lib
X264_INCLUDES=$(pwd)/../build/x264/$TARGET_ARCH_ABI/include

X265_LIBS=$(pwd)/../../../../../x265_2.5/prebuilt/$TARGET_ARCH_ABI/lib
X265_INCLUDES=$(pwd)/../../../../../x265_2.5/prebuilt/$TARGET_ARCH_ABI/include

FDK_AAC_PATH=$(pwd)/../../../../../fdk-aac/lib/android/$TARGET_ARCH_ABI/lib
FDK_AAC_INCLUDE=$(pwd)/../../../../../fdk-aac/lib/android/$TARGET_ARCH_ABI/include

fi		

ABI=$TARGET_ARCH_ABI
case "$TARGET_ARCH_ABI" in
	neon)
        # --- THIS IS NEVER USED FOR NOW ---
		EXTRA_CFLAGS="$EXTRA_CFLAGS -march=armv7-a -mfloat-abi=softfp -mfpu=neon"
		EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,--fix-cortex-a8"
		# Runtime choosing neon vs non-neon requires
		# renamed files
		ABI="armeabi-v7a-neon"
		;;
	armeabi-v7a)
		EXTRA_CFLAGS="$EXTRA_CFLAGS -march=armv7-a -mfloat-abi=softfp -mfpu=neon"
        EXTRA_LDFLAGS="$EXTRA_LDFLAGS -Wl,--fix-cortex-a8"
		;;
    arm64-v8a)
        EXTRA_CFLAGS="$EXTRA_CFLAGS -march=armv8-a"
        ;;
esac

DEST="$DEST/$ABI"
FLAGS="$FLAGS --prefix=$DEST"

# CXX
EXTRA_CXXFLAGS="-Wno-multichar -fno-exceptions -fno-rtti"

if [ $BUILD_FLAG -eq 1 -o $BUILD_FLAG -eq 3 ]; then
#For libmp3lame 3
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$MP3LAME_INCLUDE"
EXTRA_LDFLAGS="$EXTRA_LDFLAGS -L$MP3LAME_LIBS -Wl,-rpath-link,$MP3LAME_LIBS"
fi
if [ $BUILD_FLAG -eq 2 -o $BUILD_FLAG -eq 3 ]; then
# X264 libs and includes
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$X264_INCLUDES"
EXTRA_LDFLAGS="$EXTRA_LDFLAGS -L$X264_LIBS -Wl,-rpath-link,$X264_LIBS"

# x265 libs and includes
#EXTRA_CFLAGS="$EXTRA_CFLAGS -I$X265_INCLUDES"
#EXTRA_LDFLAGS="$EXTRA_LDFLAGS -L$X265_LIBS"
#EXTRA_CFLAGS="$EXTRA_CFLAGS $(pkg-config --cflags x265)"
#EXTRA_LDFLAGS="$EXTRA_LDFLAGS $(pkg-config --libs --static x265)"

# vo-aac libs and includes
EXTRA_CFLAGS="$EXTRA_CFLAGS -I$FDK_AAC_INCLUDE"
EXTRA_LDFLAGS="$EXTRA_LDFLAGS -L$FDK_AAC_PATH"

EXTRA_CFLAGS="$EXTRA_CFLAGS -DFIX_NDK_LD_ERR"
fi

# Stagefright
if [ $USE_STAGEFRIGHT -eq 1 ]; then
    EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/base/include -I$ANDROID_SOURCE/system/core/include"
    EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/base/media/libstagefright"
    EXTRA_CFLAGS="$EXTRA_CFLAGS -I$ANDROID_SOURCE/frameworks/base/include/media/stagefright/openmax"
    EXTRA_CFLAGS="$EXTRA_CFLAGS -I$NDK_ROOT/sources/cxx-stl/system/include"
    EXTRA_LDFLAGS="$EXTRA_LDFLAGS -L$ANDROID_LIBS -Wl,-rpath-link,$ANDROID_LIBS"
fi


mkdir -p $DEST
echo "$FLAGS" > $DEST/log.txt
./configure $FLAGS --extra-cflags="$EXTRA_CFLAGS -DANDROID" --extra-ldflags="$EXTRA_LDFLAGS" --extra-cxxflags="$EXTRA_CXXFLAGS" | tee $DEST/configuration.txt
make clean
make -j4 > /mnt/hgfs/workspace/yuwan/ywav-native/ywaudio-native/src/main/cpp/audio/3rdparty/ffmpeg/build/android/sources.txt || exit 1
make install || exit 1

popd; popd
