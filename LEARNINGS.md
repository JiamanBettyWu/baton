# Learnings

What is true in this project that is not obvious. Test for an entry: would a
new session waste time rediscovering this? This file is committed, so entries
hold nothing private: no names, no paths outside the repository, no secrets.

How to keep this file:

- Find the theme in the index and add the entry under it as
  `- **<YYYY-MM-DD>** — <fact>`. Start a new theme only when no scope phrase
  fits, and add its index line.
- Never delete an entry. When one stops being true, add a line under it:
  `Outdated as of <YYYY-MM-DD>: <what is true now>`. When one is re-checked
  and still holds, add `Verified <YYYY-MM-DD>`.
- Entries may move between themes; wording and dates stay unchanged.

## Index

- **Git and the journal** — Git behavior that affects the git-ignored
  `SESSIONS.md` journal and its `sessions/` archive.

## Git and the journal

- **2026-11-14** — Checking out any commit before `22f9951` overwrites the
  git-ignored journal on disk with the old tracked copy, because the journal
  was still tracked in those commits. Back the journal up before such a
  checkout.
