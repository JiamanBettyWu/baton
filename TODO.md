# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-09-22 (latest session):** baton 0.2's agent-agnostic migration
shipped through PR #2 (`92df370`), and `main` is clean. The standalone Codex
CLI now has `baton@baton` 0.2.0 installed and enabled; live startup-hook
verification in a fresh task remains. Detail in [SESSIONS.md](SESSIONS.md).

## Needs attention

- ⚠️ **Rotation is unexercised** — the ~500-line archive path has never run
  against a real oversized journal; `SESSIONS.md` was 338 lines before this
  entry, so watch its first real rotation.
- ⚠️ **The skill cannot hand off a repo other than the session's own.** This
  entry was written by hand from a `retrieval-lab` session, because the work
  happened there and the narrative only exists where the session was. Not
  obviously worth fixing — cross-repo targeting is a real complication for a
  rare case — but it is a known edge, not an oversight.
- ⚠️ **Live Codex hook verification remains.** The standalone CLI is now
  `0.156.1` and the plugin is installed and enabled, but this already-running
  task cannot prove that a new task discovers the skills and injects startup
  context after hook review and trust.

## Scratch — not yet promoted

- **why skill — lazy decision archaeology:** answer one "why" question via
  git archaeology, persist the finding to `BECAUSE.md`. Full design in
  [docs/baton-why-design.md](docs/baton-why-design.md).

## Pick up here

1. Start a fresh Codex task in this repo, confirm `$handoff` and `$decide` are
   discoverable, then review and trust baton's SessionStart hook in `/hooks`.
2. Confirm startup injects all of `TODO.md` plus only the latest
   `SESSIONS.md` heading, not the full journal.
3. Dogfood in mise: compare one Claude Code `/baton:handoff` with one Codex
   `$handoff`, including file output, scoped commit contents, and no push.

**Later —** work port (repo public as of 2026-07-13, so plain clone works):
clone on the work laptop, check the company's plugin policy, test — falling
back to the skills-only degraded install from the README if plugins/hooks are
locked down. Once proven in daily use, go through the company's formal
registration to list it on the internal skill marketplace.
