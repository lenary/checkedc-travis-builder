#!/usr/bin/env bash

set -ue
set -o pipefail

: ${BM_KIND:=$1}

TARGETS_TO_BUILD="all"
export MULTISAMPLE=100

${SCRIPTS_DIR}/checkout.sh

echo "============== BUILDING CLANG: ${BM_KIND} ================="

mkdir -p ${BUILD_DIR}/llvm
# Run CMake for BUILD_DIR, uses cmake setup in install.sh
pushd ${BUILD_DIR}/llvm

$CMAKE_OUR_BIN \
  -G "Unix Makefiles" \
  -DLLVM_TARGETS_TO_BUILD="X86" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_ASSERTIONS=On \
  -DLLVM_LIT_ARGS="-sv --no-progress-bar" \
  ${CHECKOUT_DIR}/llvm

make -j${NPROC} -k ${TARGETS_TO_BUILD}

popd

echo "================= RUNNING BMs: ${BM_KIND} ================="

BRANCH=$(git --git-dir=${SCRIPTS_DIR}/.git rev-parse --abbrev-ref HEAD)

${SCRIPTS_DIR}/benchmark-defaults.sh \
  --only-test MultiSource/Benchmarks/Olden \
  --run-order="${BM_KIND}-${BRANCH}-olden-clang:${CHECKEDC_CLANG_HEAD:0:8}-suite:${CHECKEDC_TESTS_HEAD:0:8}"

${SCRIPTS_DIR}/benchmark-defaults.sh \
  --only-test MultiSource/Benchmarks/Ptrdist \
  --run-order="${BM_KIND}-${BRANCH}-ptrdist-clang:${CHECKEDC_CLANG_HEAD:0:8}-suite:${CHECKEDC_TESTS_HEAD:0:8}"


echo "==================== DONE BMs: ${BM_KIND} ================="

set +ue
set +o pipefail
