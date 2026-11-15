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

# Parked decisions: a new PARKED.md joins the records-only commit.
PARKED="$TMP_ROOT/parked-records"
mkdir -p "$PARKED"
init_repo "$PARKED"
printf '%s\n' '# TODO' '' '## Open decisions' '' '### D1: question' > "$PARKED/TODO.md"
printf '%s\n' '# Session log' > "$PARKED/SESSIONS.md"
git -C "$PARKED" add TODO.md SESSIONS.md
git -C "$PARKED" commit -q -m 'Add records'

assert_parked_commit() {
  COMMITTED=$(git -C "$PARKED" diff-tree --no-commit-id --name-only -r HEAD | sort)
  EXPECTED=$(printf '%s\n' 'PARKED.md' 'SESSIONS.md' 'TODO.md')
  [ "$COMMITTED" = "$EXPECTED" ] || fail "unexpected committed paths: $COMMITTED"
  [ "$(git -C "$PARKED" diff --cached --name-only)" = 'src/feature.py' ] ||
    fail 'unrelated staged path was not preserved'
}

printf '%s\n' 'staged feature work' > "$PARKED/src/feature.py"
git -C "$PARKED" add src/feature.py
printf '%s\n' '# Parked decisions' '' '### D1: question' > "$PARKED/PARKED.md"
printf '%s\n' '# TODO' '' '## Parked decisions' '' '- D1' > "$PARKED/TODO.md"
printf '%s\n' '# Session log' '' 'D1 parked' > "$PARKED/SESSIONS.md"
git -C "$PARKED" add TODO.md SESSIONS.md PARKED.md
git -C "$PARKED" commit -q --only -m 'Decision D1: parked until later' -- TODO.md SESSIONS.md PARKED.md
assert_parked_commit

# Settling the last parked decision deletes PARKED.md; the commit records that.
rm "$PARKED/PARKED.md"
printf '%s\n' '# TODO' > "$PARKED/TODO.md"
printf '%s\n' '# Session log' '' 'D1 parked' 'D1 chose A' > "$PARKED/SESSIONS.md"
git -C "$PARKED" add TODO.md SESSIONS.md PARKED.md
git -C "$PARKED" commit -q --only -m 'Decision D1: choose A' -- TODO.md SESSIONS.md PARKED.md
assert_parked_commit
git -C "$PARKED" ls-files --error-unmatch PARKED.md >/dev/null 2>&1 &&
  fail 'deleted PARKED.md is still tracked'

# Default local-only journal: the first handoff ignores the journal and its
# archive, and commits TODO.md plus the .gitignore lines it added.
LOCAL="$TMP_ROOT/local-journal"
mkdir -p "$LOCAL/sessions"
init_repo "$LOCAL"
printf '%s\n' 'staged feature work' > "$LOCAL/src/feature.py"
git -C "$LOCAL" add src/feature.py
printf '%s\n' 'SESSIONS.md' 'sessions/' > "$LOCAL/.gitignore"
printf '%s\n' '# TODO' > "$LOCAL/TODO.md"
printf '%s\n' '# Session log' > "$LOCAL/SESSIONS.md"
printf '%s\n' '# Session log' > "$LOCAL/sessions/2026-01-01--2026-02-01.md"

TO_COMMIT=''
for path in TODO.md SESSIONS.md sessions/2026-01-01--2026-02-01.md .gitignore; do
  STATUS=0
  git -C "$LOCAL" check-ignore -q "$path" || STATUS=$?
  case "$STATUS" in
    0) ;;
    1) TO_COMMIT="$TO_COMMIT $path" ;;
    *) fail "check-ignore errored on $path (exit $STATUS)" ;;
  esac
done
[ "$TO_COMMIT" = ' TODO.md .gitignore' ] || fail "unexpected paths to commit:$TO_COMMIT"

# shellcheck disable=SC2086 # word splitting of the path list is intended
git -C "$LOCAL" add $TO_COMMIT
# shellcheck disable=SC2086
git -C "$LOCAL" commit -q --only -m 'Handoff: local journal' -- $TO_COMMIT
COMMITTED=$(git -C "$LOCAL" diff-tree --no-commit-id --name-only -r HEAD | sort)
EXPECTED=$(printf '%s\n' '.gitignore' 'TODO.md')
[ "$COMMITTED" = "$EXPECTED" ] || fail "unexpected committed paths: $COMMITTED"
[ "$(git -C "$LOCAL" diff --cached --name-only)" = 'src/feature.py' ] ||
  fail 'unrelated staged path was not preserved'
[ -z "$(git -C "$LOCAL" ls-files SESSIONS.md sessions)" ] ||
  fail 'local-only journal was committed'

# Learnings: LEARNINGS.md is committed with TODO.md while the journal stays
# local-only, and a later split adds the learnings/ files by path.
LEARN="$TMP_ROOT/learnings-records"
mkdir -p "$LEARN"
init_repo "$LEARN"
printf '%s\n' 'SESSIONS.md' 'sessions/' > "$LEARN/.gitignore"
git -C "$LEARN" add .gitignore
git -C "$LEARN" commit -q -m 'Keep journal local'
printf '%s\n' 'staged feature work' > "$LEARN/src/feature.py"
git -C "$LEARN" add src/feature.py
printf '%s\n' '# TODO' > "$LEARN/TODO.md"
printf '%s\n' '# Session log' > "$LEARN/SESSIONS.md"
printf '%s\n' '# Learnings' '' '## Index' '- **Theme one** — scope' \
  '- **Theme two** — scope' '' '## Theme one' '- **2026-01-01** — fact one' \
  '- **2026-01-02** — fact two' '' '## Theme two' \
  '- **2026-01-03** — fact three' > "$LEARN/LEARNINGS.md"

TO_COMMIT=''
for path in TODO.md SESSIONS.md LEARNINGS.md; do
  STATUS=0
  git -C "$LEARN" check-ignore -q "$path" || STATUS=$?
  case "$STATUS" in
    0) ;;
    1) TO_COMMIT="$TO_COMMIT $path" ;;
    *) fail "check-ignore errored on $path (exit $STATUS)" ;;
  esac
done
[ "$TO_COMMIT" = ' TODO.md LEARNINGS.md' ] || fail "unexpected paths to commit:$TO_COMMIT"

# shellcheck disable=SC2086 # word splitting of the path list is intended
git -C "$LEARN" add $TO_COMMIT
# shellcheck disable=SC2086
git -C "$LEARN" commit -q --only -m 'Handoff: first learnings' -- $TO_COMMIT
COMMITTED=$(git -C "$LEARN" diff-tree --no-commit-id --name-only -r HEAD | sort)
EXPECTED=$(printf '%s\n' 'LEARNINGS.md' 'TODO.md')
[ "$COMMITTED" = "$EXPECTED" ] || fail "unexpected committed paths: $COMMITTED"
[ "$(git -C "$LEARN" diff --cached --name-only)" = 'src/feature.py' ] ||
  fail 'unrelated staged path was not preserved'

# The split: the skill compares the sorted non-blank, non-heading lines of the
# theme sections before with the theme files after. Annotation lines and
# continuation lines must survive, and index lines must not be counted.
before_lines() {
  awk '/^## /{keep = ($0 != "## Index")} keep && NF && !/^#/' "$1" | sort
}
after_lines() {
  cat "$@" | awk 'NF && !/^#/' | sort
}
printf '%s\n' '# Learnings' '' 'How to keep this file:' '- header rule' '' \
  '## Index' '- **Theme one** — scope' '- **Theme two** — scope' '' \
  '## Theme one' '- **2026-01-01** — fact one' \
  '  continues on a second line' \
  '  Outdated as of 2026-02-01: fact one changed' \
  '- **2026-01-02** — fact two' '  Verified 2026-02-02' '' '## Theme two' \
  '- **2026-01-03** — fact three' > "$LEARN/LEARNINGS.md"
before_lines "$LEARN/LEARNINGS.md" > "$TMP_ROOT/before"
[ "$(wc -l < "$TMP_ROOT/before" | tr -d ' ')" -eq 6 ] ||
  fail "expected 6 lines to move, got: $(cat "$TMP_ROOT/before")"

mkdir -p "$LEARN/learnings"
printf '%s\n' '# Theme one' '' '- **2026-01-01** — fact one' \
  '  continues on a second line' \
  '  Outdated as of 2026-02-01: fact one changed' \
  '- **2026-01-02** — fact two' '  Verified 2026-02-02' \
  > "$LEARN/learnings/theme-one.md"
printf '%s\n' '# Theme two' '' '- **2026-01-03** — fact three' \
  > "$LEARN/learnings/theme-two.md"
printf '%s\n' '# Learnings' '' '## Index' \
  '- **[Theme one](learnings/theme-one.md)** — scope' \
  '- **[Theme two](learnings/theme-two.md)** — scope' > "$LEARN/LEARNINGS.md"
after_lines "$LEARN"/learnings/*.md | cmp -s - "$TMP_ROOT/before" ||
  fail 'a faithful split was reported as lossy'

# A split that drops an annotation line is caught.
grep -v 'Outdated as of' "$LEARN/learnings/theme-one.md" > "$TMP_ROOT/lossy.md"
after_lines "$TMP_ROOT/lossy.md" "$LEARN/learnings/theme-two.md" |
  cmp -s - "$TMP_ROOT/before" && fail 'a dropped annotation line was not caught'

# A file with no theme sections yields nothing to move: the skill stops.
printf '%s\n' '# Devlog' '' 'Append-only.' '' '### 2026-01-01' 'long entry' \
  > "$TMP_ROOT/dated-log.md"
[ -z "$(before_lines "$TMP_ROOT/dated-log.md")" ] ||
  fail 'a dated log was treated as theme sections'

git -C "$LEARN" add LEARNINGS.md learnings/theme-one.md learnings/theme-two.md
git -C "$LEARN" commit -q --only -m 'Handoff: split learnings' -- \
  LEARNINGS.md learnings/theme-one.md learnings/theme-two.md
COMMITTED=$(git -C "$LEARN" diff-tree --no-commit-id --name-only -r HEAD | sort)
EXPECTED=$(printf '%s\n' 'LEARNINGS.md' 'learnings/theme-one.md' 'learnings/theme-two.md')
[ "$COMMITTED" = "$EXPECTED" ] || fail "unexpected committed paths: $COMMITTED"
[ "$(git -C "$LEARN" diff --cached --name-only)" = 'src/feature.py' ] ||
  fail 'unrelated staged path was not preserved'

echo 'commit-scope smoke tests passed'
