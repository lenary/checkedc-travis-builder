#!/usr/bin/env bash

set -ue
set -o pipefail

# If we're on travis, set BUILD_OS_NAME to be cross-build-system
if [ -n "${TRAVIS_OS_NAME:-}" ]; then
  export BUILD_OS_NAME=$TRAVIS_OS_NAME
fi

CLONE_DEPTH=50

function clone_or_update {
  local dir=$1
  local url=$2
  local branch=${3:-master}

  if [ ! -d ${dir}/.git ]; then
    echo "Cloning ${url} to ${dir}"
    git clone -q --depth ${CLONE_DEPTH} ${url} ${dir}
  else
    echo "Updating ${dir}"
    (cd ${dir}; git fetch -q --update-shallow origin)
  fi

  echo "Switching ${dir} to ${branch}"
  (cd ${dir}; git checkout -qf $branch; git pull -fq origin $branch)
}

# TODO: Choose branches intelligently

# Check out LLVM
clone_or_update llvm https://github.com/Microsoft/checkedc-llvm master

# Check out Clang
clone_or_update llvm/tools/clang https://github.com/Microsoft/checkedc-clang master

# Check out Checked C Tests
clone_or_update llvm/projects/checkedc-wrapper/checkedc https://github.com/Microsoft/checkedc master

# Check out LNT
clone_or_update lnt https://github.com/llvm-mirror/lnt master

# Check out Test Suite
clone_or_update llvm-test-suite https://github.com/Microsoft/checkedc-llvm-test-suite master

# Make Build Dir
mkdir -p llvm.build

# Run CMake for llvm.build (cached), uses cmake setup in install.sh
(cd llvm.build;
$CMAKE_OUR_BIN -G "Unix Makefiles" \
  -DLLVM_TARGETS_TO_BUILD="X86" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_ASSERTIONS=On \
  -DLLVM_LIT_ARGS="-sv --no-progress-bar --show-unsupported" \
  ../llvm)

# Install lnt into the virtualenv we set up in install.sh
(cd lnt;
$LNT_VE_DIR/bin/python setup.py -q install)

set +ue
set +o pipefail
