#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=2a168085a3e7b1fafddba32e96d26f2c7700b167
export CHECKEDC_TESTS_HEAD=86265e553d61f08a6e89187cb267a9c5ca3ee3f5

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
