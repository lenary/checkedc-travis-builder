#!/usr/bin/env bash

set -ue
set -o pipefail

# If we're on travis, set BUILD_OS_NAME to be cross-build-system
if [ -n "${TRAVIS_OS_NAME:-}" ]; then
  export BUILD_OS_NAME=$TRAVIS_OS_NAME
fi

source ./install.sh # Sets some environment variables that are useful.

# set the right variables for checkout

# export CHECKEDC_LLVM_HEAD=ed393c24a6f787399a623bad718be4d567d1d64a
export CHECKEDC_SPEC_HEAD=e5b957f63e8639c4ef83c5e2ef798aa2c1112b35
export CHECKEDC_LNT_HEAD=8dc13a3fbbd0109132046589efa7c3c6bcbba626


export BM_KIND=baseline
export CHECKEDC_CLANG_HEAD=fc6245cf9dc945c35d7b1be78c92b970a1c5199d
export CHECKEDC_TESTS_HEAD=a75815f0fdfeffd007c6d93b9b3633c1a727d9f3

# In the middle, of the 96 cores of the machine we're running on
export TASKSET_CORE=48

./checkout.sh
./configure.sh

make -j${NPROC} --no-print-directory -C llvm.build

echo "================= RUNNING BMs: baseline ================="

./benchmark-defaults.sh \
  --only-test MultiSource/Benchmarks/Olden \
  --run-order="${BM_KIND}-clang:${CHECKEDC_CLANG_HEAD:0:8}-suite:${CHECKEDC_TESTS_HEAD:0:8}-olden"

./benchmark-defaults.sh \
  --only-test MultiSource/Benchmarks/Ptrdist \
  --run-order"${BM_KIND}-clang:${CHECKEDC_CLANG_HEAD:0:8}-suite:${CHECKEDC_TESTS_HEAD:0:8}-ptrdist"

echo "================= DONE BMs: baseline ================="

export BM_KIND=converted
export CHECKEDC_CLANG_HEAD=8ad4042b757e461488d1c92ebec25753a8a518ae
# TODO: Update this SHA
export CHECKEDC_TESTS_HEAD=9fb740a90b86a59803dba39ebb256bc9ea5fef54

./checkout.sh
./configure.sh

make -j${NPROC} --no-print-directory -C llvm.build clang

echo "================= RUNNING BMs: converted ================="

./benchmark-defaults.sh \
  --only-test MultiSource/Benchmarks/Olden \
  --run-order="${BM_KIND}-clang:${CHECKEDC_CLANG_HEAD:0:8}-suite:${CHECKEDC_TESTS_HEAD:0:8}-olden" \
  --cflags="-fcheckedc-extension"

./benchmark-defaults.sh \
  --only-test MultiSource/Benchmarks/Ptrdist \
  --run-order="${BM_KIND}-clang:${CHECKEDC_CLANG_HEAD:0:8}-suite:${CHECKEDC_TESTS_HEAD:0:8}-ptrdist" \
  --cflags="-fcheckedc-extension"

echo "================= DONE BMs: converted ================="

set +ue
set +o pipefail
