# Gemini CLI Agent

Agent using [Gemini CLI](https://geminicli.com) for Java framework migration.

## Skills

Migration skills are loaded from this agent's `skills/` directory. At runtime, `run.sh` copies the contents of this directory into `$WORK_DIR/.gemini/skills` so Gemini discovers them.

**Location:** `agents/gemini-cli/skills/`

Each skill should be a subdirectory with a `SKILL.md` file, e.g.:

```
skills/
└── spring-to-quarkus/
    └── SKILL.md
```

See [Gemini CLI Agent Skills](https://geminicli.com/docs/cli/skills/) for the full specification.
