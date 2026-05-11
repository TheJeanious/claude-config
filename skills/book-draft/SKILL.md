---
name: book-draft
description: >
  Generate chapter or scene draft text from a book outline or concept.
  Accepts a chapter outline, scene prompt, or book plan as $ARGUMENTS.
disable-model-invocation: false
allowed-tools: Bash, Read, Grep, Glob, Agent, Write, Edit, TodoWrite
---

# Book Draft

Generate draft prose for a chapter, scene, or section from the approved
book structure.

## Input

- `$ARGUMENTS`: a chapter outline, section prompt, scene description, or book
  plan.
- If `$ARGUMENTS` is empty, ask the user what chapter or scene they want to
  draft and what the key emotional or narrative goal is.

## Phase 1 — Understand the input

1. Identify the desired scope: full chapter, scene, section, or sample.
2. Identify the book type and tone: fiction, memoir, nonfiction, romance, AI,
   narrative nonfiction, etc.
3. Identify any existing structure or outline to follow.

## Phase 2 — Draft the prose

1. Use the provided outline to generate an opening hook.
2. Preserve the voice: conversational, direct, practical, warm.
3. Keep narrative and argument beats aligned with the chapter purpose.
4. For nonfiction, include examples, clear transitions, and reader takeaways.
5. For fiction, emphasize character, stakes, emotion, and setting.

## Phase 3 — Output

1. Provide a draft with an optional section header and paragraph breaks.
2. Include a short note at the end summarizing the draft goals and next
   revision steps.
3. If the repo contains `drafts/` or `planning/`, suggest saving the draft there.

This skill is intended for generating first-pass writing. For structural
planning, use `/book-plan` and `/book-outline` first.
