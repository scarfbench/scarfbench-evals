# Code Mapping

Use these mappings as defaults; adapt to project architecture.

## Injection and Scopes

- `@Autowired` -> `@Inject`
- `@Component` / `@Service` / `@Repository` -> `@ApplicationScoped` (or narrower scope as needed)
- `@Configuration` + `@Bean` -> CDI producer methods/fields where required

## Web Endpoints

- `@RestController` -> `@Path` + `@Produces` + `@Consumes`
- `@RequestMapping` -> `@Path`
- `@GetMapping` -> `@GET`
- `@PostMapping` -> `@POST`
- `@PutMapping` -> `@PUT`
- `@DeleteMapping` -> `@DELETE`
- `@RequestBody` -> method parameter with JSON mapping
- `@PathVariable` -> `@PathParam`
- `@RequestParam` -> `@QueryParam`

## Transactions and Validation

- `org.springframework.transaction.annotation.Transactional` -> `jakarta.transaction.Transactional`
- `@Valid` generally remains `jakarta.validation.Valid` after import update

## Bootstrapping

- Remove `@SpringBootApplication` and Spring Boot main bootstrap assumptions.
- Keep a plain entrypoint only if required by project structure; otherwise follow Quarkus defaults.

## Data Access

- Spring Data repository abstractions may need replacement with:
  - Jakarta persistence + injected `EntityManager`
  - Quarkus Panache repositories/entities
- Choose one approach consistently per module.
