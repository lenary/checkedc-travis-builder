#!/usr/bin/env bash

set -ue
set -o pipefail

CLONE_DEPTH=50

function clone_or_update {
  local dir=${CHECKOUT_DIR}/${1}
  local url=${2}
  local branch=${3:-master}

  if [ ! -d ${dir}/.git ]; then
    echo "Cloning ${url} to ${dir}"
    git clone -q --no-single-branch --depth ${CLONE_DEPTH} ${url} ${dir}
  else
    echo "Updating ${dir}"
    pushd ${dir};
    git remote rm origin
    git remote add origin ${url}
    git fetch -q --depth ${CLONE_DEPTH} --update-shallow origin
    popd
  fi

  pushd ${dir}
  git checkout -fq ${branch}
  popd
}

# Check out LLVM
clone_or_update llvm https://github.com/Microsoft/checkedc-llvm ${CHECKEDC_LLVM_HEAD:-master}

# Check out Clang
clone_or_update llvm/tools/clang https://github.com/Microsoft/checkedc-clang ${CHECKEDC_CLANG_HEAD:-master}

# Check out CheckedC Spec
clone_or_update llvm/projects/checkedc-wrapper/checkedc https://github.com/Microsoft/checkedc.git ${CHECKEDC_SPEC_HEAD:-master}

# Check out Test Suite
clone_or_update llvm-test-suite https://github.com/Microsoft/checkedc-llvm-test-suite ${CHECKEDC_TESTS_HEAD:-master}

set +ue
set +o pipefail
