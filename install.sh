#!/usr/bin/env bash

set -ue
set -o pipefail

# If we're on travis, set BUILD_OS_NAME to be cross-build-system
if [ -n "${TRAVIS_OS_NAME:-}" ]; then
  export BUILD_OS_NAME=$TRAVIS_OS_NAME
fi

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

# NPROC_LIMIT defaults to 8. Export it to control the limit
export NPROC=`awk "BEGIN { limit=${NPROC_LIMIT:-16}; print (${NPROC} < limit) ? ${NPROC} : limit ;}"`
echo "Running with -j${NPROC}"

CMAKE_REQ_VERS=3.7
if cmake --version | grep $CMAKE_REQ_VERS > /dev/null; then
  export CMAKE_OUR_BIN=`which cmake`
  echo "Using System CMake: ${CMAKE_OUR_BIN}"
else
  if [ ! -x cmake/${CMAKE_DIR}/${CMAKE_BIN_DIR}/cmake ]; then
    mkdir -p cmake
    curl -o cmake.tar.gz  $CMAKE_URL
    tar -xzf cmake.tar.gz
    mv $CMAKE_DIR cmake
  fi

  export CMAKE_OUR_BIN="$(pwd)/cmake/${CMAKE_DIR}/${CMAKE_BIN_DIR}/cmake"
  export PATH="$(pwd)/cmake/${CMAKE_DIR}/${CMAKE_BIN_DIR}:$PATH"
  echo "Using Own CMake: ${CMAKE_OUR_BIN}"
  $CMAKE_OUR_BIN --version | grep -q $CMAKE_REQ_VERS
fi

export LNT_VE_DIR="$(pwd)/llvm.lnt.ve"
export LNT_DB_DIR="$(pwd)/llvm.lnt.db"

# Virtualenv for LNT (cached)
if [ ! -x ${LNT_VE_DIR}/bin/python ]; then
  virtualenv -q ${LNT_VE_DIR}
fi

set +ue
set +o pipefail
