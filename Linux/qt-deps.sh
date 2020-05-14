#!/bin/bash -eux

source ./common.sh
if [[ ! -d qt5 ]]; then
  $GIT clone https://code.qt.io/qt/qt5.git
  (
    cd qt5
    $GIT checkout 5.15
    $GIT submodule update --init --recursive $(cat "$SDK_ROOT/common/qtmodules")
    $GIT config --global user.email "you@example.com"
    $GIT config --global user.name "Your Name"

    cd qtbase
    sed -i 's/fuse-ld=gold/fuse-ld=lld/g' \
      mkspecs/common/gcc-base-unix.conf \
      mkspecs/features/qt_configure.prf \
      configure.json   

    sed -i "s/-O3/$CFLAGS/" mkspecs/common/gcc-base.conf
    sed -i "s/-O2/$CFLAGS/" mkspecs/common/gcc-base.conf
  )
fi
