# Code Mapping

Use these mappings as defaults; adapt to project architecture.

## Injection and Scopes

- `@Autowired` -> `@Inject`
- `@Component` / `@Service` / `@Repository` -> `@ApplicationScoped` (or narrower CDI scope)
- `@Configuration` + `@Bean` -> CDI producer methods/fields

## Web Endpoints

- `@RestController` -> `@Path` + `@Produces` + `@Consumes`
- `@RequestMapping` -> `@Path`
- `@GetMapping` -> `@GET`
- `@PostMapping` -> `@POST`
- `@PutMapping` -> `@PUT`
- `@DeleteMapping` -> `@DELETE`
- `@PathVariable` -> `@PathParam`
- `@RequestParam` -> `@QueryParam`
- `@RequestBody` -> JAX-RS method parameter with JSON binding

## Transactions and Validation

- `org.springframework.transaction.annotation.Transactional` -> `jakarta.transaction.Transactional`
- `@Valid` -> `jakarta.validation.Valid`

## Bootstrapping

- Remove `@SpringBootApplication` bootstrap.
- Use WAR/container deployment startup model for OpenLiberty.

## Data Access

- Spring Data repositories -> Jakarta persistence with injected `EntityManager` or CDI-based repositories.
- Choose one data access style consistently per module.
