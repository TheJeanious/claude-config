---
name: book-title
description: >
  Brainstorm titles, subtitles, and hooks for a book concept. Accepts a book
  idea, theme, audience, or working title as $ARGUMENTS.
disable-model-invocation: false
allowed-tools: Bash, Read, Grep, Glob, Agent, Write, Edit, TodoWrite
---

# Book Title

Generate strong title, subtitle, and hook ideas for a book.

## Input

- `$ARGUMENTS`: book concept, theme, audience, tone, or a working title.
- If `$ARGUMENTS` is empty, ask the user for the book’s core promise and
  intended reader.

## Phase 1 — Understand the promise

1. Identify the core promise or emotional hook.
2. Identify the book’s genre and audience.
3. Identify the desired tone: warm, practical, inspiring, romantic, urgent,
   mysterious, etc.

## Phase 2 — Generate title options

1. Create a set of 8–12 title ideas that fit the concept.
2. Provide 3–5 subtitle options if the book benefits from clarification.
3. Provide 2–3 short positioning hooks for blurbs, pitches, or back-cover
   copy.
4. Group the suggestions by tone or approach when helpful.

## Phase 3 — Output

1. Return title options with one-line rationales.
2. Show subtitle examples that make the promise clear.
3. Suggest which title approach is strongest for the intended audience.
4. Recommend a next step (e.g. use `/book-outline` with the chosen title).

This skill is for naming and positioning, not for full marketing copy.
