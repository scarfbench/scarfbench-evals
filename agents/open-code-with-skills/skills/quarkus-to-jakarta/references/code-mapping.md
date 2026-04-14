# Code Mapping

Use these mappings as defaults; adapt to project architecture.

## Injection and Scopes

- `@Inject` remains `@Inject`
- `@ApplicationScoped` remains `@ApplicationScoped`
- Remove Quarkus-only CDI/lifecycle conveniences where not portable

## Web Endpoints

- JAX-RS annotations usually remain valid (`@Path`, `@GET`, `@POST`, etc.)
- Replace Quarkus-specific endpoint/runtime helpers with portable Jakarta patterns

## Transactions and Validation

- `jakarta.transaction.Transactional` remains valid
- `jakarta.validation.Valid` remains valid

## Quarkus-Specific APIs

- Panache repositories/entities -> portable Jakarta persistence with `EntityManager` or standard repository abstractions.
- Quarkus config/runtime annotations -> standard Jakarta/MicroProfile/OpenLiberty-compatible alternatives.

## Bootstrapping

- Remove Quarkus runtime bootstrap assumptions.
- Ensure application packaging and startup match OpenLiberty deployment model.
