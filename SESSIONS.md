# Session log

Reverse-chronological journal — one dated entry per working session: what got
done, what was decided and why. History only; for what to do next see
[TODO.md](TODO.md).

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
