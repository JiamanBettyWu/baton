#!/bin/bash
# SessionStart hook: inject the project's forward-looking state into context.
# Plain stdout from a SessionStart hook is added as context automatically,
# so this needs no jq or JSON — it stays portable to locked-down machines.
#
# Both TODO.md and SESSIONS.md existing is the signal that the baton
# convention is active; a lone TODO.md may be an unrelated scratch file.

DIR="${CLAUDE_PROJECT_DIR:-.}"
TODO="$DIR/TODO.md"
SESSIONS="$DIR/SESSIONS.md"

if [ -f "$TODO" ] && [ -f "$SESSIONS" ]; then
  echo "This project keeps handoff state in TODO.md (current) and SESSIONS.md (dated journal). TODO.md:"
  echo
  cat "$TODO"
  echo
  LATEST=$(grep -m1 '^## ' "$SESSIONS")
  echo "(Latest journal entry: ${LATEST#\#\# }. Read the relevant dated entry in SESSIONS.md when a task resumes an older thread. Suggest /baton:handoff before the session ends; if the user reports a team decision, suggest /baton:decide.)"
elif [ -f "$SESSIONS" ]; then
  # Journal without a forward-looking file: still surface continuity, and
  # flag that the next /baton:handoff should initialize TODO.md.
  LATEST=$(grep -m1 '^## ' "$SESSIONS")
  echo "This project keeps a dated session journal in SESSIONS.md (latest entry: ${LATEST#\#\# }) but has no TODO.md current-state file yet. Read the latest journal entry to catch up; the next /baton:handoff should initialize TODO.md."
fi

exit 0
