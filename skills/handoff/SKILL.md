---
name: handoff
description: Create a decision-aware end-of-session handoff when the user explicitly asks to pause or hand off work. Sweep loose ends, update the project's current-state and journal files, and commit only the handoff records.
---

# Handoff

Run this workflow only when the user explicitly requests a handoff. Weave any
extra context or notes from the user's request into the record.

## Where to write

1. If the project documents its own session-notes convention, check the active
   project instruction files (for example, `AGENTS.md` and `CLAUDE.md`) for
   rules about session logs, current-state pointers, or post-session sweeps.
   **Follow that convention exactly** — same files, same format, same length
   rules. If multiple active files define conflicting conventions, ask which
   one is canonical instead of combining them. User-level instructions count
   only when they explicitly define a convention for all projects.
2. Otherwise, use the default convention: **`TODO.md`** (forward-looking,
   kept current) and **`SESSIONS.md`** (append-only dated journal), both at
   the project root.
   - If they don't exist, initialize them from the templates below. **Both
     files are mandatory after a handoff — never skip TODO.md because there
     are no pending tasks.** The session-start hook only injects context when
     both files exist, and TODO.md's load-bearing section is "Current state"
     (which always has content), not the task list. With nothing pending,
     write the current-state pointer and put "(nothing pending)" under "Pick
     up here".
   - If a `TODO.md` already exists with a different structure, do not
     overwrite it — graft the missing sections (Current state, Open
     decisions) into it and say so.

## Before writing: sweep the session

Take a proactive pass over the session's loose ends first, so nothing silently
drops. Fold what you find into the files below — don't just mention it in chat:

- **Loose ends → TODO.md "Pick up here":** uncommitted or stashed changes, new
  `TODO`/`FIXME` markers added this session, failing or skipped tests left
  behind, unmerged branches, half-finished threads.
- **Attention items → TODO.md "Needs attention":** anything blocked on the repo
  owner — *you, or whoever runs this on their own project* — a decision to make,
  a risky assumption baked into the code, a breaking change, or a
  secret/credential that was touched. This is a flag, not a fork — distinct from
  "Open decisions", which is option-and-recommendation shaped.
  - **Trivially-safe hygiene fixes** (a missing `.gitignore` line, a typo'd
    doc link — one-liners with no behavior change) may be *offered inline* in
    the report-back instead of parked as a flag: state the fix, ask, apply on
    approval in a separate commit. Anything with judgment in it stays a flag.
- **Documentation drift → update when traceable, else flag:** if the session
  changed behavior, flags, or APIs, check whether README / CHANGELOG / other
  docs went stale.
  - **When the drift is caused by *this session's own changes* and the fix is
    unambiguous, update the doc** — you have the context and it's traceable to
    what you just did. Change only what drifted (don't rewrite surrounding
    prose), and add the file to the handoff commit by path.
  - **Otherwise — drift you can't trace to this session, or a fix that's
    ambiguous — flag, don't edit.** List it under "Needs attention" and offer
    to update; editing here would mean guessing at intent or history you don't
    have.
- **Oversized Scratch items → flag for extraction:** TODO.md is injected whole
  at every session start, so it must stay lean. If a "Scratch" item has grown
  past ~10 lines or sprouted internal structure (sub-sections, multiple bold
  headers), it's a document wearing a bullet point's clothes. Flag it under
  "Needs attention" and offer to extract it to its own file (e.g.
  `docs/<idea>.md`), leaving a one-liner in Scratch: title, one-sentence hook,
  link. Flag, don't auto-move — whether an idea deserves promotion is the
  owner's call, and a silent relocation is easy to lose.

## What a handoff does

**Append to `SESSIONS.md`** (new dated entry at the top, below the header —
but first check whether the journal needs rotating; see "Rotate SESSIONS.md
when it grows" below):
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
  - **What qualifies.** An open decision is a question whose answer changes
    what gets built and that **cannot be settled yet** — missing evidence, or
    someone else's call. If it already has costed options, a recommendation and
    a definition of done, it is **work**, not a decision: put it wherever the
    project tracks work (issue tracker, backlog, task list) and leave a pointer.
    A decisions section that collects tasks is the most common reason TODO.md
    outgrows its length budget, and TODO.md is injected whole at every session
    start.
  - Omit the section entirely when nothing is genuinely unsettled — an empty
    heading invites the next handoff to refill it.
- **Needs attention:** flags for the repo owner surfaced by the sweep above.
  Omit the section entirely when there's nothing to flag.
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
- **Don't duplicate the project's own knowledge files.** If the repo keeps a
  decisions/lessons/ADR doc and this session already recorded something there,
  the journal cites it ("principles recorded in docs/lessons_learned.md §13–16")
  and keeps only the *narrative* — what happened and in what order. Two prose
  copies of the same decision will drift.
- **D-numbers are project-lifetime and never reused.** Next number = highest
  D-number ever used + 1 — resolved decisions leave TODO.md, so check the
  journal (`grep -o 'D[0-9]*' SESSIONS.md sessions/* | sort -u`) before
  numbering a new one.
- Keep TODO.md under ~100 lines; the narrative lives in SESSIONS.md. **If it
  exceeds that, the overflow is usually concrete work masquerading as state** —
  move the work out (see "What qualifies" above) rather than compressing the
  prose. Compression buys a handful of lines; moving three tasks out buys
  thirty, and leaves what remains readable.

## Templates (for initializing a project)

`SESSIONS.md`:

```markdown
# Session log

Reverse-chronological journal — one dated entry per working session: what got
done, what was decided and why. History only; for what to do next see
[TODO.md](TODO.md).

---

## <YYYY-MM-DD> (<one-line session title>)

<What shipped this session, with commit/PR refs.> <What was tried and
abandoned, and why.> <Each decision with its reasoning.>

<For a multi-thread session, break the narrative with bold sub-labels —
e.g. **The redesign (the real decision):** … — one per distinct phase or
decision.>
```

Keep entries as flowing narrative, not form fields — the journal is written
to be mined months later (blog posts, resuming parked threads), and prose
with occasional bold sub-labels reads better than bulleted fields.

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

## Needs attention

<Omit this whole section when nothing needs flagging.>
- ⚠️ <thing blocked on the repo owner — a risky assumption, a breaking change,
  a secret that was touched, a doc that went stale>

## Pick up here

1. <first concrete action next session>
2. <second>
```

## Rotate SESSIONS.md when it grows

**Before** appending this session's entry, check the journal's length
(`wc -l SESSIONS.md`). If it already exceeds ~500 lines, rotate — but
**announce it and confirm first; never move files silently:**

1. Tell the user: "SESSIONS.md is <N> lines — archiving it to `sessions/` and
   starting a fresh journal." Proceed once they're on board.
2. `mkdir -p sessions` and
   `git mv SESSIONS.md sessions/<oldest-date>--<newest-date>.md` — the date
   range of the archived entries, so history stays greppable by date.
3. Start a fresh `SESSIONS.md` from the template, with a pointer line under the
   header: "Older entries archived in [`sessions/`](sessions/)."
4. Write this session's entry as the first entry of the fresh file.

Rotate the whole file in one move rather than splitting entries by hand — that
can't drop content. History stays greppable with
`grep -rn . sessions SESSIONS.md`. Rotation is a navigability/git-hygiene step,
not a context-cost one: the SessionStart hook never loads the journal body, only
its latest entry's date.

## Commit the handoff

After writing, commit the handoff so the record is durable and the journal is
shareable — **even on a repo's first handoff, when the files are new and
untracked:**

- Stage **only** the files this handoff wrote or updated (`TODO.md`,
  `SESSIONS.md`, plus any doc the sweep updated under the traceable-drift rule
  above). `git add` them by path — this is what picks up new, untracked files
  the first time. **Never `git add -A`**: a handoff must not sweep unrelated
  working-tree changes into the commit.
- If you rotated the journal, the `git mv` already staged the rename; also
  `git add` the fresh `SESSIONS.md` so both the archive and the new file land in
  the commit.
- Commit with the message `Handoff: <session title>` — the same title as the
  new SESSIONS.md entry.
- **If the user wants substantive changes committed too, commit those
  SEPARATELY and FIRST**, then the handoff on top. The handoff commit stays a
  docs-only commit whatever else is in the tree: a commit titled `Handoff: …`
  that also carries a new module is one nobody expects to find code in. This is
  the same "don't sweep unrelated changes" rule, applied to the case where the
  sweeping was *requested* rather than accidental.
- **Do not push.** Pushing stays a manual step.
- If the project isn't a git repository, skip this silently.

After committing, report back:
- The "Open decisions" section verbatim (if any) so they can copy it for their team.
- Anything the sweep surfaced for their action — the "Needs attention" items,
  any docs you auto-updated under the traceable-drift rule, and any stale docs
  you flagged but left for them to confirm.
- Which files you touched, whether you rotated the journal, and the commit SHA.
