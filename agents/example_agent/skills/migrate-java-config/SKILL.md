---
name: migrate-java-config
description: Migrate Java application configuration files between frameworks. Use when updating application.properties, application.yml, XML configs, or other framework-specific configuration.
---

When migrating configuration files:

## Files to Migrate
- `application.properties`, `application.yml`
- XML configuration files
- Framework-specific config formats

## Migration Steps
- Translate source framework configuration syntax to target framework format
- Update property names, namespaces, and structure as required
- Ensure all application settings are preserved and functional

## Validation
- Confirm configuration files parse correctly with the new framework
- Document config changes in `CHANGELOG.md`
