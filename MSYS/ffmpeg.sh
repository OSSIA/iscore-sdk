#!/bin/bash

source ./common.sh

export VERSION=4.4

if [[ ! -f ffmpeg-$VERSION.tar.bz2 ]]; then
  wget -nv https://ffmpeg.org/releases/ffmpeg-$VERSION.tar.bz2
  tar xaf ffmpeg-$VERSION.tar.bz2
fi

mkdir ffmpeg-build
cd ffmpeg-build

 ../ffmpeg-$VERSION/configure \
    --arch=x86_64 --cpu=x86_64 \
 	--disable-doc --disable-ffmpeg --disable-ffplay \
 	--disable-debug \
 	--pkg-config-flags="--static" \
 	--enable-gpl --enable-version3 \
 	--disable-openssl --disable-securetransport \
 	--disable-videotoolbox \
 	--disable-network --disable-iconv \
 	--enable-protocols  --disable-lzma \
 	--prefix=$INSTALL_PREFIX/ffmpeg 

 make -j$NPROC
 make install
