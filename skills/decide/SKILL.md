---
description: Record the outcome of an open decision and reconcile the plan — log it with reasoning in SESSIONS.md, update TODO.md's next steps, flag invalidated work. Use when the team has made a decision that work was blocked on.
disable-model-invocation: true
---

# Decide

The user is reporting the outcome of a decision the project was blocked on:

> $ARGUMENTS

## Where to write

If the project documents its own session-notes convention (check CLAUDE.md /
AGENTS.md for rules about session logs, current-state pointers, or open-decision
tracking), **follow that convention exactly** — same files, same format. The
journal and forward-looking doc names in the steps below then resolve to that
project's files (e.g. `docs/session-log.md` and `docs/TODO.md`), not the
defaults. Otherwise use baton's defaults: **`TODO.md`** and **`SESSIONS.md`** at
the project root.

1. Find the open decisions: TODO.md's "Open decisions" section (or wherever
   the project's own documented convention keeps them). If none exist, say so
   and offer to run `/baton:handoff` first instead.
2. Match the outcome to an open decision (by number like "D3" if given,
   otherwise by content). If the match is ambiguous or the outcome doesn't
   correspond to any listed option, ask — do not guess.
3. Record it in `SESSIONS.md` as (part of) a dated entry: the question, the
   chosen option, and the stated reason — ask for the reason if the user
   didn't give one and it isn't obvious; future sessions and future blog
   posts need the *why*. Keep the decision's number (D3) for reference.
4. Reconcile `TODO.md`:
   - Remove the decision from "Open decisions" (its record now lives in the
     journal).
   - Promote the matching "If <option>" branch into "Pick up here" /
     "Current state"; delete the branches that didn't happen.
   - If the outcome invalidates work already done, list exactly what needs
     reverting or reworking — as explicit next steps, not silently.
5. Show the user a short summary: decision recorded (where), plan changes,
   and any invalidated work. Then ask if they want to start on the first
   next step now.
