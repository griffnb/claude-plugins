---
name: review-session
description: Preview what learnings would be captured from current session without creating files
allowed-tools: ["Task"]
---

# Review Session Command

Preview what learnings would be captured from the current session without actually creating or modifying any skill files.

## Usage

```
/review-session
```

This command runs the learning analyzer in **preview mode** to show what would be captured without writing any files or staging changes.

## What This Command Does

1. **Analyzes current session** for valuable patterns and learnings
2. **Identifies relevant skills** - shows which would be created or updated
3. **Generates preview** of skill content without writing files
4. **Provides summary** of findings without making changes
5. **No file modifications** - completely safe to run anytime

## Output Format

The command provides:

**Analysis Summary:**
- Overall assessment of session value
- Quality threshold check result
- Number of learnings identified

**Skills Preview:**
- List of skills that would be created (with names and descriptions)
- List of existing skills that would be updated (with change summaries)
- Draft content preview showing key sections

**Key Learnings:**
- Bullet points of patterns identified
- Techniques or approaches discovered
- Insights worth capturing

**Recommendations:**
- Whether capturing is worthwhile
- Suggestions for improving learnings
- Alternative actions if session too trivial

## When to Use

**Use this command when:**
- You want to see what would be captured before committing
- Checking if session has valuable learnings
- Evaluating quality before running /capture-learning
- Curious about what the analyzer would extract
- Before session ends to preview SessionEnd hook behavior

**Especially useful:**
- Before creating a PR (see what skills would be included)
- After working on complex problems (validate learnings are captured well)
- When unsure if session warrants skill creation

## Preview vs. Capture

| /review-session | /capture-learning |
|-----------------|-------------------|
| No files written | Creates/updates skills |
| No git staging | Stages changes (if enabled) |
| Safe to run anytime | Modifies repository |
| Shows preview only | Commits to creating skills |
| Can run multiple times | Should run when ready |

## Example Workflow

```
# 1. Work on problem and solve it
[development work happens]

# 2. Preview what would be captured
/review-session

# 3. Review the output
# - Are the learnings valuable?
# - Are the skills well-structured?
# - Should anything be adjusted?

# 4. If satisfied, capture for real
/capture-learning

# 5. Verify with git
git status
git diff .claude/skills/
```

## Configuration

Uses the same settings as /capture-learning:

- **skills_path** - Shows where skills would be created
- **quality_threshold** - Applied during analysis
- Settings from `.claude/session-learner.local.md`

**Note:** Always runs in dry-run mode regardless of settings file.

## Instructions

When this command is invoked:

1. Invoke the learning-analyzer agent using the Task tool with explicit preview instructions:
   ```
   agent learning-analyzer "Analyze current session in PREVIEW MODE. Show what learnings would be captured and what skills would be created/updated, but DO NOT write any files or stage any changes. Provide a detailed summary for review."
   ```

2. The agent will:
   - Analyze the session
   - Identify learnings
   - Generate skill previews
   - Report findings without modifying files

3. Display the agent's preview output to the user

**Important:** Ensure the agent knows this is preview mode. The agent should analyze and report but not create files or stage changes.

## Output Example

```
## Session Learning Preview

**Analysis Result:** Found 2 valuable patterns worth capturing

**Quality Check:** ✅ Passed (session had 15 tool calls, 8 minutes of technical work)

**Skills That Would Be Created:**

1. **api-rate-limit-handling** (v1.0.0)
   - Location: .claude/skills/api-rate-limit-handling/SKILL.md
   - Content: Patterns for detecting and handling API rate limits with exponential backoff
   - Sections: Overview, Detection Strategies, Backoff Algorithms, Code Examples

**Skills That Would Be Updated:**

1. **error-handling-patterns** (v1.0.1 → v1.0.2)
   - Location: .claude/skills/error-handling-patterns/SKILL.md
   - Changes: Add section on retry logic with circuit breaker pattern
   - New examples: Circuit breaker implementation from today's work

**Key Learnings:**
- API rate limiting detection pattern (check response headers + status codes)
- Exponential backoff with jitter to avoid thundering herd
- Circuit breaker pattern for failing gracefully after repeated failures

**Recommendation:** ✅ Worth capturing - these are reusable patterns applicable to future API integration work

**Next Steps:**
- Run `/capture-learning` to create these skills
- Or adjust session work and re-run `/review-session`
```

## Tips

- **Run before creating PR** to see what knowledge will be documented
- **Use to validate quality** before actually capturing
- **Iterate if needed** - do more work and review again
- **Compare with /capture-learning** output to verify consistency

## Related Commands

- `/capture-learning` - Actually create the skills shown in preview
- `/git-status` - Check repository status (preview doesn't modify)
- `/git-diff` - View changes (preview has none)
