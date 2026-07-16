# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-07-15 (latest session):** added a sweep rule to the handoff skill
(`1ae4aeb`): Scratch items in TODO.md past ~10 lines (or with internal
structure) get flagged for extraction to their own doc — because TODO.md is
injected whole at every session start and had no size guard. All previously
unpushed work (`f575bc3` + `1ae4aeb`) is now on `origin/main`. This handoff is
the rule's first live run, and it fired (see "Needs attention"). Detail in
[SESSIONS.md](SESSIONS.md).

## Open decisions

(none — nothing currently blocked on an outside call)

## Needs attention

- ⚠️ **Rotation is unexercised** — the ~500-line archive path has never run
  against a real oversized journal; watch the first real rotation.
- ⚠️ **Scratch item oversized (new rule, first firing):** the `/baton:why`
  blob below is ~18 lines of design prose. Offer: extract to
  `docs/baton-why.md`, leaving a one-liner here (title, hook, link). Your
  call — flag, not auto-move.

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

1. Decide on the `/baton:why` Scratch extraction flagged above — extract to
   `docs/baton-why.md` or leave in place.
2. Mirror the auto-commit step into `/baton:decide` (it writes SESSIONS.md +
   TODO.md but never commits them — same gap handoff closed on 2026-07-15).
3. Dogfood in mise: end the next mise session with `/baton:handoff` and
   judge the SESSIONS.md entry against Betty's own entries — the convention
   it was modeled on is the strictest test of format fidelity.

**Later —** work port (repo public as of 2026-07-13, so plain clone works):
clone on the work laptop, check the company's plugin policy, test — falling
back to the skills-only degraded install from the README if plugins/hooks are
locked down. Once proven in daily use, go through the company's formal
registration to list it on the internal skill marketplace.
