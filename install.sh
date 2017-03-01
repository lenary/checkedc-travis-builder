#!/usr/bin/env bash

set -ue
set -o pipefail

# If we're on travis, set BUILD_OS_NAME to be cross-build-system
if [ -n "${TRAVIS_OS_NAME:-}" ]; then
  export BUILD_OS_NAME=$TRAVIS_OS_NAME
fi

local NPROC_LIMIT=8
export NPROC=`awk "BEGIN { nproc=$(nproc); if (nproc > ${NPROC_LIMIT}) { print ${NPROC_LIMIT} } else { print nproc } }"`
echo "NPROC=$(NPROC)"

if [ "${BUILD_OS_NAME}" = "linux" ]; then
  CMAKE_DIR=cmake-3.7.2-Linux-x86_64
  CMAKE_URL="https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz"
  CMAKE_BIN_DIR="bin"
elif [ "${BUILD_OS_NAME}" = "osx" ]; then
  CMAKE_DIR=cmake-3.7.2-Darwin-x86_64
  CMAKE_URL="https://cmake.org/files/v3.7/cmake-3.7.2-Darwin-x86_64.tar.gz"
  CMAKE_BIN_DIR="CMake.app/Contents/bin"
else
  echo "Unknown Platform"
  exit 1
fi

CMAKE_REQ_VERS=3.7.2
if cmake --version | grep $CMAKE_REQ_VERS > /dev/null; then
  export CMAKE_OUR_BIN=`which cmake`
  echo "Using System CMake: ${CMAKE_OUR_BIN}"
else
  if [ ! -x cmake/${CMAKE_BIN_DIR}/cmake ]; then
    rm -fr cmake
    curl -o cmake.tar.gz  $CMAKE_URL
    tar -xzf cmake.tar.gz
    mv -T $CMAKE_DIR cmake
  fi

  export CMAKE_OUR_BIN="$(pwd)/cmake/${CMAKE_BIN_DIR}/cmake"
  export PATH="$(pwd)/cmake/${CMAKE_BIN_DIR}:$PATH"
  echo "Using Own CMake: ${CMAKE_OUR_BIN}"
  $CMAKE_OUR_BIN --version | grep -q $CMAKE_REQ_VERS
fi

if [ $BUILD_OS_NAME = 'linux' ]; then
  # Handled by travis apt addon
  true
elif [ $BUILD_OS_NAME == "osx" ]; then
  if [ -z `which bison` ]; then
    brew install bison
  fi
fi

# Virtualenv for LNT (cached)
if [ ! -x llvm.lnt.ve/bin/python ]; then
  virtualenv ./llvm.lnt.ve
fi
export LNT_VE_DIR="$(pwd)/llvm.lnt.ve"

set +ue
set +o pipefail
