# Repository guidance

`baton` is a portable plugin with first-class support for Claude Code and
Codex. Keep one implementation of each workflow and use host-specific files
only for discovery, installation, or invocation policy.

## Canonical sources

- `plugin.json` owns portable plugin identity and metadata.
- `skills/*/SKILL.md` owns workflow instructions.
- `hooks/hooks.json` and `hooks/session-start.sh` own startup behavior.
- `.claude-plugin/` and `.agents/` are thin host adapters.
  Do not copy workflow instructions into them.
- `TODO.md` is current state. `SESSIONS.md` is append-only history; never edit
  old entries to modernize terminology.

## Portability rules

- Shared skill bodies must not depend on host command-template placeholders,
  host-specific home directories, or one host's invocation syntax.
- Host-specific invocation policy belongs in host metadata, such as
  `skills/*/agents/openai.yaml` for Codex.
- Hook commands must prefer `PLUGIN_ROOT` and fall back to
  `CLAUDE_PLUGIN_ROOT`. Project discovery must work without either host's
  project-directory variable.
- If live documentation names a host-specific command, show the Claude Code
  and Codex forms together. Historical journal entries remain unchanged.

## Validation

Run before handing off a plugin change:

```bash
bash tests/session-start.sh
bash -n hooks/session-start.sh tests/session-start.sh
claude plugin validate . --strict
claude plugin validate .claude-plugin/marketplace.json --strict
```

The first Claude command currently reports one expected repository-level
warning because `CLAUDE.md` imports contributor guidance and is not a plugin
component; treat any additional warning or any error as a failure. Also
validate both skills with the bundled skill validator and test a fresh
installation in both supported hosts when packaging or discovery changes.
