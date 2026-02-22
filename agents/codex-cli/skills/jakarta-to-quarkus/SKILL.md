---
name: migrate-jakarta-to-quarkus
description: Migrate Java applications from Jakarta EE on OpenLiberty to Quarkus with one-shot execution. Use when converting Jakarta EE/OpenLiberty services to Quarkus, modernizing standards-based Java services to Quarkus extensions, or when asked to perform Jakarta-to-Quarkus dependency, configuration, annotation, and build migration with compile validation and migration logging.
---

# Jakarta to Quarkus Migration (from OpenLiberty)

Execute the migration autonomously in one run. Do not ask follow-up questions unless blocked by missing or unreadable files.

## Operating Contract

Follow these constraints for every run:

- Work only inside the provided project root.
- Prioritize successful compilation over stylistic refactors.
- Preserve business behavior while replacing framework integrations.
- Assume source runtime conventions are OpenLiberty when interpreting Jakarta configuration and packaging.
- Keep a chronological migration log in `CHANGELOG.md` with ISO8601 UTC timestamps and severity levels: `info`, `warning`, `error`.

## Required Workflow

Run these steps in order and log each step outcome in `CHANGELOG.md`.

1. Inspect project structure.
2. Detect build system and framework usage.
3. Migrate dependencies and plugins.
4. Migrate framework configuration.
5. Refactor framework-bound source code.
6. Compile and fix errors until build succeeds or no safe fix remains.
7. Produce a final migration report including file changes, chronological log, full `CHANGELOG.md`, and unresolved issues.

## Step 1: Inspect Project Structure

- Identify build files (`pom.xml`, `build.gradle`, `settings.gradle`, wrappers).
- Detect module layout (single module vs multi-module).
- Enumerate framework-bound entrypoints and layers:
  - JAX-RS resources
  - CDI beans/producers
  - Jakarta Persistence entities/repositories
  - OpenLiberty runtime config (`server.xml`, variables)
- Record findings in `CHANGELOG.md`.

## Step 2: Detect Migration Scope

- Locate Jakarta/OpenLiberty dependencies and plugins in build files.
- Locate runtime and application configuration in:
  - `server.xml`
  - `bootstrap.properties`
  - `microprofile-config.properties`
  - application properties/YAML
- Locate Jakarta API imports and annotations in Java/Kotlin sources.
- Use targeted search (`rg`) and log counts/locations.

## Step 3: Migrate Dependencies and Build

- Replace Jakarta/OpenLiberty runtime dependencies with Quarkus BOM/extensions.
- Remove OpenLiberty plugin and packaging assumptions.
- Add Quarkus build plugin and compiler settings as needed.
- Keep non-framework libraries unless incompatible.

For common mappings, read:

- `references/dependency-mapping.md`

Validation:

- Resolve dependencies by running a compile/package command before code refactors when feasible.
- If this early build fails due to known source incompatibility, continue and log why.

## Step 4: Migrate Configuration

- Convert OpenLiberty/Jakarta/MicroProfile keys and conventions to Quarkus equivalents.
- Preserve ports, datasource settings, profile intent, and feature flags.
- Migrate runtime-oriented server settings from OpenLiberty config into Quarkus properties where possible.
- Keep final config in `src/main/resources/application.properties` unless project conventions require otherwise.

For common property mappings, read:

- `references/config-mapping.md`

Validation:

- Re-check configuration syntax and required values before compile.

## Step 5: Refactor Source Code

- Keep Jakarta APIs where already compatible with Quarkus runtime.
- Replace OpenLiberty-specific bootstrapping/runtime patterns with Quarkus conventions.
- Replace framework-specific integrations with Quarkus extensions where needed.
- Normalize injection, transactions, and validation to Quarkus-compatible Jakarta usage.

For common annotation and API mappings, read:

- `references/code-mapping.md`

Validation:

- After significant refactors, run a compile/build.
- Fix compile errors in small batches and log each resolution.

## Step 6: Compile and Iterate

Use commands that write local caches to project-local directories:

- Maven: `mvn -q -Dmaven.repo.local=.m2repo clean package`
- Gradle: `./gradlew -g .gradle clean build`

If build fails:

- Capture the exact failing symbols/classes/modules.
- Apply minimal, safe fix.
- Rebuild and repeat.
- If blocked, record clear mitigation steps for manual follow-up.

## Step 7: Logging and Report Requirements

`CHANGELOG.md` format:

- Use one entry per action or corrective step.
- Include timestamp, severity, title, and details.
- For errors include:
  - failing file/area
  - root cause
  - attempted fix
  - final outcome

Final response format:

1. `Migration Summary`
2. `File Tree` with modified/added/removed files and short purpose notes
3. `Step-by-Step Log` in chronological order
4. `CHANGELOG.md Contents` full file in fenced code block
5. `Error Handling` with counts, blockers, mitigations, and manual intervention flag

## Execution Policy

- Do not stop at partial edits when a safe next fix exists.
- Do not claim success without a compile attempt.
- If full migration is not possible, provide precise blockers and next actions.
