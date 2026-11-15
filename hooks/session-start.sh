#!/bin/bash
# SessionStart hook: inject the project's forward-looking state into context.
# Supported hosts add plain stdout to context, so this needs no jq or JSON and
# stays portable to locked-down machines.
#
# A SESSIONS.md journal is the signal that the baton convention is active.
# The journal is local-only by default, so a fresh clone or worktree may have
# TODO.md alone: that still counts when TODO.md points at SESSIONS.md, as
# baton's template does. Any other lone TODO.md may be an unrelated scratch
# file and stays silent.

baton_todo() {
  [ -f "$1" ] && grep -q 'SESSIONS\.md' "$1"
}

CURRENT_DIR="${PWD:-.}"

if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
  DIR="$CLAUDE_PROJECT_DIR"
elif [ -f "$CURRENT_DIR/SESSIONS.md" ] || baton_todo "$CURRENT_DIR/TODO.md"; then
  # Codex has no project-directory variable. Prefer an initialized baton
  # project in the working directory before considering a parent Git root.
  DIR="$CURRENT_DIR"
elif DIR=$(git rev-parse --show-toplevel 2>/dev/null); then
  :
else
  DIR="$CURRENT_DIR"
fi

TODO="$DIR/TODO.md"
SESSIONS="$DIR/SESSIONS.md"

if [ -f "$TODO" ] && [ -f "$SESSIONS" ]; then
  echo "This project keeps handoff state in TODO.md (current) and SESSIONS.md (dated journal). TODO.md:"
  echo
  cat "$TODO"
  echo
  LATEST=$(grep -m1 '^## ' "$SESSIONS")
  echo "(Latest journal entry: ${LATEST#\#\# }. When a task resumes an older thread or TODO.md cites an entry by date, search SESSIONS.md and sessions/ by date or keyword and read that one entry. If LEARNINGS.md exists, read its index and then the matching theme before work in an area the index names, when a failure looks like tooling or environment rather than the code being written, and before repeating a setup step. Suggest the handoff skill before the session ends; if the user reports a team decision, suggest the decide skill.)"
elif [ -f "$SESSIONS" ]; then
  # Journal without a forward-looking file: still surface continuity, and
  # flag that the next handoff should initialize TODO.md.
  LATEST=$(grep -m1 '^## ' "$SESSIONS")
  echo "This project keeps a dated session journal in SESSIONS.md (latest entry: ${LATEST#\#\# }) but has no TODO.md current-state file yet. Read the latest journal entry to catch up; the next handoff should initialize TODO.md. If LEARNINGS.md exists, read its index and then the matching theme before work in an area the index names."
elif baton_todo "$TODO"; then
  # Current state without a journal: the journal is local-only and this
  # checkout does not have it.
  echo "This project keeps handoff state in TODO.md (current). Its session journal SESSIONS.md is local-only and is not in this checkout, so journal entries cited by date are unavailable here. TODO.md:"
  echo
  cat "$TODO"
  echo
  echo "(If LEARNINGS.md exists, read its index and then the matching theme before work in an area the index names, when a failure looks like tooling or environment rather than the code being written, and before repeating a setup step. Suggest the handoff skill before the session ends; it will start a local journal here. If the user reports a team decision, suggest the decide skill.)"
fi

exit 0
