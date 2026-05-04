# Dependency Mapping

Use this as a starting point; verify against actual project behavior.

## Maven Baseline

- Remove OpenLiberty plugin/runtime dependencies from build/runtime path.
- Import Quarkus BOM and add `quarkus-maven-plugin`.
- Keep Jakarta APIs where Quarkus consumes the same standards.

## Common Dependency Replacements

- OpenLiberty/Jakarta REST runtime stack -> `io.quarkus:quarkus-rest-jackson` or `io.quarkus:quarkus-resteasy-jackson`
- Container-managed JPA runtime -> `io.quarkus:quarkus-hibernate-orm` + `io.quarkus:quarkus-jdbc-<driver>`
- Jakarta validation runtime -> `io.quarkus:quarkus-hibernate-validator`
- Jakarta security/container auth stack -> Quarkus security extensions per auth mechanism

## Notes

- Prefer Quarkus extensions over low-level dependency composition.
- Remove WAR/container deployment packaging assumptions if moving to Quarkus fast-jar/native model.
