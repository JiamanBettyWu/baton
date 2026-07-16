# `/baton:why` — lazy decision archaeology (design, not yet built)

Parked design, extracted from TODO.md's Scratch section on 2026-07-15 (first
firing of the oversized-Scratch sweep rule). Evolved 2026-07-13 from the
parked "memory graph" idea; trigger fired: Betty's real onboarding pain at
work — "why was this code written this way?" cost hours of manual git
spelunking.

## Corpus

Whatever records decisions: SESSIONS.md where baton runs, **git history
everywhere else** (blame → commit → PR → issue → review threads is already a
decision graph).

## Design

NOT a batch pass over all commits (rung-3 trap) — a skill that answers one
"why" question by running the archaeology ritual (`git log -L`, `git log -S`
pickaxe, `gh pr view`), then **persists the finding** to a `BECAUSE.md` (named
for the why→because pairing; *not* `DECISIONS.md`, which reads like
`/baton:decide` output — it isn't): question, answer, evidence trail
(SHAs/PR links), confidence.

A query cache for institutional knowledge — the index grows exactly where
real questions landed.

## Acceptance test (before work port)

Ask it a "why" mise's git history answers (e.g. why `generate_output` moved
before the gaps fork, #124) with SESSIONS.md hidden, and check it reconstructs
the reason from commits alone.

## Resume/work upside

Onboarding-questions-become-team-artifact impact story; GraphRAG-adjacent
vocabulary with measurable retrieval quality.
