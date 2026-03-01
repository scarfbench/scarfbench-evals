# Claude Code Agent

Agent using [Claude Code](https://code.claude.com) (Agent SDK CLI) for Java framework migration.

## Skills

Migration skills are loaded from this agent's `skills/` directory. At runtime, `run.sh` copies the contents of this directory into `$WORK_DIR/.claude/skills` so Claude discovers them.

**Location:** `agents/claude-code/skills/`

Each skill should be a subdirectory with a `SKILL.md` file, e.g.:

```
skills/
└── spring-to-quarkus/
    └── SKILL.md
```

Claude Code loads project skills from `.claude/skills/<skill-name>/SKILL.md`. See [Claude Code Skills](https://code.claude.com/docs/en/skills) for the full specification.
