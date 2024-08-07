#!/bin/bash

CURRENT_DIR=$(cd $(dirname $0) && pwd)

#OHOS_NDK=/home/weekend/openharmony/ohos-sdk/linux/native/
OHOS_NDK=${OHOS_NDK_PATH}
INSTALL=${CURRENT_DIR}/install

SYSROOT=${OHOS_NDK}/sysroot
LLVM=${OHOS_NDK}/llvm

# compile
CLANG=${LLVM}/bin/clang
CLANGXX=${LLVM}/bin/clang++
AR=${LLVM}/bin/llvm-ar
AS=${LLVM}/bin/llvm-as
NM=${LLVM}/bin/llvm-nm
RANLIB=${LLVM}/bin/llvm-ranlib
STRIP=${LLVM}/bin/llvm-strip
OBJDUMP=${LLVM}/bin/llvm-objdump
LD=${LLVM}/bin/ld.lld

OHOS_CFLAGS="--target=aarch64-linux-ohos --arch=aarch64 --sysroot=${SYSROOT}"
OHOS_LIBS="-L${LLVM}/lib"
OHOS_INCS="-I${LLVM}/include"
OHOS_LIBS="$OHOS_LIBS -L${SYSROOT}/usr/lib/aarch64-linux-ohos"
OHOS_INCS="$OHOS_INCS -I${SYSROOT}/usr/include/aarch64-linux-ohos"

if [ -d ${INSTALL} ]; then
    rm -rf ${INSTALL}
fi
mkdir -p ${INSTALL}

if [ -d ${CURRENT_DIR}/ffmpeg-3.3 ]; then
    rm -rf ${CURRENT_DIR}/ffmpeg-3.3
fi
tar -xf ${CURRENT_DIR}/ffmpeg-3.3.tar.bz2
cd ${CURRENT_DIR}/ffmpeg-3.3

./configure --prefix=${INSTALL} \
		--arch=aarch64 \
		--target-os=linux \
		--disable-asm \
		--disable-programs \
		--disable-avdevice \
		--enable-cross-compile \
		--enable-small \
		--enable-shared \
		--cc=${CLANG} \
		--ld=${CLANG} \
		--strip=${STRIP} \
		--extra-cflags="${OHOS_CFLAGS} ${OHOS_INCS} ${OHOS_LIBS}" \
		--extra-ldflags="${OHOS_CFLAGS} ${OHOS_INCS} ${OHOS_LIBS}"

make -j2
make install

#cd -
#rm -rf ${CURRENT_DIR}/ffmpeg-3.3