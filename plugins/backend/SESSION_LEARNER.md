# Session Learner

Automatic knowledge capture system that extracts learnings from development sessions and codifies them into reusable skills.

## Overview

The session learner implements **meta-learning** - capturing valuable patterns, techniques, and insights from your development work and transforming them into skills that help with future sessions.

**Core principle:** Each unit of engineering work should make subsequent units easier. Every solved problem becomes reusable knowledge.

## How It Works

```
Development Session
    ↓
User Ends Session (Ctrl+D, exit, etc.)
    ↓
Stop Hook Fires ⚠️ BLOCKS SESSION END
    ↓
Quick Quality Check (transcript length)
    ↓
┌─ Trivial session? → Skip, approve stop immediately
│
└─ Valuable session? → Continue
    ↓
Bash Script Executes
    ↓
NEW Claude Session Spawned (SYNCHRONOUS)
    ↓
Learning Analyzer Agent Invoked
    ↓
Reads: Session Transcript + Git Changes
    ↓
Quality Threshold Check (detailed)
    ↓
Analyze Patterns & Insights
    ↓
Smart Merge Decision
    ↓
Create/Update Skills
    ↓
Git Stage for PR
    ↓
Agent Exits
    ↓
Stop Hook Returns "approve"
    ↓
Session Ends
    ↓
Knowledge Compounded ✨
```

**Key Architecture Point:** Uses a **Stop hook** (not SessionEnd) that blocks session ending until learning capture completes. This ensures the process finishes even in CI/CD environments like GitHub Actions where background processes would be killed.

**Latency:** Adds 5-30 seconds to session end (depending on session complexity). Trivial sessions skip immediately.

## Components

### 1. Stop Hook

**Location:** `hooks/hooks.json` + `hooks/scripts/capture-session-learnings.sh`

Automatically triggers when session is about to end, blocking until learning capture completes.

**How it works:**
1. User ends session (Ctrl+D, exit command, etc.)
2. Stop hook fires BEFORE session ends
3. Bash script `capture-session-learnings.sh` executes
4. Quick quality check: if transcript < 50 lines, skip immediately
5. Script reads configuration from `.claude/session-learner.local.md`
6. Script spawns a **new Claude Code session** SYNCHRONOUSLY with: `claude agent learning-analyzer "..."`
7. New session runs learning-analyzer agent to analyze current session
8. Agent reads transcript, checks git changes, creates skills
9. Agent stages changes with git add
10. Agent exits
11. Hook returns `{"decision": "approve"}` to allow session to end
12. Original session finally ends

**Why Stop hook (not SessionEnd):**
- **CI/CD compatible:** Blocks session end, so works in GitHub Actions
- **Guaranteed completion:** Process finishes before Action terminates
- **Synchronous:** No background process that could be killed
- **Fast-path for trivial:** Quick check skips immediately if no work done

**Trade-off:** Adds latency (5-30s) to session ending, but ensures skills are captured.

### 2. Learning Analyzer Agent

**Location:** `agents/learning-analyzer.md`

Autonomous agent that extracts learnings and creates/updates skills.

**Capabilities:**
- Reads session transcript and analyzes patterns
- Applies quality filters (>5 tool calls, >2 minutes)
- Smart merge: updates existing skills or creates new ones
- Generates skill markdown with proper frontmatter
- Stages changes with git for PR inclusion

**Tools:** Read, Write, Edit, Grep, Glob, Bash

### 3. Meta-Learning Skill

**Location:** `skills/meta-learning/`

Teaches the agent what makes a good learning and how to write quality skills.

**Contents:**
- `SKILL.md` - Core guidance on identifying valuable learnings
- `references/learning-examples.md` - Detailed good vs bad examples
- `examples/good-skill-example.md` - Complete skill showing best practices
- `examples/bad-skill-example.md` - Anti-patterns to avoid

### 4. Commands

#### `/capture-learning [focus]`

**Location:** `commands/capture-learning.md`

Manually trigger learning capture mid-session.

**Usage:**
```
/capture-learning
/capture-learning API authentication patterns
/capture-learning React hooks debugging
```

**Use when:**
- Want to capture before session ends
- Solved particularly interesting problem
- Want to ensure insights aren't lost

#### `/review-session`

**Location:** `commands/review-session.md`

Preview what would be captured without creating files.

**Usage:**
```
/review-session
```

**Shows:**
- Skills that would be created
- Skills that would be updated
- Key learnings identified
- Recommendations

### 5. Configuration

**Location:** `session-learner.local.md.example`

Example configuration file showing all settings.

**Settings:**
- `skills_path` - Where to save skills (default: `.claude/skills/`)
- `quality_threshold` - Skip trivial sessions (default: true)
- `auto_stage` - Auto git add skills (default: true)
- `dry_run` - Preview mode (default: false)

**Installation:**
```bash
cp session-learner.local.md.example .claude/session-learner.local.md
# Customize settings as needed
```

## Usage Workflows

### Automatic Workflow (Default)

1. **Do work** - Code, debug, solve problems normally
2. **End session** - Press Ctrl+D or type exit
3. **Hook blocks** - Stop hook fires, blocks session end
4. **Quick check** - If trivial session, skip immediately
5. **Agent analyzes** - If valuable, learning-analyzer agent runs (5-30s)
6. **Skills created** - Learnings captured and staged automatically
7. **Session ends** - After hook completes
8. **Create PR** - Skills included in PR alongside code changes

No manual intervention needed! Works in CI/CD environments.

### Manual Workflow

1. **Do work** - Solve interesting problem
2. **Capture immediately** - `/capture-learning`
3. **Review** - Check generated skills
4. **Adjust if needed** - Edit skills manually
5. **Commit** - Include in next commit

### Preview Workflow

1. **Do work** - Development session
2. **Review first** - `/review-session`
3. **Evaluate** - Are learnings valuable?
4. **Capture if worthwhile** - `/capture-learning`
5. **Or continue working** - Do more work, review again

## What Gets Captured

### ✅ Valuable Learnings

**Capture these:**
- Debugging patterns that worked systematically
- Architecture decisions with rationale
- Framework-specific gotchas discovered
- Non-obvious usage patterns
- Performance optimization techniques
- Testing strategies that proved effective
- Common pitfalls and how to avoid them

**Examples:**
- "API rate limiting detection pattern with exponential backoff"
- "React hooks dependency array rules to prevent infinite loops"
- "PostgreSQL JSONB query optimization with expression indexes"
- "Git merge conflict resolution strategy for multi-file conflicts"

### ❌ Skip These

**Don't capture:**
- Trivial operations (typo fixes, simple CRUD)
- Generic advice from any coding guide
- Just reading documentation
- One-off solutions without reusable patterns
- Standard operations covered in framework docs

**Examples:**
- "Fixed typo in README"
- "Use descriptive variable names"
- "Created basic model with CRUD"
- "Read React documentation"

## Quality Standards

Every generated skill meets these standards:

**Structure:**
- Proper YAML frontmatter with name and description
- Third-person description ("This skill should be used when...")
- Specific trigger phrases in description
- Imperative form in body (verb-first instructions)
- Focused content (1,500-2,000 words ideal)
- Progressive disclosure (references/ for detailed content)

**Content:**
- Concrete examples from the session
- Actionable guidance
- Specific patterns and techniques
- Clear best practices
- Common pitfalls identified

**Version Tracking:**
- New skills: v1.0.0
- Updates: Bump patch (1.0.0 → 1.0.1)

## Configuration Guide

### Basic Setup

1. **Copy example config:**
   ```bash
   cp plugins/backend/session-learner.local.md.example .claude/session-learner.local.md
   ```

2. **Customize settings:**
   ```yaml
   ---
   skills_path: ".claude/skills/"
   quality_threshold: true
   auto_stage: true
   dry_run: false
   ---
   ```

3. **Create skills directory:**
   ```bash
   mkdir -p .claude/skills
   ```

### Recommended Settings

**For most projects:**
```yaml
skills_path: ".claude/skills/"       # Project-local
quality_threshold: true              # High quality bar
auto_stage: true                     # Include in PRs
dry_run: false                       # Actually create skills
```

**For testing:**
```yaml
skills_path: ".claude/skills/"
quality_threshold: false             # Capture everything
auto_stage: false                    # Manual control
dry_run: true                        # Preview only
```

## Examples

### Example 1: API Authentication Learning

**Session:** User debugged API authentication, tried several approaches, discovered header format issue.

**Captured skill:** `api-authentication-debugging`
- Systematic checklist for debugging auth failures
- Common issues: Bearer prefix, token expiration, case sensitivity
- Step-by-step diagnostic process
- Code examples from session

### Example 2: React Hooks Pattern

**Session:** User hit infinite render loop, learned dependency array rules.

**Updated skill:** `react-hooks-patterns` (v1.0.1 → v1.0.2)
- Added section on dependency arrays
- Infinite loop detection patterns
- Solutions: useCallback, functional updates
- Examples from the debugging session

### Example 3: Trivial Session Skipped

**Session:** User fixed typo in README, read some docs.

**Result:** Quality threshold filtered - no skill created
- <5 tool calls
- No problem-solving
- No reusable patterns

## Troubleshooting

### Skills Not Created

**Problem:** SessionEnd hook fires but no skills generated.

**Solutions:**
1. Check quality threshold - try `quality_threshold: false` temporarily
2. Run `/review-session` to see analysis
3. Verify session had substantive work (>5 tool calls, >2 minutes)

### Skills in Wrong Location

**Problem:** Skills created but not where expected.

**Solutions:**
1. Check `skills_path` setting in `.claude/session-learner.local.md`
2. Ensure directory exists or can be created
3. Verify path is relative to project root

### Changes Not Staged

**Problem:** Skills created but not staged for commit.

**Solutions:**
1. Check `auto_stage: true` in settings
2. Verify git repository initialized
3. Run `git status` to check manually
4. Stage manually: `git add .claude/skills/`

### Want to Test Without Committing

**Solution:**
1. Set `dry_run: true` in settings
2. Run session or `/capture-learning`
3. Review output shows what would be created
4. No files actually written
5. Set `dry_run: false` when ready

## Best Practices

### For Individual Developers

1. **Trust the system** - Let SessionEnd hook run automatically
2. **Use /review-session** - Preview before PRs
3. **Customize settings** - Adjust quality_threshold for your workflow
4. **Review git diff** - Check generated skills before committing
5. **Iterate** - Edit skills if agent didn't capture perfectly

### For Teams

1. **Share configuration** - Commit `.claude/session-learner.local.md` for consistency
2. **Skills in PRs** - Review skills alongside code changes
3. **Refine together** - Edit skills collaboratively
4. **Build knowledge base** - Skills compound across team's work
5. **Document patterns** - Use skills as living documentation

### For Projects

1. **Keep skills with code** - `.claude/skills/` in project repo
2. **Version control** - Commit skills like code
3. **Review in PRs** - Treat skills as first-class artifacts
4. **Refactor skills** - As patterns evolve, update skills
5. **Share learnings** - Skills become project documentation

## Architecture Decisions

### Why Stop Hook (Not SessionEnd)?

**Alternative considered:** SessionEnd hook with background process.
**Chosen:** Stop hook with synchronous execution.
- **CI/CD compatible:** Process completes before GitHub Action terminates
- **Guaranteed completion:** No background process that could be killed
- **Same capabilities:** Can still spawn new Claude session to analyze transcript
- **Fast-path:** Quick quality check skips trivial sessions immediately

**Trade-off:** Adds 5-30s latency to session ending, but ensures reliable capture in all environments.

### Why Command Hook with New Session?

**Alternative considered:** Prompt-based hook or inline script processing.
**Chosen:** Command hook that spawns new Claude session.
- **Access to transcript:** Can read completed session transcript
- **Full tool access:** New session has all agent capabilities
- **Git changes visible:** Can see what was actually modified
- **Synchronous control:** Hook waits for completion before approving stop

### Why Smart Merge?

**Alternative considered:** Always create new skills.
**Chosen:** Smart merge to avoid skill sprawl.
- Updates existing when >60% topic overlap
- Prevents duplicate skills
- Compounds knowledge in focused skills

### Why Auto-Stage?

**Alternative considered:** Always require manual staging.
**Chosen:** Auto-stage for seamless PR workflow.
- Skills automatically included in PRs
- Reduces friction
- User can disable if they want control

## Files Created

```
plugins/backend/
├── hooks/
│   ├── hooks.json                          # SessionEnd hook config
│   └── scripts/
│       └── capture-session-learnings.sh    # Hook script that spawns new Claude session
├── agents/
│   └── learning-analyzer.md                # Analysis agent
├── skills/
│   └── meta-learning/
│       ├── SKILL.md                        # Core guidance
│       ├── references/
│       │   └── learning-examples.md        # Detailed examples
│       └── examples/
│           ├── good-skill-example.md       # Best practices
│           └── bad-skill-example.md        # Anti-patterns
├── commands/
│   ├── capture-learning.md                 # Manual capture
│   └── review-session.md                   # Preview mode
└── session-learner.local.md.example        # Config template
```

## Integration Points

**Works with:**
- Git workflow - Auto-stages for PRs
- Claude Code sessions - Analyzes transcripts
- Plugin skills system - Uses meta-learning skill
- Agent system - Invokes learning-analyzer
- Hook system - SessionEnd trigger

**Extends:**
- Compound engineering plugin - Adds meta-learning capability
- Skill system - Automatically expands skill library
- Development workflow - Captures knowledge alongside code

## Future Enhancements

**Potential additions:**
- Skill quality scoring and metrics
- Team knowledge sharing integration
- Search across captured skills
- Similarity detection to prevent near-duplicates
- Skill usage analytics
- Cross-project skill library

## CI/CD Integration

### GitHub Actions Compatibility

The Stop hook architecture ensures learning capture completes before GitHub Action jobs terminate.

**Example workflow:**
```yaml
- name: Run Claude Code
  run: |
    claude "Implement feature X"
    # Stop hook blocks here until learning capture completes
    # Skills are created and staged automatically

- name: Commit changes including skills
  run: |
    git add .
    git commit -m "Implement feature X"
    # Skills in .claude/skills/ are included
```

**Key points:**
- Stop hook blocks session end until complete
- No background processes to be killed
- Skills staged automatically before Action ends
- Works same as local development

### Latency Considerations

**Local development:** 5-30s added to session end
- Trivial sessions: <1s (quick skip)
- Moderate sessions: 5-10s
- Complex sessions: 15-30s

**CI/CD:** Same latency, but guarantees capture completion

**To disable in CI:** Set environment variable
```yaml
- name: Run Claude Code
  env:
    CLAUDE_SKIP_LEARNING_CAPTURE: "true"
  run: claude "..."
```

(Note: Script would need to check this env var - not yet implemented)

## Support

**Questions or issues:**
- Check this documentation
- Review examples in `skills/meta-learning/examples/`
- Run `/review-session` to see what agent sees
- Try `dry_run: true` to test without side effects

**Feedback:**
- Open issue in repository
- Suggest improvements to capture quality
- Share interesting skills generated
- Report edge cases

---

**Built with compounding engineering principles:** Each captured learning makes future sessions easier. Every skill created is an investment in productivity that pays dividends across all future work.
