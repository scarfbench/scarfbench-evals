---
name: migrate-jakarta-to-spring
description: Migrate Java applications from Jakarta EE on OpenLiberty to Spring Boot/Spring Framework with one-shot execution. Use when converting Jakarta EE/OpenLiberty services to Spring, modernizing Jakarta services into Spring Boot architecture, or when asked to perform Jakarta-to-Spring dependency, configuration, annotation, and build migration with compile validation and migration logging.
---

# Jakarta to Spring Migration (from OpenLiberty)

Execute the migration autonomously in one run. Do not ask follow-up questions unless blocked by missing or unreadable files.

## Operating Contract

Follow these constraints for every run:

- Work only inside the provided project root.
- Prioritize successful compilation over stylistic refactors.
- Preserve business behavior while replacing framework integrations.
- Assume source runtime conventions are OpenLiberty when interpreting Jakarta configuration and packaging.
- Keep a chronological migration log in `migration-artifacts/MONOLOUGE.log.md` with ISO8601 UTC timestamps and severity levels: `info`, `warning`, `error`.
- Persist verbose intermediate artifacts under `migration-artifacts/` for every step, including: thinking/reasoning notes, every tool/command call with inputs, raw tool outputs, interpretation of outputs, and explicit next-step decisions.

## Required Workflow

Run these steps in order and log each step outcome in `migration-artifacts/MONOLOUGE.log.md`.

1. Inspect project structure.
2. Detect build system and framework usage.
3. Migrate dependencies and plugins.
4. Migrate framework configuration.
5. Refactor framework-bound source code.
6. Compile and fix errors until build succeeds or no safe fix remains.
7. Produce a final migration report including file changes, chronological log, full `migration-artifacts/MONOLOUGE.log.md`, and unresolved issues.

## Step 1: Inspect Project Structure

- Identify build files (`pom.xml`, `build.gradle`, `settings.gradle`, wrappers).
- Detect module layout (single module vs multi-module).
- Enumerate framework-bound entrypoints and layers:
  - JAX-RS resources
  - CDI beans/producers
  - Jakarta Persistence entities/repositories
  - Jakarta Security/OpenLiberty auth config
  - OpenLiberty runtime config (`server.xml`, variables)
- Record findings in `migration-artifacts/MONOLOUGE.log.md`.

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

- Replace Jakarta/OpenLiberty runtime dependencies with Spring Boot starters and Spring plugin/tooling.
- Remove OpenLiberty Maven/Gradle plugin configuration not needed by Spring runtime.
- Add Spring Boot plugin and executable jar/war packaging as required.
- Keep non-framework libraries unless incompatible.

For common mappings, read:

- `references/dependency-mapping.md`

Validation:

- Resolve dependencies by running a compile/package command before code refactors when feasible.
- If this early build fails due to known source incompatibility, continue and log why.

## Step 4: Migrate Configuration

- Convert OpenLiberty/Jakarta/MicroProfile keys and conventions to Spring equivalents.
- Preserve ports, datasource settings, profile intent, and feature flags.
- Move or translate runtime server settings from OpenLiberty config into Spring Boot conventions.
- Keep final config in `src/main/resources/application.properties` or `application.yml` per project conventions.

For common property mappings, read:

- `references/config-mapping.md`

Validation:

- Re-check configuration syntax and required values before compile.

## Step 5: Refactor Source Code

- Replace CDI/JAX-RS/Jakarta annotations/imports with Spring equivalents.
- Replace CDI injection and producer patterns with Spring DI idioms.
- Replace JAX-RS resources with Spring MVC/REST controllers.
- Replace Jakarta transactions/validation/security APIs with Spring equivalents where needed.
- Add Spring Boot bootstrap entrypoint when required by project structure.

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

For monologue and intermediate artifact capture requirements, read:

- `references/MONOLOUGE.md`

- `migration-artifacts/MONOLOUGE.log.md` is the only required migration log file and single source of truth.

`migration-artifacts/MONOLOUGE.log.md` format:

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
4. `MONOLOUGE.log.md Contents` full file in fenced code block
5. `Error Handling` with counts, blockers, mitigations, and manual intervention flag

## Execution Policy

- Do not stop at partial edits when a safe next fix exists.
- Do not claim success without a compile attempt.
- If full migration is not possible, provide precise blockers and next actions.
