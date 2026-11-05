# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-11-04 (latest session):** `main` now has baton 0.2.1's journal
fidelity rules plus both local handoff commits. Codex discovers both skills,
and Betty confirmed startup context in a fresh local task through the
user-level hook at `~/.codex/hooks.json`; bundled-hook discovery remains
unresolved. Detail in [SESSIONS.md](SESSIONS.md).

## Needs attention

- ⚠️ **Bundled Codex hook discovery remains unresolved.** The 0.2.1 plugin is
  enabled and its skills load, but isolated `hooks/list` probes found no
  plugin-sourced hook. The visible working hook is from User config and points
  at `/Users/jiamanwu/dev/baton/hooks/session-start.sh`, so moving this
  checkout requires updating `~/.codex/hooks.json`. `README.md` still
  describes the bundled-hook trust path; update it after the cause and
  supported fix are established (see SESSIONS.md 2026-11-04).
- ⚠️ **Strict Claude plugin validation reports `ICON_MISSING`.** The root
  `CLAUDE.md` warning is expected, but the icon warning is additional and
  `claude plugin validate . --strict` exits nonzero. Decide whether to add a
  listing icon before the next packaging handoff. The bundled Agent Skills
  validator rejected only the expected `disable-model-invocation` extension;
  both 0.2.1 skills passed in temporary copies without that key.
- ⚠️ **Rotation is unexercised** — the ~500-line archive path has never run
  against a real oversized journal; watch its first real rotation.
- ⚠️ **The skill cannot hand off a repo other than the session's own.** The
  2026-09-22 entry was written by hand from a `retrieval-lab` session because
  the work happened there. Cross-repo targeting remains a known edge.

## Scratch — not yet promoted

- **why skill — lazy decision archaeology:** answer one "why" question via
  git archaeology, persist the finding to `BECAUSE.md`. Full design in
  [docs/baton-why-design.md](docs/baton-why-design.md).

## Pick up here

1. Diagnose plugin-sourced hook discovery on the installed 0.2.1 package;
   keep the working user hook until the native path is verified, then update
   `README.md`.
2. Dogfood in mise: compare Claude Code `/baton:handoff` with Codex
   `$baton:handoff`, including file output, scoped commit contents, and no push.
3. Resolve the `ICON_MISSING` strict-validator warning before the next plugin
   packaging handoff.

**Later —** work port (repo public as of 2026-07-13, so plain clone works):
clone on the work laptop, check the company's plugin policy, test — falling
back to the skills-only degraded install from the README if plugins/hooks are
locked down. Once proven in daily use, go through the company's formal
registration to list it on the internal skill marketplace.
