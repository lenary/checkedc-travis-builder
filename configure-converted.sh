#!/usr/bin/env bash

export CHECKEDC_CLANG_BRANCH=master
export CHECKEDC_TESTS_BRANCH=master

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
