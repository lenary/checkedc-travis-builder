#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=99cd57abcd044ad8c176bbff3591139a25a7c53a
export CHECKEDC_TESTS_HEAD=b995113921af682494ec0aa2cd4c8d6987fc2c24

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
