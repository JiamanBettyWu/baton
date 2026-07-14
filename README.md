# baton 🏃‍♀️

Decision-aware session handoffs for Claude Code.

Session-summary tools remember *what happened*. `baton` is built for a
different pause: **work stopped because a decision left the room** — you're
waiting on team alignment, and when you come back, what matters is which
option was chosen and which parts of the plan that invalidates.

`baton` maintains two plain-markdown files per project, at the repo root:

- **`TODO.md`** — forward-looking state, refreshed each handoff: a ~3-sentence
  current-state pointer, **open decisions** (options, trade-offs,
  recommendation, outcome-dependent next steps), and the next 2–3 actions.
- **`SESSIONS.md`** — an append-only dated journal: one narrative entry per
  session, decisions recorded *with their reasoning*. History never gets
  rewritten — it's greppable when work resumes a thread from weeks ago, and
  it's blog-post source material.

A SessionStart hook injects `TODO.md` (plus a pointer to the latest journal
entry) at the start of every session, so Claude is already caught up before
your first prompt.

## Skills

| Skill | When | What it does |
| --- | --- | --- |
| `/baton:handoff [notes]` | End of a session, or before pausing for alignment | Appends a dated journal entry to `SESSIONS.md`, refreshes `TODO.md`; initializes both files in a fresh project; prints open decisions ready to paste to your team |
| `/baton:decide <outcome>` | The team decided | Logs the decision + reasoning to the journal, promotes the matching "if" branch of the plan in `TODO.md`, flags work the outcome invalidated |

The hook (on startup, resume, and `/clear`) activates only when **both** files
exist, so repos with an unrelated `TODO.md` are unaffected.

## Install

**Personal (auto-loading, no marketplace needed):**

```bash
git clone https://github.com/<you>/baton ~/.claude/skills/baton
```

Plugins placed in `~/.claude/skills/` load automatically in every session
(as `baton@skills-dir`). To develop against a working copy elsewhere instead:

```bash
claude --plugin-dir ~/dev/baton
```

**Via a marketplace** (team/company): add this repo to the marketplace's
`marketplace.json`, then `/plugin install baton@<marketplace>`.

**Locked-down environment (plugins/hooks disabled):** the skills degrade
gracefully to plain project skills — copy `skills/handoff` and `skills/decide`
into the repo's `.claude/skills/` (they become `/handoff` and `/decide`).
Without the hook, start sessions with "read TODO.md", or add the
`SessionStart` block from `hooks/hooks.json` to `.claude/settings.json` with
the script path adjusted, if hooks are permitted.

## Projects with their own conventions

If a project already documents a session-notes workflow in CLAUDE.md /
AGENTS.md, both skills **defer to it** — same files, same format, same rules —
rather than imposing the default templates. The hook works unchanged wherever
the project keeps `TODO.md` + `SESSIONS.md` at the root.

## Notes

The files are ordinary markdown — human-readable, human-editable, reviewable
in git. Commit them if teammates use Claude Code too; `.gitignore` them if
personal. `TODO.md` is current-state only (resolved decisions move to the
journal); `SESSIONS.md` is append-only. The failure mode of every handoff
system is the state file going stale — if you keep forgetting to run
`/baton:handoff`, wire a SessionEnd reminder hook.

## License

MIT — see [LICENSE](LICENSE).
