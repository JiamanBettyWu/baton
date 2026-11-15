<p align="center">
  <img src="assets/icon.png" alt="baton icon: a running character holding up a relay baton" width="160">
</p>

# baton

Decision-aware session handoffs for coding agents, with first-class support
for Claude Code and Codex.

Session-summary tools remember *what happened*. `baton` is built for a
different pause: **work stopped because a decision left the room**. When work
resumes, the important context is which option was chosen and which parts of
the plan that invalidates.

`baton` maintains plain-Markdown files at the project root:

- **`TODO.md`** — forward-looking state, refreshed at each handoff: a short
  current-state pointer, open decisions with options and trade-offs, and the
  next 2–3 actions.
- **`SESSIONS.md`** — an append-only dated journal: one narrative entry per
  session, with decisions recorded alongside their reasoning. It is
  **local-only by default**: the first handoff adds it to `.gitignore`, so
  session detail is not pushed. See [Journal privacy](#journal-privacy).
- **`LEARNINGS.md`** (optional) — what is true in the project that is not
  obvious: environment quirks, tooling behavior, setup steps that were hard
  to work out. Grouped by theme with an index at the top, and committed. See
  [Learnings](#learnings).

A `SessionStart` hook injects `TODO.md` plus the latest journal entry's title
when a session starts or resumes, and says when to look in the journal and in
`LEARNINGS.md`. It does not print either of them. The hook activates when the journal exists,
or when `TODO.md` points at `SESSIONS.md` (a clone without the local journal),
so a project with an unrelated `TODO.md` is unaffected.

## Skills

| Workflow | Claude Code | Codex | What it does |
| --- | --- | --- | --- |
| Handoff | `/baton:handoff [notes]` | `$handoff` with optional notes | Sweeps for loose ends and stale docs, appends to `SESSIONS.md`, refreshes `TODO.md`, proposes entries for `LEARNINGS.md`, and creates a scoped commit that never pushes |
| Decide | `/baton:decide <outcome>` | `$decide` with the outcome | Logs a decision and its reasoning, promotes the matching branch of the plan (or parks or withdraws the decision), flags invalidated work, and creates a scoped records-only commit |

Both workflows are explicit-only. They do not run unless the user invokes the
skill or directly asks for that action.

If a project git-ignores any of its notes files, both workflows treat those
files as local-only: they still write them but leave them out of the commit
instead of forcing ignored paths into Git.

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

### Update

Refresh the marketplace, then update the plugin. Start a new session or task
afterward so the new version loads.

```bash
# Claude Code
claude plugin marketplace update baton
claude plugin update baton@baton

# Codex
codex plugin marketplace upgrade baton
codex plugin add baton@baton
```

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

## Journal privacy

Session journals collect private detail: local paths, names, and dead ends.
So when a handoff creates the journal in a Git repository, it adds
`SESSIONS.md` and the `sessions/` archive to `.gitignore`. `TODO.md` is still
committed. A local-only journal has no Git history or backup, and it does not
exist in other clones.

- **To share the journal instead:** ask for that at the first handoff, or
  later remove the two lines from `.gitignore`. The next handoff then commits
  the journal.
- **To make an already-committed journal local-only:** baton never does this
  on its own. Add the two lines to `.gitignore` and run
  `git rm --cached SESSIONS.md` (and `git rm -r --cached sessions` if the
  archive exists). Two warnings: entries already pushed stay in the Git
  history, and every other clone loses its copy of the file on the next pull,
  so back the journal up there first.

## Learnings

The test for an entry: would a new session waste time rediscovering this?

- **How entries get in.** At each handoff, baton proposes candidates from the
  session and writes only the ones you confirm. Once the file exists you can also ask at any
  time ("add that to learnings"); the file's header states the format, so
  the agent does not need the handoff skill loaded.
- **Nothing private.** The file is committed while the journal is local-only,
  so baton rewords or holds back anything with a name, a path outside the
  repository, or a secret.
- **Nothing is deleted.** An entry that stops being true gets an
  `Outdated as of <date>: <what is true now>` line under it; a re-checked one
  gets `Verified <date>`.
- **Growth.** Past ~500 lines, baton offers to split the file into
  `learnings/<theme>.md`, with `LEARNINGS.md` kept as the index.
- **An existing `LEARNINGS.md`** in another shape (a dated log, a report) is
  never restructured without asking, and a header that says "append-only" is
  followed.

## Notes

The state files are human-readable and human-editable, and `TODO.md` is
reviewable in Git.
Both skills stage only the records they created or updated and never push.
`TODO.md` stays current-state only; resolved decisions move to the append-only
journal, and parked decisions keep their full options in `PARKED.md` with a
one-line pointer in `TODO.md`. If handoffs are frequently missed, add a
host-supported end-of-session reminder rather than duplicating the workflow.

## License

MIT — see [LICENSE](LICENSE).
