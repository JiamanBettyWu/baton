# Splitting LEARNINGS.md

Read this only when the handoff skill sends you here: `LEARNINGS.md`, or one
file in `learnings/`, has passed ~500 lines, the file is in baton's
theme-first shape, and the user has agreed to the split.

A split only moves lines. It never rewords, prunes, or deletes.

## Split LEARNINGS.md into theme files

1. Save the content to be moved, in a temporary directory outside the
   repository: every non-blank line of the theme sections except the `## <Theme>`
   headings, sorted.
   `awk '/^## /{keep = ($0 != "## Index"); next} keep && NF' LEARNINGS.md | sort > <tmp>/before`
   **If that file is empty, stop:** the file is not in the shape this
   procedure expects.
2. Look for entries that should also be a rule in the project's instruction
   file. Offer to copy those out; the entry stays.
3. Move each theme's lines, unchanged, into `learnings/<theme-slug>.md`
   (lowercase, hyphens), each file starting with `# <Theme>`. Annotation
   lines and continuation lines move with their entry.
4. `LEARNINGS.md` keeps its header and index. Each index line now links to
   its file: `- **[<Theme>](learnings/<theme-slug>.md)** — <scope phrase>`.
   Change the header's first upkeep line to say that entries go in the theme
   file the index links to, because the header is what a later reader
   follows.
5. Check that nothing was lost:
   `awk 'FNR == 1 && /^# /{next} NF' learnings/*.md | sort | cmp - <tmp>/before`.
   Only the `# <Theme>` title on each file's first line is left out, so any
   other line that went missing is reported. It must report no difference
   before anything is committed. If it does report one, fix the files; do
   not commit.

## Split one theme file in two

When one file in `learnings/` passes ~500 lines:

1. Agree the two new theme names and their scope phrases with the user.
2. Save the old file's lines:
   `awk 'FNR == 1 && /^# /{next} NF' learnings/<old-slug>.md | sort > <tmp>/before`
3. Move the lines, unchanged, into the two new files, each starting with
   `# <Theme>`. Remove the old file.
4. Replace the old theme's index line in `LEARNINGS.md` with the two new
   lines.
5. Check those two files alone against the old one:
   `awk 'FNR == 1 && /^# /{next} NF' learnings/<new-a>.md learnings/<new-b>.md | sort | cmp - <tmp>/before`.
   It must report no difference before anything is committed.

Keep `learnings/` flat; never nest folders inside it.

## Commit

Add every file the split wrote or removed to the handoff commit by path, as
the skill's "Commit the handoff" section describes.
