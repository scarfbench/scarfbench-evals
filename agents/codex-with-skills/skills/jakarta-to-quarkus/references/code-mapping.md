# Code Mapping

Use these mappings as defaults; adapt to project architecture.

## Injection and Scopes

- `@Inject` remains `@Inject`
- `@ApplicationScoped` remains `@ApplicationScoped`
- CDI producers generally remain valid; adjust only for Quarkus extension constraints

## Web Endpoints

- JAX-RS annotations usually remain unchanged (`@Path`, `@GET`, `@POST`, etc.)
- Replace only OpenLiberty-specific endpoint/runtime hooks with Quarkus-compatible patterns

## Transactions and Validation

- `jakarta.transaction.Transactional` remains valid
- `jakarta.validation.Valid` remains valid

## Bootstrapping and Runtime

- Remove OpenLiberty container/bootstrap assumptions.
- Follow Quarkus application startup and extension configuration patterns.

## Data Access

- Jakarta persistence code can remain; optionally adopt Panache where safe and consistent.
- Keep data access style consistent within each module.
