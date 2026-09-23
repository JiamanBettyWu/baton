#!/bin/bash

set -eu

REPO_ROOT=$(cd "$(dirname "$0")/.." && pwd)
HOOK="$REPO_ROOT/hooks/session-start.sh"
HOOK_COMMAND=$(python3 -c 'import json, sys; print(json.load(open(sys.argv[1]))["hooks"]["SessionStart"][0]["hooks"][0]["command"])' "$REPO_ROOT/hooks/hooks.json")
TMP_ROOT=$(mktemp -d)
trap 'rm -rf "$TMP_ROOT"' EXIT

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

assert_contains() {
  case "$1" in
    *"$2"*) ;;
    *) fail "expected output to contain: $2" ;;
  esac
}

assert_not_contains() {
  case "$1" in
    *"$2"*) fail "expected output not to contain: $2" ;;
    *) ;;
  esac
}

write_todo() {
  MARKER="${2:-TODO-SENTINEL}"
  mkdir -p "$1"
  printf '%s\n' '# TODO' '' '## Current state' "$MARKER" > "$1/TODO.md"
}

write_sessions() {
  mkdir -p "$1"
  printf '%s\n' '# Session log' '' '## 2026-09-22 (latest fixture)' \
    'LATEST-JOURNAL-BODY' '' '## 2026-09-21 (older fixture)' \
    'OLDER-JOURNAL-BODY' > "$1/SESSIONS.md"
}

# Claude-style project discovery.
CLAUDE_FIXTURE="$TMP_ROOT/claude-project"
write_todo "$CLAUDE_FIXTURE"
write_sessions "$CLAUDE_FIXTURE"
OUTPUT=$(cd "$TMP_ROOT" && CLAUDE_PROJECT_DIR="$CLAUDE_FIXTURE" "$HOOK")
assert_contains "$OUTPUT" 'TODO-SENTINEL'
assert_contains "$OUTPUT" '2026-09-22 (latest fixture)'
assert_not_contains "$OUTPUT" 'LATEST-JOURNAL-BODY'
assert_not_contains "$OUTPUT" 'OLDER-JOURNAL-BODY'

# Codex-style discovery from a nested working directory via the Git root.
CODEX_FIXTURE="$TMP_ROOT/codex-project"
write_todo "$CODEX_FIXTURE"
write_sessions "$CODEX_FIXTURE"
git -C "$CODEX_FIXTURE" init -q
mkdir -p "$CODEX_FIXTURE/nested/path"
write_todo "$CODEX_FIXTURE/nested/path" 'SCRATCH-TODO-SENTINEL'
OUTPUT=$(cd "$CODEX_FIXTURE/nested/path" && env -u CLAUDE_PROJECT_DIR \
  PLUGIN_ROOT="$REPO_ROOT" \
  sh -c "$HOOK_COMMAND")
assert_contains "$OUTPUT" 'TODO-SENTINEL'
assert_not_contains "$OUTPUT" 'SCRATCH-TODO-SENTINEL'
assert_contains "$OUTPUT" '2026-09-22 (latest fixture)'
assert_not_contains "$OUTPUT" 'LATEST-JOURNAL-BODY'

# Codex prefers baton state in the current folder over a containing Git root.
MONOREPO="$TMP_ROOT/monorepo"
write_todo "$MONOREPO" 'ROOT-TODO-SENTINEL'
write_sessions "$MONOREPO"
git -C "$MONOREPO" init -q
SUBPROJECT="$MONOREPO/packages/subproject"
write_todo "$SUBPROJECT" 'SUBPROJECT-TODO-SENTINEL'
write_sessions "$SUBPROJECT"
OUTPUT=$(cd "$SUBPROJECT" && env -u CLAUDE_PROJECT_DIR "$HOOK")
assert_contains "$OUTPUT" 'SUBPROJECT-TODO-SENTINEL'
assert_not_contains "$OUTPUT" 'ROOT-TODO-SENTINEL'

# The shared hook command also works with Claude's plugin-root variable alone.
OUTPUT=$(cd "$CLAUDE_FIXTURE" && env -u PLUGIN_ROOT -u CLAUDE_PROJECT_DIR \
  CLAUDE_PLUGIN_ROOT="$REPO_ROOT" \
  sh -c "$HOOK_COMMAND")
assert_contains "$OUTPUT" 'TODO-SENTINEL'

# PLUGIN_ROOT wins when both host root variables are present.
OUTPUT=$(cd "$CLAUDE_FIXTURE" && env -u CLAUDE_PROJECT_DIR \
  PLUGIN_ROOT="$REPO_ROOT" \
  CLAUDE_PLUGIN_ROOT="$TMP_ROOT/not-the-plugin" \
  sh -c "$HOOK_COMMAND")
assert_contains "$OUTPUT" 'TODO-SENTINEL'

# Without a host project variable or Git repository, use the current folder.
NO_GIT="$TMP_ROOT/no-git-project"
write_todo "$NO_GIT" 'NO-GIT-TODO-SENTINEL'
write_sessions "$NO_GIT"
OUTPUT=$(cd "$NO_GIT" && env -u CLAUDE_PROJECT_DIR "$HOOK")
assert_contains "$OUTPUT" 'NO-GIT-TODO-SENTINEL'
assert_contains "$OUTPUT" '2026-09-22 (latest fixture)'

# A journal without TODO.md surfaces the recovery guidance.
JOURNAL_ONLY="$TMP_ROOT/journal-only"
write_sessions "$JOURNAL_ONLY"
OUTPUT=$(CLAUDE_PROJECT_DIR="$JOURNAL_ONLY" "$HOOK")
assert_contains "$OUTPUT" 'has no TODO.md current-state file yet'
assert_contains "$OUTPUT" '2026-09-22 (latest fixture)'
assert_not_contains "$OUTPUT" 'LATEST-JOURNAL-BODY'

# TODO.md alone, and a project with neither file, remain silent.
TODO_ONLY="$TMP_ROOT/todo-only"
write_todo "$TODO_ONLY"
OUTPUT=$(CLAUDE_PROJECT_DIR="$TODO_ONLY" "$HOOK")
[ -z "$OUTPUT" ] || fail 'TODO-only project should produce no output'

EMPTY="$TMP_ROOT/empty"
mkdir -p "$EMPTY"
OUTPUT=$(CLAUDE_PROJECT_DIR="$EMPTY" "$HOOK")
[ -z "$OUTPUT" ] || fail 'empty project should produce no output'

echo 'session-start smoke tests passed'
