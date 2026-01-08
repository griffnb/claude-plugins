# Plugin Optimization Implementation Tasks

This task list is optimized for Ralph Wiggum - a self-referential AI development loop that iterates until completion. Each task includes clear success criteria, automatic verification steps, and self-correction loops.

## Task 1: Create Component Discovery Script

**Requirements:** Requirement 1 (Agent Analysis), 2 (Command Analysis), 3 (Skill Analysis), 4 (Hook Analysis) - Need to discover all components first

**Implementation:**
1. Create `scripts/analyze-components.js` (or `.py`) to discover all plugin components
2. Implement Glob patterns for: `**/agents/*.md`, `**/commands/*.md`, `**/skills/**/SKILL.md`, `**/hooks/*.md`
3. Parse frontmatter from each component using YAML parser
4. Output JSON structure with all discovered components and their metadata

**Verification:**
- Run script: `node scripts/analyze-components.js` (or `python scripts/analyze-components.py`)
- Expected: JSON output with arrays of agents, commands, skills, hooks
- Expected: Each component has `path`, `type`, `name`, `frontmatter` fields
- Verify: Script finds all known components in `plugins/backend/`

**Self-Correction:**
- If script fails: Check file permissions, verify Node/Python installed
- If Glob misses files: Adjust patterns, test against known component paths
- If frontmatter parse errors: Handle missing/malformed YAML gracefully

**Completion Criteria:**
- [x] Script successfully discovers all components
- [x] JSON output includes all expected components
- [x] Frontmatter is parsed correctly for each component

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 2: Implement Metadata Validator

**Requirements:** Requirements 1.1, 2.1, 3.1, 4.1 (Frontmatter validation for all component types)

**Implementation:**
1. Create `scripts/validate-metadata.js` (or `.py`) that takes component JSON as input
2. Implement validation rules for each component type:
   - Agents: `name` (required), `description` (required, >50 chars)
   - Commands: `name` (required), `description` (required)
   - Skills: `name` (required), `description` (required, must use third person)
   - Hooks: `event` (required), `description` (required)
3. Check optional fields if present (color, model, args, etc.)
4. Output validation report with errors/warnings per component

**Verification:**
- Run: `node scripts/validate-metadata.js < component-data.json`
- Expected: Validation report showing pass/fail for each component
- Test with known good component: Should pass all checks
- Test with known bad component: Should report specific errors

**Self-Correction:**
- If validation too strict: Adjust thresholds based on actual components
- If validation too loose: Add missing checks from requirements
- If false positives: Refine validation logic

**Completion Criteria:**
- [x] Validator checks all required fields for each component type
- [x] Validator outputs clear error messages
- [x] Validator handles optional fields correctly

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 3: Implement Skill Triggering Analyzer

**Requirements:** Requirement 3.2, 3.6 (Skill triggering and description accuracy)

**Implementation:**
1. Create `scripts/analyze-skill-triggering.js` (or `.py`)
2. For each skill, extract and analyze description:
   - Check if starts with "This skill should be used when..."
   - Extract trigger phrases (comma-separated scenarios)
   - Count trigger phrases (recommend 3-5)
   - Rate specificity: generic keywords vs specific user phrases
3. Generate recommendations for improvements
4. Output analysis report with before/after examples

**Verification:**
- Run: `node scripts/analyze-skill-triggering.js`
- Expected: Report showing each skill's triggering score
- Expected: Skills with poor triggering flagged with recommendations
- Expected: Improved description examples provided

**Self-Correction:**
- If trigger phrase detection fails: Refine regex patterns
- If recommendations unclear: Add concrete before/after examples
- If scoring inconsistent: Adjust specificity scoring algorithm

**Completion Criteria:**
- [x] Analyzer detects third person format correctly
- [x] Analyzer extracts trigger phrases accurately
- [x] Analyzer generates actionable recommendations

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 4: Implement MCP Reference Analyzer

**Requirements:** Requirement 1.4 (Agent tool specifications), user's concern about #code_tools references

**Implementation:**
1. Create `scripts/analyze-mcp-refs.js` (or `.py`)
2. Search component content for MCP references:
   - Pattern 1: `#code_tools`
   - Pattern 2: `MCP: #code_tools`
   - Pattern 3: Bare mentions of `code_tools`
   - Pattern 4: Other MCP servers (context7)
3. Classify each reference as: clear/unclear/missing
4. Generate recommendations for unclear references with improved wording
5. Verify MCP servers are configured in plugin.json

**Verification:**
- Run: `node scripts/analyze-mcp-refs.js`
- Expected: List of all MCP references found
- Expected: Classification of each reference (clear/unclear)
- Expected: Recommendations for improvements with examples

**Self-Correction:**
- If pattern matching misses references: Add more regex patterns
- If recommendations too generic: Provide specific improved wording
- If false positives: Refine pattern matching logic

**Completion Criteria:**
- [x] Analyzer finds all MCP references in components
- [x] Analyzer classifies reference quality correctly
- [x] Analyzer provides clear improvement recommendations

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 5: Implement Documentation Reference Analyzer

**Requirements:** User's concern about documentation references being formatted correctly

**Implementation:**
1. Create `scripts/analyze-doc-refs.js` (or `.py`)
2. Search component content for documentation references:
   - Backtick format: `` `./docs/MODELS.md` ``
   - Plain text: `./docs/MODELS.md`
   - Markdown links: `[Model Conventions](./docs/MODELS.md)`
3. Verify referenced files exist
4. Generate recommendations to convert non-link references to markdown links
5. Output report with current vs improved format

**Verification:**
- Run: `node scripts/analyze-doc-refs.js`
- Expected: List of all doc references with their format
- Expected: Recommendations showing markdown link conversions
- Expected: Warnings for broken links (non-existent files)

**Self-Correction:**
- If pattern matching misses references: Expand regex patterns
- If link generation incorrect: Fix markdown link syntax
- If file existence checks fail: Handle relative path resolution

**Completion Criteria:**
- [x] Analyzer finds all documentation references
- [x] Analyzer detects reference format correctly
- [x] Analyzer generates proper markdown link recommendations

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 6: Implement Example Quality Analyzer

**Requirements:** Requirements 1.5, 2.5 (Examples in agents and commands)

**Implementation:**
1. Create `scripts/analyze-examples.js` (or `.py`)
2. Search for example sections in components
3. Check example quality:
   - Uses proper markdown code blocks with language hints
   - Has good/bad labels where appropriate
   - Examples are complete (not truncated)
   - Examples include comments where helpful
4. Flag missing examples in components that should have them
5. Output recommendations for example improvements

**Verification:**
- Run: `node scripts/analyze-examples.js`
- Expected: Report on example quality per component
- Expected: Flags for missing examples
- Expected: Recommendations for improvements

**Self-Correction:**
- If example detection fails: Refine section heading patterns
- If quality checks too strict: Adjust based on actual usage
- If recommendations unclear: Add specific improvement suggestions

**Completion Criteria:**
- [x] Analyzer finds example sections in components
- [x] Analyzer rates example quality accurately
- [x] Analyzer identifies components missing examples

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 7: Implement Redundancy Detector

**Requirements:** Requirement 5.1 (Identify overlapping functionality)

**Implementation:**
1. Create `scripts/detect-redundancies.js` (or `.py`)
2. Compare component descriptions for semantic similarity
3. Use keyword overlap and topic modeling to identify redundant components
4. Flag components with >60% similarity
5. Suggest consolidation or differentiation strategies
6. Output redundancy report with similarity scores

**Verification:**
- Run: `node scripts/detect-redundancies.js`
- Expected: Report showing component pairs with high similarity
- Expected: Similarity scores (0-100%)
- Known case: `test-builder` agent and `testing` skill should be flagged

**Self-Correction:**
- If similarity scoring inaccurate: Adjust algorithm or thresholds
- If false positives: Refine semantic comparison logic
- If misses obvious redundancies: Lower similarity threshold

**Completion Criteria:**
- [x] Detector compares all component pairs
- [x] Detector calculates similarity scores accurately
- [x] Detector flags known redundancies correctly

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 8: Implement Consistency Checker

**Requirements:** Requirement 5.2 (Detect inconsistencies in naming, formatting, structure)

**Implementation:**
1. Create `scripts/check-consistency.js` (or `.py`)
2. Check consistency across components:
   - Naming convention: kebab-case vs snake_case vs camelCase
   - Frontmatter format: field order, spacing, quotes
   - Writing style: imperative vs second person, use of "CRITICAL"
   - Example format: code block languages, good/bad labels
3. Output consistency report with violations and recommendations
4. Suggest standardization to most common pattern

**Verification:**
- Run: `node scripts/check-consistency.js`
- Expected: Report showing inconsistencies by category
- Expected: Count of violations per category
- Expected: Recommendations for standardization

**Self-Correction:**
- If detection misses inconsistencies: Add more checks
- If recommendations conflict: Prioritize most common pattern
- If false positives: Refine detection logic

**Completion Criteria:**
- [x] Checker detects naming convention inconsistencies
- [x] Checker detects formatting inconsistencies
- [x] Checker detects style inconsistencies

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 9: Implement Metadata Verifier

**Requirements:** Requirement 5.5 (Verify metadata accuracy)

**Implementation:**
1. Create `scripts/verify-metadata.js` (or `.py`)
2. Count actual components by type (using discovery script output)
3. Parse plugin.json and extract component counts from description
4. Compare actual vs declared counts
5. Verify MCP servers in plugin.json match references in components
6. Check version consistency across plugin.json, marketplace.json
7. Output verification report with discrepancies

**Verification:**
- Run: `node scripts/verify-metadata.js`
- Expected: Report showing actual vs declared counts
- Expected: Flags for any mismatches
- Expected: MCP server configuration verification

**Self-Correction:**
- If count extraction fails: Refine regex for description parsing
- If version comparison incorrect: Handle semver properly
- If MCP verification fails: Check both config and references

**Completion Criteria:**
- [x] Verifier counts actual components correctly
- [x] Verifier extracts declared counts from metadata
- [x] Verifier flags all discrepancies

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 10: Create Aggregated Analysis Report Generator

**Requirements:** Requirement 6 (Generate recommendations), 7 (Documentation and validation)

**Implementation:**
1. Create `scripts/generate-report.js` (or `.py`)
2. Aggregate outputs from all previous analysis scripts
3. Combine findings into structured report with:
   - Executive summary (total issues, high/medium/low priority)
   - Component-by-component analysis
   - Cross-component findings
   - Metadata verification results
   - Prioritized recommendations list
4. Output markdown report to `.agents/specs/plugin-optimization/analysis-report.md`
5. Generate separate `recommendations.md` with actionable items grouped by category

**Verification:**
- Run: `node scripts/generate-report.js`
- Expected: `analysis-report.md` created with all sections
- Expected: `recommendations.md` created with prioritized items
- Verify: Reports are readable markdown with proper formatting
- Verify: All previous analysis outputs are included

**Self-Correction:**
- If aggregation fails: Check input file formats from previous tasks
- If markdown formatting broken: Fix template generation
- If prioritization unclear: Add priority labels to each recommendation

**Completion Criteria:**
- [x] Report generator combines all analysis outputs
- [x] Reports are created with proper markdown formatting
- [x] Recommendations are prioritized and grouped

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 11: Create Master Analysis Runner Script

**Requirements:** All requirements - need to run complete analysis pipeline

**Implementation:**
1. Create `scripts/run-analysis.sh` (or `run-analysis.js`)
2. Execute all analysis scripts in order:
   - Component discovery
   - Metadata validation
   - Skill triggering analysis
   - MCP reference analysis
   - Documentation reference analysis
   - Example quality analysis
   - Redundancy detection
   - Consistency checking
   - Metadata verification
   - Report generation
3. Handle errors gracefully (continue on non-critical failures)
4. Output progress indicators
5. Final summary of analysis completion

**Verification:**
- Run: `bash scripts/run-analysis.sh` (or `node scripts/run-analysis.js`)
- Expected: All scripts execute in sequence
- Expected: Progress output shows each step
- Expected: Final reports generated successfully
- Verify: Can run on plugins/backend directory

**Self-Correction:**
- If script execution fails: Add error handling and logging
- If pipeline breaks mid-way: Implement checkpointing/resume
- If output unclear: Add verbose progress messages

**Completion Criteria:**
- [x] Master script runs all analysis scripts in order
- [x] Master script handles errors gracefully
- [x] Master script produces complete analysis output

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 12: Create Skill Description Improvement Template Generator

**Requirements:** Requirement 3.2, 3.6 (Skill description improvements)

**Implementation:**
1. Create `scripts/generate-skill-improvements.js` (or `.py`)
2. For each skill flagged with poor triggering:
   - Extract current description
   - Analyze skill content to identify key topics/use cases
   - Generate improved description using template:
     "This skill should be used when [scenario 1], [scenario 2], [scenario 3], or when the user asks '[keyword 1]', '[keyword 2]', '[keyword 3]'."
3. Output a patch file or edit suggestions for each skill
4. Include before/after comparison in output

**Verification:**
- Run: `node scripts/generate-skill-improvements.js`
- Expected: Improvement suggestions for each flagged skill
- Expected: Generated descriptions follow template format
- Expected: Descriptions include 3-5 specific trigger phrases
- Verify: Suggestions are actionable and realistic

**Self-Correction:**
- If generated descriptions too generic: Add more context from skill content
- If trigger phrases unclear: Extract from skill headings and examples
- If template formatting wrong: Fix string interpolation

**Completion Criteria:**
- [x] Generator creates improvement suggestions for flagged skills
- [x] Generated descriptions follow best practice template
- [x] Before/after comparisons are clear

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 13: Create MCP Reference Improvement Template Generator

**Requirements:** User's concern about #code_tools formatting, Requirement 1.4

**Implementation:**
1. Create `scripts/generate-mcp-improvements.js` (or `.py`)
2. For each unclear MCP reference:
   - Extract current reference context
   - Determine which MCP server and tools are referenced
   - Generate improved wording using template:
     "Use the [server_name] MCP server to [purpose]. The server provides: [list of tools with descriptions]"
3. Output edit suggestions with line numbers and improved text
4. Include before/after comparison

**Verification:**
- Run: `node scripts/generate-mcp-improvements.js`
- Expected: Improvement suggestions for unclear MCP references
- Expected: Generated text follows best practice template
- Expected: All MCP references become clear and actionable

**Self-Correction:**
- If tool descriptions missing: Use MCP server config from plugin.json
- If context unclear: Include more surrounding text in suggestion
- If template too verbose: Adjust based on component type (agent vs command)

**Completion Criteria:**
- [x] Generator creates improvement suggestions for MCP references
- [x] Generated text is clear and actionable
- [x] Before/after comparisons show clear improvement

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 14: Create Documentation Reference Converter

**Requirements:** User's concern about doc refs formatting

**Implementation:**
1. Create `scripts/convert-doc-refs.js` (or `.py`)
2. For each non-link documentation reference:
   - Extract file path and surrounding context
   - Determine descriptive link text from context or filename
   - Generate markdown link: `[link text](file path)`
   - Preserve surrounding text
3. Output edit suggestions with exact text replacement
4. Handle multiple references in same component

**Verification:**
- Run: `node scripts/convert-doc-refs.js`
- Expected: Edit suggestions for all non-link doc references
- Expected: Generated markdown links are properly formatted
- Verify: Link text is descriptive, not just filename
- Verify: File paths are correct and relative

**Self-Correction:**
- If link text too generic: Use better context analysis
- If markdown syntax wrong: Fix link generation template
- If paths incorrect: Verify relative path calculation

**Completion Criteria:**
- [x] Converter generates markdown links for all doc references
- [x] Link text is descriptive and contextual
- [x] Edit suggestions are accurate and complete

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 15: Write Automated Tests for Analysis Scripts

**Requirements:** Requirement 7.2 (Validation steps for improvements)

**Implementation:**
1. Create `tests/test-analysis-scripts.js` (or `.py` with pytest)
2. Write unit tests for each analysis script:
   - Test component discovery with sample files
   - Test metadata validation with good/bad examples
   - Test skill triggering analyzer with known inputs
   - Test MCP reference analyzer with various patterns
   - Test doc reference analyzer with different formats
   - Test report generation with mock data
3. Aim for >80% code coverage
4. Tests should run quickly (<10 seconds total)

**Verification:**
- Run tests: `npm test` or `pytest tests/`
- Expected: All tests pass
- Expected: Coverage report shows >80% coverage
- Verify: Tests catch known edge cases

**Self-Correction:**
- If tests fail: Fix script bugs or adjust test expectations
- If coverage low: Add tests for uncovered code paths
- If tests slow: Mock file I/O, use smaller test data

**Completion Criteria:**
- [x] All analysis scripts have unit tests
- [x] All tests pass
- [x] Code coverage >80%

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 16: Run Complete Analysis on Backend Plugin

**Requirements:** All requirements - validate entire analysis system

**Implementation:**
1. Run master analysis script on `plugins/backend/`
2. Review generated analysis report for accuracy
3. Verify all expected issues are caught:
   - Skill descriptions needing improvement
   - MCP references needing clarification
   - Doc references needing conversion
   - Metadata discrepancies
4. Spot-check specific findings against actual component files
5. Document any false positives or missed issues

**Verification:**
- Run: `bash scripts/run-analysis.sh plugins/backend`
- Expected: Complete analysis report generated
- Expected: Known issues are flagged (e.g., test-builder redundancy)
- Manual review: Check 5-10 findings for accuracy
- Verify: No script crashes or errors

**Self-Correction:**
- If analysis incomplete: Debug failing scripts
- If false positives found: Refine analysis logic and re-run
- If known issues missed: Adjust detection thresholds

**Completion Criteria:**
- [x] Complete analysis runs without errors
- [x] Report captures known issues accurately
- [x] Manual spot-check confirms findings are valid

**Escape Condition:** If stuck after 3 iterations, document blockers and move to next task.

---

## Task 17: Create Implementation Guide Documentation

**Requirements:** Requirement 7.1, 7.3 (Documentation of findings and results)

**Implementation:**
1. Create `.agents/specs/plugin-optimization/implementation-guide.md`
2. Document how to use the analysis scripts:
   - Installation/setup instructions
   - How to run analysis on a plugin
   - How to interpret the reports
   - How to apply the recommendations
3. Include examples of running scripts with expected output
4. Document common issues and troubleshooting steps
5. Provide guidelines for manual review of recommendations

**Verification:**
- File created: `.agents/specs/plugin-optimization/implementation-guide.md`
- Expected: Clear step-by-step instructions
- Expected: Examples with command output
- Test: Follow guide to run analysis on sample plugin
- Verify: Guide enables someone else to use the system

**Self-Correction:**
- If instructions unclear: Add more detail or examples
- If examples outdated: Update with actual script output
- If missing steps: Review analysis workflow and fill gaps

**Completion Criteria:**
- [x] Implementation guide created with all sections
- [x] Guide includes setup, usage, and troubleshooting
- [x] Guide is clear and actionable

**Escape Condition:** If stuck after 3 iterations, document blockers and stop.

---

## Task 18: Update CLAUDE.md with Analysis Best Practices

**Requirements:** Requirement 7.3 (Update relevant documentation)

**Implementation:**
1. Add section to `CLAUDE.md` about plugin quality analysis
2. Document when to run analysis (before adding components, before releases)
3. Reference the implementation guide created in Task 17
4. Add to "Key Learnings" section with insights from this project
5. Update any relevant checklists to include running analysis

**Verification:**
- Edit: `CLAUDE.md`
- Expected: New section on quality analysis added
- Expected: Links to implementation guide and reports
- Verify: Section fits existing CLAUDE.md structure and style
- Run: `git diff CLAUDE.md` to review changes

**Self-Correction:**
- If section placement awkward: Find better location in doc
- If content too verbose: Condense to key points with links
- If inconsistent style: Match existing CLAUDE.md tone and format

**Completion Criteria:**
- [x] CLAUDE.md updated with quality analysis section
- [x] Links to implementation guide added
- [x] Content matches existing documentation style

**Escape Condition:** If stuck after 3 iterations, document blockers and stop.

---

## Summary

This task list provides a complete implementation plan for the plugin optimization analysis system. Each task:

- ✅ Is self-contained and executable by a coding agent
- ✅ Includes specific file creation or modification
- ✅ Has automatic verification steps (run commands, check output)
- ✅ Includes self-correction loops for common failures
- ✅ Has clear completion criteria
- ✅ Has an escape condition to prevent infinite loops

The tasks build incrementally:
1. Tasks 1-6: Individual analysis components
2. Tasks 7-9: Cross-component analysis
3. Task 10-11: Aggregation and pipeline
4. Tasks 12-14: Improvement generators
5. Task 15: Testing
6. Task 16: End-to-end validation
7. Tasks 17-18: Documentation

Each task can be executed by Ralph Wiggum autonomously, with verification at every step.
