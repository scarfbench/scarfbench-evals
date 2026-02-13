---
name: handle-migration-errors
description: Handle and document errors during a Java framework migration. Use when encountering compilation failures, partial migrations, or any migration setbacks.
---

When handling migration errors:

## Error Documentation
- Every error must include: severity (`info`, `warning`, `error`), description, context, and resolution or mitigation strategy
- Capture full error messages for compilation failures
- Document root causes, attempted fixes, and final resolutions in `CHANGELOG.md`

## Partial Migration
- If unable to complete migration, document all incomplete steps with severity `error`
- Provide actionable recommendations for unresolved issues
- Clearly state if human review or manual intervention is needed

## Error Handling Section (for report)
If errors occurred, provide:
- **Error Summary:** Count and categorize errors by severity
- **Critical Issues:** Detail any blocking errors that prevented full migration
- **Mitigation Steps:** Actionable next steps or recommendations
- **Manual Intervention Required:** Clearly state if human review is needed
