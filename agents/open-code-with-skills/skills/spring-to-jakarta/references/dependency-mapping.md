# Dependency Mapping

Use this as a starting point; verify against actual project behavior.

## Maven Baseline

- Remove Spring Boot dependency management and plugin assumptions.
- Add Jakarta API coordinates with `provided` scope where container supplies implementations.
- Add OpenLiberty runtime/plugin setup (for example `io.openliberty.tools:liberty-maven-plugin`) when needed.
- Prefer WAR packaging for container deployment unless project requires alternate packaging.

## Common Dependency Replacements

- `org.springframework.boot:spring-boot-starter-web` -> `jakarta.ws.rs:jakarta.ws.rs-api`, `jakarta.servlet:jakarta.servlet-api` (provided)
- `org.springframework.boot:spring-boot-starter-data-jpa` -> `jakarta.persistence:jakarta.persistence-api` + chosen JPA provider/runtime integration for OpenLiberty
- `org.springframework.boot:spring-boot-starter-validation` -> `jakarta.validation:jakarta.validation-api`
- `org.springframework.boot:spring-boot-starter-security` -> `jakarta.security.enterprise:jakarta.security.enterprise-api` and/or OpenLiberty security features
- `org.springframework.boot:spring-boot-starter-test` -> JUnit/Jakarta-compatible test stack chosen by project
- `org.springframework.boot:spring-boot-devtools` -> remove

## Notes

- Keep implementation dependencies aligned with OpenLiberty feature set.
- Avoid bundling server-provided Jakarta APIs into the deployment artifact.
