---
name: book-plan
description: >
  Turn a vague or emerging book idea into a structured writing plan.
  Generates a concept summary, target audience, voice/tone guidance,
  high-level structure, chapter outline, research checklist, and a
  mission-style brief for book development. Accepts a book idea as
  $ARGUMENTS.
disable-model-invocation: false
allowed-tools: Bash, Read, Grep, Glob, Agent, Write, Edit, TodoWrite
---

# Book Plan

Turn an idea, genre prompt, or vague theme into a complete book planning
brief.

## Input

- `$ARGUMENTS`: a plain-English description of the book idea, genre, theme,
  audience, or one or more example concepts.
- If `$ARGUMENTS` is empty, ask the user to describe the book and provide at
  least one genre, target audience, or core emotional focus.

## Phase 1 — Clarify the concept

1. Identify the likely book type: nonfiction, memoir, fiction, romance, sci-fi,
   hybrid, self-help, guide, etc.
2. Identify the primary audience and what they should feel, learn, or take away.
3. Identify the author voice and tone using the project context:
   - conversational, direct, practical, warm
   - grounded in lived experience, not academic
   - real rather than theoretical
4. If the idea is too vague, ask one or two focused questions:
   - “Should this be a memoir, a practical guide, or a novel?”
   - “Do you want this to be aimed at readers curious about neurodiversity,
     romance, or AI futures?”
   - “What is the emotional core: hope, insight, connection,
     transformation, or survival?”

## Phase 2 — Define the core book promise

Create and present:
- one-sentence book promise
- main theme(s)
- target reader
- book genre / form
- suggested tone and voice
- high-level structure format

If the user asks for idea exploration, generate up to three strong variants
(e.g. a neurotypical-living narrative, a romance arc, an AI-driven story) and
ask which one they want to develop.

## Phase 3 — Build the planning brief

Generate a planning brief containing:
- Objective
- Audience
- Tone and voice
- Theme and promise
- Book type and form
- Suggested titles or working title ideas
- Core structure (parts, acts, sections)
- Chapter-by-chapter outline
- Key scenes, lessons, or argument beats
- Research and accuracy requirements
- Writing tasks for the first draft
- Suggested next skill: `/book-outline` for deeper structure

If the user wants planning rather than draft text, keep the output focused on
structure and accuracy rather than full prose.

## Phase 4 — Save and surface

If the current repo contains `planning/`, write:
- `planning/book-plan.md`
- `planning/book-plan-ideas.md` if multiple variants were generated

If `planning/` is missing, output a complete brief in the response and
recommend creating `planning/book-plan.md` in the repo.

This skill is intended for idea shaping and accurate book planning. For
chapter-level structure, use `/book-outline` once the concept is chosen.
