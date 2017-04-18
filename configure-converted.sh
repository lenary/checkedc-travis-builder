#!/usr/bin/env bash

export CHECKEDC_CLANG_HEAD=7150247664d3ead1ce43cc0bbc57d1331f107baf
export CHECKEDC_TESTS_HEAD=8a195fab046ad85a28975fe577919e20256483dd

export EXTRA_TEST_ARGS="${EXTRA_TEST_ARGS} --cflags -fcheckedc-extension"
