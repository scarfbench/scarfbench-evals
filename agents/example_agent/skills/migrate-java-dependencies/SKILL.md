---
name: migrate-java-dependencies
description: Migrate Java project dependencies from one framework to another. Use when updating pom.xml, build.gradle, or equivalent build files for a framework migration.
---

When migrating dependencies:

## Analysis
- Analyze `pom.xml`, `build.gradle`, or equivalent build files
- Identify all framework-specific dependencies

## Migration Steps
- Replace source framework dependencies with target framework equivalents
- Update dependency versions to stable, compatible releases
- Remove obsolete dependencies specific to the source framework
- Add any new dependencies required by the target framework

## Validation
- Verify dependency resolution succeeds before proceeding
- Document all dependency changes in `CHANGELOG.md`
