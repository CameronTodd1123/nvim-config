#!/usr/bin/env bash
# ~/bin/tmux-proj
# Usage: tmux-proj <project-name>

set -euo pipefail

PROJECT="${1:-}"
if [[ -z "$PROJECT" ]]; then
  echo "Usage: tmux-proj <project-name>"
  exit 1
fi

SESSION="$PROJECT"
PROJECT_DIR="$HOME/code/$PROJECT"

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "No such directory: $PROJECT_DIR"
  exit 1
fi

# If already running, just attach
if tmux has-session -t "$SESSION" 2>/dev/null; then
  exec tmux attach -t "$SESSION"
fi

# Create the session and first window (code)
tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR" -n code "nvim ."

# Add a run/logs window
tmux new-window -t "$SESSION:" -n run -c "$PROJECT_DIR"

# Add ai window
tmux new-window -t "$SESSION:" -n ai -c "$PROJECT_DIR"

# Add infra window
tmux new-window -t "$SESSION:" -n infra -c "$PROJECT_DIR"

# Add misc scratch window
tmux new-window -t "$SESSION:" -n misc -c "$PROJECT_DIR"

# Jump to code window
tmux select-window -t "$SESSION:code"

exec tmux attach -t "$SESSION"
