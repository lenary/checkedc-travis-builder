#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=0121c97c5d372f5657cedba8395ac8d7ea9d9ee1
export CHECKEDC_TESTS_HEAD=64200b474e3703b5b51eea56bba2c70ccfa86c1b

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
