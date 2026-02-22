# Dependency Mapping

Use this as a starting point; verify against actual project behavior.

## Maven Baseline

- Remove Quarkus BOM and `quarkus-maven-plugin`.
- Add Jakarta API dependencies and OpenLiberty runtime/plugin configuration.
- Prefer WAR/container deployment packaging for OpenLiberty unless project requires alternative packaging.

## Common Dependency Replacements

- `io.quarkus:quarkus-rest-jackson` / `io.quarkus:quarkus-resteasy-jackson` -> `jakarta.ws.rs:jakarta.ws.rs-api` + container JSON provider/runtime
- `io.quarkus:quarkus-hibernate-orm` -> `jakarta.persistence:jakarta.persistence-api` + provider/runtime integration
- `io.quarkus:quarkus-hibernate-validator` -> `jakarta.validation:jakarta.validation-api`
- Quarkus security extensions -> `jakarta.security.enterprise:jakarta.security.enterprise-api` and OpenLiberty security features

## Notes

- Add `io.openliberty.tools:liberty-maven-plugin` where build/deploy flow expects it.
- Avoid packaging APIs already provided by OpenLiberty runtime.
