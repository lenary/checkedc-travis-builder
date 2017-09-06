#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=2a168085a3e7b1fafddba32e96d26f2c7700b167
export CHECKEDC_TESTS_HEAD=4c2b02118799ceff661361c54169db4a3d23a46b

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
