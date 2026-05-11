---
name: book-marketing
description: >
  Draft blurbs, back-cover copy, author positioning, and launch messaging for
  a book. Accepts a book concept, title, audience, or outline as
  $ARGUMENTS.
disable-model-invocation: false
allowed-tools: Bash, Read, Grep, Glob, Agent, Write, Edit, TodoWrite
---

# Book Marketing

Create marketing copy, positioning, and launch messaging for a book.

## Input

- `$ARGUMENTS`: book concept, working title, audience, outline, or draft
  summary.
- If `$ARGUMENTS` is empty, ask the user for the book’s promise, audience,
  and the author's unique perspective.

## Phase 1 — Understand the book and audience

1. Identify the promise, tone, and genre.
2. Identify the target reader and the problem the book solves or the desire it
   fulfills.
3. Identify the author position and why this book is different.

## Phase 2 — Generate marketing assets

1. Draft a short book blurb for discovery pages and back cover copy.
2. Draft a longer pitch summary for author platform or sales pages.
3. Generate 3–5 author positioning statements or taglines.
4. Suggest launch copy for social media, newsletter, or author website.
5. Optionally, provide a short reader hook for email subject lines or ad
   headlines.

## Phase 3 — Output

1. Return the marketing copy grouped by use case.
2. Include a simple “why this works” note for each asset.
3. If the repo contains `marketing/` or `author/`, suggest saving the copy
   there.

This skill is for messaging and positioning, not for book editing or outline
work. Use it when the concept is clear and you want copy that sells the idea.
