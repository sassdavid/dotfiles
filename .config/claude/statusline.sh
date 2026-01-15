#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# Extract values using jq
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# Cost tracking - extract cost information from the correct path
COST_TOTAL=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
DURATION_API_SEC=$(echo "$input" | jq -r '(.cost.total_api_duration_ms // 0) / 1000')
LINES_ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
LINES_REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Context window size
CONTEXT_WINDOW_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

# Format cost display (only show if > 0)
COST_DISPLAY=""
if (($(echo "$COST_TOTAL > 0" | bc -l 2>/dev/null || echo 0))); then
  COST_DISPLAY=$(printf " | 💰 \$%.4f" "$COST_TOTAL")
fi

# Format duration display (only show if > 0)
DURATION_DISPLAY=""
if (($(echo "$DURATION_API_SEC > 0" | bc -l 2>/dev/null || echo 0))); then
  DURATION_DISPLAY=$(printf " | ⏱️  %.0fs" "$DURATION_API_SEC")
fi

# Format code changes display
CHANGES_DISPLAY=""
if [ "$LINES_ADDED" -gt 0 ] || [ "$LINES_REMOVED" -gt 0 ]; then
  CHANGES_DISPLAY=$(printf " | 📝 +%d/-%d" "$LINES_ADDED" "$LINES_REMOVED")
fi

# Context window display
CONTEXT_DISPLAY=""
if [ "$CONTEXT_WINDOW_SIZE" -gt 0 ]; then
  # Use the new used_percentage field from Claude Code 2.1.6+
  USED_PERCENTAGE=$(echo "$input" | jq -r '.context_window.used_percentage // 0')

  # Use current_usage which includes cache tokens
  USAGE=$(echo "$input" | jq '.context_window.current_usage')
  CURRENT_TOKENS=$(echo "$USAGE" | jq '(.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)')
  TOTAL_TOKENS=$(printf "%.0f" "$CURRENT_TOKENS")

  if [ "$TOTAL_TOKENS" -gt 0 ]; then
    # Use the pre-calculated percentage from Claude Code
    CONTEXT_DISPLAY=$(printf " | 🧠 %dk/%dk (%.0f%%)" "$((TOTAL_TOKENS / 1000))" "$((CONTEXT_WINDOW_SIZE / 1000))" "$USED_PERCENTAGE")
  else
    # Fallback if no tokens used yet
    CONTEXT_DISPLAY=$(printf " | 🧠 0k/%dk (0%%)" "$((CONTEXT_WINDOW_SIZE / 1000))")
  fi
fi

# Show git branch if in a git repo
GIT_BRANCH=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  if [ -n "$BRANCH" ]; then
    # Check if repo is dirty (modified files, staged changes, or untracked files)
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
      GIT_BRANCH=" | 🌿 $BRANCH*"
    else
      GIT_BRANCH=" | 🌿 $BRANCH"
    fi
  fi
fi

echo "[$MODEL_DISPLAY] 📁 ${CURRENT_DIR##*/}$GIT_BRANCH$CONTEXT_DISPLAY$COST_DISPLAY$DURATION_DISPLAY$CHANGES_DISPLAY"
