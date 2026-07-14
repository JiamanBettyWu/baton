---
description: End-of-session handoff — append a dated journal entry to SESSIONS.md and refresh TODO.md's current state, open decisions, and next steps. Initializes both files in projects that have none. Use at the end of a work session or before pausing for team alignment.
disable-model-invocation: true
---

# Handoff

If the user provided extra context, weave it in: $ARGUMENTS

## Where to write

1. If the project documents its own session-notes convention (check
   CLAUDE.md / AGENTS.md for rules about session logs, current-state
   pointers, or post-session sweeps), **follow that convention exactly** —
   same files, same format, same length rules.
2. Otherwise, use the default convention: **`TODO.md`** (forward-looking,
   kept current) and **`SESSIONS.md`** (append-only dated journal), both at
   the project root.
   - If they don't exist, initialize them from the templates below.
   - If a `TODO.md` already exists with a different structure, do not
     overwrite it — graft the missing sections (Current state, Open
     decisions) into it and say so.

## What a handoff does

**Append to `SESSIONS.md`** (new dated entry at the top, below the header):
a narrative of what happened this session — what shipped (with PR/commit
refs), what was tried and abandoned (and why), and every decision **with its
reasoning**. Write it to be readable months later by someone mining it for a
blog post or resuming a parked thread. This file is history: never edit or
delete old entries.

**Refresh `TODO.md`** — this file is current state, overwritten each time:

- **Current state:** ~3 sentences max — what just happened, any open manual
  follow-ups, then a link to SESSIONS.md for detail.
- **Open decisions:** for each, the question, options with trade-offs, your
  recommendation, what/who it's blocked on, and outcome-dependent next steps
  ("If A: … / If B: …, including what gets reverted"). Number decisions
  sequentially for the life of the project (D1, D2, …). Write them so the
  user can paste the section into a message to their team.
- **Pick up here:** the next 2–3 concrete actions. Not a backlog.
- Remove lines that referenced now-finished work. Resolved decisions leave
  TODO.md entirely — their record is the journal entry that resolved them.

## Rules

- **Be specific.** `path/to/file.py:123`, branch names, ticket IDs, exact
  commands. "Fixed the bug" is useless three weeks later.
- **Point to history, don't inline it.** Work is not linear — when a next
  step resumes an older thread, cite the journal entry by date ("see
  SESSIONS.md 2026-07-10") instead of re-summarizing it.
- **Capture the non-obvious** in the journal entry: environment quirks, dead
  ends explored, assumptions baked into the code.
- Keep TODO.md under ~100 lines; the narrative lives in SESSIONS.md.

## Templates (for initializing a project)

`SESSIONS.md`:

```markdown
# Session log

Reverse-chronological journal — one dated entry per working session: what got
done, what was decided and why. History only; for what to do next see
[TODO.md](TODO.md).

---

## <YYYY-MM-DD> (<one-line session title>)

<Narrative: what shipped (refs), dead ends, decisions with reasoning.>
```

`TODO.md`:

```markdown
# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of <YYYY-MM-DD> (latest session):** <~3 sentences + open manual
follow-ups. Detail in [SESSIONS.md](SESSIONS.md).>

## Open decisions

### D1: <one-line question>
- **Options:** A) <option — trade-off> B) <option — trade-off>
- **Recommendation:** <which and why>
- **Blocked on:** <who/what, since when>
- **If A:** <next steps> · **If B:** <next steps, incl. what gets reverted>

## Pick up here

1. <first concrete action next session>
2. <second>
```

After writing, show the user the "Open decisions" section verbatim (if any)
so they can copy it for their team, and list which files you touched.
