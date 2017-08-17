#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=e285764595149855fd96ee19f9d3d9181b48d05b
export CHECKEDC_TESTS_HEAD=64200b474e3703b5b51eea56bba2c70ccfa86c1b

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
