#!/usr/bin/env bash

set -ue
set -o pipefail

# If we're on travis, set BUILD_OS_NAME to be cross-build-system
if [ -n "${TRAVIS_OS_NAME:-}" ]; then
  export BUILD_OS_NAME=$TRAVIS_OS_NAME
fi

if [ "${BUILD_OS_NAME}" = "linux" ]; then
  EXTRA_ARGS="--use-perf=time"
  TASKSET="taskset -c 6,7"
elif [ "${BUILD_OS_NAME}" = "osx" ]; then
  EXTRA_ARGS=""
  TASKSET=""
else
  echo "Unknown Platform"
  exit 1
fi

exec $TASKSET $LNT_VE_DIR/bin/lnt runtest test_suite \
  --sandbox ${PWD}/llvm.lnt.sandbox \
  --cc ${PWD}/llvm.build/bin/clang \
  --use-lit ${PWD}/llvm.build/bin/llvm-lit \
  --use-cmake=${CMAKE_OUR_BIN} \
  --test-suite ${PWD}/llvm-test-suite \
  --benchmarking-only \
  --succinct-compile-output \
  --submit=${LNT_DB_DIR} \
  --threads 1 \
  --build-threads 1 \
  --compile-multisample=${MULTISAMPLE:-10} \
  --exec-multisample=${MULTISAMPLE:-10} \
  --test-size=large \
  ${EXTRA_ARGS} \
  $@
