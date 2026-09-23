#!/bin/bash
# SessionStart hook: inject the project's forward-looking state into context.
# Supported hosts add plain stdout to context, so this needs no jq or JSON and
# stays portable to locked-down machines.
#
# Both TODO.md and SESSIONS.md existing is the signal that the baton
# convention is active; a lone TODO.md may be an unrelated scratch file.

CURRENT_DIR="${PWD:-.}"

if [ -n "${CLAUDE_PROJECT_DIR:-}" ]; then
  DIR="$CLAUDE_PROJECT_DIR"
elif [ -f "$CURRENT_DIR/TODO.md" ]; then
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
  echo "(Latest journal entry: ${LATEST#\#\# }. Read the relevant dated entry in SESSIONS.md when a task resumes an older thread. Suggest the handoff skill before the session ends; if the user reports a team decision, suggest the decide skill.)"
elif [ -f "$SESSIONS" ]; then
  # Journal without a forward-looking file: still surface continuity, and
  # flag that the next handoff should initialize TODO.md.
  LATEST=$(grep -m1 '^## ' "$SESSIONS")
  echo "This project keeps a dated session journal in SESSIONS.md (latest entry: ${LATEST#\#\# }) but has no TODO.md current-state file yet. Read the latest journal entry to catch up; the next handoff should initialize TODO.md."
fi

exit 0
