#!/usr/bin/env bash

set -ue
set -o pipefail

# Argument Parsing
: ${CHECKOUT_DIR:=$1}
: ${BUILD_DIR:=$2}
: ${RESULTS_DIR:=$3}
: ${SCRIPTS_BRANCH:=${4:-benchmarking}}

# Close stdin, Redirect all future stdout/stderr to a log in RESULTS_DIR
exec </dev/null
exec 1>${RESULTS_DIR}/checkedc-bm.log
exec 2>&1

: ${BUILD_OS_NAME:=linux}
SCRIPTS_DIR=$(dirname ${BASH_SOURCE[0]})
LNT_DB_DIR="${RESULTS_DIR}/llvm.lnt.db"

export BUILD_OS_NAME
export CHECKOUT_DIR
export BUILD_DIR
export RESULTS_DIR
export SCRIPTS_DIR
export LNT_DB_DIR

# Makes sure all the scripts in here are up to date with a given branch
./update-scripts.sh ${SCRIPTS_DIR} ${SCRIPTS_BRANCH}

# Sets some environment variables that are useful
# Installs cmake too.
source ./setup.sh

# Baseline
source ./configure-common.sh
source ./configure-baseline.sh
./benchmark-run.sh baseline

# Converted
source ./configure-common.sh
source ./configure-converted.sh
./benchmark-run.sh converted

# Export Results
zip -r ${RESULTS_DIR}/lnt_db.zip ${LNT_DB_DIR}

set +ue
set +o pipefail
