#!/usr/bin/env bash

set -ue
set -o pipefail

# If we're on travis, set BUILD_OS_NAME to be cross-build-system
if [ -n "${TRAVIS_OS_NAME:-}" ]; then
  export BUILD_OS_NAME=$TRAVIS_OS_NAME
fi

. ./install.sh # Sets some environment variables that are useful.

$LNT_VE_DIR/bin/lnt runtest test_suite \
  --sandbox ${PWD}/llvm.lnt.sandbox \
  --cc ${PWD}/llvm.build/bin/clang \
  --test-suite ${PWD}/llvm-test-suite \
  --cflags -fcheckedc-extension \
  -j1 --build-threads=${NPROC} \
  --benchmarking-only \
  --use-cmake=${CMAKE_OUR_BIN} \
  --succinct-compile-output \
  $@

 #

set +ue
set +o pipefail
