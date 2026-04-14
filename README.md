# Structuring Solutions for ScarfBench

This document describes how to structure an **agent implementation** so it can be executed by the `scarf` CLI during evaluation runs.

An *agent* is an opaque executable harness from Scarf’s point of view.

> **NOTE:** `scarf` does not interpret your code or prompts. It only knows how to run your agent (based on the `agent.toml` you have specified and the entrypoint contained within) and where results would go (based on the `--eval-out` flag).

---

## Agent Directory Structure
```
agents/<agent-name>/
├── agent.toml <-  REQUIRED 
├── run.sh     <-  OPTIONAL/RECOMMENDED wrapper script to wrap your agent's main executable (must be specified as the entrypoint in `agent.toml`)
└── README.md  <-  OPTIONAL (Documentation for your agent)
```

Some remarks on the structure:
1. `scarf` treats the agent implementation as opaque.
2. The only required contract is:
   - a metadata file (`agent.toml`)
   - an executable entrypoint (`run.sh`)
   - all other files are agent-defined, unconstrained, and private to your implementation.

## `agent.toml` file

The `agent.toml` file is a required configuration file that provides metadata about your agent. It should include the following fields:

### Fields

| Field | Required | Description |
|------|----------|-------------|
| `solution_name` | yes | Logical name of the agent / harness (e.g. `claude-code`, `codex-cli`). Used in run metadata, leaderboard, and reporting. |
| `model` | yes | LLM model identifier the agent uses (e.g. `claude-opus-4.6`, `gpt-5.3-codex`). |
| `description` | no | Short human description of the agent. |
| `entrypoint` | yes | Executable (relative to agent directory) used to run the agent. |
| `variant` | no | Optional discriminator when you submit multiple variants of the same agent + model (e.g. `with-skills`, `with-claude-md`). |

### Minimal example

```toml
solution_name = "claude-code"
model         = "claude-opus-4.6"
description   = "Claude code (with a monolith CLAUDE.md) for framework migration"
entrypoint    = "run.sh"
```

> **Note:** The `scarf` CLI will execute the entrypoint exactly as specified relative to the agent directory. For example, if your entrypoint is `run.sh`, `scarf` will execute `/path/to/agent-dir/example-agent/run.sh` when running your agent.

---

## `run.sh` — Agent Entrypoint

`run.sh` is the executable that `scarf` runs to execute your agent.

`scarf` sets the following environment variables before calling `run.sh`:
```bash
SCARF_WORK_DIR       # Output/work directory. Do not write outside this directory.
SCARF_FRAMEWORK_FROM # Source framework.
SCARF_FRAMEWORK_TO   # Target framework.
```

### Minimal example

This is a contrived example of what `run.sh` could look like for a simple Python-based agent. The script resolves the agent directory and then runs a Python module as the main process. The actual agent implementation can remain private; only a small public wrapper (`run.sh`) is required for `scarf` to call.

```bash
#!/usr/bin/env bash
set -euo pipefail

# Resolve agent directory
AGENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run the agent as a module
python3 -m your_agent
```

### Expectations from `run.sh`
- Must be executable (make sure you have run `chmod +x run.sh`)
- Must return:
  - exit code `0` on success
  - non-zero on failure
- Must only write application changes to the provided output directory (as specified by `scarf` via `$SCARF_WORK_DIR`).

---

## Writing a Codex-based agent (`agents/codex-cli`)

The `agents/codex-cli` folder in this repo is an example to get started with a ScarfBench agent powered by the `codex` CLI. A similar structure can be used for other LLM-based agents.

### 1) Recommended directory layout

```text
agents/codex-cli/
├── agent.toml
├── run.sh
└── skills/
    ├── spring-to-quarkus/
    │   └── SKILL.md
    ├── spring-to-jakarta/
    │   └── SKILL.md
    ├── quarkus-to-spring/
    │   └── SKILL.md
    ├── quarkus-to-jakarta/
    │   └── SKILL.md
    ├── jakarta-to-spring/
    │   └── SKILL.md
    └── jakarta-to-quarkus/
        └── SKILL.md
```

Each `SKILL.md` could contain migration instructions for exactly one conversion pair.

### 2) `agent.toml` for Codex

Use an entrypoint that points to your shell wrapper:

```toml
solution_name = "codex-cli"
model         = "gpt-5.2"
description   = "Sample implementation of a framework-migration agent for ScarfBench."
entrypoint    = "./run.sh"
variant       = "with-skills"
```

### 3) What `run.sh` should do

The `agents/codex-cli/run.sh` implementation follows a robust flow that you should copy for your own Codex-based agent:

1. Resolve script-local paths (for example, `skills/`).
2. Read required env vars:
   - `SCARF_WORK_DIR` (with optional fallback support if needed)
   - `SCARF_FRAMEWORK_FROM`
   - `SCARF_FRAMEWORK_TO`
3. Validate all required values and fail fast with clear stderr messages.
4. Normalize framework names (for example, map aliases like `springboot` -> `spring`).
5. Build the conversion key `${from}-to-${to}` and verify `skills/<pair>/SKILL.md` exists.
6. Verify the `codex` CLI is installed and available in `PATH`.
7. Prepare managed helper files inside `SCARF_WORK_DIR`:
   - Create a local `.agent/skills` symlink to the selected skill directory.
   - Create/update `AGENTS.md` so Codex can discover the active skill.
   - Backup any existing `AGENTS.md` and restore it on exit.
8. Run `codex exec` in headless mode against `SCARF_WORK_DIR` with a migration prompt.
9. Always clean up temporary links/files with a trap handler.

### 4) Example Codex invocation pattern

Use a workspace-restricted execution mode and set cwd to the scarf work directory:

```bash
codex -a never exec \
  --sandbox workspace-write \
  --skip-git-repo-check \
  -C "$SCARF_WORK_DIR" \
  "$PROMPT"
```

This keeps writes constrained to the evaluation workspace and makes execution deterministic for batch runs.

### 5) Best practices for Codex agents in ScarfBench

- Keep framework-specific logic in `skills/<pair>/SKILL.md`, not hardcoded into prompt strings.
- Keep `run.sh` focused on orchestration: validation, routing, setup, invocation, cleanup.
- Normalize aliases so scorer-provided framework names do not break pair resolution.
- Print concise diagnostics to stderr and use non-zero exits for invalid inputs.
- Ensure no writes happen outside `$SCARF_WORK_DIR`.
- Keep the public wrapper minimal; private internals can remain outside this repository.
