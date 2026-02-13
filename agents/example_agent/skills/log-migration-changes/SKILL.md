---
name: log-migration-changes
description: Document migration actions, decisions, and outcomes in CHANGELOG.md. Use when recording changes, validation results, or error resolutions during a Java framework migration.
---

When documenting migration changes:

## CHANGELOG.md Format
- Log every action, decision, and outcome in `CHANGELOG.md`
- Record timestamps in ISO8601 format (e.g. `[2025-11-05T14:32:10Z]`)
- Use severity levels: `[info]`, `[warning]`, `[error]`
- Include detailed descriptions, context, attempted fixes, and final resolutions
- If migration is incomplete, clearly note which steps failed and why

## Validation Protocol
After each major step or tool invocation:
1. **Check:** Verify the step achieved its intended effect
2. **Log:** Record the validation result in `CHANGELOG.md`
3. **Decide:** Proceed if successful; self-correct and retry if validation fails
4. **Document:** Log any corrective actions taken

## Output Format
When presenting the migration report, include:
- **Migration Summary:** Frameworks involved, high-level actions, overall outcome
- **File Tree:** Modified, added, and removed files with brief descriptions
- **Step-by-Step Log:** Chronological log with timestamps and severity
- **CHANGELOG.md Contents:** Complete changelog in a code block
