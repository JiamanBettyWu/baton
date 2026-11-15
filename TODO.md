# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-11-14 (latest session):** baton 0.4.1 is on `main` (PR #9), and
the plugin icon is in at `assets/icon.png` and shown in the README (PR #10).
The 0.4.0 behavior passed in two Claude Code scratch repos; 0.4.1 is a
one-clause wording fix in the handoff skill found by that test. Both hosts are
reinstalled at 0.4.1, but no fresh session has loaded it, and the Codex half
of the test is not done. Detail is in the local `SESSIONS.md`.

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
- ⚠️ **Installed copies do not have the icon.** PR #10 added it without a
  version bump, and both hosts were reinstalled at 0.4.1 before it merged. How
  the icon renders in a host or in the plugin directory is unchecked, and the
  listing icon can be set only once, at the first portal submission.
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

1. Run the Codex half of the test in a new scratch repo, in a fresh Codex task
   that loads 0.4.1: `$baton:handoff` on a first handoff, then `$baton:decide`
   to park one decision, withdraw one, and settle the parked one. The Claude
   Code steps and expected results are in SESSIONS.md 2026-11-14.
2. In a fresh session on 0.4.1, repeat the git-ignored `TODO.md` handoff and
   check that it still commits `.gitignore` alone.

**Later —** dogfood in mise, comparing Claude Code `/baton:handoff` with Codex
`$baton:handoff`. Diagnose plugin-sourced hook discovery in Codex, keeping the
working user hook until the native path is verified. Work port (repo public as
of 2026-07-13, so plain clone works): clone on the work laptop, check the
company's plugin policy, test — falling back to the skills-only degraded
install from the README if plugins/hooks are locked down. Once proven in daily
use, go through the company's formal registration to list it on the internal
skill marketplace.
