#!/usr/bin/env bash

set -ue
set -o pipefail

: ${CHECKEDC_SCRIPTS_DIR:=$1}
: ${CHECKEDC_SCRIPTS_BRANCH:=$2}

pushd $CHECKEDC_SCRIPTS_DIR;
git fetch -q origin;
git checkout -qf origin/${CHECKEDC_SCRIPTS_BRANCH};
popd

echo "Scripts Updated to ${CHECKEDC_SCRIPTS_BRANCH}";


set +ue
set +o pipefail
