#!/bin/sh

set -e

CMAKE_VERS=3.7.2
CMAKE_URL="https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.tar.gz"
if cmake --version | grep -q $CMAKE_VERS; then
  echo "Using Installed CMake"
elif [ ! -d cmake ]; then
  curl -o cmake.tar.gz  $CMAKE_URL
  tar -xzf cmake.tar.gz
  (cd cmake;
  ./bootstrap;
  make)
fi

if [ -x cmake/bin/cmake ]; then
  CMAKE="$(pwd)/cmake/bin/cmake"
  export PATH="$(pwd)/cmake/bin:$PATH"
fi

cmake --version

# Check out LLVM
if [ ! -d llvm/.git ]; then
  git clone  https://github.com/Microsoft/checkedc-llvm llvm
else
  (cd llvm; git pull)
fi;

# Check out Clang
if [ ! -d llvm/tools/clang/.git ]; then
  (cd llvm/tools; git clone https://github.com/Microsoft/checkedc-clang clang)
else
  (cd llvm/tools/git; git pull)
fi

# Check out Checked C Tests
if [ ! -d llvm/projects/checkedc-wrapper/checkedc/.git ]; then
  (cd llvm/projects/checkedc-wrapper; git clone https://github.com/Microsoft/checkedc checkedc)
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
