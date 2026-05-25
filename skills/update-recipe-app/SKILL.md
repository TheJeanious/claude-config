---
name: update-recipe-app
description: >
  Regenerate the recipe app data from the recipe markdown files,
  run tests, and commit the updated recipes-data.js so Cloudflare
  Pages picks up the changes on the next push.
  Usage: /update-recipe-app
---

# /update-recipe-app — Recipe App Data Updater

Run the steps below from the repo root. Report what changed and
whether the commit was created or skipped.

## Steps

1. **Parse recipes** — regenerate `recipes-data.js` from all markdown files:
   ```bash
   cd recipe-app && python3 parse-recipes.py
   ```
   Capture stdout. If the script exits non-zero, stop and report the error.

2. **Run tests** — confirm nothing is broken:
   ```bash
   cd recipe-app && npm test
   ```
   If tests fail, stop and report the failures. Do not commit broken data.

3. **Check for changes:**
   ```bash
   git diff --name-only recipe-app/js/recipes-data.js
   ```
   If the file is unchanged, report "recipes-data.js is already up to date"
   and skip the commit.

4. **Commit** (only if `recipes-data.js` changed):
   ```bash
   git add recipe-app/js/recipes-data.js
   git commit -m "chore(recipe-app): regenerate recipes-data.js"
   ```

## Output to report

- How many recipes were parsed (look for count in parse-recipes.py output,
  or count entries in the generated file)
- Whether tests passed or failed
- Whether a commit was created or skipped
- Any warnings or errors from the parser (unrecognized files, missing fields)

## Notes

- `parse-recipes.py` uses `rglob('*.md')` — it picks up recipes in all
  subdirectories under `recipes/` automatically. No changes to the script
  are needed when adding recipes to new subdirectory locations.
- `recipe-app/dist/` is gitignored and built by Cloudflare Pages CI —
  do NOT commit it.
- Images live in `recipes/images/` and are copied by `build.sh` at CI
  time — do NOT copy or commit images to `recipe-app/images/`.
- Cloudflare Pages deploys automatically on push to the tracked branch.
  After this skill commits, a `git push` is all that's needed to deploy.
