---
name: decide
description: Record and reconcile an open project decision when the user explicitly reports its outcome. Preserve the reasoning, update current next steps, and flag invalidated work.
disable-model-invocation: true
---

# Decide

Run this workflow only when the user explicitly asks to record a decision or
reports the outcome of a decision that blocked the project. Use the outcome and
reasoning stated in the user's request.

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

1. Find the open decisions: TODO.md's "Open decisions" section (or wherever
   the project's own documented convention keeps them). If none exist, say so
   and offer to run the handoff skill first instead.
2. Match the outcome to an open decision (by number like "D3" if given,
   otherwise by content). If the match is ambiguous or the outcome doesn't
   correspond to any listed option, ask — do not guess.
3. Record it in `SESSIONS.md` as (part of) a dated entry: the question, the
   chosen option, and the stated reason — ask for the reason if the user
   didn't give one and it isn't obvious; future sessions and future blog
   posts need the *why*. Keep the decision's number (D3) for reference.
   Write identifiers in full as they exist (table, column, file, ticket
   names), and when the reasoning rests on a reading of data or code rather
   than a tested result, tag that claim `(unverified)`. If the outcome
   disproves an earlier journal entry, say so explicitly in the new entry
   ("corrects <date>: …") — never edit the old entry.
4. Reconcile `TODO.md`:
   - Remove the decision from "Open decisions" (its record now lives in the
     journal).
   - Promote the matching "If <option>" branch into "Pick up here" /
     "Current state"; delete the branches that didn't happen.
   - If the outcome invalidates work already done, list exactly what needs
     reverting or reworking — as explicit next steps, not silently.

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
- Stage only the journal and forward-looking files this workflow updated,
  using their exact paths. Never use `git add -A` or sweep unrelated changes
  into the commit.
- Commit with an explicit pathspec so files staged before this workflow cannot
  leak into the records commit:
  `git commit --only -m "Decision D<n>: <short outcome>" -- <journal-path> <forward-looking-path>`.
  When the decision has no number, use `Decision: <short outcome>` instead.
  Never use a plain `git commit` for this workflow.
- If the user also asked to commit substantive project changes, commit those
  separately and first. The decision commit remains records-only.
- Do not push. If the project is not a Git repository, skip the commit.

Finally, show the user a short summary: where the decision was recorded, the
plan changes, any invalidated work, and the commit SHA when one was created
and which git-ignored paths were left out of it.
Then ask if they want to start on the first next step now.
