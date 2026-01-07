#!/bin/bash
set -euo pipefail

# Stop hook script that captures learnings before session ends
# This script runs SYNCHRONOUSLY and blocks session ending until complete
# Works in CI/CD environments where background processes would be killed

# Read hook input from stdin
input=$(cat)

# Extract session info
session_id=$(echo "$input" | jq -r '.session_id // "unknown"')
transcript_path=$(echo "$input" | jq -r '.transcript_path // ""')
cwd=$(echo "$input" | jq -r '.cwd // "."')

# Read configuration if it exists
config_file="$CLAUDE_PROJECT_DIR/.claude/session-learner.local.md"
quality_threshold="true"
dry_run="false"
skills_path=".claude/skills/"

if [ -f "$config_file" ]; then
  # Extract YAML frontmatter values
  quality_threshold=$(sed -n '/^---$/,/^---$/p' "$config_file" | grep "quality_threshold:" | awk '{print $2}' 2>/dev/null || echo "true")
  dry_run=$(sed -n '/^---$/,/^---$/p' "$config_file" | grep "dry_run:" | awk '{print $2}' 2>/dev/null || echo "false")
  skills_path=$(sed -n '/^---$/,/^---$/p' "$config_file" | grep "skills_path:" | awk '{print $2}' 2>/dev/null | tr -d '"' || echo ".claude/skills/")
fi

# Quick quality check - if session is trivial, skip immediately
if [ "$quality_threshold" = "true" ]; then
  # Check if transcript exists and has reasonable size
  if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
    # Count lines in transcript as rough proxy for session complexity
    line_count=$(wc -l < "$transcript_path" 2>/dev/null || echo "0")

    # Skip if transcript is too short (< 50 lines = very brief session)
    if [ "$line_count" -lt 50 ]; then
      echo "{
        \"decision\": \"approve\",
        \"reason\": \"Session too brief for learning capture (${line_count} lines)\",
        \"systemMessage\": \"Session ending. No learnings captured (session too brief).\"
      }" | jq -c .
      exit 0
    fi
  fi
fi

# If dry_run mode, skip actual capture but show what would happen
if [ "$dry_run" = "true" ]; then
  echo "{
    \"decision\": \"approve\",
    \"reason\": \"Dry-run mode enabled\",
    \"systemMessage\": \"Session ending. Dry-run mode: would have captured learnings to $skills_path\"
  }" | jq -c .
  exit 0
fi

# Build analysis prompt for the agent
analysis_prompt="Analyze this session and create skills from learnings.

Session Info:
- Session ID: $session_id
- Transcript: $transcript_path
- Working Directory: $cwd

Instructions:
1. Read the session transcript to understand what was worked on
2. Check git status and git diff to see what changed
3. Identify valuable learnings (debugging patterns, architecture decisions, gotchas discovered)
4. Apply quality threshold: skip if session was trivial (just typo fixes, reading docs, no problem-solving)
5. Use smart merge: update existing skills in $skills_path or create new ones
6. Stage changes with git add for PR inclusion
7. Provide brief summary of what was captured

Configuration:
- Skills path: $skills_path
- This is running in Stop hook - be efficient and complete quickly

IMPORTANT: If session has no valuable learnings, just say so and exit quickly. Don't force creation of low-quality skills."

# Run learning capture SYNCHRONOUSLY (blocking)
# Session won't end until this completes
capture_output=$(cd "$cwd" && claude agent learning-analyzer "$analysis_prompt" 2>&1 | head -100)

# Log output for debugging
if [ -n "$capture_output" ]; then
  echo "$capture_output" > /tmp/session-learning-$session_id.log 2>&1 || true
fi

# Always approve stopping after capture completes
echo "{
  \"decision\": \"approve\",
  \"reason\": \"Learning capture completed\",
  \"systemMessage\": \"Session ending. Learning capture completed - check $skills_path for new/updated skills.\"
}" | jq -c .

exit 0
