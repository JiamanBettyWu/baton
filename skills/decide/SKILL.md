---
name: decide
description: Record and reconcile an open project decision when the user explicitly reports its outcome. Preserve the reasoning, update current next steps, and flag invalidated work.
disable-model-invocation: true
---

# Decide

Run this workflow only when the user explicitly asks to record a decision or
reports the outcome of a decision that blocked the project. Use the outcome and
reasoning stated in the user's request.

Parking or withdrawing a decision is itself a decision, and this workflow
records it the same way. So an outcome is one of three kinds: an option was
**chosen**, the decision was **parked** (still unsettled, but not being pursued
now — "backlog" and "later" mean this too), or it was **withdrawn** (the
question no longer matters).

## Where to write

If the project documents its own session-notes convention, check the active
project instruction files (for example, `AGENTS.md` and `CLAUDE.md`) for rules
about session logs, current-state pointers, or open-decision tracking. **Follow
that convention exactly** — same files, same format. If multiple active files
define conflicting conventions, ask which one is canonical instead of
combining them. The journal and forward-looking doc names in the steps below
then resolve to that project's files (for example, `docs/session-log.md` and
`docs/TODO.md`), not the defaults. Otherwise use baton's defaults:
**`TODO.md`** and **`SESSIONS.md`** at the project root.

Parked decisions live in their own file: the one the project's convention
names, otherwise **`PARKED.md`** next to `TODO.md`. It holds the full record of
every decision that is parked right now, and nothing else. Create it on first
use with this header:

```markdown
# Parked decisions

Decisions set aside on purpose. Each keeps its full options so it can be
reopened. Current plan: [TODO.md](TODO.md). History: [SESSIONS.md](SESSIONS.md).
```

1. Find the open decisions: TODO.md's "Open decisions" section, plus the
   parked ones in `PARKED.md` if it exists (or wherever the project's own
   documented convention keeps them). If none exist, say so and offer to run
   the handoff skill first instead.
   - **Decisions already marked as parked.** The project may predate this
     layout and carry parked decisions in another shape: a "parked", "on
     hold", "backlog", or "later" label, or a note on a block that still sits
     under "Open decisions" or elsewhere in `TODO.md`. They count as parked
     decisions. Before handling the user's outcome, tell the user which ones
     you found and move each into `PARKED.md` in the step 4 format. This is a
     change of format, not a new decision: keep the wording and the number
     (give it the next number if it has none), and write "not recorded" for
     a missing reason or revisit trigger instead of inventing one. Note the
     move in this run's journal entry in one line, with the numbers.
2. Match the outcome to a decision (by number like "D3" if given, otherwise
   by content) and classify it as **chosen**, **parked**, or **withdrawn**.
   If the match is ambiguous, if a chosen outcome doesn't correspond to any
   listed option, or if you can't tell whether the user means parked or
   withdrawn, ask — do not guess.
3. Record it in `SESSIONS.md` as (part of) a dated entry: the question, the
   outcome (the chosen option, or "parked" / "withdrawn"), and the stated
   reason — ask for the reason if the user didn't give one and it isn't
   obvious; future sessions and future blog posts need the *why*.
   Always keep the decision's number (D3), whatever the outcome: the journal
   is where the next number is looked up, so a number that never reaches it
   gets reused.
   Write identifiers in full as they exist (table, column, file, ticket
   names), and when the reasoning rests on a reading of data or code rather
   than a tested result, tag that claim `(unverified)`. If the outcome
   disproves an earlier journal entry, say so explicitly in the new entry
   ("corrects <date>: …") — never edit the old entry.
   - **Parked:** keep the journal entry short — number, question, "parked",
     the reason, and "full record in `PARKED.md`". The detail goes in the
     parked file (step 4), not here.
   - **Chosen or withdrawn, for a decision that was parked:** the journal
     entry also names the options that were on the table, because the
     decision's section is about to leave `PARKED.md`.
4. Reconcile the plan according to the outcome. In every case, clean up any
   "Pick up here" or "Current state" line in `TODO.md` that depended on the
   decision, and if "Open decisions" or "Parked decisions" ends up empty,
   remove the heading.
   - **Chosen:** remove the decision from "Open decisions" (its record now
     lives in the journal). Promote the matching "If <option>" branch into
     "Pick up here" / "Current state"; delete the branches that didn't
     happen.
   - **Parked:** move the decision's whole block out of "Open decisions" and
     into `PARKED.md` as its own section, unchanged — options, trade-offs,
     recommendation, "Blocked on", and every "If <option>" branch — and add
     two lines to it: `- **Parked:** <YYYY-MM-DD> — <reason>` and
     `- **Revisit when:** <an event, a date, or "no trigger">`. Ask for the
     revisit trigger if the user didn't give one. In `TODO.md`, leave one
     line under "Parked decisions" (create the section right after "Open
     decisions" if it doesn't exist):
     `- **D<n>: <question>** — revisit when <trigger>. See PARKED.md.`
     Promote no branch.
   - **Withdrawn:** remove the decision and all of its "If <option>"
     branches. No line stays behind.
   - **A decision that was parked** and is now chosen or withdrawn: read its
     options from its section in `PARKED.md`, then delete that section and
     its line under "Parked decisions". If `PARKED.md` has no sections left,
     delete the file.
   - If the outcome invalidates work already done — including work done in
     anticipation of a decision that is now parked or withdrawn — list
     exactly what needs reverting or reworking, as explicit next steps, not
     silently.

## Commit the decision record

After writing, commit the record so the journal and current plan cannot drift
apart:

- Before staging, run `git check-ignore -q <path>` on each file this workflow
  updated. Exit 0 means ignored; exit 1 means not ignored; any other exit code
  is an error, not "ignored". An ignored file is one the project keeps
  local-only: leave it out of both `git add` and the commit pathspec, report
  it as skipped, and commit the remaining files. If every file is ignored,
  skip the commit. Never force it with `git add -f`, and do not add `--no-index`
  to the check: an already-tracked file correctly reports as not ignored.
- Stage only the journal, forward-looking, and parked-decisions files this
  workflow updated, using their exact paths. Never use `git add -A` or sweep unrelated changes
  into the commit.
- Commit with an explicit pathspec so files staged before this workflow cannot
  leak into the records commit:
  `git commit --only -m "Decision D<n>: <short outcome>" -- <journal-path> <forward-looking-path> [<parked-path>]`.
  Include the parked-decisions file whenever this run created, changed, or
  deleted it.
  When the decision has no number, use `Decision: <short outcome>` instead.
  For a parked or withdrawn decision, start the short outcome with
  that word (`Decision D3: parked until the vendor quote arrives`).
  Never use a plain `git commit` for this workflow.
- If the user also asked to commit substantive project changes, commit those
  separately and first. The decision commit remains records-only.
- Do not push. If the project is not a Git repository, skip the commit.

Finally, show the user a short summary: where the decision was recorded, the
plan changes, any invalidated work, and the commit SHA when one was created
and which git-ignored paths were left out of it.
Then ask if they want to start on the first next step now.
