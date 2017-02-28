#!/bin/sh

set -e


# CMAKE_REQ_VERS=3.7.2
# if cmake --version | grep $CMAKE_REQ_VERS > /dev/null; then
#   echo "Using Installed CMake"
#   CMAKE=`which cmake`
if [ ! -d cmake ]; then

  if [ $TRAVIS_OS_NAME = 'linux' ]; then
    CMAKE_DIR=cmake-3.7.2-Linux-x86_64
    CMAKE_URL="https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz"
  elif [ $TRAVIS_OS_NAME == "osx" ]; then
    echo "TODO: CMake Install Mac"
    exit 1
  fi

  curl -o cmake.tar.gz  $CMAKE_URL
  tar -xzf cmake.tar.gz
  mv $CMAKE_DIR cmake
  (cd cmake;
  ./bootstrap;
  make)
fi

if [ -x cmake/bin/cmake ]; then
  CMAKE="$(pwd)/cmake/bin/cmake"
  export PATH="$(pwd)/cmake/bin:$PATH"
  echo "Using Own CMake: ${CMAKE}"
fi

$CMAKE --version

CLONE_DEPTH=50

# Check out LLVM
if [ ! -d llvm/.git ]; then
  git clone --depth ${CLONE_DEPTH} https://github.com/Microsoft/checkedc-llvm llvm
else
  (cd llvm; git pull)
fi;

# Check out Clang
if [ ! -d llvm/tools/clang/.git ]; then
  (cd llvm/tools; git clone --depth ${CLONE_DEPTH} https://github.com/Microsoft/checkedc-clang clang)
else
  (cd llvm/tools/clang; git pull)
fi

# Check out Checked C Tests
if [ ! -d llvm/projects/checkedc-wrapper/checkedc/.git ]; then
  (cd llvm/projects/checkedc-wrapper; git clone --depth ${CLONE_DEPTH} https://github.com/Microsoft/checkedc checkedc)
else
  (cd llvm/projects/checkedc-wrapper/checkedc; git pull)
fi

# TODO: Choose Branches based on ENV Variables

# Make Build Dir
mkdir -p llvm.build
cd llvm.build

# Run CMake
$CMAKE -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="X86" ../llvm

# TODO: LNT Test Suite
