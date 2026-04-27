# Configuration Mapping

Translate OpenLiberty/Jakarta/MicroProfile keys to Quarkus while preserving runtime behavior.

## Server

- OpenLiberty `httpEndpoint` port -> `quarkus.http.port`
- OpenLiberty context-root settings -> `quarkus.http.root-path`

## Datasource and JPA

- OpenLiberty datasource JDBC URL -> `quarkus.datasource.jdbc.url`
- OpenLiberty datasource user -> `quarkus.datasource.username`
- OpenLiberty datasource password -> `quarkus.datasource.password`
- JPA schema generation settings -> `quarkus.hibernate-orm.database.generation`
- SQL logging settings -> `quarkus.hibernate-orm.log.sql`

## Logging

- OpenLiberty package trace/log levels -> `quarkus.log.category."<package>".level`

## Profiles and Environment

- OpenLiberty environment-specific server configs -> Quarkus `%dev/%test/%prod` profile properties
- `microprofile-config.properties` keys -> Quarkus/MicroProfile property equivalents

## Notes

- Consolidate runtime-relevant app settings into `application.properties` when possible.
- Keep secrets externalized.
