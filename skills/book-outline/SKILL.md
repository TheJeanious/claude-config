---
name: book-outline
description: >
  Turn an approved book concept into a detailed chapter outline and writing
  task plan. Works from a book idea, theme, audience, or the output of
  `/book-plan`. Accepts $ARGUMENTS.
disable-model-invocation: false
allowed-tools: Bash, Read, Grep, Glob, Agent, Write, Edit, TodoWrite
---

# Book Outline

Turn a book concept into a chapter-by-chapter outline with beats,
research notes, structure, and writing tasks.

## Input

- `$ARGUMENTS`: book concept, title, theme, audience, or an existing book
  planning brief.
- If `$ARGUMENTS` is empty, ask the user for the book idea, the intended
  audience, and the emotional or informational goal.

## Phase 1 — Understand the concept

1. If the user provided only an idea, derive:
   - concept
   - genre
   - audience
   - core promise
   - tone
2. If the user provided an existing plan, read and preserve the central promise
   and structure.

## Phase 2 — Select the organizing structure

Choose the best structure for the concept:
- fiction: 3-act story arc, romance beat sheet, sci-fi worldbuilding arc
- nonfiction: part/section flow, thematic chapters, problem/solution progression
- memoir: emotional arc, lessons learned, reflective bookending
- hybrid: narrative + toolkit, story + analysis

Explain why the chosen structure fits the concept.

## Phase 3 — Outline chapters

For each chapter, provide:
- title
- purpose in the book
- 2-4 key beats or scenes
- research or accuracy notes
- narrative stakes or reader takeaway
- what the reader should feel or know after reading it

Also include a “Writing tasks” section with:
- key scenes or sections to draft first
- research tasks
- example opening hook
- pacing guidance

## Phase 4 — Output and save

If the repo contains `planning/`, write:
- `planning/book-outline.md`

Otherwise, output the outline in the response and suggest saving it to
`planning/book-outline.md`.

This skill is for structure and planning. If the user wants actual chapter
prose, recommend a `/book-draft` skill or provide a focused sample on request.
