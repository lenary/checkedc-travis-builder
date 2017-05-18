#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=d4f8a8e58102096264da206e77ace211f0aa9041
export CHECKEDC_TESTS_HEAD=3be5abccb5d3a0a81552f903a7b53707a37a854f

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
