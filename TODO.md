# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-11-15 (latest session):** baton 0.5.0 is on `main` and pushed
(PR #13): handoff now proposes entries for a theme-first `LEARNINGS.md`, and
this repo has its first one. Both hosts still have 0.4.3 installed, and 0.5.0
is tested in Claude Code only, from the working copy. Parts 2 to 4 of the
design are not built. Detail is in the local `SESSIONS.md`.

## Needs attention

- ⚠️ **0.5.0 has not been installed fresh in either host.** It adds
  `skills/handoff/references/learnings-split.md`, the first reference file,
  and it is unchecked that the hosts copy that folder on install.
- ⚠️ **`docs/baton-learnings-design.md` is still not committed.** This repo
  is public, and the doc names personal projects, a work pattern, and local
  paths. Decide: commit as is, trim the personal parts first, or keep it
  local.
- ⚠️ **The previous handoff's `TODO.md` is public in Git history** (commit
  `5cf31e6`), with three home-directory paths. Left on purpose (see
  SESSIONS.md 2026-11-15, the 0.5.0 entry).
- ⚠️ **The journal has one backup, made 2026-11-14,** in a folder outside
  this repo (named in SESSIONS.md 2026-11-14). Why the journal can be lost
  is in `LEARNINGS.md` under "Git and the journal".
- ⚠️ **Bundled Codex hook discovery remains unresolved.** The plugin's skills
  load, but isolated `hooks/list` probes found no plugin-sourced hook. The
  working hook is from Codex user config and points at this checkout, so
  moving the checkout requires updating that config. `README.md` still
  describes the bundled-hook trust path; update it after the cause and
  supported fix are established (see sessions/2026-07-13--2026-11-05.md,
  2026-11-04).
- ⚠️ **Settle the icon before any directory submission.** The validator says
  the listing icon can be set only once, at the first portal submission; the
  docs do not confirm this. The dark outline is faint on dark backgrounds and
  there is no dark variant (Codex has a `logoDark` field). Where Codex shows
  `logo` has not been looked at.
- ⚠️ **Unexercised paths.** Rotation's plain-`mv` path for a git-ignored
  journal (this repo's next rotation will be the first; the journal is at
  ~480 lines). The `LEARNINGS.md` split in a live session. A handoff that
  adds a new entry under an existing theme. The `TODO.md` privacy rule.
- ⚠️ **The skill cannot hand off a repo other than the session's own.**
  Cross-repo targeting remains a known edge.
- ⚠️ **Changes made outside this repo on 2026-11-15** are listed in
  SESSIONS.md (the design-session entry): one uncommitted change in another
  repository and one backup folder that can be deleted. Where Codex looks
  for user-level skills is unverified.

## Scratch — not yet promoted

- **why skill — lazy decision archaeology:** answer one "why" question via
  git archaeology, persist the finding to `BECAUSE.md`. Full design in
  [docs/baton-why-design.md](docs/baton-why-design.md).
- **Promotion check, workstream index:** a handoff step that moves
  cross-project material to user level, and a thread index in `TODO.md` so
  old workstreams are found. Parts 2 and 3 of
  `docs/baton-learnings-design.md` (local, see Needs attention). Also not
  built from Part 1: regrouping an existing `LEARNINGS.md` into themes.

## Pick up here

1. Update baton to 0.5.0 in both hosts (commands in `README.md`, "Update"),
   start a new session, and check that the installed copy contains
   `skills/handoff/references/learnings-split.md`.
2. Run the Codex tests in a new scratch repo, in a fresh Codex task: a first
   `$baton:handoff` that should stop and ask about a learning candidate, then
   the `$baton:decide` steps still owed from 0.4.0 (park one decision,
   withdraw one, settle the parked one; steps and expected results in
   SESSIONS.md 2026-11-14, the 0.4.1 entry).
3. Pick the next part of the design to build. Part 3 (workstream index) only
   changes `TODO.md` and the hook's wording; Part 2 (promotion check) writes
   outside the repo and needs more care.

**Later —** repeat the git-ignored `TODO.md` handoff in a new scratch repo
and check that it still commits `.gitignore` alone. Consider moving journal
rotation into a reference file (the handoff skill is 480 lines). In a
`retrieval-lab` session, write the first two wiki session notes to test the
note template. Dogfood in mise, comparing Claude Code `/baton:handoff` with
Codex `$baton:handoff`. Diagnose plugin-sourced hook discovery in Codex,
keeping the working user hook until the native path is verified. Work port:
clone on the work laptop, check the company's plugin policy, test, falling
back to the skills-only install from the README if plugins or hooks are
locked down; once proven in daily use, register it on the internal skill
marketplace.
