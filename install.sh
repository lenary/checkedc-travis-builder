#!/bin/sh

set -e

if [ "${TRAVIS_OS_NAME}" = "linux" ]; then
  CMAKE_DIR=cmake-3.7.2-Linux-x86_64
  CMAKE_URL="https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz"
elif [ "${TRAVIS_OS_NAME}" = "osx" ]; then
  CMAKE_DIR=cmake-3.7.2-Darwin-x86_64
  CMAKE_URL="https://cmake.org/files/v3.7/cmake-3.7.2-Darwin-x86_64.tar.gz"
else
  echo "Unknown Platform"
  exit 1
fi


# CMAKE_REQ_VERS=3.7.2
# if cmake --version | grep $CMAKE_REQ_VERS > /dev/null; then
#   echo "Using Installed CMake"
#   CMAKE=`which cmake`
if [ ! -d cmake/bin ]; then


  curl -o cmake.tar.gz  $CMAKE_URL
  tar -xzf cmake.tar.gz
  mv $CMAKE_DIR cmake
fi

if [ -x cmake/bin/cmake ]; then
  CMAKE="$(pwd)/cmake/bin/cmake"
  export PATH="$(pwd)/cmake/bin:$PATH"
  echo "Using Own CMake: ${CMAKE}"
fi

$CMAKE --version

if [ $TRAVIS_OS_NAME = 'linux' ]; then
  # Handled by travis apt addon
  true
elif [ $TRAVIS_OS_NAME == "osx" ]; then
  brew install bison
fi

CLONE_DEPTH=50

# Check out LLVM
if [ ! -d llvm/.git ]; then
  git clone --depth ${CLONE_DEPTH} https://github.com/Microsoft/checkedc-llvm llvm
else
  (cd llvm; git fetch --update-shallow origin; git pull)
fi;

# Check out Clang
if [ ! -d llvm/tools/clang/.git ]; then
  (cd llvm/tools; git clone --depth ${CLONE_DEPTH} https://github.com/Microsoft/checkedc-clang clang)
else
  (cd llvm/tools/clang; git fetch --update-shallow origin; git pull)
fi

# Check out Checked C Tests
if [ ! -d llvm/projects/checkedc-wrapper/checkedc/.git ]; then
  (cd llvm/projects/checkedc-wrapper; git clone --depth ${CLONE_DEPTH} https://github.com/Microsoft/checkedc checkedc)
else
  (cd llvm/projects/checkedc-wrapper/checkedc; git fetch --update-shallow origin; git pull)
fi

# Check out LNT
if [ ! -d lnt/.git ]; then
  git clone --depth ${CLONE_DEPTH} https://github.com/llvm-mirror/lnt.git lnt
else
  (cd lnt; git fetch --update-shallow origin; git pull)
fi

# Check out Test Suite
if [ ! -d checkedc-llvm-test-suite/.git ]; then
  git clone --depth ${CLONE_DEPTH} https://github.com/Microsoft/checkedc-llvm-test-suite.git checkedc-llvm-test-suite
else
  (cd checkedc-llvm-test-suite; git fetch --update-shallow origin; git pull)
fi

# TODO: Choose Branches based on ENV Variables

# Make Build Dir
mkdir -p llvm.build

# Run CMake for llvm.build (cached)
(cd llvm.build;
$CMAKE -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="X86" -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=On ../llvm)

# Virtualenv for LNT (cahced)
virtualenv ./llvm.lnt.ve
LNT_VE_DIR=$(pwd)/llvm.lnt.ve

# Install lnt
(cd lnt;
$LNT_VE_DIR/bin/python setup.py install)
