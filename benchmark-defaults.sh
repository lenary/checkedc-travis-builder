#!/usr/bin/env bash

set -ue
set -o pipefail

EXTRA_ARGS=""
TASKSET=""

if [ "${BUILD_OS_NAME}" = "linux" ]; then
  TASKSET="taskset -c 0"
fi

mkdir -p ${BUILD_DIR}/sandbox

exec $TASKSET \
  lnt runtest test_suite \
  --sandbox ${BUILD_DIR}/sandbox \
  --cc ${BUILD_DIR}/llvm/bin/clang \
  --use-lit ${BUILD_DIR}/llvm/bin/llvm-lit \
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
