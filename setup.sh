#!/usr/bin/env bash

echo "Making Build Dirs..."
# Make Build Dirs
mkdir -p ${CHECKOUT_DIR}
mkdir -p ${BUILD_DIR}
mkdir -p ${RESULTS_DIR}

if [ "${BUILD_OS_NAME}" = "linux" ]; then
  CMAKE_DIR=cmake-3.7.2-Linux-x86_64
  CMAKE_URL="https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz"
  CMAKE_BIN_DIR="bin"
  NPROC=$(nproc)
elif [ "${BUILD_OS_NAME}" = "osx" ]; then
  CMAKE_DIR=cmake-3.7.2-Darwin-x86_64
  CMAKE_URL="https://cmake.org/files/v3.7/cmake-3.7.2-Darwin-x86_64.tar.gz"
  CMAKE_BIN_DIR="CMake.app/Contents/bin"
  NPROC=$(sysctl -n hw.ncpu)
else
  echo "Unknown Platform"
  exit 1
fi

echo "Running with -j${NPROC}"
export NPROC

CMAKE_REQ_VERS=3.7
if [ -e "$(which cmake)" ] && cmake --version | grep $CMAKE_REQ_VERS > /dev/null; then
  CMAKE_OUR_BIN=`which cmake`
  echo "Using System CMake: ${CMAKE_OUR_BIN}"
else
  pushd ${CHECKOUT_DIR};
  if [ ! -x ${CHECKOUT_DIR}/cmake/${CMAKE_DIR}/${CMAKE_BIN_DIR}/cmake ]; then
    mkdir -p ${CHECKOUT_DIR}/cmake
    curl -o cmake.tar.gz $CMAKE_URL
    tar -xzf cmake.tar.gz
    mv $CMAKE_DIR ${CHECKOUT_DIR}/cmake
  fi

  CMAKE_OUR_BIN="${CHECKOUT_DIR}/cmake/${CMAKE_DIR}/${CMAKE_BIN_DIR}/cmake"
  echo "Using Own CMake: ${CMAKE_OUR_BIN}"
  $CMAKE_OUR_BIN --version | grep -q $CMAKE_REQ_VERS
  popd
fi
export CMAKE_OUR_BIN

if [ ! -e `which lnt` ]; then
  echo "LNT Not Found"
  exit 1
fi

# Create LNT DB
if [ ! -d ${LNT_DB_DIR} ]; then
  lnt create ${LNT_DB_DIR}
fi
