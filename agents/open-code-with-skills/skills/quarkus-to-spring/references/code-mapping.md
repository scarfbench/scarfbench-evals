# Code Mapping

Use these mappings as defaults; adapt to project architecture.

## Injection and Scopes

- `@Inject` -> `@Autowired` (constructor injection preferred)
- `@ApplicationScoped` -> `@Service` / `@Component` / `@Repository`
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
- `jakarta.validation.Valid` generally remains unchanged

## Quarkus-Specific APIs

- Panache repositories/entities -> Spring Data repositories + JPA entities or explicit repository/service classes.
- Quarkus lifecycle hooks/config APIs -> Spring lifecycle/configuration equivalents.

## Bootstrapping

- Add `@SpringBootApplication` main class if absent.
