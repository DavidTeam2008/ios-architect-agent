#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

if [ ! -d "$CLAUDE_DIR" ]; then
  echo "Claude Code config directory not found: $CLAUDE_DIR" >&2
  echo "Set CLAUDE_CONFIG_DIR or install Claude Code first." >&2
  exit 1
fi

backup() {
  local target="$1"
  if [ -e "$target" ]; then
    local stamp
    stamp="$(date +%Y%m%d%H%M%S)"
    cp -R "$target" "${target}.bak.${stamp}"
    echo "backup: ${target}.bak.${stamp}"
  fi
}

mkdir -p "$CLAUDE_DIR/agents" "$CLAUDE_DIR/skills/ios-rn-playbook"

backup "$CLAUDE_DIR/agents/ios-researcher.md"
backup "$CLAUDE_DIR/agents/ios-rn-architect.md"
backup "$CLAUDE_DIR/skills/ios-rn-playbook"

cp "$REPO_DIR/agents/ios-researcher.md" "$CLAUDE_DIR/agents/ios-researcher.md"
cp "$REPO_DIR/agents/ios-rn-architect.md" "$CLAUDE_DIR/agents/ios-rn-architect.md"
cp -R "$REPO_DIR/skills/ios-rn-playbook/." "$CLAUDE_DIR/skills/ios-rn-playbook/"

echo "Installed:"
echo "  $CLAUDE_DIR/agents/ios-researcher.md"
echo "  $CLAUDE_DIR/agents/ios-rn-architect.md"
echo "  $CLAUDE_DIR/skills/ios-rn-playbook/"
echo
echo "Open a new Claude Code session, then use @ios-researcher or @ios-rn-architect."
echo "Optional: run 'claude plugin validate ~/.claude' to validate the installed components."
