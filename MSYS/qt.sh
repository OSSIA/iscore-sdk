#!/bin/bash -eux

source ./common.sh

export SDK_COMMON_ROOT=$(cd "$PWD/.." ; pwd -P)
if [[ ! -d qt5 ]]; then
git clone https://invent.kde.org/qt/qt/qt5

(
  cd qt5
  git checkout kde/5.15
  git submodule update --init --recursive $(cat "$SDK_COMMON_ROOT/common/qtmodules")
  
  git clone https://github.com/jcelerier/qtshadertools.git

  (
    cd qtbase
    sed -i "s/-O2/$CFLAGS/" mkspecs/common/gcc-base.conf 
  )
)
fi

mkdir -p qt5-build-static
(
  cd qt5-build-static
  ../qt5/configure $(cat "$SDK_COMMON_ROOT/common/qtfeatures") \
                   -static \
                   -platform win32-clang-g++ \
                   -opengl desktop \
                   -feature-schannel \
                   -prefix $INSTALL_PREFIX/qt5-static

make -j$NPROC
make install -j$NPROC
)

(
  cd qt5/qtshadertools
  git clean -dffx
  $INSTALL_PREFIX/qt5-static/bin/qmake
  make -j12
  make install -j12
)
