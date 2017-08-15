#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=0121c97c5d372f5657cedba8395ac8d7ea9d9ee1
export CHECKEDC_TESTS_HEAD=c5ff8c3f68875d9173d806420234099acef1df67

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
