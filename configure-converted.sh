#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=2a168085a3e7b1fafddba32e96d26f2c7700b167
export CHECKEDC_TESTS_HEAD=32b68013a3b92b814ab2e8be6f38e118c0a56a88

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
