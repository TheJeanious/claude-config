---
name: book-edit
description: >
  Revise or polish existing book prose. Accepts current text plus editing
  instructions such as tone, clarity, pacing, or structural changes.
disable-model-invocation: false
allowed-tools: Bash, Read, Grep, Glob, Agent, Write, Edit, TodoWrite
---

# Book Edit

Improve existing prose while preserving the author voice and book intent.

## Input

- `$ARGUMENTS`: current prose with editing direction, or a description of the
  editing goal.
- If `$ARGUMENTS` is empty, ask the user to provide the text and their
  objective (e.g. tighten pacing, strengthen hook, clarify meaning, polish
  voice).

## Phase 1 — Understand the editing goal

1. Identify the requested change: clarity, tone, pacing, voice, structure,
   sentence flow, or consistency.
2. Identify the genre and intended reader.
3. Identify any existing style notes from the book plan or outline.

## Phase 2 — Edit the text

1. Preserve the author voice: conversational, direct, practical, warm.
2. Remove unnecessary repetition and tighten sentence structure.
3. Improve readability with clear paragraph transitions.
4. Preserve or strengthen the chapter’s emotional impact or argument.
5. Suggest a brief rationale for any substantive change.

## Phase 3 — Output

1. Return the edited prose with change notes if requested.
2. If major structural edits are needed, explain the reason and offer a
   small alternative.
3. If the repo has `drafts/` or `editing/`, suggest where to save the revised
   text.

This skill is for revision and polish, not new draft generation. For new
content, use `/book-draft`.
