# baton 🏃‍♀️

Decision-aware session handoffs for coding agents, with first-class support
for Claude Code and Codex.

Session-summary tools remember *what happened*. `baton` is built for a
different pause: **work stopped because a decision left the room**. When work
resumes, the important context is which option was chosen and which parts of
the plan that invalidates.

`baton` maintains two plain-Markdown files at the project root:

- **`TODO.md`** — forward-looking state, refreshed at each handoff: a short
  current-state pointer, open decisions with options and trade-offs, and the
  next 2–3 actions.
- **`SESSIONS.md`** — an append-only dated journal: one narrative entry per
  session, with decisions recorded alongside their reasoning.

A `SessionStart` hook injects `TODO.md` plus the latest journal entry's title
when a session starts or resumes. The hook activates only when both files
exist, so a project with an unrelated `TODO.md` is unaffected.

## Skills

| Workflow | Claude Code | Codex | What it does |
| --- | --- | --- | --- |
| Handoff | `/baton:handoff [notes]` | `$handoff` with optional notes | Sweeps for loose ends and stale docs, appends to `SESSIONS.md`, refreshes `TODO.md`, and creates a scoped commit that never pushes |
| Decide | `/baton:decide <outcome>` | `$decide` with the outcome | Logs a decision and its reasoning, promotes the matching branch of the plan, flags invalidated work, and creates a scoped records-only commit |

Both workflows are explicit-only. They do not run unless the user invokes the
skill or directly asks for that action.

## Install

### Claude Code

When migrating from the older personal install, remove the
`~/.claude/skills/baton` symlink first so baton and its startup hook do not load
twice.

```bash
claude plugin marketplace add JiamanBettyWu/baton
claude plugin install baton@baton
```

For development against a working copy:

```bash
claude --plugin-dir ~/dev/baton
```

### Codex

```bash
codex plugin marketplace add JiamanBettyWu/baton
codex plugin add baton@baton
```

Start a new task after installation so Codex loads the skills and hook. Codex
does not automatically trust plugin-bundled hooks: open `/hooks`, review the
baton `SessionStart` hook, and trust it before expecting automatic context
injection.

For local development, replace `JiamanBettyWu/baton` with the absolute path to
a clean checkout or export when adding the marketplace, then reinstall the
plugin and start a new task after changes. Local-path installation copies that
directory, including ignored files, so do not point it at a working copy that
contains private local configuration.

## Projects with their own conventions

If a project documents a session-notes workflow in an active instruction file
such as `AGENTS.md` or `CLAUDE.md`, both skills follow that convention instead
of imposing baton's default templates. If active instruction files conflict,
the skill asks which convention is canonical rather than merging them.

## Hooks disabled or unavailable

The skills still work without lifecycle hooks. Install `skills/handoff` and
`skills/decide` in the host's project skill directory (`.claude/skills/` for
Claude Code or `.agents/skills/` for Codex), and begin a session by asking the
agent to read `TODO.md`. This is also the fallback for locked-down environments
that prohibit plugins or untrusted hooks.

Other agents may load the shared skill directories manually when they support
the Agent Skills format, but this release provides first-class packaging only
for Claude Code and Codex.

If Codex discovers the skills but `/hooks` shows no baton hook, update to a
Codex build that supports portable plugin hooks or use the manual fallback
above.

## Notes

The state files are human-readable, human-editable, and reviewable in Git.
Both skills stage only the records they created or updated and never push.
`TODO.md` stays current-state only; resolved decisions move to the append-only
journal. If handoffs are frequently missed, add a host-supported end-of-session
reminder rather than duplicating the workflow.

## License

MIT — see [LICENSE](LICENSE).
