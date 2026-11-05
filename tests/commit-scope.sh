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

# Partly ignored records: the ignored file is left out, the rest is committed.
IGNORED="$TMP_ROOT/ignored-records"
mkdir -p "$IGNORED"
init_repo "$IGNORED"
printf '%s\n' 'TODO.md' > "$IGNORED/.gitignore"
git -C "$IGNORED" add .gitignore
git -C "$IGNORED" commit -q -m 'Keep TODO local'
printf '%s\n' 'staged feature work' > "$IGNORED/src/feature.py"
git -C "$IGNORED" add src/feature.py
printf '%s\n' '# TODO' > "$IGNORED/TODO.md"
printf '%s\n' '# Session log' > "$IGNORED/SESSIONS.md"

TO_COMMIT=''
for path in TODO.md SESSIONS.md; do
  STATUS=0
  git -C "$IGNORED" check-ignore -q "$path" || STATUS=$?
  case "$STATUS" in
    0) ;;
    1) TO_COMMIT="$TO_COMMIT $path" ;;
    *) fail "check-ignore errored on $path (exit $STATUS)" ;;
  esac
done
[ "$TO_COMMIT" = ' SESSIONS.md' ] || fail "unexpected paths to commit:$TO_COMMIT"

# shellcheck disable=SC2086 # word splitting of the path list is intended
git -C "$IGNORED" add $TO_COMMIT
# shellcheck disable=SC2086
git -C "$IGNORED" commit -q --only -m 'Handoff: partly ignored' -- $TO_COMMIT
COMMITTED=$(git -C "$IGNORED" diff-tree --no-commit-id --name-only -r HEAD)
[ "$COMMITTED" = 'SESSIONS.md' ] || fail "unexpected committed paths: $COMMITTED"
[ "$(git -C "$IGNORED" diff --cached --name-only)" = 'src/feature.py' ] ||
  fail 'unrelated staged path was not preserved'
git -C "$IGNORED" ls-files --error-unmatch TODO.md >/dev/null 2>&1 &&
  fail 'ignored TODO.md was committed'

# A tracked file that matches an ignore pattern is not ignored: commit proceeds.
printf '%s\n' 'SESSIONS.md' >> "$IGNORED/.gitignore"
STATUS=0
git -C "$IGNORED" check-ignore -q SESSIONS.md || STATUS=$?
[ "$STATUS" -eq 1 ] || fail "tracked SESSIONS.md reported as ignored (exit $STATUS)"

# Outside a repository, check-ignore errors out (128); that is not "ignored".
OUTSIDE="$TMP_ROOT/not-a-repo"
mkdir -p "$OUTSIDE"
STATUS=0
GIT_CEILING_DIRECTORIES="$TMP_ROOT" git -C "$OUTSIDE" check-ignore -q TODO.md 2>/dev/null || STATUS=$?
[ "$STATUS" -eq 128 ] || fail "check-ignore outside a repo exited $STATUS, expected 128"

echo 'commit-scope smoke tests passed'
