---
name: build-cookbook
description: >
  Regenerate one or all Jeanius Kitchen cookbook PDFs.
  Runs /recount first, builds the specified PDF(s), then commits
  all updated markdown and PDF files.
  Usage: /build-cookbook [main|v2|compact|condensed|minimal|small-batch|all]
  Default (no args): builds all cookbooks.
---

# /build-cookbook — Cookbook PDF Builder

Run the shell commands below from the repo root. Then report
what was built and what changed.

## Steps

1. Run the recount script to update RECIPE-STATUS.md and
   RECIPE-LIST.md before building:
   ```bash
   python3 /tmp/recount_recipes.py
   ```
   If the script isn't at `/tmp/recount_recipes.py`, invoke the
   `/recount` skill first to write and run it, then continue.

2. Determine which cookbooks to build from the skill args.
   If no args (or `all`), build every cookbook.
   Valid args: `main`, `v2`, `compact`, `condensed`, `minimal`,
   `small-batch`.

3. Run each selected script from the repo root:

   | Arg | Command |
   |-----|---------|
   | `main` | `python3 recipes/cookbook/create_cookbook_pdf.py` |
   | `v2` | `python3 recipes/cookbook/create_cookbook_pdf_v2.py` |
   | `compact` | `python3 recipes/cookbook/create_cookbook_pdf_compact.py` |
   | `condensed` | `python3 recipes/cookbook/create_cookbook_pdf_condensed.py` |
   | `minimal` | `python3 recipes/cookbook/create_cookbook_pdf_minimal.py` |
   | `small-batch` | `python3 recipes/cookbook/create_cookbook_pdf_small_batch.py` |

   Run them one at a time (they are long-running and produce output).
   Each script self-locates via `__file__`, so the working directory
   does not matter as long as the repo root is the cwd for git.

4. Stage and commit all changed files:
   ```bash
   git add recipes/cookbook/*.pdf recipes/RECIPE-STATUS.md \
           recipes/small-batch/RECIPE-LIST.md
   git commit -m "chore(cookbook): regenerate PDFs and update counts"
   ```
   Only stage files that actually changed (`git diff --name-only`).
   If nothing changed, skip the commit and say so.

## Output to report

- Which PDFs were built and whether they succeeded or failed
- Any individual entry changes from recount (photo Yes/No flips)
- Final recipe counts (total, with photo, without photo)
- Whether the commit was created or skipped

## Notes

- PDF generation takes 1–3 minutes per book; the small-batch and
  v2 scripts are fastest, the main/compact/condensed take longer
- If a script fails with a missing dependency error, run:
  `pip3 install reportlab markdown pillow`
- The `small-batch` PDF is always worth rebuilding after adding
  or removing recipes from the small-batch chapter list
- RECIPE-STATUS.md tracks individual recipe photo and GF status;
  it is always updated by recount even if counts don't change
