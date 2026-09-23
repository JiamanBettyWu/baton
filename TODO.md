# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-09-22 (latest session):** baton has one portable implementation
for Claude Code and Codex on branch `agent-agnostic-baton`: root Agent Plugins
metadata, thin host catalogs, shared explicit-only skills, a host-neutral
startup hook, and canonical contributor guidance. The persistence contract is
unchanged, and both write workflows now create scoped records-only commits
without pushing. Detail in [SESSIONS.md](SESSIONS.md).

## Open decisions

(none — nothing currently blocked on an outside call)

## Needs attention

- ⚠️ **Rotation is unexercised** — the ~500-line archive path has never run
  against a real oversized journal; watch the first real rotation. (`baton`'s
  own journal is at 263 lines; `retrieval-lab`'s is at 449 and will trip first.)
- ⚠️ **The skill cannot hand off a repo other than the session's own.** This
  entry was written by hand from a `retrieval-lab` session, because the work
  happened there and the narrative only exists where the session was. Not
  obviously worth fixing — cross-repo targeting is a real complication for a
  rare case — but it is a known edge, not an oversight.
- ⚠️ **Recheck automatic hook discovery after the local Codex runtime is
  updated.** Codex `0.154.0-alpha.6.2` discovered both packaged skills but
  showed no plugin hook for the current documented root-manifest extension.
  The shared hook itself passes its fixture tests, and the README documents
  the disabled-hook fallback; live marketplace verification is not a release
  blocker for this source migration.

## Scratch — not yet promoted

- **why skill — lazy decision archaeology:** answer one "why" question via
  git archaeology, persist the finding to `BECAUSE.md`. Full design in
  [docs/baton-why-design.md](docs/baton-why-design.md).

## Pick up here

1. Dogfood in mise: end one Claude Code session with `/baton:handoff` and one
   Codex session with `$handoff`; compare the resulting files and scoped
   commits. Betty's own entries are the strictest test of format fidelity.
2. After updating Codex, review and trust the baton hook in `/hooks`, then
   confirm a new task receives all of `TODO.md` and only the latest
   `SESSIONS.md` heading.

**Later —** work port (repo public as of 2026-07-13, so plain clone works):
clone on the work laptop, check the company's plugin policy, test — falling
back to the skills-only degraded install from the README if plugins/hooks are
locked down. Once proven in daily use, go through the company's formal
registration to list it on the internal skill marketplace.
