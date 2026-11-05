# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-11-05 (latest session):** baton 0.2.2 is on `main` (PR #6). It
leaves git-ignored record files out of the handoff and decide commits instead
of forcing them in, and the README now has update steps for both hosts. Both
Claude Code and Codex were reinstalled at 0.2.2, but no fresh session has
loaded it yet. Detail in [SESSIONS.md](SESSIONS.md).

## Needs attention

- ⚠️ **Bundled Codex hook discovery remains unresolved.** The plugin's skills
  load, but isolated `hooks/list` probes found no plugin-sourced hook. The
  working hook is from User config and points at
  `/Users/jiamanwu/dev/baton/hooks/session-start.sh`, so moving this checkout
  requires updating `~/.codex/hooks.json`. `README.md` still describes the
  bundled-hook trust path; update it after the cause and supported fix are
  established (see SESSIONS.md 2026-11-04).
- ⚠️ **Strict Claude plugin validation reports `ICON_MISSING`.** The root
  `CLAUDE.md` warning is expected, but the icon warning is additional and
  `claude plugin validate . --strict` exits nonzero. Decide whether to add a
  listing icon before the next packaging handoff.
- ⚠️ **Rotation is unexercised, and the next handoff will likely trigger it.**
  `SESSIONS.md` is now 544 lines, so the next handoff should offer
  to archive it. Watch that first real run, including the new plain-`mv` path
  for an ignored journal.
- ⚠️ **The skill cannot hand off a repo other than the session's own.** The
  2026-09-22 entry was written by hand from a `retrieval-lab` session because
  the work happened there. Cross-repo targeting remains a known edge.

## Scratch — not yet promoted

- **why skill — lazy decision archaeology:** answer one "why" question via
  git archaeology, persist the finding to `BECAUSE.md`. Full design in
  [docs/baton-why-design.md](docs/baton-why-design.md).

## Pick up here

1. Start a fresh Claude Code session and a fresh Codex task, and confirm each
   loads baton 0.2.2. Then run a handoff in a scratch repo with `TODO.md` in
   `.gitignore` and check that the commit contains only `SESSIONS.md`.
2. Dogfood in mise: compare Claude Code `/baton:handoff` with Codex
   `$baton:handoff`, including file output, scoped commit contents, and no push.
3. Diagnose plugin-sourced hook discovery in Codex. Keep the working user
   hook until the native path is verified, then update `README.md`.

**Later —** work port (repo public as of 2026-07-13, so plain clone works):
clone on the work laptop, check the company's plugin policy, test — falling
back to the skills-only degraded install from the README if plugins/hooks are
locked down. Once proven in daily use, go through the company's formal
registration to list it on the internal skill marketplace.
