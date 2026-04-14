# Dependency Mapping

Use this as a starting point; verify against actual project behavior.

## Maven Baseline

- Remove Quarkus BOM and `quarkus-maven-plugin`.
- Add Spring Boot dependency management and `spring-boot-maven-plugin`.
- Replace Quarkus extension artifacts with Spring Boot starters.

## Common Dependency Replacements

- `io.quarkus:quarkus-rest-jackson` / `io.quarkus:quarkus-resteasy-jackson` -> `org.springframework.boot:spring-boot-starter-web`
- `io.quarkus:quarkus-hibernate-orm` + `io.quarkus:quarkus-jdbc-<driver>` -> `org.springframework.boot:spring-boot-starter-data-jpa`
- `io.quarkus:quarkus-hibernate-validator` -> `org.springframework.boot:spring-boot-starter-validation`
- Quarkus security extensions -> `org.springframework.boot:spring-boot-starter-security` + mechanism-specific libraries
- `io.quarkus:quarkus-junit5` -> `org.springframework.boot:spring-boot-starter-test`

## Notes

- Remove Quarkus-specific test/dev tooling unless explicitly retained.
- Align dependency versions through Spring Boot BOM.
