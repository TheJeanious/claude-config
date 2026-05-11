---
name: book-research
description: >
  Gather research notes, fact-checking prompts, and source suggestions for a
  book concept or chapter. Accepts themes, topics, or draft text as
  $ARGUMENTS.
disable-model-invocation: false
allowed-tools: Bash, Read, Grep, Glob, Agent, Write, Edit, TodoWrite
---

# Book Research

Generate research guidance, sources, and fact-check prompts for a book.

## Input

- `$ARGUMENTS`: the book theme, chapter topic, scene context, or draft text.
- If `$ARGUMENTS` is empty, ask the user what topic or chapter they need
  research support for.

## Phase 1 — Identify the research need

1. Determine whether the request is for background, accuracy, worldbuilding,
   historical context, technology, neurodiversity, relationships, or genre
   authenticity.
2. Identify the genre and whether the research should inform fiction,
   nonfiction, memoir, or hybrid work.
3. Identify any sensitive or personal topics that require care.

## Phase 2 — Build the research plan

1. List key questions the book should answer.
2. Recommend credible source types (books, articles, interviews, studies,
   expert voices).
3. Provide a prioritized research checklist.
4. Generate fact-checking prompts and note where verification is required.
5. Flag any areas that should remain high-level or fictionalized rather than
   presented as fact.

## Phase 3 — Output

1. Return research notes with clear sections: questions, sources, notes,
   and next steps.
2. If the repo contains `research/` or `notes/`, suggest saving the output
   there.
3. If the user wants, produce short source citation examples for later
   bibliography use.

This skill is for research planning and fact-checking support, not for
writing final book prose.
