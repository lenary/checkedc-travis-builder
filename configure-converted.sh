#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=f53948738e4ffdf6b0435a7d1155a200b3925cd4
export CHECKEDC_TESTS_HEAD=7dffb8c3f525b8283eef91a3fd694dbe46640473

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
