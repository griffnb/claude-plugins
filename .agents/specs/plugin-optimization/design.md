# Plugin Optimization Design

## Overview

This document outlines the design for analyzing and optimizing all agents, commands, skills, and hooks in the Claude Code plugin repository. The system will perform comprehensive analysis against established best practices, with special attention to skill triggering, MCP tool references, and prompt quality.

### Goals

1. Analyze all plugin components against Claude Code best practices
2. Identify issues with skill triggering (description format)
3. Verify proper MCP tool references (especially `#code_tools`)
4. Ensure documentation references are formatted correctly
5. Generate actionable, prioritized recommendations
6. Create an implementation plan for systematic improvements

### Key Focus Areas (from user requirements)

- **Skill Triggering**: Ensure skills use proper "This skill should be used when..." format with specific trigger phrases
- **MCP Tool References**: Verify `#code_tools` and other MCP tools are referenced using correct syntax
- **Documentation References**: Check that references to `/docs` files use proper markdown link format
- **Prompt Optimization**: Ensure all prompts provide maximum value with minimal tokens

## Architecture

### Analysis System Components

```
┌─────────────────────────────────────────────────┐
│         Component Discovery                     │
│  (Glob/Read all agents, commands, skills)       │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│         Metadata Validation                      │
│  (Frontmatter, required fields, formats)        │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│         Content Analysis                         │
│  (Triggering, MCP refs, docs refs, examples)    │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│         Cross-Component Analysis                 │
│  (Redundancies, gaps, consistency)              │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│         Recommendation Engine                    │
│  (Prioritized improvements, examples)           │
└──────────────────┬──────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────┐
│         Report Generation                        │
│  (Analysis results, optimization plan)          │
└─────────────────────────────────────────────────┘
```

### Analysis Flow

1. **Discovery Phase**: Locate all components using Glob patterns
2. **Validation Phase**: Check frontmatter and metadata
3. **Content Analysis Phase**: Deep analysis of prompt content
4. **Cross-Component Phase**: Identify patterns across components
5. **Recommendation Phase**: Generate prioritized improvements
6. **Documentation Phase**: Create comprehensive report

## Components and Interfaces

### Component Discovery Module

**Purpose**: Locate all plugin components in the repository

**Interface**:
```
Input: Repository root path
Output: Categorized lists of component files
  - agents: List[AgentFile]
  - commands: List[CommandFile]
  - skills: List[SkillFile]
  - hooks: List[HookFile]
```

**Implementation**:
- Use Glob to find: `**/agents/*.md`, `**/commands/*.md`, `**/skills/**/SKILL.md`, `**/hooks/*.md`
- Read plugin.json files to validate component registration
- Create structured inventory with file paths and component types

### Metadata Validation Module

**Purpose**: Validate frontmatter and required fields

**Agent Validation Rules**:
```yaml
Required Fields:
  - name: string (lowercase-with-hyphens)
  - description: string (should include triggering conditions)

Optional Fields:
  - color: string (standard color names)
  - model: string (haiku/sonnet/opus)
  - when: string (deprecated - use description)

Validation Checks:
  - name matches file name
  - description is detailed (>50 chars recommended)
  - description includes "use when" or similar trigger language
  - color is valid if present
```

**Command Validation Rules**:
```yaml
Required Fields:
  - name: string
  - description: string

Optional Fields:
  - argument-hint: string
  - allowed-tools: array[string]
  - args: object

Validation Checks:
  - name matches file name (without .md)
  - description explains what command does
  - argument-hint present if command takes args
  - allowed-tools uses proper tool names
```

**Skill Validation Rules**:
```yaml
Required Fields:
  - name: string (matches directory name)
  - description: string (MUST use third person)

Format Requirements:
  - description MUST start with "This skill should be used when..."
  - description MUST include 3-5 specific trigger phrases
  - description length: 100-300 chars recommended

Best Practices:
  - Include keywords users would naturally say
  - Be specific about scenarios, not generic
  - Use imperative form in body content
  - No second person ("you") in body
```

**Hook Validation Rules**:
```yaml
Required Fields:
  - event: string (PreToolUse/PostToolUse/Stop/etc)
  - description: string

Validation Checks:
  - event is valid hook type
  - description explains what hook does
  - hook logic is focused and efficient
```

### Content Analysis Module

**Purpose**: Analyze prompt content for quality and best practices

#### Skill Triggering Analysis

**Problem Identified**: Skills may not trigger properly if description doesn't include:
- Third person format ("This skill should be used when...")
- Specific trigger phrases users would say
- Clear scenario descriptions

**Analysis Steps**:
1. Extract description from frontmatter
2. Check if description uses third person format
3. Identify trigger phrases (keywords/scenarios)
4. Rate specificity (generic vs specific)
5. Suggest improvements with examples

**Example Good Description**:
```yaml
description: This skill should be used when analyzing development sessions to extract learnings, determining what constitutes valuable knowledge to capture, creating skills from session insights, or evaluating whether patterns are worth codifying for reuse.
```

**Example Bad Description** (needs improvement):
```yaml
description: Use to build proper go unit tests
# Issues:
# - Uses second person ("Use")
# - Too generic
# - Missing specific trigger scenarios
# - No keywords users would say

# Better version:
description: This skill should be used when writing Go unit tests, implementing test-driven development workflows, testing controllers with table-driven patterns, or when the user asks to "write tests", "add test coverage", or "implement TDD".
```

#### MCP Tool Reference Analysis

**Problem Identified**: MCP tools like `#code_tools` may not be referenced correctly

**Current Patterns Found**:
```markdown
# Pattern 1: Hash prefix
**CRITICAL** you always use `#code_tools` for what you need

# Pattern 2: MCP prefix
use MCP: `#code_tools docs` to look at packages

# Pattern 3: Bare mention
use code_tools to ensure proper environment
```

**Recommended Pattern** (based on research):
```markdown
# For referencing MCP server tools in prompts:
Use the code_tools MCP server to analyze the codebase. The server provides tools for documentation lookup, code generation, and testing.

# Specific tool invocation instructions:
- To look up documentation: Use the code_tools MCP server's `docs` tool
- To generate objects: Use the code_tools MCP server's `make_object` tool
- To run tests: Use the code_tools MCP server's test execution tools
```

**Analysis Steps**:
1. Search for MCP references in component content
2. Identify reference patterns used
3. Determine if references are clear and actionable
4. Check if MCP server is properly configured in plugin.json
5. Suggest improvements for clarity

#### Documentation Reference Analysis

**Problem Identified**: References to `/docs` files may not use proper markdown link format

**Current Patterns Found**:
```markdown
# Pattern 1: Backtick reference (not a link)
read `./docs/MODELS.md`

# Pattern 2: Plain text
Instructions for models are in ./docs/MODELS.md

# Pattern 3: Proper markdown link
See [MODELS.md](./docs/MODELS.md) for details
```

**Recommended Pattern**:
```markdown
# Use proper markdown links with descriptive text
See [Model Conventions](./docs/MODELS.md) for standards on struct tags and field naming.

# For inline references, use links
Follow the [Controller Guidelines](./docs/CONTROLLERS.md) when implementing handlers.
```

**Analysis Steps**:
1. Search for file path references in content
2. Identify format used (backticks, plain text, links)
3. Check if referenced files exist
4. Suggest converting to proper markdown links
5. Verify link targets are correct

#### Example Quality Analysis

**Purpose**: Ensure examples are concrete and helpful

**Analysis Checks**:
1. Examples use proper markdown code blocks with language hints
2. Examples are complete and functional
3. Examples demonstrate the point being made
4. Examples include comments where helpful
5. Good/bad examples are clearly labeled

**Pattern**:
```markdown
# Good example structure:
**Good:**
```go
func (this *User) FullName() string {
    return this.FirstName.Get() + " " + this.LastName.Get()
}
```

**Bad:**
```go
func (u *User) FullName() string {  // ❌ Wrong receiver name
    return u.FirstName.Get() + " " + u.LastName.Get()
}
```
```

### Cross-Component Analysis Module

**Purpose**: Identify patterns, redundancies, and gaps across all components

#### Redundancy Detection

**Analysis**:
1. Compare agent descriptions for overlap
2. Identify commands that could be combined
3. Find skills covering similar topics
4. Detect duplicate examples or patterns

**Example Redundancy Found**:
- `test-builder` agent and `testing` skill cover same material
- Should consolidate or clearly differentiate

#### Consistency Checking

**Checks**:
1. Naming conventions consistent across components
2. Frontmatter format consistent
3. Writing style consistent (imperative vs second person)
4. Example format consistent
5. Documentation reference style consistent

**Example Inconsistencies**:
- Some agents use CRITICAL in all caps, others don't
- Some components use snake_case, others kebab-case
- Mixed use of "you" vs imperative form

#### Gap Analysis

**Identify Missing Elements**:
1. Components missing required frontmatter fields
2. Agents without clear triggering conditions
3. Commands without examples
4. Skills without progressive disclosure
5. Missing cross-references between related components

#### Metadata Verification

**Plugin.json Checks**:
1. Component counts match actual files
2. MCP servers properly configured
3. Version numbers are consistent
4. Description matches reality

**Cross-file Checks**:
1. README.md matches plugin.json
2. CHANGELOG.md is up to date
3. All components are registered/discoverable

### Recommendation Engine

**Purpose**: Generate prioritized, actionable recommendations

#### Recommendation Structure

```markdown
## Component: [component-name]
**Priority**: High/Medium/Low
**Category**: [Triggering/MCP-Refs/Docs-Refs/Examples/Structure]

### Issue
[Clear description of what's wrong]

### Impact
[Why this matters]

### Recommendation
[Specific action to take]

### Example
[Show current vs improved version]
```

#### Prioritization Criteria

**High Priority**:
- Broken MCP references that prevent functionality
- Skills with poor triggering that won't be invoked
- Missing required frontmatter fields
- Incorrect metadata counts

**Medium Priority**:
- Suboptimal documentation references (work but not best practice)
- Missing examples in critical components
- Inconsistent formatting/style
- Redundant components

**Low Priority**:
- Optional frontmatter fields not used
- Minor style inconsistencies
- Enhancement opportunities
- Additional examples that would be nice to have

#### Recommendation Grouping

Group similar recommendations for batch processing:
- All skill description improvements together
- All MCP reference updates together
- All documentation link conversions together
- All frontmatter additions together

## Data Models

### Component Model

```typescript
interface Component {
  path: string;
  type: 'agent' | 'command' | 'skill' | 'hook';
  name: string;
  frontmatter: Map<string, any>;
  content: string;
  validationErrors: ValidationError[];
  contentIssues: ContentIssue[];
  recommendations: Recommendation[];
}

interface ValidationError {
  field: string;
  severity: 'error' | 'warning';
  message: string;
  suggestion?: string;
}

interface ContentIssue {
  category: 'triggering' | 'mcp-refs' | 'docs-refs' | 'examples' | 'structure';
  severity: 'high' | 'medium' | 'low';
  line?: number;
  message: string;
  currentPattern: string;
  recommendedPattern: string;
}

interface Recommendation {
  priority: 'high' | 'medium' | 'low';
  category: string;
  issue: string;
  impact: string;
  action: string;
  example?: {
    before: string;
    after: string;
  };
}
```

### Analysis Report Model

```typescript
interface AnalysisReport {
  summary: {
    totalComponents: number;
    componentsByType: Map<string, number>;
    issuesFound: number;
    issuesByPriority: Map<string, number>;
    issuesByCategory: Map<string, number>;
  };

  componentReports: ComponentReport[];

  crossComponentFindings: {
    redundancies: Redundancy[];
    inconsistencies: Inconsistency[];
    gaps: Gap[];
  };

  recommendations: Recommendation[];

  metadata: {
    pluginJsonAccurate: boolean;
    readmeAccurate: boolean;
    changelogUpToDate: boolean;
    mcpServersConfigured: string[];
  };
}

interface ComponentReport {
  component: Component;
  validationStatus: 'pass' | 'fail' | 'warning';
  bestPracticesScore: number;  // 0-100
  issuesFound: number;
  recommendations: Recommendation[];
}
```

## Error Handling

### Validation Errors

**File Not Found**:
- Log warning
- Continue analysis of other components
- Note missing component in report

**Invalid Frontmatter**:
- Parse as much as possible
- Report syntax errors
- Provide corrected examples

**Missing Required Fields**:
- Mark component as failing validation
- Generate high-priority recommendation
- Show example of correct frontmatter

### Analysis Errors

**Pattern Matching Failures**:
- Use multiple regex patterns for flexibility
- Log patterns that failed
- Manual review may be needed

**Reference Resolution Failures**:
- Note broken references
- Attempt to suggest corrections
- Flag for manual review

## Testing Strategy

### Component Discovery Tests

1. Test Glob patterns match all component types
2. Test component type identification
3. Test handling of nested directories
4. Test plugin.json parsing

### Validation Tests

**Frontmatter Parsing**:
- Test valid YAML frontmatter
- Test invalid/malformed YAML
- Test missing frontmatter
- Test partial frontmatter

**Field Validation**:
- Test required field checks for each component type
- Test optional field validation
- Test field format validation (names, descriptions)
- Test field value constraints

### Content Analysis Tests

**Skill Triggering**:
- Test detection of third person format
- Test identification of trigger phrases
- Test specificity scoring
- Test suggestion generation

**MCP Reference Detection**:
- Test various MCP reference patterns
- Test MCP server configuration checks
- Test tool reference validation
- Test recommendation generation

**Documentation Reference Detection**:
- Test backtick reference detection
- Test plain text path detection
- Test markdown link detection
- Test link target verification

### Cross-Component Tests

**Redundancy Detection**:
- Test overlap calculation between components
- Test grouping of similar components
- Test duplicate detection

**Consistency Checking**:
- Test naming convention validation
- Test style consistency checks
- Test format consistency checks

### Integration Tests

**End-to-End Analysis**:
- Test full analysis pipeline on sample components
- Verify report generation
- Validate recommendation quality
- Check prioritization logic

**Real Component Tests**:
- Run analysis on actual plugin components
- Verify findings are accurate
- Test recommendation applicability

## Implementation Approach

### Phase 1: Component Discovery and Inventory

1. Implement Glob-based discovery
2. Build component inventory with metadata
3. Validate component registration in plugin.json
4. Generate initial component report

### Phase 2: Metadata Validation

1. Implement frontmatter parser
2. Build validation rules for each component type
3. Run validation on all components
4. Generate validation report with errors/warnings

### Phase 3: Content Analysis

1. Implement skill triggering analyzer
2. Implement MCP reference analyzer
3. Implement documentation reference analyzer
4. Implement example quality analyzer
5. Generate content analysis report

### Phase 4: Cross-Component Analysis

1. Implement redundancy detection
2. Implement consistency checking
3. Implement gap analysis
4. Implement metadata verification
5. Generate cross-component report

### Phase 5: Recommendation Engine

1. Aggregate findings from all analyzers
2. Apply prioritization logic
3. Generate specific recommendations with examples
4. Group recommendations for batch processing
5. Generate final optimization report

### Phase 6: Documentation and Handoff

1. Create comprehensive analysis report
2. Document findings with examples
3. Provide implementation guidance
4. Create task list for improvements

## Best Practices Reference

### Agent Best Practices

```yaml
---
name: agent-name
description: Detailed description including when to use this agent. Should mention specific scenarios, keywords users would say, and clear triggering conditions. Use "Use when..." or "Use to..." format.
color: cyan  # Optional: visual distinction
model: sonnet  # Optional: haiku for quick tasks
---

# Agent Title

## Critical Instructions (if needed)
**CRITICAL**: Always follow these rules
- Rule 1 with clear reasoning
- Rule 2 with clear reasoning

## Persona (for role-based agents)
[Description of agent's role and personality]

## Core Principles
- Principle 1
- Principle 2

## Responsibilities
1. **Responsibility 1**
   - Details
   - Examples

2. **Responsibility 2**
   - Details
   - Examples

## Constraints
- Constraint 1
- Constraint 2

## Example Behaviors (if helpful)
**Good Behavior:**
- Example of what to do

**Bad Behavior:**
- Example of what to avoid
```

### Command Best Practices

```yaml
---
name: command-name
description: Clear explanation of what this command does and when to use it
argument-hint: "[arg1] [arg2]"  # Show expected arguments
allowed-tools: ["Tool1", "Tool2"]  # Optional: restrict tool usage
---

# Command Title

Brief overview of command purpose.

## Usage

```
/command-name arg1 arg2
```

## Arguments

- **arg1** - Description of first argument
- **arg2** - Description of second argument

## Examples

```
/command-name example value
```
Does X with the example value.

```
/command-name another example
```
Does Y with another example.

## What This Command Does

1. Step 1
2. Step 2
3. Step 3

## When to Use

- Scenario 1
- Scenario 2

## Instructions (for implementation)

When this command is invoked:

1. Action to take
2. Tool to use
3. Output to provide
```

### Skill Best Practices

```yaml
---
name: skill-name
description: This skill should be used when [scenario 1], [scenario 2], [scenario 3], or when the user asks "[keyword 1]", "[keyword 2]", "[keyword 3]".
version: 1.0.0
---

# Skill Title

## Overview
Brief 2-3 sentence overview of what this skill covers.

## Key Concepts
Core ideas presented as bullet points or short sections.

## [Section 2]
Detailed information using imperative form (verb-first instructions).

## Examples

Concrete examples with proper code formatting.

**Good:**
```language
example code
```

**Bad:**
```language
anti-pattern
```

## Related Skills/Resources

- [related-skill](../related-skill/SKILL.md)
- [Documentation](./docs/guide.md)
```

### MCP Tool Reference Best Practices

```markdown
# In agent/command/skill content:

Use the [server_name] MCP server to [purpose]. The server provides:
- **tool_name** - Description of what tool does
- **another_tool** - Description of another tool

To perform [action], use the [server_name] MCP server's [tool_name] tool.

# Example:
Use the code_tools MCP server to interact with the codebase. The server provides:
- **docs** - Look up Go package and function documentation
- **make_object** - Generate model objects following project conventions
- **test** - Run tests with proper environment setup

To look up model documentation, use the code_tools MCP server's docs tool with the model name.
```

### Documentation Reference Best Practices

```markdown
# Use markdown links with descriptive text:
See [Model Conventions](./docs/MODELS.md) for field naming standards.

Follow the [Controller Guidelines](./docs/CONTROLLERS.md) when implementing handlers.

Refer to [Testing Best Practices](./docs/TESTING.md) for TDD workflow.

# For multiple related docs:
Key documentation:
- [Models](./docs/MODELS.md) - Model structure and conventions
- [Controllers](./docs/CONTROLLERS.md) - HTTP handler patterns
- [Testing](./docs/TESTING.md) - Test-driven development workflow
```

## Deliverables

1. **Component Inventory Report**
   - List of all agents, commands, skills, hooks
   - Basic metadata for each component
   - Registration status in plugin.json

2. **Validation Report**
   - Frontmatter validation results
   - Required field compliance
   - Format compliance

3. **Content Analysis Report**
   - Skill triggering analysis
   - MCP reference analysis
   - Documentation reference analysis
   - Example quality analysis

4. **Cross-Component Analysis Report**
   - Redundancies identified
   - Inconsistencies found
   - Gaps identified
   - Metadata accuracy

5. **Optimization Recommendations**
   - Prioritized list of improvements
   - Specific recommendations with examples
   - Grouped for efficient implementation

6. **Implementation Task List**
   - Step-by-step tasks for improvements
   - Organized by component and priority
   - Includes verification steps

## Success Criteria

1. All components analyzed for best practices compliance
2. All MCP references verified and corrected if needed
3. All documentation references use proper markdown links
4. All skill descriptions optimized for triggering
5. Prioritized recommendations generated with examples
6. Implementation task list ready for execution
7. Metadata (plugin.json, README, CHANGELOG) verified accurate

## Future Enhancements

1. **Automated Fixes**: Generate pull requests for low-risk improvements
2. **Continuous Monitoring**: Run analysis on git hooks to maintain quality
3. **Custom Rules**: Allow project-specific best practices rules
4. **Scoring System**: Provide overall quality score for plugin
5. **Comparative Analysis**: Compare against other high-quality plugins
