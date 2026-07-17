# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-07-17 (latest session):** shipped Betty's edit to
`skills/decide/SKILL.md` (`aa3a3f6`, on `origin/main`) — a "Where to write"
section giving `/baton:decide` the same follow-the-project's-own-convention
behavior `/baton:handoff` already has. Reviewed, fixed three small typos,
pushed. Working tree clean. Detail in [SESSIONS.md](SESSIONS.md).

## Open decisions

(none — nothing currently blocked on an outside call)

## Needs attention

- ⚠️ **Rotation is unexercised** — the ~500-line archive path has never run
  against a real oversized journal; watch the first real rotation.

## Scratch — not yet promoted

- **`/baton:why` — lazy decision archaeology:** answer one "why" question via
  git archaeology, persist the finding to `BECAUSE.md`. Full design in
  [docs/baton-why-design.md](docs/baton-why-design.md).

## Pick up here

1. Mirror the auto-commit step into `/baton:decide` (it writes SESSIONS.md +
   TODO.md but never commits them — same gap handoff closed on 2026-07-15).
2. Dogfood in mise: end the next mise session with `/baton:handoff` and
   judge the SESSIONS.md entry against Betty's own entries — the convention
   it was modeled on is the strictest test of format fidelity.

**Later —** work port (repo public as of 2026-07-13, so plain clone works):
clone on the work laptop, check the company's plugin policy, test — falling
back to the skills-only degraded install from the README if plugins/hooks are
locked down. Once proven in daily use, go through the company's formal
registration to list it on the internal skill marketplace.
