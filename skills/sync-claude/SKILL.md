---
name: sync-claude
description: >
  Sync ~/.claude with the upstream config repo at ~/git/claude-config.
  Adds new skills, rules, agents, hooks, and templates. Merges CLAUDE.md
  intelligently. Strips all Serena MCP references. Preserves local-unique
  content. Maintains a JSON ignore list. Commits all changes.
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Sync Claude Config

Sync `~/.claude` with the upstream spec at `~/git/claude-config`.

**Never touch:** `~/.claude/settings.json` or `~/.claude/settings.local.json`

---

## Phase 1 — Setup

1. Pull latest upstream:
   ```bash
   git -C ~/git/claude-config pull
   ```
   If pull fails, stop and report the error.

2. Read `~/.claude/sync-ignore.json`. Parse the JSON array.
   Build an in-memory ignore set: a list of `path` values from all entries.
   If the file is missing or empty array, the ignore set is empty.

---

## Phase 2 — Identify local-unique content

For each directory below, list what exists locally but NOT upstream.
These are **local-unique** — never remove, overwrite, or touch them.

```bash
# Skills (directories)
diff <(ls ~/git/claude-config/skills/ | sort) <(ls ~/.claude/skills/ | sort)

# Agents (recursive .md files, relative paths)
diff <(find ~/git/claude-config/agents -name "*.md" | sed 's|.*/claude-config/agents/||' | sort) \
     <(find ~/.claude/agents -name "*.md" | sed 's|.*/.claude/agents/||' | sort)

# Rules
diff <(ls ~/git/claude-config/rules/ | sort) <(ls ~/.claude/rules/ | sort)

# Hooks
diff <(ls ~/git/claude-config/hooks/ | sort) <(ls ~/.claude/hooks/ | sort)

# Templates
diff <(ls ~/git/claude-config/templates/ | sort) <(ls ~/.claude/templates/ | sort)
```

Note each local-unique item. You will protect them throughout all phases.

---

## Phase 3 — Sync skills

Skills are directories containing a `SKILL.md` file (and possibly other
files). Upstream: `~/git/claude-config/skills/`. Local: `~/.claude/skills/`.

For each skill directory in upstream:

1. **Check ignore list** — if the skill name matches any entry in the ignore
   set, log `SKIP (ignored): skills/<name>` and continue to next.

2. **New skill** (not in local):
   - Copy the entire directory recursively to `~/.claude/skills/<name>/`
   - Log `ADD: skills/<name>`

3. **Existing skill** (in local, differs from upstream):
   - Read both versions of `SKILL.md`
   - If identical: skip (no-op)
   - If different: apply **Judgment Rules** (see end of document)
   - Log outcome: `UPDATE: skills/<name>` or `SKIP (judgment): skills/<name>`

Never remove or modify skills that are local-unique.

---

## Phase 4 — Sync agents

Agents are `.md` files under `~/git/claude-config/agents/` organized in
numbered subdirectories (e.g. `01-core-development/`, `04-quality-security/`).

For each `.md` file found recursively in `~/git/claude-config/agents/`:

1. **Strip Serena references** from the upstream content before any comparison
   or write (see **Serena Stripping** section below).

2. **Check ignore list** — if the relative agent path matches an ignore entry,
   log `SKIP (ignored): agents/<path>` and continue.

3. **New agent** (not in local):
   - Create parent directory if needed
   - Write the Serena-stripped content to `~/.claude/agents/<relative-path>`
   - Log `ADD: agents/<path>`

4. **Existing agent** (in local):
   - Compare Serena-stripped upstream content to local content
   - If identical after stripping: skip
   - If different: apply **Judgment Rules**
   - Log outcome

Never remove or modify agents that are local-unique.

### Serena Stripping

Apply to every upstream agent file before writing or comparing:

**Step A — tools: line**

The frontmatter `tools:` line is a comma-separated list. Remove all
`mcp__serena__*` entries (and their surrounding commas/whitespace) so
only non-Serena tools remain.

Example:
```
# Before:
tools: Read, Write, Edit, Grep, Glob, Bash, mcp__serena__find_symbol, mcp__serena__list_dir

# After:
tools: Read, Write, Edit, Grep, Glob, Bash
```

Use a regex approach: remove `,?\s*mcp__serena__\w+` globally from the
`tools:` line, then clean up any trailing comma or double-spaces.

**Step B — body text**

Remove any paragraph or bullet point that is *exclusively* about using
Serena tools. These typically look like:
- A `When the serena MCP server is connected...` paragraph
- Bullets listing `mcp__serena__*` as the preferred tool for a task

Keep any paragraph that describes a general capability, even if it
mentions Serena in passing alongside other tools.

---

## Phase 5 — Sync rules, hooks, templates

Apply the same logic as Phase 3 to each directory. No Serena stripping
is needed for these directories.

**Rules:** `~/git/claude-config/rules/` → `~/.claude/rules/`
**Hooks:** `~/git/claude-config/hooks/` → `~/.claude/hooks/`
**Templates:** `~/git/claude-config/templates/` → `~/.claude/templates/`

For each file in upstream:
1. Check ignore list → if matched, skip
2. Not in local → add it (log `ADD`)
3. In local and differs → apply Judgment Rules (log `UPDATE` or `SKIP`)

Never remove or modify files that are local-unique.

---

## Phase 6 — Merge CLAUDE.md

1. Read `~/git/claude-config/CLAUDE.md` (upstream)
2. Read `~/.claude/CLAUDE.md` (local)
3. If identical: skip (log `CLAUDE.md: no changes`)
4. If different:
   - Identify what changed in upstream compared to local:
     - **Added sections**: new H2/H3 headings with content not in local
     - **Modified sections**: same heading, different content
     - **Removed sections**: headings in local but not in upstream
   - For each change, check the ignore list and apply Judgment Rules
   - Write the merged result to `~/.claude/CLAUDE.md`:
     - Adopt upstream additions and improvements
     - Preserve all local-only sections verbatim
     - Never remove a local section unless upstream explicitly removes it
       AND the removal makes sense for local context
   - Log `UPDATE: CLAUDE.md` with a brief summary of what changed

---

## Phase 7 — Update ignore list

For each item you chose to skip using judgment (i.e., not already in the
ignore list), append an entry to `~/.claude/sync-ignore.json`.

Read the current file, parse the JSON array, append new entries, write
back. Each new entry:
```json
{
  "path": "<relative path from claude-config root>",
  "reason": "<one sentence: why this was skipped>",
  "date": "<today's date YYYY-MM-DD>",
  "permanent": false
}
```

If no new items were skipped by judgment, leave the file unchanged.

---

## Phase 8 — Commit

Only proceed if there are actual changes (check `git -C ~/.claude status`).

Stage only the files you added or modified — do not use `git add -A`:
```bash
git -C ~/.claude add <file1> <file2> ...
```

Commit with a conventional commit message:
```
chore(sync): sync with claude-config upstream

Added: <comma-separated list, or "none">
Updated: <comma-separated list, or "none">
Skipped: <item (reason), or "none">
Serena refs stripped: <count> files
```

All lines ≤80 chars.

---

## Phase 9 — Report

Print a human-readable summary:

```
Sync complete.

Added:    <count> items — <list>
Updated:  <count> items — <list>
Skipped:  <count> items — <list with reasons>
Stripped: <count> agent files had Serena references removed
Commit:   <SHA> (or "no changes, nothing committed")
```

---

## Judgment Rules

When deciding whether to adopt an upstream change to an existing file:

**Auto-adopt when:**
- Upstream is a strict superset of local (has everything local has, plus more)
- The change is clearly additive and doesn't conflict with any local content
- The change fixes a clear error (typo, broken formatting, outdated instruction)
- New upstream content covers a gap that local doesn't address

**Skip (add to ignore list) when:**
- The change references tools, infrastructure, or integrations not available
  locally (e.g., Serena MCP, internal services)
- The change would remove or overwrite something that appears intentionally
  customized locally
- The upstream removed a section that is still useful locally
- The change appears project-specific to the upstream repo's context

**Ask the user when:**
- Both versions have substantively different content in the same section
  and you cannot determine with confidence which is better
- The change touches something that seems sensitive or load-bearing

**Default:** When uncertain, preserve local content and add to ignore list
with `reason: "Uncertain — review manually"`.
