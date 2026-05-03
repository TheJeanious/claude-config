#!/usr/bin/env bash
# project-init.sh — Initialize .agent-notes and Mem0 for the current project.
# Runs as an async UserPromptSubmit hook; all operations are idempotent.

set -euo pipefail

PROJECT_DIR="$(pwd)"

# Only act inside git repos
if ! git -C "$PROJECT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
  exit 0
fi

# ── 1. .agent-notes/ ──────────────────────────────────────────────────────────
if [ ! -d "$PROJECT_DIR/.agent-notes" ]; then
  mkdir -p "$PROJECT_DIR/.agent-notes"
  touch "$PROJECT_DIR/.agent-notes/.gitkeep"
fi

# ── 2. .mcp.json ──────────────────────────────────────────────────────────────
if [ ! -f "$PROJECT_DIR/.mcp.json" ]; then
  cat > "$PROJECT_DIR/.mcp.json" << EOF
{
  "mcpServers": {
    "mem0": {
      "type": "sse",
      "url": "http://localhost:8765/mcp/claude-code/sse/default"
    }
  }
}
EOF
fi
