# Configuration Mapping

Translate Quarkus keys to Spring Boot while preserving runtime behavior.

## Server

- `quarkus.http.port` -> `server.port`
- `quarkus.http.root-path` -> `server.servlet.context-path`

## Datasource and JPA

- `quarkus.datasource.jdbc.url` -> `spring.datasource.url`
- `quarkus.datasource.username` -> `spring.datasource.username`
- `quarkus.datasource.password` -> `spring.datasource.password`
- `quarkus.hibernate-orm.database.generation` -> `spring.jpa.hibernate.ddl-auto`
- `quarkus.hibernate-orm.log.sql` -> `spring.jpa.show-sql`

## Logging

- `quarkus.log.category."<package>".level` -> `logging.level.<package>`

## Profiles

- `%dev/%test/%prod` properties -> Spring profile-specific properties and `spring.profiles.active`

## Notes

- Remove Quarkus-only configuration sections after migration.
- Keep secrets externalized.
