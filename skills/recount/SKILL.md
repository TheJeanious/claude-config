---
name: recount
description: >
  Recount all recipe photo and GF status numbers in
  recipes/RECIPE-STATUS.md and recipes/small-batch/RECIPE-LIST.md.
  Updates individual Yes/No photo entries, the photo summary table,
  the GF summary table, and the small-batch chapter counts.
  Usage: /recount
---

# /recount — Recipe Count Updater

Run the Python script below (write it to `/tmp/recount_recipes.py` and
execute it from the repo root). Then report a summary of what changed.

## The script

```python
#!/usr/bin/env python3
"""
Recount recipe photo and GF status in RECIPE-STATUS.md
and chapter counts in small-batch/RECIPE-LIST.md.
"""

import os
import re
import subprocess

REPO = os.getcwd()
STATUS_FILE = os.path.join(REPO, "recipes/RECIPE-STATUS.md")
SMALL_BATCH_LIST = os.path.join(REPO, "recipes/small-batch/RECIPE-LIST.md")
SMALL_BATCH_SCRIPT = os.path.join(REPO, "recipes/cookbook/create_cookbook_pdf_small_batch.py")

# Directories to scan for recipe files (order matches STATUS categories)
RECIPE_DIRS = {
    "Appetizers":               ["recipes/appetizers"],
    "Beverages":                ["recipes/beverages"],
    "Breads & Baking":          [
        "recipes/breads-and-baking",
        "recipes/breads-and-baking/flatbreads",
        "recipes/breads-and-baking/muffins",
        "recipes/breads-and-baking/pie-crusts",
        "recipes/breads-and-baking/quick-breads",
        "recipes/breads-and-baking/sourdough",
        "recipes/breads-and-baking/yeast-breads",
    ],
    "Canning":                  ["recipes/canning"],
    "Desserts — Bars":          ["recipes/desserts/bars"],
    "Desserts — Brownies":      ["recipes/desserts/brownies"],
    "Desserts — Cakes":         [
        "recipes/desserts/cakes",
        "recipes/desserts/cakes/cheesecakes",
        "recipes/desserts/cakes/cupcakes",
    ],
    "Desserts — Candy":         ["recipes/desserts/candy"],
    "Desserts — Cookies":       ["recipes/desserts/cookies"],
    "Desserts — Crisps":        ["recipes/desserts/crisps-and-cobblers"],
    "Desserts — Frostings/Toppings": [
        "recipes/desserts/frostings",
        "recipes/desserts/frostings-and-icings",
        "recipes/desserts/toppings",
    ],
    "Desserts — Pies":          ["recipes/desserts/pies"],
    "Desserts — Puddings":      ["recipes/desserts/puddings"],
    "Main Dishes":              ["recipes/main-dishes"],
    "Salads":                   ["recipes/salads"],
    "Seasonings & Sauces":      ["recipes/seasonings-and-sauces"],
    "Sides":                    ["recipes/sides"],
}

SKIP_NAMES = {
    "RECIPE-STATUS", "TABLE-OF-CONTENTS", "INDEX", "COOKBOOK-COMPLETE",
    "COOKBOOK-MASTER", "CHECKLIST", "GLOSSARY", "INTRODUCTION", "HOW-TO-USE",
    "COVER-DESIGN-BRIEF", "KDP-ACCOUNT-NOTES", "KDP-COVER-SPECS",
    "SCHEDULE", "TIPS", "INTRO", "RECIPE-LIST", "RECIPE-CHECKLIST",
    "RECIPES-TO-PERSONALIZE", "RECIPES-TO-TRY", "RECIPES_FOR_ONENOTE",
    "README", "ABOUT-THE-AUTHOR", "ACKNOWLEDGMENTS", "AMAZON-AFFILIATE-SETUP",
    "AMAZON-KDP-DESCRIPTION", "CONVERSION-CHARTS", "EQUIPMENT-GUIDE",
    "MY-RECIPE-NOTES", "PANTRY-STAPLES", "PHOTO-GALLERY",
    "GF-CONVERSION-REFERENCE", "RECIPE-FORMATTING-PLAN",
}


def is_recipe_file(path):
    stem = os.path.splitext(os.path.basename(path))[0].upper()
    return stem not in SKIP_NAMES


def has_photo(path):
    """True if the recipe file has an active (non-commented) image tag."""
    with open(path, encoding="utf-8") as f:
        content = f.read()
    return "📷 Photo needed" not in content


def scan_category(dirs):
    """Return (total, with_photo, without_photo) for a list of dirs."""
    total = with_p = without_p = 0
    for d in dirs:
        full = os.path.join(REPO, d)
        if not os.path.isdir(full):
            continue
        for fname in os.listdir(full):
            if not fname.endswith(".md"):
                continue
            fpath = os.path.join(full, fname)
            if not is_recipe_file(fpath):
                continue
            total += 1
            if has_photo(fpath):
                with_p += 1
            else:
                without_p += 1
    return total, with_p, without_p


def normalize(name):
    """Normalize a recipe name for fuzzy matching."""
    name = name.lower()
    name = re.sub(r"[''`]", "", name)      # remove apostrophes
    name = re.sub(r"[^a-z0-9 ]", " ", name)  # non-alpha → space
    name = re.sub(r"\s+", " ", name).strip()
    return name


def build_file_map():
    """
    Map normalized recipe name → has_photo for every recipe file in the repo.
    Also map image stem → has_photo as a fallback.
    """
    name_map = {}
    img_map = {}
    for category_dirs in RECIPE_DIRS.values():
        for d in category_dirs:
            full = os.path.join(REPO, d)
            if not os.path.isdir(full):
                continue
            for fname in os.listdir(full):
                if not fname.endswith(".md"):
                    continue
                fpath = os.path.join(full, fname)
                if not is_recipe_file(fpath):
                    continue
                stem = os.path.splitext(fname)[0]
                human = stem.replace("-", " ")
                key = normalize(human)
                photo = has_photo(fpath)
                name_map[key] = photo

                # also index by image filename found in the file
                with open(fpath, encoding="utf-8") as fh:
                    content = fh.read()
                for img in re.findall(r"!\[[^\]]*\]\([^)]*images/([^)]+)\)", content):
                    img_stem = os.path.splitext(img)[0]
                    img_map[normalize(img_stem.replace("-", " "))] = photo

    return name_map, img_map


def update_individual_entries(content, name_map, img_map):
    """
    Update Yes/No in individual recipe rows.
    Row pattern: | Recipe Name | Yes/No | GF Status |
    """
    changes = []

    def replace_row(m):
        recipe_name = m.group(1).strip()
        current_photo = m.group(2).strip()
        rest = m.group(3)

        key = normalize(recipe_name)
        # Try direct name match, then image name match
        new_photo = name_map.get(key, img_map.get(key))

        if new_photo is None:
            return m.group(0)  # no match found, leave unchanged

        new_val = "Yes" if new_photo else "No"
        if new_val != current_photo:
            changes.append(f"  {recipe_name}: {current_photo} → {new_val}")
            return f"| {recipe_name} | {new_val} |{rest}"
        return m.group(0)

    updated = re.sub(
        r"\| ([^|]+) \| (Yes|No) \|([^\n]+)",
        replace_row,
        content
    )
    return updated, changes


def update_photo_summary(content, category_counts):
    """Replace the summary table rows with fresh counts."""
    grand_total = grand_with = grand_without = 0

    def replace_row(m):
        nonlocal grand_total, grand_with, grand_without
        cat = m.group(1).strip()
        if cat in category_counts:
            total, with_p, without_p = category_counts[cat]
            grand_total += total
            grand_with += with_p
            grand_without += without_p
            return f"| {cat} | {total} | {with_p} | {without_p} |"
        return m.group(0)

    updated = re.sub(
        r"\| ([^|*]+) \| \d+ \| \d+ \| \d+ \|",
        replace_row,
        content
    )

    # Update grand total row
    updated = re.sub(
        r"\| \*\*Total\*\* \| \*\*\d+\*\* \| \*\*\d+\*\* \| \*\*\d+\*\* \|",
        f"| **Total** | **{grand_total}** | **{grand_with}** | **{grand_without}** |",
        updated
    )
    return updated, grand_total


def update_gf_summary(content):
    """Recount GF statuses from individual entries and update GF summary table."""
    counts = {
        "TESTED": 0,
        "NOT YET TESTED": 0,
        "Naturally GF": 0,
        "N/A": 0,
        "No GF notes": 0,
    }

    for m in re.finditer(r"^\| [^|*-][^|]+ \| (?:Yes|No) \| ([^|]+) \|", content, re.MULTILINE):
        gf = m.group(1).strip()
        if "TESTED" in gf and "NOT YET" not in gf:
            counts["TESTED"] += 1
        elif "NOT YET TESTED" in gf:
            counts["NOT YET TESTED"] += 1
        elif "Naturally GF" in gf:
            counts["Naturally GF"] += 1
        elif "N/A" in gf or "not suitable" in gf.lower():
            counts["N/A"] += 1
        else:
            counts["No GF notes"] += 1

    total = sum(counts.values())

    def replace_gf_row(m):
        label = m.group(1).strip().strip("*")
        if label in counts:
            return f"| **{label}** | {counts[label]} |" if label == "TESTED" else f"| {label} | {counts[label]} |"
        return m.group(0)

    updated = re.sub(r"\| (\*?\*?[^|*]+\*?\*?) \| \d+ \|", replace_gf_row, content)
    updated = re.sub(
        r"\| \*\*Total\*\* \| \*\*\d+\*\* \|",
        f"| **Total** | **{total}** |",
        updated
    )
    return updated, counts, total


def update_small_batch_summary(content, chapter_counts):
    """Update the Summary table in RECIPE-LIST.md."""
    total = sum(v for v in chapter_counts.values())

    rows = []
    for chapter, count in chapter_counts.items():
        rows.append(f"| {chapter} | {count} | — |")

    # Replace the entire Summary table body
    new_table = (
        "| Category | Recipes | Notes |\n"
        "|----------|---------|-------|\n"
        + "\n".join(rows) + "\n"
        + f"| **Total** | **{total}** | — |"
    )

    updated = re.sub(
        r"\| Category \| Recipes \| Notes \|.*?\| \*\*Total\*\* \| \*\*\d+\*\* \| — \|",
        new_table,
        content,
        flags=re.DOTALL
    )
    return updated, total


def get_small_batch_chapters():
    """Parse chapter recipe counts from the PDF generator script."""
    if not os.path.exists(SMALL_BATCH_SCRIPT):
        return {}

    with open(SMALL_BATCH_SCRIPT, encoding="utf-8") as f:
        content = f.read()

    chapters = {}
    current_title = None
    for line in content.splitlines():
        title_m = re.search(r"'title':\s*'([^']+)'", line)
        if title_m:
            current_title = title_m.group(1)
            chapters[current_title] = 0
        elif current_title and re.search(r"'recipes/", line):
            chapters[current_title] += 1

    return chapters


# ── Main ────────────────────────────────────────────────────────────────────

print("Scanning recipe files...")
name_map, img_map = build_file_map()

print("Counting by category...")
category_counts = {cat: scan_category(dirs) for cat, dirs in RECIPE_DIRS.items()}

print("Reading RECIPE-STATUS.md...")
with open(STATUS_FILE, encoding="utf-8") as f:
    status = f.read()

print("Updating individual photo entries...")
status, entry_changes = update_individual_entries(status, name_map, img_map)

print("Updating photo summary table...")
status, grand_total = update_photo_summary(status, category_counts)

print("Updating GF summary...")
status, gf_counts, gf_total = update_gf_summary(status)

with open(STATUS_FILE, "w", encoding="utf-8") as f:
    f.write(status)

print("\nUpdating small-batch RECIPE-LIST.md...")
chapter_counts = get_small_batch_chapters()
with open(SMALL_BATCH_LIST, encoding="utf-8") as f:
    sb_content = f.read()
sb_content, sb_total = update_small_batch_summary(sb_content, chapter_counts)
with open(SMALL_BATCH_LIST, "w", encoding="utf-8") as f:
    f.write(sb_content)

# ── Report ──────────────────────────────────────────────────────────────────
print("\n=== RECOUNT COMPLETE ===")
print(f"\nRECIPE-STATUS.md — {grand_total} total recipes")
print(f"  Photo summary updated per category")
if entry_changes:
    print(f"  Individual entry changes ({len(entry_changes)}):")
    for c in entry_changes:
        print(c)
else:
    print("  Individual entries: no changes needed")

print(f"\nGF Summary:")
for label, count in gf_counts.items():
    print(f"  {label}: {count}")
print(f"  Total: {gf_total}")

print(f"\nSmall-batch RECIPE-LIST.md — {sb_total} total recipes")
for chapter, count in chapter_counts.items():
    print(f"  {chapter}: {count}")
```

## Steps

1. Write the script above to `/tmp/recount_recipes.py`
2. Run it from the repo root:
   ```bash
   python3 /tmp/recount_recipes.py
   ```
3. Report what changed — chapter counts, individual entry flips, GF totals.
4. If any individual entries show "no match found" (couldn't be mapped to a
   file), list them so the user can decide whether to update manually.

## Notes

- Photo status is determined by whether the recipe `.md` file contains
  `📷 Photo needed` (No) or not (Yes).
- GF status in individual entries is **not** auto-updated — only the summary
  totals are recounted from the existing entries. GF testing must be updated
  manually.
- Small-batch chapter counts come from the PDF generator script
  (`create_cookbook_pdf_small_batch.py`), which is the source of truth for
  what's actually in the book.
