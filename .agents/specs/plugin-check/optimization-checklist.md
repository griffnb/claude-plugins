# Backend Plugin Component Optimization Checklist

This checklist contains all agents, commands, hooks, and skills in the `plugins/backend` folder that need to be reviewed and optimized according to Claude Code plugin best practices.

## Agents (6)

- [ ] **test-builder** - `plugins/backend/agents/test-builder.md`
- [ ] **engineer** - `plugins/backend/agents/engineer.md`
- [ ] **context-fetcher** - `plugins/backend/agents/context-fetcher.md`
- [ ] **ralph-planner** - `plugins/backend/agents/ralph-planner.md`
- [ ] **subagent-planner** - `plugins/backend/agents/subagent-planner.md`
- [ ] **learning-analyzer** - `plugins/backend/agents/learning-analyzer.md`

## Commands (5)

- [ ] **new-go-object** - `plugins/backend/commands/new-go-object.md`
- [ ] **capture-learning** - `plugins/backend/commands/capture-learning.md`
- [ ] **review-session** - `plugins/backend/commands/review-session.md`
- [ ] **ralph-planner** - `plugins/backend/commands/ralph-planner.md`
- [ ] **subagent-planner** - `plugins/backend/commands/subagent-planner.md`

## Hooks (0)

No hooks found in the backend plugin.

## Skills (9)

- [ ] **controller-generation** - `plugins/backend/skills/controller-generation/SKILL.md`
- [ ] **controller-handlers** - `plugins/backend/skills/controller-handlers/SKILL.md`
- [ ] **controller-roles** - `plugins/backend/skills/controller-roles/SKILL.md`
- [ ] **db-new-column** - `plugins/backend/skills/db-new-column/SKILL.md`
- [ ] **model-conventions** - `plugins/backend/skills/model-conventions/SKILL.md`
- [ ] **model-queries** - `plugins/backend/skills/model-queries/SKILL.md`
- [ ] **model-usage** - `plugins/backend/skills/model-usage/SKILL.md`
- [ ] **testing** - `plugins/backend/skills/testing/SKILL.md`
- [ ] **meta-learning** - `plugins/backend/skills/meta-learning/SKILL.md`

## Optimization Guidelines

For each component, the reviewing agent should:

1. **Read the current prompt/content**
2. **Apply best practices** specific to that component type:
   - **Agents**: System prompt clarity, tool access, triggering conditions, examples
   - **Commands**: Clear frontmatter, argument handling, execution patterns
   - **Skills**: Progressive disclosure, clear structure, YAML frontmatter
   - **Hooks**: Event handling, validation patterns, prompt-based hooks API
3. **Suggest improvements** or apply them directly
4. **Check for consistency** with Claude Code documentation
5. **Verify metadata** (name, description, version info)

## Total Components: 20

- Agents: 6
- Commands: 5
- Hooks: 0
- Skills: 9
