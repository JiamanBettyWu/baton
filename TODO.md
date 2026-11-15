# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-11-15 (latest session):** baton 0.4.3 is on `main` and installed
in both hosts; nothing in the plugin changed this session. A design session
produced `docs/baton-learnings-design.md`: a `LEARNINGS.md` file, a promotion
check at handoff, a workstream index in `TODO.md`, and a link to a personal
research wiki. None of it is built. The Codex half of the 0.4.0 test is still
not done. Detail is in the local `SESSIONS.md`.

## Needs attention

- ⚠️ **`docs/baton-learnings-design.md` is not committed.** This repo is
  public, and the doc names personal projects, a work pattern, and local
  paths (most of Part 4 and the "Existing learnings files" section). Decide:
  commit as is, trim the personal parts first, or keep it local.
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
- ⚠️ **Settle the icon before any directory submission.** The validator says
  the listing icon can be set only once, at the first portal submission; the
  docs do not confirm this. The dark outline is faint on dark backgrounds and
  there is no dark variant (Codex has a `logoDark` field). Where Codex shows
  `logo` has not been looked at.
- ⚠️ **Rotation's plain-`mv` path is unexercised.** The `git mv` path ran for
  the first time on 2026-11-14; the path for a git-ignored journal has not,
  and this repo's next rotation will be the first to use it.
- ⚠️ **The skill cannot hand off a repo other than the session's own.** The
  2026-09-22 entry was written by hand from a `retrieval-lab` session because
  the work happened there. Cross-repo targeting remains a known edge.
- ⚠️ **Changes made outside this repo on 2026-11-15** (see that journal
  entry): user-level instructions are now one file, `~/.agents/AGENTS.md`,
  with both hosts symlinked to it; `~/research/llm-wiki/AGENTS.md` has an
  uncommitted change; `~/.agents/backup-instructions-2026-11-15/` can be
  deleted. Where Codex looks for user-level skills is unverified.

## Scratch — not yet promoted

- **why skill — lazy decision archaeology:** answer one "why" question via
  git archaeology, persist the finding to `BECAUSE.md`. Full design in
  [docs/baton-why-design.md](docs/baton-why-design.md).
- **LEARNINGS.md, promotion check, workstream index:** per-project
  non-obvious facts by theme, a handoff step that moves cross-project
  material to user level, and a thread index so old workstreams are found.
  Full design in `docs/baton-learnings-design.md` (local, see Needs attention).

## Pick up here

1. Build Part 1 of `docs/baton-learnings-design.md` (`LEARNINGS.md`) first;
   the promotion check and the wiki capture both use it as their source.
   Settle the doc's open questions as they come up, starting with the
   acceptance test.
2. Run the Codex half of the test in a new scratch repo, in a fresh Codex
   task: `$baton:handoff` on a first handoff, then `$baton:decide` to park one
   decision, withdraw one, and settle the parked one. The Claude Code steps
   and expected results are in SESSIONS.md 2026-11-14 (the 0.4.1 entry).
3. Restart Claude Code so it loads 0.4.3, then repeat the git-ignored
   `TODO.md` handoff in a new scratch repo and check that it still commits
   `.gitignore` alone.

**Later —** in a `retrieval-lab` session, write the first two wiki session
notes (bootstrap versus Wilson interval, Cohen's kappa) to test the note
template. Dogfood in mise, comparing Claude Code `/baton:handoff` with Codex
`$baton:handoff`. Diagnose plugin-sourced hook discovery in Codex, keeping the
working user hook until the native path is verified. Work port (repo public as
of 2026-07-13, so plain clone works): clone on the work laptop, check the
company's plugin policy, test — falling back to the skills-only degraded
install from the README if plugins/hooks are locked down. Once proven in daily
use, go through the company's formal registration to list it on the internal
skill marketplace.
