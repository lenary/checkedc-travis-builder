#!/usr/bin/env bash

set -ue
set -o pipefail

# Installs system packages.
if [ "${BUILD_OS_NAME}" = "linux" ]; then
  apt-get install build-essential clang make curl wget
  apt-get install linux-tools-common linux-tools-generic linux-tools-`uname -r`
  apt-get install tcl bison zlib1g-dev
  apt-get install python python-dev
  pip install six==1.10.0 # Just in case
elif [ "${BUILD_OS_NAME}" = "osx" ]; then
  # tcl and zlib1g-dev should be installed by default
  brew install bison
else
  echo "Unknown Platform"
  exit 1
fi

# TODO: Check This actually works
lnt_dir=${TMPDIR}/lnt
git clone https://github.com/Microsoft/checkedc-lnt.git ${lnt_dir}
pushd ${lnt_dir}
python setup.py install
popd
rm -fr $lnt_dir

set +ue
set +o pipefail
