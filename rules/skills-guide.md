# Skills & Agents Reference

Proactively suggest the right skill when a user's request matches a trigger.
Skills are invoked via the Skill tool when users type `/skill-name`.

## Skills — Trigger Patterns

### Code Quality & Review

| Skill | Invoke when |
|-------|-------------|
| `/fix` | Failing test, build error, compile error, or runtime error. Pass the error message or `file:line` as argument. Loops until green or 5 iterations. |
| `/code-review` | "Review this code", pre-merge quality check, or any multi-file review. Runs parallel agents covering correctness, security, types, coverage, performance. |
| `/review-pr` | Reviewing a GitHub PR by number. Fetches diff, runs full review, posts inline comments. Use over `/code-review` when you have a PR URL/number. |
| `/security-review` | Security audit of pending branch changes. Run before merging anything touching auth, payments, secrets, or external inputs. |
| `/simplify` | After completing a coding task — review changed code for reuse, quality, and efficiency, then fix issues found. |

### Development Workflow

| Skill | Invoke when |
|-------|-------------|
| `/plan-mission` | Feature requiring 1–4 hours of autonomous work. Produces a structured brief with batches, tasks, quality gates. Required before `/sandbox`. |
| `/explore` | User is new to a codebase or needs an architecture overview. Clones related repos, produces diagrams and architecture docs. |
| `/sandbox` | Run a mission brief autonomously in an isolated Docker container. Requires a brief from `/plan-mission`. |
| `/init` | Starting fresh in a new repo with no CLAUDE.md. Creates codebase documentation. |
| `/webapp-testing` | Test a locally running web app with Playwright. Covers UI flows, screenshots, regression checks. |

### Project Setup (Scaffolding)

| Skill | Invoke when |
|-------|-------------|
| `/project-bootstrap` | Bootstrapping a new project from scratch. |
| `/auth-setup` | Adding authentication to a project. |
| `/payments-setup` | Integrating a payment system. |
| `/analytics-setup` | Adding analytics instrumentation. |
| `/i18n-setup` | Scaffolding internationalization (18 locales, lazy-loading, Claude-powered translations). |
| `/testing-setup` | Setting up a test framework in a project. |
| `/compliance-setup` | Scaffolding GDPR + CRA compliance (consent, data export, deletion) for Cloudflare Workers + Neon + React/Vite. |
| `/powerpoint-addin-setup` | Scaffolding a PowerPoint add-in. |

### Dependencies & Maintenance

| Skill | Invoke when |
|-------|-------------|
| `/upgrade-deps` | Auditing or upgrading dependencies. Detects languages, runs security checks, delegates to language agents. |
| `/changelog-generator` | Generating a user-facing changelog from git history between dates or tags. |
| `/sync-claude` | Syncing `~/.claude` with the upstream `claude-config` repo. Run when new skills, rules, or agents are available. |

### Automation & Scheduling

| Skill | Invoke when |
|-------|-------------|
| `/schedule` | Recurring agent on a cron schedule, one-time timed run ("run at 3pm", "remind me tomorrow"), or managing existing routines. |
| `/loop` | Repeatedly running a command or polling for state on an interval (e.g., "check build every 5 min"). NOT for one-off tasks. |
| `/update-config` | Any change to `settings.json` or `settings.local.json`: hooks, permissions, env vars, allowlists. Automated "whenever X" behaviors require hooks — memory alone won't persist them. |
| `/fewer-permission-prompts` | Too many permission prompts during a session. Scans transcripts and adds an allowlist to project settings. |
| `/keybindings-help` | Customizing keyboard shortcuts or modifying `~/.claude/keybindings.json`. |

### Claude API & AI

| Skill | Invoke when |
|-------|-------------|
| `/claude-api` | Building or debugging code that imports `anthropic` or `@anthropic-ai/sdk`. Also for prompt caching, model migration (4.5→4.6→4.7), tool use, batch API, thinking, compaction. |

### Content & Communication

| Skill | Invoke when |
|-------|-------------|
| `/internal-comms` | Writing internal communications (memos, updates, announcements) in company format. |
| `/video-downloader` | Downloading YouTube videos with quality/format options. |
| `/file-organizer` | Organizing files/folders: finding duplicates, suggesting structure, automating cleanup. |
| `/brand-knowvah` | Brand-related tasks for Knowvah. |

### Claude Code Environment

| Skill | Invoke when |
|-------|-------------|
| `/claude-code-setup:claude-automation-recommender` | "What automations should I add?", optimize Claude Code setup, recommend hooks/subagents/MCP servers for a codebase. |

---

## Agents — When to Delegate

Default: handle tasks directly. Delegate to an agent when the task **clearly**
falls within a specialist's domain and benefits from deep expertise or
isolation from the main context window.

### High-value delegation triggers

| Situation | Agent |
|-----------|-------|
| Writing substantial production code in a specific language | Language specialist (e.g., `python-pro`, `typescript-pro`, `rust-engineer`) |
| Deep code review requiring full file reads | `code-reviewer` |
| Complex bug with multiple plausible root causes | `debugger` or `error-detective` |
| Refactoring with pattern application | `refactoring-specialist` |
| Architecture validation / trade-off analysis | `architect-reviewer` |
| Terraform / IaC changes | `terraform-engineer` |
| Docker image build/security | `docker-expert` |
| Kubernetes deployment or cluster config | `kubernetes-specialist` |
| SQL query optimization, index design | `database-optimizer` or `postgres-pro` |
| ML model training/serving/MLOps | `ml-engineer` or `mlops-engineer` |
| Technical documentation | `documentation-engineer` or `technical-writer` |
| Writing blog posts or informal content | `blog` |
| Formal reports, proposals, project docs | `write` |
| Competitive or market research | `competitive-analyst` or `market-researcher` |
| Security vulnerability analysis | `security-auditor` or `penetration-tester` |
| Promoting `.agent-notes/` to Mem0 | `memory-curator` |
| Broad codebase exploration (3+ queries) | `Explore` (built-in) |

### Agent categories

**01 Core Development** — `frontend-developer`, `backend-developer`,
`fullstack-developer`, `api-designer`, `graphql-architect`,
`microservices-architect`, `mobile-developer`, `ui-designer`,
`websocket-engineer`, `electron-pro`

**02 Language Specialists** — `python-pro`, `typescript-pro`,
`javascript-pro`, `golang-pro`, `rust-engineer`, `java-architect`,
`csharp-developer`, `swift-expert`, `kotlin-specialist`, `php-pro`,
`ruby-specialist`, `react-specialist`, `nextjs-developer`,
`vue-expert`, `angular-architect`, `django-developer`,
`rails-expert`, `laravel-specialist`, `spring-boot-engineer`,
`cpp-pro`, `sql-pro`, `flutter-expert`, `elixir-expert`,
`dotnet-core-expert`, `dotnet-framework-4.8-expert`,
`powershell-5.1-expert`, `powershell-7-expert`,
`ruby-2-7-specialist`

**03 Infrastructure** — `devops-engineer`, `cloud-architect`,
`terraform-engineer`, `kubernetes-specialist`, `docker-expert`,
`sre-engineer`, `security-engineer`, `deployment-engineer`,
`database-administrator`, `network-engineer`, `platform-engineer`,
`azure-infra-engineer`, `terragrunt-expert`,
`devops-incident-responder`, `incident-responder`,
`windows-infra-admin`

**04 Quality & Security** — `code-reviewer`, `qa-expert`,
`test-automator`, `debugger`, `error-detective`,
`performance-engineer`, `security-auditor`, `penetration-tester`,
`compliance-auditor`, `architect-reviewer`, `chaos-engineer`,
`accessibility-tester`, `refactoring-specialist` (in 06),
`ad-security-reviewer`, `powershell-security-hardening`

**05 Data & AI** — `data-scientist`, `data-analyst`, `data-engineer`,
`ml-engineer`, `machine-learning-engineer`, `mlops-engineer`,
`ai-engineer`, `llm-architect`, `nlp-engineer`,
`database-optimizer`, `postgres-pro`, `prompt-engineer`

**06 Developer Experience** — `refactoring-specialist`,
`build-engineer`, `documentation-engineer`, `git-workflow-manager`,
`dependency-manager`, `dx-optimizer`, `legacy-modernizer`,
`cli-developer`, `tooling-engineer`, `mcp-developer`,
`slack-expert`, `powershell-module-architect`,
`powershell-ui-architect`

**07 Specialized Domains** — `fintech-engineer`, `payment-integration`,
`blockchain-developer`, `game-developer`, `embedded-systems`,
`iot-engineer`, `quant-analyst`, `risk-manager`, `seo-specialist`,
`m365-admin`, `mobile-app-developer`, `api-documenter`

**08 Business & Product** — `product-manager`, `project-manager`,
`business-analyst`, `technical-writer`, `content-marketer`,
`legal-advisor`, `customer-success-manager`, `sales-engineer`,
`scrum-master`, `ux-researcher`, `blog`, `write`,
`wordpress-master`

**09 Meta / Orchestration** — `memory-curator` (promotes
`.agent-notes/` to Mem0), `it-ops-orchestrator` (routes complex
IT tasks), `agent-installer` (browse/install agents from
awesome-claude-code-subagents)

**10 Research & Analysis** — `research-analyst`, `data-researcher`,
`market-researcher`, `competitive-analyst`,
`scientific-literature-researcher`, `search-specialist`,
`trend-analyst`
