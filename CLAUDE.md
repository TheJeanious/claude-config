# Claude Code — Global Instructions

## Interaction Style

- Be direct. No filler phrases ("Perfect!", "Great!", "Certainly!"), no pleasantries.
- After completing a task, briefly summarize what was done and the reasoning behind any non-obvious decisions. Identify any agents used.

## Complex Tasks

For multi-part tasks or more than ~2 pages of output:
1. Present an outline for review before executing
2. Complete one section at a time
3. Use TodoWrite to track progress

For features requiring 1-4 hours of autonomous work, use `/plan-mission` to generate a mission brief first.

## Skills

Skills are invoked via the Skill tool when users type `/skill-name`. Proactively
suggest the right skill when the user's request matches a trigger. Full reference
with all triggers and agent categories: `~/.claude/rules/skills-guide.md`.

**Key triggers — suggest these proactively:**
| User intent | Skill |
|-------------|-------|
| Failing test / build / runtime error | `/fix` |
| Pre-merge or PR review | `/code-review` or `/review-pr` |
| Security audit of branch | `/security-review` |
| Large feature (1–4 hrs of work) | `/plan-mission` |
| Unfamiliar codebase, need architecture map | `/explore` |
| Upgrade or audit dependencies | `/upgrade-deps` |
| Code quality pass after changes | `/simplify` |
| Recurring task / polling | `/loop` |
| Cron job / one-time scheduled run | `/schedule` |
| Hooks, permissions, env vars, settings.json | `/update-config` |
| Scaffold auth / payments / analytics / i18n | `/auth-setup`, `/payments-setup`, `/analytics-setup`, `/i18n-setup` |
| Generate user-facing changelog | `/changelog-generator` |
| Sync with upstream claude-config | `/sync-claude` |
| Test local web app with Playwright | `/webapp-testing` |
| Code using `anthropic` SDK / prompt caching | `/claude-api` |
| Update recipe counts (photos, GF status) | `/recount` |
| Regenerate Jeanius Kitchen cookbook PDFs | `/build-cookbook` |
| Update recipe app after adding/changing recipes | `/update-recipe-app` |
| Add a health journal entry | `/health-journal-entry` |

## Agents

Agents live in `~/.claude/agents/`. Invoke via the Agent tool with `subagent_type` matching the agent's `name`. Default to handling tasks directly; delegate when the task clearly falls within a specialist's domain. Agent descriptions are loaded automatically. Always announce which agent you are invoking and why before calling it.

## Multi-Agent Parallelism

Plan before executing: list subtasks, mark dependencies, assign file ownership (one writer per file), batch independent work in parallel, sequence dependent batches. See `~/.claude/rules/parallelism.md` for full rules.

## Commit Messages

Conventional Commits, all lines ≤80 chars. Subject `<type>(<scope>): <desc>` ≤72 chars, lowercase, no period. See `~/.claude/rules/commits.md` for full spec.

## Rules

All rules live in `~/.claude/rules/`:
- **code-principles.md** — YAGNI (design decisions, not spec fidelity), SOLID, no magic strings, native fetch
- **security.md** — input validation, secrets handling, error hygiene
- **testing.md** — TDD, 90/90/90 coverage, assertion quality
- **testability.md** — pure functions, functional core/imperative shell, DI as mechanism
- **commits.md** — Conventional Commits format and full spec
- **parallelism.md** — multi-agent execution, file ownership, batching rules
- **autonomous-execution.md** — mission briefs, quality gates, compaction recovery
- **memory.md** — Mem0 usage, scoping, curator criteria
- **lsp.md** — code navigation with typescript-lsp, pyright-lsp, rust-analyzer-lsp
- **extended-thinking.md** — when to use extended thinking and how to request it
- **logging.md** — structured JSON logs, log levels, required fields, no PII
- **error-handling.md** — throw vs return, wrap at boundaries, message quality
- **api-design.md** — resource naming, standard envelopes, versioning strategy
- **observability.md** — SLO-first design, RED metrics, distributed tracing, alerting
- **architecture.md** — blast radius layers, ADRs, fitness functions, reversibility
- **research-sources.md** — 5-tier source hierarchy for technical claims and design decisions
- **prompting-quality.md** — constraint keywords, specificity, instruction bloat, session hygiene

## Agent Memory

Local `.agent-notes/` observations + long-term Mem0 via MCP.
The `memory-curator` agent handles promotion. See `~/.claude/rules/memory.md`.

## On Compaction

CLAUDE.md is automatically reloaded from disk after compaction —
it survives verbatim. Instructions lost after compaction were given
only in conversation, not written to CLAUDE.md.

A `PostCompact` hook injects `~/.claude/post-compact-context.md`
for content that isn't in any instruction file: the autonomous
execution recovery sequence.
