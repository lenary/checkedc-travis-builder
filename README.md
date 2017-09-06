# Superseded

This repo has become its own lovecraftian mess.

It is the source of some build scripts for benchmarking Checked C inside
a specific docker container.

Note the default branch is `benchmarking`.

## Setup/Requirements

You'll need:

- OS X or Linux. Set the `BUILD_OS_NAME` env variable to the string `linux` or `osx`.
- Run `install-pkgs.sh`. If this doesn't work, take a look at the script and follow what it's attempting to do
  - installing required system packages
  - installing LNT from our own repo, so that it's available globally
  - There is a half-requirement on cmake 3.7+, if you don't have it, then later scripts will download a copy.

## Running the benchmarks

- Make sure `configure-common.sh`, `configure-baseline.sh` and `configure-converted.sh` have the right SHAs in them
  to reflect the repo versions you want to test. You may also have to play with the urls in `checkout.sh`. This is the biggest annoyance
  and setting them to a branch name could be much easier.
- Run `benchmark.sh <checkout dir> <build dir> <results dir> <repo branch>` where:
  - `<checkout dir>` is where you want the repos to all be checked out.
  - `<build dir>` is where you want all the builds to happen. There will be subdirs in this for the llvm build dir, and for the lnt sandbox dir.
  - `<results dir>` is where you want the dir containing the lnt db (containing benchmark results) and a build log to go.
  - `<repo branch>` is the branch of THIS repository that you want to build. `benchmark.sh` will update the scripts to follow this branch, before    invoking them. This means it can change the contents of all but the `benchmark.sh` script without needing to update a docker image. 

- This will drop a timestamped directory into `<results dir>` containging a log of what was run, and a lnt results dir. This dir is standalone, rsync it from the benchmark runner back to your own computer, and run `lnt runserver <synced results dir>/<timestamp>/llvm.lnt.db` to get the web interface of the results. If you have the server running on localhost:8000 (the default), you can see the results here:
  - [Ptrdist](http://localhost:8000/db_default/v4/nts/4?show_delta=yes&show_previous=yes&show_stddev=yes&show_all=yes&show_small_diff=yes&num_comparison_runs=0&test_filter=&test_min_value_filter=&aggregation_fn=median&MW_confidence_lv=0.05&compare_to=2&submit=Update)
  - [Olden](http://localhost:8000/db_default/v4/nts/3?show_delta=yes&show_previous=yes&show_stddev=yes&show_all=yes&show_small_diff=yes&num_comparison_runs=0&test_filter=&test_min_value_filter=&aggregation_fn=median&MW_confidence_lv=0.05&compare_to=1&submit=Update)
