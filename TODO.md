# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-08-24 (latest session):** shipped **PR #1** (`2cb8f90`) — the
handoff skill now says *what qualifies* as an open decision (a question that
cannot be settled yet; anything with a definition of done is work and belongs
where the project tracks work), the ~100-line budget gained a diagnostic, and
substantive changes now commit separately from the handoff. Also committed four
refinements that had been **live but uncommitted since 2026-07-18** — the
symlink means the working tree is the runtime, so they had been running for five
weeks (`bb5f0cd`). Working tree clean, `main` pushed. Detail in
[SESSIONS.md](SESSIONS.md).

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

## Scratch — not yet promoted

- **`/baton:why` — lazy decision archaeology:** answer one "why" question via
  git archaeology, persist the finding to `BECAUSE.md`. Full design in
  [docs/baton-why-design.md](docs/baton-why-design.md).

## Pick up here

1. Mirror the auto-commit step into `/baton:decide` (it writes SESSIONS.md +
   TODO.md but never commits them — same gap handoff closed on 2026-07-15).
   **Now evidenced:** this repo just found four of its own edits uncommitted and
   live for five weeks. A skill that writes files it does not commit produces
   exactly that, and the symlink makes it invisible — nothing looks broken.
2. Dogfood in mise: end the next mise session with `/baton:handoff` and
   judge the SESSIONS.md entry against Betty's own entries — the convention
   it was modeled on is the strictest test of format fidelity.

**Later —** work port (repo public as of 2026-07-13, so plain clone works):
clone on the work laptop, check the company's plugin policy, test — falling
back to the skills-only degraded install from the README if plugins/hooks are
locked down. Once proven in daily use, go through the company's formal
registration to list it on the internal skill marketplace.
