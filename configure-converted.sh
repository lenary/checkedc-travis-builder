#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=e285764595149855fd96ee19f9d3d9181b48d05b
export CHECKEDC_TESTS_HEAD=e8d43a023207ce751f1e8e8aecd43eaeddc2c41c

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
