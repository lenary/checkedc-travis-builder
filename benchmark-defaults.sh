#!/usr/bin/env bash

set -ue
set -o pipefail

EXTRA_ARGS=""
TASKSET=""

if [ "${BUILD_OS_NAME}" = "linux" ]; then
  CPU=$(( RANDOM % NPROC ))
  TASKSET="taskset -c $CPU"
fi

mkdir -p ${BUILD_DIR}/sandbox

set -x

exec \
  lnt runtest test_suite \
  --sandbox ${BUILD_DIR}/sandbox \
  --cc ${BUILD_DIR}/llvm/bin/clang \
  --use-lit ${BUILD_DIR}/llvm/bin/llvm-lit \
  --use-cmake ${CMAKE_OUR_BIN} \
  --test-suite ${CHECKOUT_DIR}/llvm-test-suite \
  --submit ${LNT_DB_DIR} \
  --threads 1 \
  --build-threads 1 \
  --compile-multisample ${MULTISAMPLE} \
  --exec-multisample ${MULTISAMPLE} \
  --succinct-compile-output \
  --run-under="${TASKSET}" \
  ${EXTRA_ARGS} \
  ${EXTRA_TEST_ARGS} \
  $@
