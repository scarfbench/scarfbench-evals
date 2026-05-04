# Configuration Mapping

Translate Quarkus keys to Jakarta/OpenLiberty equivalents while preserving runtime behavior.

## Server

- `quarkus.http.port` -> OpenLiberty `httpEndpoint` port in `server.xml`
- `quarkus.http.root-path` -> OpenLiberty context root settings

## Datasource and JPA

- `quarkus.datasource.jdbc.url` -> OpenLiberty datasource JDBC config in `server.xml`
- `quarkus.datasource.username` -> OpenLiberty datasource credentials
- `quarkus.datasource.password` -> OpenLiberty datasource credentials/secure variables
- `quarkus.hibernate-orm.database.generation` -> Jakarta provider schema generation config
- `quarkus.hibernate-orm.log.sql` -> provider/OpenLiberty SQL logging settings

## Logging

- `quarkus.log.category."<package>".level` -> OpenLiberty package trace/logging configuration

## Profiles and Environment

- `%dev/%test/%prod` patterns -> OpenLiberty environment-specific server configs and variables

## Notes

- Place server/runtime concerns in `server.xml` and keep app-level config separate.
- Keep secrets externalized in environment or secure variable stores.
