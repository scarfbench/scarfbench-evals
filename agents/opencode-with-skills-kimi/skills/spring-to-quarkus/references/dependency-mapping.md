# Dependency Mapping

Use this as a starting point; verify against actual project behavior.

## Maven Baseline

- Import Quarkus BOM in `<dependencyManagement>`.
- Replace `spring-boot-maven-plugin` with `quarkus-maven-plugin`.
- Keep test plugins and compiler plugins if compatible.

## Common Dependency Replacements

- `org.springframework.boot:spring-boot-starter-web` -> `io.quarkus:quarkus-resteasy-jackson` or `io.quarkus:quarkus-rest-jackson`
- `org.springframework.boot:spring-boot-starter-data-jpa` -> `io.quarkus:quarkus-hibernate-orm` and `io.quarkus:quarkus-jdbc-<driver>`
- `org.springframework.boot:spring-boot-starter-validation` -> `io.quarkus:quarkus-hibernate-validator`
- `org.springframework.boot:spring-boot-starter-security` -> `io.quarkus:quarkus-security` plus feature-specific extensions
- `org.springframework.boot:spring-boot-starter-test` -> `io.quarkus:quarkus-junit5`, `io.rest-assured:rest-assured`, and chosen mock/test libs
- `org.springframework.boot:spring-boot-devtools` -> remove (use Quarkus dev mode instead)

## Notes

- Prefer Quarkus extension artifacts over manually composing transitive stacks.
- If project is reactive, choose reactive Quarkus extensions consistently.
