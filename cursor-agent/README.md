# Cursor Agent

Agent using [Cursor CLI](https://cursor.com) for Java framework migration.

## Skills

Migration skills are loaded from this agent's `skills/` directory. At runtime, `run.sh` copies the contents of this directory into `$WORK_DIR/.cursor/skills` so Cursor discovers them.

**Location:** `agents/cursor-agent/skills/`

Each skill should be a subdirectory with a `SKILL.md` file, e.g.:

```
skills/
└── spring-to-quarkus/
    └── SKILL.md
```

Cursor loads project skills from `.cursor/skills/` (or `.agents/skills/`). See [Cursor Agent Skills](https://cursor.com/docs/context/skills) for the full specification.
