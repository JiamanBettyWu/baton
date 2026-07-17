# Session log

Reverse-chronological journal — one dated entry per working session: what got
done, what was decided and why. History only; for what to do next see
[TODO.md](TODO.md).

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
