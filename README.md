# Build System for Checked C

Because Building Clang/LLVM is actually really complicated, we have
this repository as a completely seperate space to build within.

Effectively, we clone all the repos we want to build into the correct
structure within this directory, and then build. This works because it means we can
have a build directory that isn't within the git tree for llvm/clang. This also means
we can run the LLVM external test suite (or our fork of it)

The final aim is that any changes to the repositories in the "Built Repos" list
will trigger a build in this repo, correctly checking out the branch that we want,
and choosing master for all other branches.

## Built Repos

- `checkedc-llvm`
- `checkedc-clang`
- `checkedc`
- `checkedc-llvm-test-suite`

## Build Steps

All the following commands should be run within the current directory.

- On non-travis platforms, run `install-pkgs.sh`, it may need sudo, and can probably just be done once.
- Run `install.sh`, this installs things travis can't install for us, like the correct version of cmake
  and sets up a python virtualenv for LNT.
- Run `checkout.sh`, which checks out all the repositories into the correct directory structure, and
  checks out the correct branches for the build. It then uses cmake to make a build directory, installs lnt
  into the virtualenv that `install.sh` created.
- Run `make -j$(nproc) --no-print-directory -C llvm.build`, which goes into the llvm.build directory
  and builds all the executables, including clang.
- Run `make -j$(nproc) --no-print-directory -C llvm.build --keep-going check-checkedc check-clang`,
  which goes into llvm.build and runs the checkedc tests and clang regression tests
- Run `./llvm.lnt.ve/bin/lnt runtest nt -j $(nproc) --sandbox ./llvm.lnt.sandbox --cc ./llvm.build/bin/clang --test-suite ./llvm-test-suite --cflags -fcheckedc-extension`,
  which runs the full llvm test suite, benchmarks and all.

## Requirements

The scripts assume Linux (Ubuntu 14.04) or OS X. The environment variable
`BUILD_OS_NAME` should be set to 'linux' or 'osx' respectively
(the scripts will find the correct value for this if they're running on travis-ci.org).

Currently we assume that you have the following installed already:
- a C/C++ compiler (clang/gcc)
- Make
- python 2.7 and virtualenv

## Caching

On travis we use ccache (which is not required), as well as caching the following directories:

- `llvm` our clone of checkedc-llvm (with the checkedc-clang and checkedc repos as subdirectories)
- `llvm-test-suite` our clone of checkedc-llvm-test-suite
- `lnt` our clone of lnt
- `llvm.build` our llvm build dir
- `llvm.lnt.sandbox` our LNT sandbox dir
- `llvm.lnt.ve` the virtualenv directory for LNT
- `cmake` our local version of cmake, if it exists
