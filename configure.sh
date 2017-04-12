#!/usr/bin/env bash

set -ue
set -o pipefail

# If we're on travis, set BUILD_OS_NAME to be cross-build-system
if [ -n "${TRAVIS_OS_NAME:-}" ]; then
  export BUILD_OS_NAME=$TRAVIS_OS_NAME
fi

# Install lnt into the virtualenv we set up in install.sh
(cd lnt;
${LNT_VE_DIR}/bin/python setup.py install)

# Create LNT DB
${LNT_VE_DIR}/bin/lnt create ${LNT_DB_DIR}

# Make Build Dir
mkdir -p llvm.build

# Run CMake for llvm.build (cached), uses cmake setup in install.sh
(cd llvm.build;
$CMAKE_OUR_BIN -G "Unix Makefiles" \
  -DLLVM_TARGETS_TO_BUILD="X86" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_ASSERTIONS=On \
  -DLLVM_LIT_ARGS="-sv --no-progress-bar" \
  ../llvm)


set +ue
set +o pipefail
