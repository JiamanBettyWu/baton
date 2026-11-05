# Session log

Reverse-chronological journal — one dated entry per working session: what got
done, what was decided and why. History only; for what to do next see
[TODO.md](TODO.md).

---

## 2026-11-05 (skip git-ignored record files; baton 0.2.2)

Betty proposed that the skills run `git check-ignore -q <path>` on each
record file before staging, and treat ignored notes as local-only instead of
forcing them into Git. Shipped as `d552c8f` ("Skip git-ignored record files
instead of forcing them") on `feat/skip-ignored-records`, merged as PR #6
(`5097e92`). That branch is now deleted locally and on `origin`. The rule
lives in both `skills/handoff/SKILL.md` ("Commit the handoff", plus the
rotation step) and `skills/decide/SKILL.md` ("Commit the decision record").
Both stage records the same way, so applying it only to handoff would have
let `decide` force-commit what handoff skips.

**Per-file skip, not whole-commit skip (the real decision):** the first draft
skipped the entire commit if *any* record file was ignored, on the theory that
committing only some records lets the journal and plan drift apart in history.
Betty pushed back, and she was right. A project that ignores `TODO.md` but
tracks `SESSIONS.md` has already chosen to keep the plan local and share the
journal. Skipping everything breaks that choice: the journal never gets
committed, and a tracked README drift fix is left uncommitted. The final rule
leaves each ignored file out of both `git add` and the
`git commit --only -- <paths>` pathspec. Untracked ignored paths must also
stay out of the pathspec, because naming one there makes Git stop with
"pathspec did not match". The commit is skipped only when every file is
ignored. The report-back lists the skipped paths.

**Exit-code semantics, tested in a scratch repo:** `git check-ignore -q`
returns 0 for an untracked ignored file and 1 for a file that is not ignored.
It also returns 1 for a **tracked** file that matches an ignore pattern, since
Git does not apply ignore rules to tracked files. With `--no-index` that same
tracked file returns 0. So the skills forbid `--no-index` (a file the project
already commits must keep being committed) and forbid `git add -f`. Outside
a repository the command exits 128; the skills call that an error, not
"ignored". Rotation now uses plain `mv` instead of `git mv` when `SESSIONS.md`
is ignored. A new fixture in `tests/commit-scope.sh` covers the
partly-ignored case (only `SESSIONS.md` committed, staged `src/feature.py`
preserved, `TODO.md` never tracked), the tracked-file exit 1, and exit 128
outside a repo with `GIT_CEILING_DIRECTORIES`. README gained a paragraph
under "Skills". The version is now 0.2.2 in both `plugin.json` and
`.claude-plugin/plugin.json`. The full AGENTS.md validation block passed apart
from the known `CLAUDE.md` and `ICON_MISSING` warnings.

**Reinstalls:** Claude Code was installed as `baton@baton` 0.2.0. Ran
`claude plugin marketplace update baton` and then
`claude plugin update baton@baton`, which reported 0.2.0 → 0.2.2. Codex
reported 0.2.1. Ran `codex plugin marketplace upgrade baton` and then
`codex plugin add baton@baton`, which installed to
`~/.codex/plugins/cache/baton/baton/0.2.2`. Both installed copies contain the
`check-ignore` rule in both skills (grepped). Whether a fresh session in each
host loads 0.2.2 is `(unverified — no new session started yet)`. The Codex
startup hook still runs through the user-level `~/.codex/hooks.json`, which
points at `/Users/jiamanwu/dev/baton/hooks/session-start.sh`; the reinstall
did not touch it.

**Version label versus content:** during the session I told Betty that the
Claude Code install "never got the 0.2.1 journal rules". That was wrong. The
cached `~/.claude/plugins/cache/baton/baton/0.2.0/skills/handoff/SKILL.md`
already has the fidelity rules: they landed in `bb78dcf` (PR #3), before
the version bump in `9a67681`, and the install was taken between the two. Only
the version label was behind. This handoff itself ran from that 0.2.0 cache,
because the session started before the update, so it lacks the new ignore
check. That has no effect here, because `TODO.md` and `SESSIONS.md` are
tracked in baton.

**README update steps:** added an "Update" subsection under "Install" with
the marketplace-refresh and update commands for both hosts (the same commands
used above). Committed directly to `main` as `082fdd7` at Betty's request,
since it is docs-only, and pushed.

## 2026-11-04 (merge remote baton 0.2.1 with local handoffs)

Fetched `origin/main` at `e5f0e9321204aa7145e07682fb57e4c6c184965c`
and merged its 0.2.1 manifests and journal-fidelity skill rules with local
handoff commits `db27514` and `9384357`. The remote journal addition had
replaced the heading of the older 2026-09-22 PR-review entry; merge resolution
restored that heading and retained both new 2026-11-04 narratives and all
older entry bodies. `TODO.md` now points to the merged state instead of
repeating the resolved 0.2.0-versus-0.2.1 mismatch. The shell, commit-scope,
package-metadata, syntax, and marketplace-manifest checks passed. Both 0.2.1
skills passed the bundled Agent Skills validator after removing only the
intentional `disable-model-invocation` key in temporary copies; strict Claude
root validation still exits nonzero on the expected `CLAUDE.md` warning plus
`ICON_MISSING`. No plugin or user hook was changed during this merge.

## 2026-11-04 (Codex startup context verified through user hook)

Checked the existing baton 0.2 checkout before changing anything. The
`tests/session-start.sh`, `tests/commit-scope.sh`, and
`tests/package-metadata.sh` suites and shell syntax checks passed; strict
validation of `.claude-plugin/marketplace.json` passed. The bundled Agent
Skills validator rejected both skills only for the intentional
`disable-model-invocation: true` Claude extension; temporary copies without
that key passed. `claude plugin validate . --strict` failed on the documented
root `CLAUDE.md` warning plus a newly observed `ICON_MISSING` warning, so the
repository's stated strict-validation bar is not currently met. No plugin
source was edited to suppress either diagnostic.

The first new Codex task did not receive startup context. After a desktop
restart, the skill picker showed both `baton:handoff` and `baton:decide`, and
the Plugins page showed the baton marketplace and installed plugin. The CLI
reported `baton@baton` 0.2.1 enabled, from marketplace revision
`e5f0e9321204aa7145e07682fb57e4c6c184965c`; that installed package has
newer skill text than this 0.2.0 checkout, while its hook files match. The
local `main` still has the earlier unpushed `db27514` handoff commit.

Corrects the 2026-09-22 expectation that the next Codex step is simply to
trust baton's bundled hook: despite the installed skills, the bundled
`SessionStart` handler was absent from `Settings > Hooks`. Isolated probes
using the desktop-bundled Codex CLI `0.166.0-alpha.5.1` and standalone CLI
`0.156.1` reproduced this split: `skills/list` found both skills, while
`hooks/list` returned an empty list with no warnings or errors. The same
`hooks/hooks.json` was discovered as an untrusted user hook in a temporary
home. Simpler commands, default-file discovery, a compatibility manifest,
and `requires_local_executor` did not make the plugin hook appear in those
probes. The cause of plugin hook omission remains unverified.

Betty approved a local workaround, so `~/.codex/hooks.json` now points to
`/Users/jiamanwu/dev/baton/hooks/session-start.sh`. The JSON was validated,
the exact user-hook definition appeared as untrusted in an isolated
`hooks/list` probe, and direct script output contained `TODO.md` plus the
latest `SESSIONS.md` heading. Betty later reported that a fresh local Codex
task received baton startup context. This proves the
user-level path in practice; it does not prove the bundled plugin hook. The
absolute script path is tied to this checkout. `README.md` still describes
the bundled-hook trust path, but its correction waits on an established cause
or supported packaging fix. No repo source or README file changed in this
session, and nothing was pushed.

## 2026-09-22 (baton 0.2 merged and installed for Codex)

Completed the agent-agnostic migration and merged PR #2 as `92df370`. Baton
0.2 now has one editable workflow implementation in `skills/` and `hooks/`,
with a canonical root plugin manifest, thin Claude Code and Codex discovery
adapters, `AGENTS.md` as the shared contributor guide, and `CLAUDE.md` as an
import-only compatibility file. The existing `TODO.md`/`SESSIONS.md`
persistence contract and Claude command names remain intact.

Review tightened the boundaries that matter for a mutating workflow. Claude's
`disable-model-invocation: true` guard was restored even though the portable
skill validator does not accept that host-specific key; Codex carries the
equivalent `allow_implicit_invocation: false` setting. Both `decide` and
`handoff` now commit with `git commit --only` and explicit record pathspecs,
so unrelated files that were already staged cannot leak into a records-only
commit. Regression coverage exercises that case for both existing and newly
created record files.

The shared startup hook and its fixtures were hardened during review. Codex
prefers an initialized baton project in the current directory before falling
back to the Git root, inherited Claude project variables are cleared where a
fixture is meant to exercise another path, and the suite covers no-Git and
both-root-variable cases. Tests now read the hook command from
`hooks/hooks.json` instead of duplicating it, manifest versions must match,
the D-number scan is safe when `sessions/` is absent, and the README warns
users to remove the legacy `~/.claude/skills/baton` symlink before installing.

After the merge, `main` was fast-forwarded and the shell, commit-scope,
package-metadata, and syntax suites all passed. The standalone Codex CLI is
now `0.156.1`, and its local catalog reports `baton@baton` version 0.2.0 as
installed and enabled. This handoff was run manually because the already-open
task predates that installation. A fresh task still needs to prove live skill
discovery and trusted SessionStart injection; no workaround or duplicate hook
body was added for the older app-bundled runtime.

## 2026-11-04 (journal fidelity rules: full identifiers, unverified tags, corrections)

Shipped three record-fidelity conventions into both write skills, from Betty's
own proposal. `skills/handoff/SKILL.md` gained three Rules entries and
`skills/decide/SKILL.md` a condensed mirror in its journal-recording step
(PR [#3](https://github.com/JiamanBettyWu/baton/pull/3), squash-merged as
`bb78dcf`): identifiers are written out in full as they exist (tables, columns,
files, tickets) and every selection names the inputs that produced it; a claim
that records a *reading* of data or code rather than a tested result is tagged
`(unverified)` at the claim level, ideally with its source; and when a session
disproves an earlier journal entry, the new entry says "corrects <date>: …"
while the old entry stays untouched — the corrections convention is what makes
the append-only rule safe, since append-only without corrections makes errors
permanent. The sweep also checks whether a corrected claim leaked into
TODO.md's current state. Versions then moved to 0.2.1 in both `plugin.json`
and `.claude-plugin/plugin.json`
(PR [#4](https://github.com/JiamanBettyWu/baton/pull/4), merged as `997b9d8`).

**Validation gap (environment):** the cloud sandbox blocked downloading the
bundled Agent Skills validator, so the change was verified only by
`tests/session-start.sh`, `tests/commit-scope.sh`, `tests/package-metadata.sh`,
`bash -n`, and `claude plugin validate . --strict` — which showed the one
documented expected `CLAUDE.md` warning plus a plugin-directory `ICON_MISSING`
notice that does not affect validation and predates this change (unverified —
inferred from the change touching only skill prose, not re-run against the
prior commit). The skill validator should be run locally once.

**Install archaeology on Betty's machine:** `claude plugin install baton@baton`
failed with "Plugin not found in marketplace" because the `baton` marketplace
had never been added there — only the pre-plugin personal install existed, a
symlink `~/.claude/skills/baton -> ~/dev/baton` from July. Removed the symlink
(the README's documented migration step), then
`claude plugin marketplace add JiamanBettyWu/baton` and
`claude plugin install baton@baton` succeeded. Worth remembering: installs are
two cached layers (marketplace clone, then plugin copy), so publishing a change
means `claude plugin marketplace update baton` *then*
`claude plugin update baton@baton`, and a new session to load it.

**Environment quirk:** the Claude Code cloud sandbox's permission classifier
denies `git push --delete`, `git push --force-with-lease`, and GitHub-API
branch deletion as destructive, even on a branch holding only merged history.
After a squash merge, replacing the remote work branch therefore needs the
user to delete it by hand; a true merge (as in PR #4) avoids this because the
restarted branch fast-forwards.
## 2026-09-22 (PR review: discovery and packaging regressions)

Hardened three migration edges found in review. Without
`CLAUDE_PROJECT_DIR`, the startup hook now checks the current folder for
`TODO.md` before falling back to the Git root, so a baton-enabled subproject in
a monorepo does not silently inherit or miss parent state. The README now tells
users migrating from the old personal install to remove the
`~/.claude/skills/baton` symlink before plugin installation, preventing double
skill and hook loading. A package-metadata test now asserts that the portable
and Claude compatibility manifests carry the same version.

---

## 2026-09-22 (isolate records-only commits from the existing index)

Fixed a commit-boundary bug found in review: staging only `TODO.md` and
`SESSIONS.md` does not make a subsequent plain `git commit` records-only,
because Git also includes anything that was already staged before the skill
ran. Both handoff and decide now commit with `git commit --only` plus an
explicit pathspec containing every record the workflow wrote. Unrelated staged
work remains staged for its own commit. Added a regression fixture covering
both existing record files and the first-run case where the records are new.

---

## 2026-09-22 (restore Claude's explicit-invocation guard)

Restored `disable-model-invocation: true` to both mutating skills after review
of the first agent-agnostic PR. The portable Agent Skills validator rejects
that Claude-specific top-level key, but instruction text alone is not an
equivalent safety boundary: without the flag Claude may select a write-and-
commit workflow automatically. Claude now enforces user-only invocation in
the shared frontmatter, while Codex continues to enforce the same policy with
`allow_implicit_invocation: false` in each `agents/openai.yaml`. Source-install
safety takes precedence over public-submission validation for this release.

---

## 2026-09-22 (baton 0.2: agent-agnostic Claude Code and Codex)

Converted baton from a Claude-native plugin into one portable implementation
with thin discovery adapters. The new root `plugin.json` is the canonical
Agent Plugins manifest at version 0.2.0; `.claude-plugin/` and `.agents/`
contain only host-facing manifests and catalogs. `AGENTS.md` now owns
contributor guidance, while `CLAUDE.md` imports it instead of maintaining a
second editable copy. The actual workflow remains in `skills/` and `hooks/`.

Both skills now carry required `name` metadata, consume context from the
user's request rather than `$ARGUMENTS`, and run only after an explicit user
request. They honor a project's own session convention, but ask when active
`AGENTS.md` and `CLAUDE.md` rules conflict instead of silently merging them.
The decide workflow gained the same durability boundary as handoff: it stages
only the record files it changed, creates a records-only commit, and never
pushes.

The shared SessionStart hook now resolves its executable through `PLUGIN_ROOT`
with `CLAUDE_PLUGIN_ROOT` as a compatibility fallback. It resolves the project
from `CLAUDE_PROJECT_DIR`, then the Git root, then the current directory, and
its plain-text suggestions use neutral skill names. Repeatable shell fixtures
cover both files, journal-only, TODO-only, neither file, nested directories,
latest-heading extraction, and exclusion of the journal body. Package JSON,
both skill frontmatters, shell syntax, and the Claude manifests were validated;
a Claude debug load discovered both skills and injected the expected startup
context.

Codex `0.154.0-alpha.6.2` discovered both skills in a clean staged package but
reported no bundled hook even though the root extension matches the current
documented schema. The hook itself is covered by host-neutral fixture tests,
and the README documents trust plus the manual fallback. Betty explicitly
scoped live marketplace verification out of this migration, so the older local
runtime mismatch is recorded for a future Codex update rather than worked
around with a duplicate hook body.

---

## 2026-08-24 (what qualifies as an open decision)

Written from a `retrieval-lab` session rather than a baton one — the work
happened there, and `/baton:handoff` targets the session's own project, so this
entry was composed by hand against the same convention. Worth noting as a small
gap: the skill has no way to hand off *another* repo, and the narrative always
lives in the session where the work happened.

**Four edits had been live-but-uncommitted since 2026-07-18.** `skills/handoff/
SKILL.md` had a dirty working tree five weeks old: the project-level-CLAUDE.md
clarification, the trivially-safe-hygiene-fixes bullet, don't-duplicate-the-
project's-knowledge-files, and D-numbers-are-project-lifetime. Because
`~/.claude/skills/baton` symlinks into this working tree, **the uncommitted
version is the version that runs** — all four had been shaping every handoff in
every project for five weeks, and a `git checkout` would have silently reverted
behaviour nobody would have known to look for. Committed as `bb5f0cd`, no
behaviour change on merge since they were already what ran. The irony is on the
nose: `TODO.md` said "working tree clean" as of 2026-07-17, and item 1 of its
own "Pick up here" is a bug about skills that write files but never commit them.

**The actual change: the skill never said what qualifies as an open decision.**
It described the *shape* — question, options with trade-offs, recommendation,
blocked-on, if-A/if-B — but not the admission criterion. So the section collects
tasks, and `TODO.md` grows without anyone doing anything wrong. The evidence
came from `retrieval-lab` the day before (see its SESSIONS.md 2026-08-23): five
"open decisions", four of which had costed options, a recommendation *and* a
definition of done. One was literally "bake off 3–5 candidates and read the
numbers" — a task in a decision's clothing. That file had reached 141 lines
against the ~100 budget, and two rounds of prose-compression bought 5 lines
while moving three decisions out to GitHub issues bought 34.

Three additions, shipped as `c1f2a4b` via **PR #1** (baton's first, and the
first exercise of the branch/PR convention adopted in `retrieval-lab` the same
day):

1. **What qualifies** — a question whose answer changes what gets built and
   that cannot be settled yet. With a definition of done it is *work*: put it
   where the project tracks work and leave a pointer. Kept deliberately
   **tracker-agnostic** — the originating project solved this with GitHub
   issues, but baton runs on projects with no tracker at all, so encoding "file
   an issue" would make the rule wrong there. Plus: omit the section entirely
   when nothing is unsettled, since an empty heading invites the next handoff
   to refill it.
2. **The length budget gained a diagnostic** rather than staying a bare limit —
   overflow is usually concrete work masquerading as state, so move the work
   out instead of compressing the prose. A limit tells you that you failed; a
   diagnostic tells you what to do about it.
3. **Substantive changes commit separately and first**, handoff on top, so a
   commit titled `Handoff: …` never carries a new module. This one came from
   breaking the existing rule: asked to commit "everything", that session
   produced a `Handoff:` commit with 1,247 insertions of code, tests and data
   in it. The skill forbids *sweeping* unrelated changes but had no answer for
   the case where the sweeping is **requested** — the answer is two commits.

**What this session says about the skill's blind spots.** Every one of the three
additions came from watching a handoff strain, not from reasoning about the
design. That argues for dogfooding on projects with real bookkeeping pressure
over polishing the text in the abstract — and specifically for noticing when a
section *grows* rather than only when it is wrong.

---

## 2026-07-17 (decide skill: honor a project's own notes convention)

Short review-and-ship session. Betty had hand-edited `skills/decide/SKILL.md`
and asked for a check-then-push. Her edit adds a **"Where to write"** section
to `/baton:decide` that mirrors the one already in `/baton:handoff`: if the
target project documents its own session-notes convention (in CLAUDE.md /
AGENTS.md), follow it exactly — the "journal" and "forward-looking doc" names
in the numbered steps then resolve to that project's files (e.g.
`docs/session-log.md`, `docs/TODO.md`) instead of baton's `SESSIONS.md` /
`TODO.md` defaults. Good change: it closes a consistency gap where `decide`
would have written to the defaults even in a project `handoff` correctly
adapts to. Content shipped as Betty wrote it.

Fixed three mechanical defects before pushing (`aa3a3f6`, pushed to
origin/main at Betty's request): a `project;s` → `project's` semicolon typo, a
missing comma in `docs/TODO.md`), not the defaults`, and trailing whitespace
on two lines. Noted but did **not** act on the pre-existing `Skill should
provide a name` diagnostic — it fires across all baton skills, which use
folder-derived names plus a `description` field, so it's unrelated to this
edit.

## 2026-07-15 (sweep rule: flag oversized Scratch items for extraction)

Session started with Betty's question: does the SessionStart hook inject all
of SESSIONS.md? Answer (verified against `hooks/session-start.sh:14-19`): no —
the hook injects **all of TODO.md** but only the latest journal entry's
*title*, so the journal lazy-loads by design and can grow indefinitely at flat
session-start cost. That surfaced the real exposure: **TODO.md itself is
injected whole and had no size guard**, and its "Scratch" section is the
natural bloat vector — the `/baton:why` blob there is already ~25 lines of
design prose.

**The fix (`1ae4aeb`):** added a sweep rule to `skills/handoff/SKILL.md` —
when a Scratch item passes ~10 lines or sprouts internal structure
(sub-sections, multiple bold headers), flag it under "Needs attention" and
offer extraction to its own doc (e.g. `docs/<idea>.md`), leaving a one-liner
in Scratch: title, hook, link. **Flag, don't auto-move** — deliberately
consistent with the doc-drift rule's traceable-vs-ambiguous split: whether an
idea deserves promotion is the owner's call, and a silent relocation is easy
to lose. The structural trigger (not just line count) was chosen because a
blob with sub-headers is already "a document wearing a bullet point's
clothes" regardless of length.

Also pushed the backlog: `f575bc3` (BECAUSE.md rename) + `1ae4aeb` went to
`origin/main`, clearing item 1 of the previous "Pick up here". Betty then ran
`/reload-plugins` and invoked this handoff as the live test of the new rule —
which fired on its first run: the `/baton:why` Scratch item is this handoff's
own first "Needs attention" extraction flag. Rule shipped and triggered in
the same session.

---

## 2026-07-15 (rename planned /baton:why output → BECAUSE.md)

Renamed the (still unbuilt) file that the parked `/baton:why` skill will persist
findings to: `DECISIONS.md` → `BECAUSE.md` (`f575bc3`). Trigger: `DECISIONS.md`
reads like `/baton:decide` output, but `decide` writes SESSIONS.md/TODO.md — the
file belongs to `/baton:why`, the archaeology skill. The collision wasn't
hypothetical — it made Claude misattribute the file earlier this same session
(see the entry below). `BECAUSE.md` maps to the **why → because** pairing and
kills the ambiguity. Also dropped the premature `DECISIONS.md if present`
forward-reference from the handoff skill's commit-scope list: no shipped skill
should point at a phantom file, so it'll be reintroduced (correctly named) when
`/baton:why` is actually built. The `DECISIONS.md` mentions in the entry below
are left as-is — append-only history, an accurate record of the old name.

---

## 2026-07-15 (handoff skill: format, auto-commit, sweep + rotation)

Improvements to `skills/handoff/SKILL.md` (`1367f29`), starting from two gaps
Betty spotted on the new-repo path and growing into a round of handoff
hardening. All design forks below were Betty's calls; I pushed back where her
first framing had a sharp edge.

**Explicit entry format on init.** The old init template collapsed a whole
journal entry into one vague `<Narrative: …>` placeholder, so a brand-new
repo's *first* SESSIONS.md entry had no shape to imitate. Replaced it with a
guided-narrative skeleton naming the beats (what shipped + refs, what was
abandoned + why, decisions + reasoning) plus the bold-sub-label pattern.
Decision — guided narrative over rigid structured-fields or a hybrid (Betty
picked from a three-way preview): the journal is mined months later for blog
posts and parked-thread resumption, and flowing prose reads better than
bulleted form fields.

**Auto-commit the handoff.** The skill wrote files but never committed them.
New `## Commit the handoff` step: `git add` the touched files *by path*
(`TODO.md`/`SESSIONS.md`/`DECISIONS.md` if present) — which is what picks up
new, untracked files on a repo's first handoff, Betty's specific ask.
Deliberately **never `git add -A`** so a handoff can't hijack unrelated
working-tree changes; message `Handoff: <title>`; **no push** (stays manual);
silent skip outside a git repo. Dogfooded live: ran the handoff with the
uncommitted SKILL.md sitting in the tree and confirmed the commit picked up
only TODO/SESSIONS, leaving SKILL.md alone — proof the scoped-add works.

**Proactive pre-write sweep.** New `## Before writing: sweep the session` step:
scan for loose ends (uncommitted changes, new TODO/FIXME, failing tests,
unmerged branches) → TODO.md "Pick up here"; owner-blocking flags → a new
"Needs attention" section (a flag, not an option-and-recommendation fork like
"Open decisions"); and documentation drift. The doc-drift rule took two passes
to settle. First cut, after pushback: **flag + offer, never silent rewrite** —
auto-editing a doc during a handoff would land it uncommitted and inconsistent
with the scoped commit. Betty then refined it to the final rule: **auto-update
when the drift is caused by *this session's own changes* and the fix is
unambiguous** (you have the context, it's traceable, and the fixed doc just
gets added to the handoff commit), touching only what drifted; **flag only when
the drift isn't traceable to this session or the fix is ambiguous** — there
you'd be guessing at intent/history you don't have. The sweep earned its keep
on the spot: it caught that `README.md` had gone stale *from this very
session's* auto-commit change — the skills table omitted the new behavior, and
the Notes section still told the user committing the files was their choice.
Both traceable and unambiguous, so under the refined rule the handoff
auto-updated the README (only the two drifted spots) and committed it alongside
the state files. That's the doc-drift rule dogfooding itself on the change that
created it.

**Rotate SESSIONS.md when it grows.** New step: at ~500 lines, `git mv` the
journal to `sessions/<date-range>.md` and start a fresh one with a pointer.
Reframe that lowered this from urgent to nice-to-have (advisor-confirmed
against `session-start.sh:18`): the hook **never loads the journal body**, only
greps the latest entry's date — so length is a navigability/git-hygiene cost,
not a context/token cost. Whole-file `git mv` over splitting entries by hand
(can't drop content); **announced + confirmed, never a silent move** (Betty's
call) — consistent with the scoped-commit trust property. Not yet exercised
against a real 500-line file.

**Course-correct (worth recording):** an earlier draft of this entry claimed
`/baton:decide` writes a `DECISIONS.md` — wrong. The advisor caught it; I'd
conflated it with the *parked* `/baton:why` idea (the only thing that would
create DECISIONS.md). `decide` writes SESSIONS.md + TODO.md, same as handoff —
and shares the same not-yet-committed gap. Fixed before push since nothing had
shipped. Lesson baked into `[[handoff]]`'s own advice: read the file, don't
infer from an adjacent note.

---

## 2026-07-13 (added MIT license)

Short session. Added an MIT `LICENSE` (root) and a `## License` section to the
README, committed and pushed (`89f3be8`). Reasoning: the repo had gone public
earlier the same day, and public-with-no-license is the worst case — code is
readable but under default copyright it's "all rights reserved," so nobody can
legally fork or build on it. MIT was the right fit here because Betty owns the
code outright (built this session, no employer IP), and the driver is
portfolio/community use rather than monetization — so the irreversibility of
MIT for released versions isn't a concern. Copyright line: "Jiaman Wu".
GitHub's About sidebar should now show the MIT badge.

---

## 2026-07-13 (baton v0.1: built, redesigned against mise, pushed)

Built the whole plugin in one session, starting from Betty's friction: Claude
Code loses continuity between sessions, especially when work pauses for team
alignment. She'd been hand-writing a SESSIONS.md after each session. Surveyed
the ecosystem first — `claude-mem`, `claude-remember`, `claude-handoff` all
solve "summarize what happened," none model *decisions*: options on the
table, a recommendation, and outcome-dependent next steps that a returning
session can reconcile against. That gap became the product.

**v0.1 (first pass):** two skills + a SessionStart hook writing a single
`.claude/HANDOFF.md` (current-state file with numbered open decisions D1/D2…,
decision log, gotchas). Validated with `claude plugin validate`, hook
smoke-tested both with and without the state file.

**The redesign (the session's real decision):** before migrating `~/dev/mise`
onto baton, actually read mise's files — and found it already had a *more
mature* convention: root `TODO.md` (current-state pointer, ~3 sentences) +
`SESSIONS.md` (append-only journal), enforced via AGENTS.md and auto-loaded
through CLAUDE.md's `@AGENTS.md` import. Seeding a HANDOFF.md there would
have created three sources of truth. Decision, at Betty's suggestion:
**mirror mise instead of imposing on it** — baton's default convention became
TODO.md + SESSIONS.md at repo root, `HANDOFF.md` deleted from the design.
Reasons: the convention is battle-tested; root files are human-visible
"honest artifacts" (portfolio/blog material) where `.claude/HANDOFF.md` was
Claude-only; and one mental model works across every project. Betty's hard
requirement driving the two-file split: the append-only journal must survive
because she mines it for tech blogs, and work is non-linear (threads resume
weeks later), so history must stay greppable by date.

Supporting decisions: skills defer to a project's own documented convention
(CLAUDE.md/AGENTS.md) when one exists, so baton never fights an established
workflow; the hook activates only when **both** files exist (a lone TODO.md
may be unrelated scratch) and injects TODO.md plus the latest journal entry's
date — never the journal itself (mise's is 104KB); the hook stays plain-bash
stdout, no jq, deliberately portable to Betty's locked-down work laptop.

Tested the redesigned hook against mise as a live fixture (injects its real
TODO.md, extracts "2026-07-10 (Weave trace export…)" as latest entry;
TODO-only repo stays silent). Pushed private:
https://github.com/JiamanBettyWu/baton (`856f4f9`). This entry is the first
dogfood — hand-executed by Claude following the skill spec, since the
build session itself didn't have the plugin loaded.
