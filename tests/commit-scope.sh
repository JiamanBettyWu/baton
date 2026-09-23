#!/bin/bash

set -eu

TMP_ROOT=$(mktemp -d)
trap 'rm -rf "$TMP_ROOT"' EXIT

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

init_repo() {
  git -C "$1" init -q
  git -C "$1" config user.name 'Baton Test'
  git -C "$1" config user.email 'baton-test@example.com'
  mkdir -p "$1/src"
  printf '%s\n' 'baseline feature' > "$1/src/feature.py"
  git -C "$1" add src/feature.py
  git -C "$1" commit -q -m 'Initial fixture'
}

assert_records_only_commit() {
  COMMITTED=$(git -C "$1" diff-tree --no-commit-id --name-only -r HEAD | sort)
  EXPECTED=$(printf '%s\n' 'SESSIONS.md' 'TODO.md')
  [ "$COMMITTED" = "$EXPECTED" ] || fail "unexpected committed paths: $COMMITTED"

  STAGED=$(git -C "$1" diff --cached --name-only)
  [ "$STAGED" = 'src/feature.py' ] || fail "unrelated staged path was not preserved: $STAGED"
}

# Existing record files: decide updates records while source work is staged.
EXISTING="$TMP_ROOT/existing-records"
mkdir -p "$EXISTING"
init_repo "$EXISTING"
printf '%s\n' '# TODO' > "$EXISTING/TODO.md"
printf '%s\n' '# Session log' > "$EXISTING/SESSIONS.md"
git -C "$EXISTING" add TODO.md SESSIONS.md
git -C "$EXISTING" commit -q -m 'Add records'

printf '%s\n' 'staged feature work' > "$EXISTING/src/feature.py"
git -C "$EXISTING" add src/feature.py
printf '%s\n' '# TODO' '' 'Decision resolved' > "$EXISTING/TODO.md"
printf '%s\n' '# Session log' '' 'Decision recorded' > "$EXISTING/SESSIONS.md"
git -C "$EXISTING" add TODO.md SESSIONS.md
git -C "$EXISTING" commit -q --only -m 'Decision D1: choose A' -- TODO.md SESSIONS.md
assert_records_only_commit "$EXISTING"

# New record files: the first handoff must also exclude prior staged work.
NEW="$TMP_ROOT/new-records"
mkdir -p "$NEW"
init_repo "$NEW"
printf '%s\n' 'staged feature work' > "$NEW/src/feature.py"
git -C "$NEW" add src/feature.py
printf '%s\n' '# TODO' > "$NEW/TODO.md"
printf '%s\n' '# Session log' > "$NEW/SESSIONS.md"
git -C "$NEW" add TODO.md SESSIONS.md
git -C "$NEW" commit -q --only -m 'Handoff: first fixture' -- TODO.md SESSIONS.md
assert_records_only_commit "$NEW"

echo 'commit-scope smoke tests passed'
