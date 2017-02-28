#!/bin/sh

set -e

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
cmake -G "Unix Makefiles" -DLLVM_TARGETS_TO_BUILD="X86" ../llvm

# TODO: LNT Test Suite
