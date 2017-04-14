#!/usr/bin/env bash

set -ue
set -o pipefail

# Argument Parsing
: ${CHECKOUT_DIR:=$1}
: ${BUILD_DIR:=$2}
: ${RESULTS_DIR:=$3}
: ${SCRIPTS_BRANCH:=${4:-benchmarking}}

SCRIPTS_DIR=$(dirname ${BASH_SOURCE[0]})
BM_TIME=$(date -Iminutes | tr 'T:+' '---')

echo "Building On: ${BUILD_OS_NAME:=linux}"
echo "Started at: ${BM_TIME}"

echo "Results Dir: ${RESULTS_DIR}/${BM_TIME}"
mkdir -p "${RESULTS_DIR}/${BM_TIME}"
LNT_DB_DIR="${RESULTS_DIR}/${BM_TIME}/llvm.lnt.db"

# Close stdin, Redirect all future stdout/stderr to a log in RESULTS_DIR
# exec </dev/null # We can't do anything with stdin because if we do make dies
exec 1>${RESULTS_DIR}/${BM_TIME}/checkedc-bm.log
exec 2>&1

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
zip -r ${RESULTS_DIR}/${BM_TIME}/lnt-db.zip ${LNT_DB_DIR}

touch ${RESULTS_DIR}/${BM_TIME}/DONE

set +ue
set +o pipefail
