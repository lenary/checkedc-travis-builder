#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=e285764595149855fd96ee19f9d3d9181b48d05b
export CHECKEDC_TESTS_HEAD=70a2dace9cfc45efe1a12f201f66fb49bda4f34f

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
