# TODO

Forward-looking state. Session history lives in [SESSIONS.md](SESSIONS.md).

## Current state

**As of 2026-11-04 (latest session):** Codex discovers both baton skills, and
Betty confirmed startup context in a fresh local task after a user-level
hook was installed at `~/.codex/hooks.json`. The bundled plugin hook still does
not appear in Hooks; the local checkout is 0.2.0 while Codex has 0.2.1
installed. Detail in [SESSIONS.md](SESSIONS.md).

## Needs attention

- ⚠️ **Rotation is unexercised** — the ~500-line archive path has never run
  against a real oversized journal; `SESSIONS.md` was 338 lines before this
  entry, so watch its first real rotation.
- ⚠️ **The skill cannot hand off a repo other than the session's own.** This
  entry was written by hand from a `retrieval-lab` session, because the work
  happened there and the narrative only exists where the session was. Not
  obviously worth fixing — cross-repo targeting is a real complication for a
  rare case — but it is a known edge, not an oversight.
- ⚠️ **Bundled Codex hook discovery remains unresolved.** The 0.2.1 plugin is
  enabled and its skills load, but `Settings > Hooks` and an isolated
  `hooks/list` probe show no plugin hook. The working user hook points at
  `/Users/jiamanwu/dev/baton/hooks/session-start.sh`, so moving this checkout
  requires updating `~/.codex/hooks.json`. `README.md` still describes the
  bundled-hook trust path; update it after the cause and supported fix are
  established (see SESSIONS.md 2026-11-04).
- ⚠️ **Checkout and installation differ.** This checkout has `plugin.json`
  0.2.0 and local `main` includes unpushed `db27514`; Codex has 0.2.1 from
  marketplace revision `e5f0e9321204aa7145e07682fb57e4c6c184965c`.
  Reconcile before editing plugin sources or pushing.
- ⚠️ **Strict Claude plugin validation has a new warning.** Besides the
  documented root `CLAUDE.md` warning, `claude plugin validate . --strict`
  reports `ICON_MISSING`; decide whether to add a listing icon before the
  next packaging handoff. The bundled skill validator's rejection of
  `disable-model-invocation` remains expected.

## Scratch — not yet promoted

- **why skill — lazy decision archaeology:** answer one "why" question via
  git archaeology, persist the finding to `BECAUSE.md`. Full design in
  [docs/baton-why-design.md](docs/baton-why-design.md).

## Pick up here

1. Reconcile local `main`/`plugin.json` 0.2.0 with installed baton 0.2.1 and
   preserve the unpushed `db27514` handoff commit.
2. Diagnose why the bundled `hooks/hooks.json` is absent from Codex Hooks;
   keep the working user hook until the native path is verified, then update
   `README.md` and its installation guidance.
3. Dogfood in mise: compare Claude Code `/baton:handoff` with Codex
   `$baton:handoff`, including file output, scoped commit contents, and no push.

**Later —** work port (repo public as of 2026-07-13, so plain clone works):
clone on the work laptop, check the company's plugin policy, test — falling
back to the skills-only degraded install from the README if plugins/hooks are
locked down. Once proven in daily use, go through the company's formal
registration to list it on the internal skill marketplace.
