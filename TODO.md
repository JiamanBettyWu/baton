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

- **`/baton:why` — lazy decision archaeology** (evolved 2026-07-13 from the
  parked "memory graph" idea; trigger fired: Betty's real onboarding pain at
  work — "why was this code written this way?" cost hours of manual git
  spelunking). The corpus is whatever records decisions: SESSIONS.md where
  baton runs, **git history everywhere else** (blame → commit → PR → issue →
  review threads is already a decision graph). Design: NOT a batch pass over
  all commits (rung-3 trap) — a skill that answers one "why" question by
  running the archaeology ritual (`git log -L`, `git log -S` pickaxe,
  `gh pr view`), then **persists the finding** to a `DECISIONS.md`: question,
  answer, evidence trail (SHAs/PR links), confidence. A query cache for
  institutional knowledge — the index grows exactly where real questions
  landed. Acceptance test before work port: ask it a "why" mise's git history
  answers (e.g. why `generate_output` moved before the gaps fork, #124) with
  SESSIONS.md hidden, and check it reconstructs the reason from commits
  alone. Resume/work upside: onboarding-questions-become-team-artifact impact
  story; GraphRAG-adjacent vocabulary with measurable retrieval quality.

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
