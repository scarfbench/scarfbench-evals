# Dependency Mapping

Use this as a starting point; verify against actual project behavior.

## Maven Baseline

- Remove OpenLiberty runtime/plugin dependencies from active runtime path.
- Add Spring Boot dependency management and `spring-boot-maven-plugin`.
- Switch from container-managed assumptions to Spring Boot runtime packaging.

## Common Dependency Replacements

- `jakarta.ws.rs:jakarta.ws.rs-api` -> `org.springframework.boot:spring-boot-starter-web`
- `jakarta.persistence:jakarta.persistence-api` + container provider -> `org.springframework.boot:spring-boot-starter-data-jpa`
- `jakarta.validation:jakarta.validation-api` -> `org.springframework.boot:spring-boot-starter-validation`
- `jakarta.security.enterprise:jakarta.security.enterprise-api` -> `org.springframework.boot:spring-boot-starter-security`
- container-managed JSON/JAX-RS stack -> Spring MVC + Jackson via starter

## Notes

- Remove OpenLiberty-specific plugin blocks unless still needed for deployment target.
- Align driver and connection-pool dependencies with Spring Boot defaults.
