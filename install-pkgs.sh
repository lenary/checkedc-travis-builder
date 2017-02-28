#!/usr/bin/env bash

set -ue
set -o pipefail

# If we're on travis, set BUILD_OS_NAME to be cross-build-system
if [ -n "${TRAVIS_OS_NAME}" ]; then
  export BUILD_OS_NAME=$TRAVIS_OS_NAME
fi

# Installs system packages.
# TODO: python 2.7?
# TODO: python-virtualenv?
if [ "${BUILD_OS_NAME}" = "linux" ]; then
  sudo apt-get install tcl bison zlib1g-dev
elif [ "${BUILD_OS_NAME}" = "osx" ]; then
  # tcl and zlib1g-dev should be installed by default
  brew install bison
else
  echo "Unknown Platform"
  exit 1
fi

