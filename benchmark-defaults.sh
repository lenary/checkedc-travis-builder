#!/usr/bin/env bash

set -ue
set -o pipefail

# If we're on travis, set BUILD_OS_NAME to be cross-build-system
if [ -n "${TRAVIS_OS_NAME:-}" ]; then
  export BUILD_OS_NAME=$TRAVIS_OS_NAME
fi

if [ "${BUILD_OS_NAME}" = "linux" ]; then
  EXTRA_ARGS="--use-perf=time --make-param='RUNUNDER=taskset -c ${TASKSET_CORE:-1}'"
elif [ "${BUILD_OS_NAME}" = "osx" ]; then
  EXTRA_ARGS=""
else
  echo "Unknown Platform"
  exit 1
fi

$LNT_VE_DIR/bin/lnt runtest test_suite \
  --sandbox ${PWD}/llvm.lnt.sandbox \
  --cc ${PWD}/llvm.build/bin/clang \
  --use-cmake=${CMAKE_OUR_BIN} \
  --test-suite ${PWD}/checkedc-llvm-test-suite \
  --benchmarking-only \
  --succinct-compile-output \
  --submit=${LNT_DB_DIR} \
  --threads 1 \
  --build-threads 1 \
  --compile-multisample=10 \
  --exec-multisample=10 \
  --test-size=large \
  ${EXTRA_ARGS} \
  $@

 #

set +ue
set +o pipefail
