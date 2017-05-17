#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=50265114f81d0c11a6b565f5618e4f74df858140
export CHECKEDC_TESTS_HEAD=9c100c8bbee86b98c92ff9ee08c96bcd49d01460

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
