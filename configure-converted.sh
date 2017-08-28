#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=e285764595149855fd96ee19f9d3d9181b48d05b
export CHECKEDC_TESTS_HEAD=32b68013a3b92b814ab2e8be6f38e118c0a56a88

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
