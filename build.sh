#!/usr/bin/env bash

set -ue
set -o pipefail

# If we're on travis, set BUILD_OS_NAME to be cross-build-system
if [ -n "${TRAVIS_OS_NAME:-}" ]; then
  export BUILD_OS_NAME=$TRAVIS_OS_NAME
fi

make -j$(nproc) --no-print-directory -C llvm.build --keep-going \
  check-checkedc check-clang

$LNT_VE_DIR/bin/lnt runtest nt -j$(nproc) \
  --sandbox ./llvm.lnt.sandbox \
  --cc ./llvm.build/bin/clang \
  --test-suite ./llvm-test-suite \
  --cflags -fcheckedc-extension

set +ue
set +o pipefail