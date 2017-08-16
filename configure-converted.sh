#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=0121c97c5d372f5657cedba8395ac8d7ea9d9ee1
export CHECKEDC_TESTS_HEAD=8d76f1e03b60b194ad8e6b3953c9fe8f5e357dd3

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
