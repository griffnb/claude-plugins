---
name: capture-learning
description: Manually capture learnings from the current session and create/update skills
argument-hint: "[optional focus description]"
allowed-tools: ["Task"]
---

# Capture Learning Command

Manually trigger the learning-analyzer agent to extract learnings from the current session and codify them into skills.

## Usage

```
/capture-learning [optional focus description]
```

**Without arguments:**
Analyzes the entire session to identify valuable learnings.

**With focus description:**
Guides the analysis to focus on specific topics or patterns.

## Examples

```
/capture-learning
```
Analyzes full session automatically.

```
/capture-learning API authentication patterns we discovered
```
Focuses analysis on API authentication learnings.

```
/capture-learning React hooks debugging approach
```
Directs attention to React hooks debugging patterns.

## What This Command Does

1. **Invokes learning-analyzer agent** with current session context
2. **Applies quality thresholds** to determine if learnings are valuable
3. **Smart merge** - decides whether to create new skills or update existing ones
4. **Creates/updates skill files** in configured location (default: `.claude/skills/`)
5. **Stages changes** with git (if auto_stage enabled in settings)
6. **Provides summary** of what was captured

## Configuration

Behavior controlled by `.claude/session-learner.local.md` settings:

- **skills_path** - Where to save skills (default: `.claude/skills/`)
- **quality_threshold** - Skip trivial sessions (default: enabled)
- **auto_stage** - Automatically git add skills (default: true)
- **dry_run** - Preview without creating files (default: false)

## When to Use

**Use this command when:**
- You want to capture learnings mid-session (before it ends)
- You've solved a particularly interesting problem
- You've discovered valuable patterns worth codifying
- You want to ensure specific insights aren't lost

**Don't use when:**
- Session was trivial (typo fixes, simple reads)
- No new patterns or techniques emerged
- Just following standard tutorials

## Output

The command provides a summary including:
- Skills created or updated
- Key learnings captured
- File locations
- Git staging status
- Next steps

## Integration

This command works with:
- **learning-analyzer agent** - Does the actual analysis and skill creation
- **meta-learning skill** - Provides patterns for identifying valuable learnings
- **SessionEnd hook** - Automatic version runs at session end
- **/review-session** - Preview mode without creating files

## Instructions

When this command is invoked:

1. Check if focus description was provided in the command arguments
2. Invoke the learning-analyzer agent using the Task tool:
   - If no arguments: `agent learning-analyzer "Analyze current session and capture learnings"`
   - If arguments provided: `agent learning-analyzer "Analyze current session focusing on: [arguments]"`
3. The agent will handle all analysis, skill creation, and reporting
4. Display the agent's summary output to the user

**Important:** Always invoke the learning-analyzer agent. Do not attempt to analyze or create skills directly—the agent has the specialized knowledge and tools needed.

## Tips

- **Be specific with focus descriptions** - "database query optimization" is better than "databases"
- **Use after solving problems** - Capture while the solution is fresh
- **Review git diff** before committing to see what was generated
- **Run /review-session first** if unsure what would be captured

## Related Commands

- `/review-session` - Preview learnings without creating files
- `/git-status` - Check what skills were staged
- `/git-diff` - Review generated skill content
