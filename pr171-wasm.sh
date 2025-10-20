#!/bin/bash
#################################################################################
# iccDEV WASMBuild Script | iccDEV Project
# Copyright (C) 2025 The International Color Consortium.
#                                        All rights reserved.
#
#
#  Last Updated: 02-AUGUST-2025 1200Z by David Hoyt
#
#
#  INTENT: Build WASM via RUNNER
#
#  Testing: Verified Working on Ubuntu24, XNU TODO
#  Issues:  The WASM Build exposed LIB Linking issues TODO via PR on master
#           Missing Graphics Link directives need to be pusg to master branch
#
#  WASM BUILD STUB for CI-CD
#
#
#################################################################################
set -e

# === System Dependencies ===
sudo apt-get update
sudo apt-get install -y \
  make cmake python3 build-essential git curl xz-utils \
  autoconf automake libtool pkg-config m4

# === Emscripten SDK ===
cd ~
rm -rf emsdk
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh

# === Clone PatchIccMAX ===
rm -rf iccDEV
git clone https://github.com/InternationalColorConsortium/iccDEV.git
cd iccDEV
git checkout wasm-v231

# === Third-Party Dependencies ===
mkdir -p Build/third_party && cd Build/third_party

# --- zlib ---
git clone https://github.com/madler/zlib.git && cd zlib
emconfigure ./configure --static --prefix=$(pwd)/out
emmake make -j$(nproc)
emmake make install
cd ..

# --- libpng ---
curl -LO https://download.sourceforge.net/libpng/libpng-1.6.43.tar.gz
tar -xzf libpng-1.6.43.tar.gz && mv libpng-1.6.43 libpng && cd libpng
CPPFLAGS="-I$(pwd)/../zlib" LDFLAGS="-L$(pwd)/../zlib/out/lib" \
emconfigure ./configure --disable-shared --enable-static --prefix=$(pwd)/out
emmake make -j$(nproc)
emmake make install
cd ..

# --- libjpeg ---
curl -LO https://ijg.org/files/jpegsrc.v9e.tar.gz
tar -xzf jpegsrc.v9e.tar.gz && mv jpeg-9e libjpeg && cd libjpeg
emconfigure ./configure --prefix=$(pwd)/out --disable-shared --enable-static
emmake make -j$(nproc)
emmake make install
cd ..

# --- libtiff ---
git clone https://gitlab.com/libtiff/libtiff.git && cd libtiff
mkdir wasm && cd wasm
emcmake cmake .. -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=../out \
  -DZLIB_INCLUDE_DIR=$(realpath ../../zlib) \
  -DZLIB_LIBRARY=$(realpath ../../zlib/out/lib/libz.a) \
  -DJPEG_INCLUDE_DIR=$(realpath ../../libjpeg/out/include) \
  -DJPEG_LIBRARY=$(realpath ../../libjpeg/out/lib/libjpeg.a)
emmake make -j$(nproc)
emmake make install
cd ../..

# --- libxml2 ---
git clone https://gitlab.gnome.org/GNOME/libxml2.git && cd libxml2
emconfigure ./autogen.sh --without-python --disable-shared --enable-static --prefix=$(pwd)/out
emmake make -j$(nproc)
emmake make install
cd ..

# --- nlohmann/json ---
mkdir -p nlohmann/json/include
curl -L https://github.com/nlohmann/json/releases/latest/download/json.hpp -o nlohmann/json/include/json.hpp

# === Build ICCMAX ===
cd ..
emcmake cmake Cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DENABLE_TOOLS=ON \
  -DENABLE_STATIC_LIBS=ON \
  -DLIBXML2_INCLUDE_DIR=$(pwd)/third_party/libxml2/out/include/libxml2 \
  -DLIBXML2_LIBRARY=$(pwd)/third_party/libxml2/out/lib/libxml2.a \
  -DTIFF_INCLUDE_DIR=$(pwd)/third_party/libtiff/out/include \
  -DTIFF_LIBRARY=$(pwd)/third_party/libtiff/out/lib/libtiff.a \
  -DJPEG_INCLUDE_DIR=$(pwd)/third_party/libjpeg/out/include \
  -DJPEG_LIBRARY=$(pwd)/third_party/libjpeg/out/lib/libjpeg.a \
  -DPNG_INCLUDE_DIR=$(pwd)/third_party/libpng/out/include \
  -DPNG_LIBRARY=$(pwd)/third_party/libpng/out/lib/libpng16.a \
  -DZLIB_INCLUDE_DIR=$(pwd)/third_party/zlib \
  -DZLIB_LIBRARY=$(pwd)/third_party/zlib/out/lib/libz.a \
  -DCMAKE_CXX_FLAGS="\
    -I$(pwd)/third_party/libtiff/out/include \
    -I$(pwd)/third_party/libjpeg/out/include \
    -I$(pwd)/third_party/libpng/out/include \
    -I$(pwd)/third_party/zlib \
    -I$(pwd)/third_party/nlohmann/json/include" \
  -DCMAKE_EXE_LINKER_FLAGS="\
    -s INITIAL_MEMORY=128MB \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s FORCE_FILESYSTEM=1 \
    -s MODULARIZE=1 \
    -s EXPORT_NAME=createModule \
    -s EXPORTED_RUNTIME_METHODS=['FS','callMain']" \
  -Wno-dev

emmake make -j$(nproc)
find -type f \( -name '*.js' -o -name '*.wasm' \) -ls
