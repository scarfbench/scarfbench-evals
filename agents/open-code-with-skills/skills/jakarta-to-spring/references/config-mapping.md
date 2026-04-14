# Configuration Mapping

Translate OpenLiberty/Jakarta/MicroProfile configuration to Spring Boot while preserving behavior.

## Server

- OpenLiberty `httpEndpoint` port -> `server.port`
- OpenLiberty context-root settings -> `server.servlet.context-path`

## Datasource and JPA

- OpenLiberty datasource JDBC URL -> `spring.datasource.url`
- OpenLiberty datasource user -> `spring.datasource.username`
- OpenLiberty datasource password/variable -> `spring.datasource.password`
- JPA provider schema settings -> `spring.jpa.hibernate.ddl-auto`
- SQL logging settings -> `spring.jpa.show-sql` and logging categories

## Logging

- OpenLiberty trace/logging categories -> `logging.level.<package>`

## Profiles and Environment

- OpenLiberty server variables/env-specific configs -> Spring profiles (`spring.profiles.active`, profile files)
- `microprofile-config.properties` keys -> Spring property namespace equivalents where applicable

## Notes

- Preserve external secret management.
- Normalize config into `application.properties`/`application.yml` unless multi-source config is intentional.
