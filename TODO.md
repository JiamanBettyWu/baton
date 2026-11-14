# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-11-14 (latest session):** baton 0.4.0 is on `main` (PR #7 and
PR #8). The decide skill records parked and withdrawn decisions, with parked
ones kept in `PARKED.md`, and the session journal is local-only by default;
this repo's `SESSIONS.md` and `sessions/` are git-ignored. Both hosts are
reinstalled at 0.4.0, but no fresh session has loaded it and the new wording
has not been run by a fresh model. Detail is in the local `SESSIONS.md`.

## Needs attention

- ⚠️ **The journal on disk can be lost by a checkout.** It is git-ignored, so
  checking out any commit before `22f9951` overwrites it with the old tracked
  copy. A backup from 2026-11-14 is in
  `~/dev/baton-journal-backup-2026-11-14/`; it is safe to delete now, or keep
  it as the journal's only backup.
- ⚠️ **Bundled Codex hook discovery remains unresolved.** The plugin's skills
  load, but isolated `hooks/list` probes found no plugin-sourced hook. The
  working hook is from User config and points at
  `/Users/jiamanwu/dev/baton/hooks/session-start.sh`, so moving this checkout
  requires updating `~/.codex/hooks.json`. `README.md` still describes the
  bundled-hook trust path; update it after the cause and supported fix are
  established (see sessions/2026-07-13--2026-11-05.md, 2026-11-04).
- ⚠️ **Strict Claude plugin validation reports `ICON_MISSING`**, so
  `claude plugin validate . --strict` exits nonzero. A candidate exists at
  `/Users/jiamanwu/Downloads/baton-icon-512.png` but looks like the Claude
  Code mascot; Betty deferred the choice. The icon may be fixed after the
  first portal submission, so settle it before any listing (see SESSIONS.md
  2026-11-14).
- ⚠️ **Rotation's plain-`mv` path is unexercised.** The `git mv` path ran for
  the first time on 2026-11-14; the path for a git-ignored journal has not,
  and this repo's next rotation will be the first to use it.
- ⚠️ **The skill cannot hand off a repo other than the session's own.** The
  2026-09-22 entry was written by hand from a `retrieval-lab` session because
  the work happened there. Cross-repo targeting remains a known edge.

## Scratch — not yet promoted

- **why skill — lazy decision archaeology:** answer one "why" question via
  git archaeology, persist the finding to `BECAUSE.md`. Full design in
  [docs/baton-why-design.md](docs/baton-why-design.md).

## Pick up here

1. Start a fresh Claude Code session and a fresh Codex task and confirm each
   loads baton 0.4.0. In a scratch repo: run a first handoff and check that
   the journal is ignored and the commit holds `TODO.md` and `.gitignore`;
   then park one decision, withdraw one, and settle the parked one.
2. In a scratch repo with `TODO.md` in `.gitignore`, run a handoff and check
   that no ignored file is committed (carried over from 0.2.2).

**Later —** dogfood in mise, comparing Claude Code `/baton:handoff` with Codex
`$baton:handoff`. Diagnose plugin-sourced hook discovery in Codex, keeping the
working user hook until the native path is verified. Work port (repo public as
of 2026-07-13, so plain clone works): clone on the work laptop, check the
company's plugin policy, test — falling back to the skills-only degraded
install from the README if plugins/hooks are locked down. Once proven in daily
use, go through the company's formal registration to list it on the internal
skill marketplace.
