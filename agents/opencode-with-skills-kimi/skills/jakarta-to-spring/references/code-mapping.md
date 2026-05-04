# Code Mapping

Use these mappings as defaults; adapt to project architecture.

## Injection and Scopes

- `@Inject` -> `@Autowired` (constructor injection preferred)
- `@ApplicationScoped` -> `@Service` / `@Component` / `@Repository` as appropriate
- CDI producers -> Spring `@Configuration` + `@Bean`

## Web Endpoints

- `@Path` -> `@RequestMapping`
- `@GET` -> `@GetMapping`
- `@POST` -> `@PostMapping`
- `@PUT` -> `@PutMapping`
- `@DELETE` -> `@DeleteMapping`
- `@PathParam` -> `@PathVariable`
- `@QueryParam` -> `@RequestParam`

## Transactions and Validation

- `jakarta.transaction.Transactional` -> `org.springframework.transaction.annotation.Transactional`
- `jakarta.validation.Valid` -> `jakarta.validation.Valid` (typically unchanged)

## Security and Context

- Jakarta Security/OpenLiberty auth integrations -> Spring Security config and filters.

## Bootstrapping

- Add `@SpringBootApplication` main entrypoint if absent.
- Replace container-driven bootstrap assumptions with Spring Boot application lifecycle.
