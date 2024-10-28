#!/usr/bin/env bats

set -euo pipefail

load "$BATS_PLUGIN_PATH/load.bash"

# Uncomment the following line to debug stub failures
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

git config --global user.email "diff-filter@buildkite.tester"
git config --global user.name "diff-filter"

plugindir="$PWD"
testdir="$PWD/tests/testdir"

randomStr() {
  str=()
  for c in {a..z} {A..Z} {0..9}; do
     str[$RANDOM]=$c
  done
  printf %s ${str[@]::6} $'\n'
}

patchfile() {
  fname="$1"
  if [[ -f "$fname" ]]; then
    echo "Patching file '$fname'"
    rngstr=$(randomStr)
    echo "$rngstr" >> "$fname"
  else
    echo "Skipping unknown file '$fname'"
  fi
}

patchfiles() {
  for fname in "$@"; do
    patchfile $fname
  done
  git add .
  git commit -m "patch"
}

setup_testdir() {
  dir=$(mktemp -d)
  cd "$dir"
  cp -r "$testdir/." "./"
  git init .
  git add .
  git commit -m "init commit"
}

export BUILDKITE_PULL_REQUEST="false"
export BUILDKITE_PULL_REQUEST_BASE_BRANCH="main"
TRIGGERED=1
NOT_TRIGGERED=0

@test "One file changed" {
  setup_testdir
  patchfiles "./docs/doc1.md"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="one-file"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="docs/doc1.md"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "One file changed, glob pattern 1" {
  setup_testdir
  patchfiles "./docs/doc1.md"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="one-file"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="docs/*.md"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "One file changed, glob pattern 2" {
  setup_testdir
  patchfiles "./docs/doc1.md"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="one-file"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="*/*.md"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "One file changed, glob pattern 3" {
  setup_testdir
  patchfiles "./docs/doc1.md"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="one-file"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="**/*.md"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "One file changed, glob pattern 4" {
  setup_testdir
  patchfiles "./docs/doc1.md"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="one-file"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="*"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Two files changed" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="two-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="docs/doc1.md"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_1="docs/doc2.md"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Two files changed, glob pattern 1" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="two-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="docs/*.md"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Two files changed, glob pattern 2" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="two-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="*/*.md"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Two files changed, glob pattern 3" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="two-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="**/*.md"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Two files changed, glob pattern 4" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="two-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="*"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Three files changed" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="three-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="docs/doc1.md"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_1="docs/doc2.md"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_2="base/base1.jl"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Three files changed, glob pattern 1" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="three-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="*"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Three files changed, glob pattern 2" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="three-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="docs/*"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Three files changed, glob pattern 3" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="three-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="base/*"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Three files changed, glob pattern 4" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="three-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="base/*"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_1="docs/*"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Three files changed, glob pattern 5" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="three-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="**/*.jl"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_1="**/*.md"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Four files changed" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl" "./base/compiler/comp1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="four-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="docs/doc1.md"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_1="docs/doc2.md"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_2="base/base1.jl"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_2="base/compiler/comp1.jl"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Four files changed, glob pattern 1" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl" "./base/compiler/comp1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="four-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="base/compiler/*"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Four files changed, glob pattern 2" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl" "./base/compiler/comp1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="four-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="*"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Four files changed, but ignore some 1" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl" "./base/compiler/comp1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="four-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="*"
  export BUILDKITE_PLUGIN_DIFF_FILTER_IGNORE_0="docs/*"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Four files changed, but ignore some 2" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl" "./base/compiler/comp1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="four-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="*"
  export BUILDKITE_PLUGIN_DIFF_FILTER_IGNORE_0="**/*.md"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Four files changed, but ignore some 3" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl" "./base/compiler/comp1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="four-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="*"
  export BUILDKITE_PLUGIN_DIFF_FILTER_IGNORE_0="**/*.jl"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $TRIGGERED
}

@test "Four files changed, but ignore some 4" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl" "./base/compiler/comp1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="four-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="*"
  export BUILDKITE_PLUGIN_DIFF_FILTER_IGNORE_0="*"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $NOT_TRIGGERED
}

@test "Four files changed, but ignore some 5" {
  setup_testdir
  patchfiles "./docs/doc1.md" "./docs/doc2.md" "./base/base1.jl" "./base/compiler/comp1.jl"

  export BUILDKITE_PLUGIN_DIFF_FILTER_NAME="four-files"
  export BUILDKITE_PLUGIN_DIFF_FILTER_MATCH_0="*"
  export BUILDKITE_PLUGIN_DIFF_FILTER_IGNORE_0="docs/*"
  export BUILDKITE_PLUGIN_DIFF_FILTER_IGNORE_1="base/*"

  run "$plugindir/hooks/diff-filter-impl"
  assert_success
  assert_line -n -1 $NOT_TRIGGERED
}
