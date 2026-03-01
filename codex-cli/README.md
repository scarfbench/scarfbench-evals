# Codex CLI Agent

Agent using [Codex](https://code.claude.com) CLI for Java framework migration.

## Skills

Migration skills are loaded from this agent's `skills/` directory. At runtime, `run.sh` copies the contents of this directory into `$WORK_DIR/.agents/skills` so Codex discovers them.

**Location:** `agents/codex-cli/skills/`

Each skill should be a subdirectory with a `SKILL.md` file, e.g.:

```
skills/
└── spring-to-quarkus/
    └── SKILL.md
```

Codex scans `.agents/skills` from the current working directory. See [Codex Skills](https://developers.openai.com/codex/skills/) for the full specification.
