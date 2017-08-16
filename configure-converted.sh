#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=0121c97c5d372f5657cedba8395ac8d7ea9d9ee1
export CHECKEDC_TESTS_HEAD=dee709367d7091c0a69e745368b23630556cdf75

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
