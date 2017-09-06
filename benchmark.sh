#!/usr/bin/env bash

set -ue
set -o pipefail

# Argument Parsing
: ${CHECKOUT_DIR:=$1}
: ${BUILD_DIR:=$2}
: ${RESULTS_DIR:=$3}
: ${SCRIPTS_BRANCH:=${4:-benchmarking}}

SCRIPTS_DIR=$(dirname ${BASH_SOURCE[0]})
BM_TIME=$(date -Iseconds | tr 'T:+' '---')

mkdir -p "${RESULTS_DIR}/${BM_TIME}"
LNT_DB_DIR="${RESULTS_DIR}/${BM_TIME}/llvm.lnt.db"

# Close stdin, Redirect all future stdout/stderr to a log in RESULTS_DIR
# exec </dev/null # We can't do anything with stdin because if we do make dies
exec 1> >(tee ${RESULTS_DIR}/${BM_TIME}/checkedc-bm.log)
exec 2>&1

# Print info for logfile
echo "Building On: ${BUILD_OS_NAME}"
echo "Checkout Dir: ${CHECKOUT_DIR}"
echo "Build Dir: ${BUILD_DIR}"
echo "Started at: ${BM_TIME}"
echo "Run Results Dir: ${RESULTS_DIR}/${BM_TIME}"
echo "Scripts Branch: ${SCRIPTS_BRANCH}"

# Mark as Running
touch ${RESULTS_DIR}/${BM_TIME}/RUNNING

export BUILD_OS_NAME
export CHECKOUT_DIR
export BUILD_DIR
export RESULTS_DIR
export SCRIPTS_DIR
export LNT_DB_DIR

# Makes sure all the scripts in here are up to date with a given branch
${SCRIPTS_DIR}/update-scripts.sh ${SCRIPTS_DIR} ${SCRIPTS_BRANCH}

# Sets some environment variables that are useful
# Installs cmake too.
source ${SCRIPTS_DIR}/setup.sh

# Baseline
source ${SCRIPTS_DIR}/configure-common.sh
source ${SCRIPTS_DIR}/configure-baseline.sh
${SCRIPTS_DIR}/benchmark-run.sh baseline

# Converted
source ${SCRIPTS_DIR}/configure-common.sh
source ${SCRIPTS_DIR}/configure-converted.sh
${SCRIPTS_DIR}/benchmark-run.sh converted

# Mark as Done
rm ${RESULTS_DIR}/${BM_TIME}/RUNNING
touch ${RESULTS_DIR}/${BM_TIME}/DONE

echo "Run Completed: ${RESULTS_DIR}/${BM_TIME}"
echo "Ended At: $(date -Iseconds | tr 'T:+' '---')"

set +ue
set +o pipefail
