#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=e285764595149855fd96ee19f9d3d9181b48d05b
export CHECKEDC_TESTS_HEAD=8d76f1e03b60b194ad8e6b3953c9fe8f5e357dd3

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
