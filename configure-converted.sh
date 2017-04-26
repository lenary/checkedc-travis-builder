#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=7150247664d3ead1ce43cc0bbc57d1331f107baf
export CHECKEDC_TESTS_HEAD=cffd9d802aabda3ea8e50e48039f91c413ef598f

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
