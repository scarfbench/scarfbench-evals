# Configuration Mapping

Translate Spring keys to Jakarta/OpenLiberty equivalents while preserving runtime behavior.

## Server

- `server.port` -> OpenLiberty `httpEndpoint` port in `server.xml`
- `server.servlet.context-path` -> OpenLiberty application context root configuration (server/app deployment descriptor)

## Datasource and JPA

- `spring.datasource.url` -> OpenLiberty datasource/JDBC config in `server.xml` (or external variables)
- `spring.datasource.username` -> OpenLiberty auth data in datasource config
- `spring.datasource.password` -> OpenLiberty auth data in datasource config/secure variable source
- `spring.jpa.hibernate.ddl-auto` -> JPA provider/OpenLiberty schema generation settings
- `spring.jpa.show-sql` -> JPA provider logging config / OpenLiberty trace settings

## Logging

- `logging.level.<package>` -> OpenLiberty logging/trace configuration for package level tuning

## Profiles and Environment

- `spring.profiles.active` -> OpenLiberty server variables / separate server config per environment
- Spring config files -> `microprofile-config.properties` or app properties following Jakarta conventions

## Notes

- Keep secrets externalized via OpenLiberty variables, not hardcoded.
- Split runtime server settings (`server.xml`) from app settings when possible.
