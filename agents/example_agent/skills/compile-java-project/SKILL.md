---
name: compile-java-project
description: Compile a Java project and verify the build. Use when testing migration success, running Maven or Gradle builds, or resolving compilation errors.
---

When compiling a Java project in a sandboxed environment:

## Build Commands
- **Maven:** `mvn -q -Dmaven.repo.local=.m2repo clean package`
- **Gradle:** `./gradlew -g .gradle clean build`

Use these commands when you only have write access to the working directory (no global Maven/Gradle cache).

## Compilation Workflow
1. Execute the appropriate build command
2. If compilation fails, capture full error messages and identify root causes
3. Apply fixes, document in `CHANGELOG.md`, and retry
4. Verify compilation succeeds before considering migration complete

## Validation
- Execute a test compilation after build script changes to ensure correctness
- Document any compilation errors with severity, context, and resolution in `CHANGELOG.md`
