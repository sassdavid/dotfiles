#!/bin/bash
# Claude Code statusline - multi-line with ANSI colors and progress bar
input=$(cat)

# Single jq call to extract all fields at once
eval "$(echo "$input" | jq -r '
  @sh "MODEL=\(.model.display_name)",
  @sh "CURRENT_DIR=\(.workspace.current_dir)",
  @sh "COST_TOTAL=\(.cost.total_cost_usd // 0)",
  @sh "DURATION_MS=\(.cost.total_duration_ms // 0)",
  @sh "API_DURATION_MS=\(.cost.total_api_duration_ms // 0)",
  @sh "LINES_ADDED=\(.cost.total_lines_added // 0)",
  @sh "LINES_REMOVED=\(.cost.total_lines_removed // 0)",
  @sh "CONTEXT_SIZE=\(.context_window.context_window_size // 0)",
  @sh "USED_PCT=\(.context_window.used_percentage // 0)"
')"

# ANSI colors
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
DIM='\033[2m'
RESET='\033[0m'

# --- Git info with cache (refreshes every 5s) ---

CACHE_FILE="/tmp/statusline-git-cache"
CACHE_MAX_AGE=5

cache_is_stale() {
  [ ! -f "$CACHE_FILE" ] ||
    # stat -f %m is macOS, stat -c %Y is Linux
    [ $(($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0))) -gt $CACHE_MAX_AGE ]
}

if cache_is_stale; then
  if git rev-parse --git-dir >/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    echo "$BRANCH|$STAGED|$MODIFIED" >"$CACHE_FILE"
  else
    echo "||" >"$CACHE_FILE"
  fi
fi

IFS='|' read -r BRANCH STAGED MODIFIED <"$CACHE_FILE"

GIT_INFO=""
if [ -n "$BRANCH" ]; then
  GIT_INFO=" | ${DIM}${BRANCH}${RESET}"
  [ "$STAGED" -gt 0 ] && GIT_INFO="${GIT_INFO} ${GREEN}+${STAGED}${RESET}"
  [ "$MODIFIED" -gt 0 ] && GIT_INFO="${GIT_INFO} ${YELLOW}~${MODIFIED}${RESET}"
fi

echo -e "${CYAN}[${MODEL}]${RESET} ${CURRENT_DIR##*/}${GIT_INFO}"

# --- Line 2: context progress bar, cost, duration, code changes ---

# Truncate to integer
PCT=${USED_PCT%.*}
: "${PCT:=0}"

# Color-coded progress bar based on context usage
# 0-40% green (normal), 40-60% yellow (warning), 60%+ red (compaction zone)
if [ "$PCT" -ge 60 ]; then
  BAR_COLOR="$RED"
elif [ "$PCT" -ge 40 ]; then
  BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && BAR=$(printf "%${FILLED}s" | tr ' ' '█')
[ "$EMPTY" -gt 0 ] && BAR="${BAR}$(printf "%${EMPTY}s" | tr ' ' '░')"

LINE2="${BAR_COLOR}${BAR}${RESET} ${PCT}%"

# Cost (only if > 0)
if [ "$(echo "$COST_TOTAL > 0" | bc -l 2>/dev/null)" = "1" ]; then
  COST_FMT=$(printf '$%.4f' "$COST_TOTAL")
  LINE2="${LINE2} ${DIM}|${RESET} ${YELLOW}${COST_FMT}${RESET}"
fi

# Wall-clock duration (only if > 0)
if [ "$DURATION_MS" -gt 0 ]; then
  MINS=$((DURATION_MS / 60000))
  SECS=$(((DURATION_MS % 60000) / 1000))
  LINE2="${LINE2} ${DIM}|${RESET} ${MINS}m${SECS}s"
fi

# Code changes (only if any)
if [ "$LINES_ADDED" -gt 0 ] || [ "$LINES_REMOVED" -gt 0 ]; then
  LINE2="${LINE2} ${DIM}|${RESET} ${GREEN}+${LINES_ADDED}${RESET}/${RED}-${LINES_REMOVED}${RESET}"
fi

echo -e "$LINE2"
