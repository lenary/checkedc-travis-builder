#!/usr/bin/env bash

set -ue
set -o pipefail

if [ "${BUILD_OS_NAME}" = "linux" ]; then
  EXTRA_ARGS="--use-perf=time"
  TASKSET="taskset -c 1"
elif [ "${BUILD_OS_NAME}" = "osx" ]; then
  EXTRA_ARGS=""
  TASKSET=""
else
  echo "Unknown Platform"
  exit 1
fi

exec $TASKSET \
  $LNT_VE_DIR/bin/lnt runtest test_suite \
  --sandbox ${TMPDIR} \
  --cc ${BUILD_DIR}/bin/clang \
  --use-lit ${BUILD_DIR}/bin/llvm-lit \
  --use-cmake=${CMAKE_OUR_BIN} \
  --test-suite ${CHECKOUT_DIR}/llvm-test-suite \
  --submit=${LNT_DB_DIR} \
  --threads 1 \
  --build-threads 1 \
  --compile-multisample=${MULTISAMPLE} \
  --exec-multisample=${MULTISAMPLE} \
  --test-size=large \
  --succinct-compile-output \
  ${EXTRA_ARGS} \
  $@
