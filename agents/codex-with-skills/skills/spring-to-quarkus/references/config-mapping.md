# Configuration Mapping

Translate Spring keys to Quarkus keys while preserving runtime behavior.

## Server

- `server.port` -> `quarkus.http.port`
- `server.servlet.context-path` -> `quarkus.http.root-path`

## Datasource and JPA

- `spring.datasource.url` -> `quarkus.datasource.jdbc.url`
- `spring.datasource.username` -> `quarkus.datasource.username`
- `spring.datasource.password` -> `quarkus.datasource.password`
- `spring.datasource.driver-class-name` -> infer from selected Quarkus JDBC extension
- `spring.jpa.hibernate.ddl-auto` -> `quarkus.hibernate-orm.database.generation`
- `spring.jpa.show-sql` -> `quarkus.hibernate-orm.log.sql`

## Logging

- `logging.level.<package>` -> `quarkus.log.category."<package>".level`

## Profiles

- `spring.profiles.active` -> Quarkus profile selection (`%dev`, `%test`, `%prod` property prefixes and runtime profile selection)

## Notes

- Convert YAML to properties when needed for consistency with project conventions.
- Keep secrets externalized; do not hardcode credentials during migration.
