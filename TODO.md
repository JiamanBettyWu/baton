# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-07-13 (latest session):** v0.1 is built, validated, and pushed
private to [JiamanBettyWu/baton](https://github.com/JiamanBettyWu/baton) —
two skills (`/baton:handoff`, `/baton:decide`) + a SessionStart hook around
a root TODO.md/SESSIONS.md convention mirrored from mise. Not yet installed
for everyday use, and no real end-of-session handoff has run through the
skill itself. Detail in [SESSIONS.md](SESSIONS.md).

## Open decisions

(none — nothing currently blocked on an outside call)

## Scratch — not yet promoted

- **Project memory graph** (idea 2026-07-13, deliberately parked): extract
  decision lineage from SESSIONS.md into a derived, regeneratable index —
  rung 1 is a flat `DECISIONS.md` (date, ID, what/why, files/issues,
  supersedes), rungs 2–3 (wiki links, GraphRAG-style retrieval) only if flat
  fails. Core principle: the graph is a *view* derived from the journal,
  never hand-maintained. **Trigger to un-park:** the first time a real
  question about a project's history can't be answered quickly by grepping
  the journal — that question becomes rung 1's acceptance test. Resume
  upside when built: LLM entity/relation extraction with measurable accuracy
  against a hand-labeled mise ground truth.

## Pick up here

1. Install for daily use: `ln -s ~/dev/baton ~/.claude/skills/baton`
   (symlink while iterating; swap for a copy or marketplace install once
   stable).
2. First real dogfood: end the next mise session with `/baton:handoff` and
   judge the SESSIONS.md entry against Betty's own entries — tune the
   handoff skill's wording from whatever drifts.
3. Later, when stable: flip repo visibility public
   (`gh repo edit JiamanBettyWu/baton --visibility public`), then the work
   port — copy to work laptop, test the skills-only degraded install
   documented in README, and submit to the company skill marketplace.
