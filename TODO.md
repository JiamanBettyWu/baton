# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-07-15 (latest session):** v0.1 built, public at
[JiamanBettyWu/baton](https://github.com/JiamanBettyWu/baton), MIT-licensed,
**installed for daily use** (symlinked at `~/.claude/skills/baton`, edits live
via `/reload-plugins`). This session hardened the handoff skill (`1367f29`)
with **explicit guided-narrative entry format**, **scoped auto-commit**, a
**proactive pre-write sweep** (with a doc-drift rule that auto-updates
session-traceable drift and flags the rest), and **journal rotation** at ~500
lines. Dogfooded format/commit/sweep on baton itself — the sweep caught real
README drift and auto-fixed it under the new rule (`1367f29`/`f9dbacf`, pushed).
Follow-up (`f575bc3`, **not yet pushed**): renamed the planned `/baton:why`
output `DECISIONS.md` → `BECAUSE.md` and dropped its phantom forward-reference
from the handoff skill. Detail in [SESSIONS.md](SESSIONS.md).

## Open decisions

(none — nothing currently blocked on an outside call)

## Needs attention

- ⚠️ **Rotation is unexercised** — the ~500-line archive path has never run
  against a real oversized journal; watch the first real rotation.

## Scratch — not yet promoted

- **`/baton:why` — lazy decision archaeology** (evolved 2026-07-13 from the
  parked "memory graph" idea; trigger fired: Betty's real onboarding pain at
  work — "why was this code written this way?" cost hours of manual git
  spelunking). The corpus is whatever records decisions: SESSIONS.md where
  baton runs, **git history everywhere else** (blame → commit → PR → issue →
  review threads is already a decision graph). Design: NOT a batch pass over
  all commits (rung-3 trap) — a skill that answers one "why" question by
  running the archaeology ritual (`git log -L`, `git log -S` pickaxe,
  `gh pr view`), then **persists the finding** to a `BECAUSE.md` (named for the
  why→because pairing; *not* `DECISIONS.md`, which reads like `/baton:decide`
  output — it isn't): question, answer, evidence trail (SHAs/PR links),
  confidence. A query cache for
  institutional knowledge — the index grows exactly where real questions
  landed. Acceptance test before work port: ask it a "why" mise's git history
  answers (e.g. why `generate_output` moved before the gaps fork, #124) with
  SESSIONS.md hidden, and check it reconstructs the reason from commits
  alone. Resume/work upside: onboarding-questions-become-team-artifact impact
  story; GraphRAG-adjacent vocabulary with measurable retrieval quality.

## Pick up here

1. Push the BECAUSE.md rename follow-up (`f575bc3` + this handoff commit) — the
   handoff-hardening work is already on `origin/main`.
2. Mirror the auto-commit step into `/baton:decide` (it writes SESSIONS.md +
   TODO.md but never commits them — same gap handoff just closed).
3. Dogfood in mise: end the next mise session with `/baton:handoff` and
   judge the SESSIONS.md entry against Betty's own entries — the convention
   it was modeled on is the strictest test of format fidelity.

**Later —** work port (repo public as of 2026-07-13, so plain clone works):
clone on the work laptop, check the company's plugin policy, test — falling
back to the skills-only degraded install from the README if plugins/hooks are
locked down. Once proven in daily use, go through the company's formal
registration to list it on the internal skill marketplace.
