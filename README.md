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
	  - all other files are agent-defined and unconstrained are private to your agent implementation.

## `agent.toml` file

The `agent.toml` file is a required configuration file that provides metadata about your agent. It should include the following fields:

### Minimal example

```toml
name = "example-application-migrator-agent"
entrypoint = ["run.sh"]
```

### Fields

| Field | Required | Description |
|------|----------|-------------|
| `name` | yes | Logical name of the agent (used in run metadata and reporting) |
| `entrypoint` | yes | Command (relative to agent directory) used to run the agent |

> **Note:** The `scarf` CLI will execute the entrypoint exactly as specified relative to the agent directory. For example, if your entrypoint is `run.sh`, `scarf` will execute `/path/to/agent-dir/example-agent/run.sh` when running your agent.

---

## run.sh` — Agent Entrypoint

`run.sh` is the executable that `scarf` execute to run your agent.

`scarf` set these following flags before calling `run.sh`:
```bash
- ${SCARF_WORK_DIR}       -> You may assume the scarf cli sets this is the work dir for the agent to write outputs to. You should not write outside this directory.
- ${SCARF_FRAMEWORK_TO}
- ${SCARF_FRAMEWORK_FROM}
```

### Minimal example

THis is a contrived example of what `run.sh` could look like for a simple Python-based agent. The script resolves the agent's bin directory and then runs a Python module as the agent's main process. The actual agent is private, you are only required to can provide a tiny public wrapper called `run.sh` that `scarf` cli can call.

```bash
#!/usr/bin/env bash
set -euo pipefail

# Resolve agent bin directory
AGENT_BIN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run the agent as a module
python3 -m your_agent.py
```

### Expectations from `run.sh`
- Must be executable (make sure you have run `chmod +x run.sh`)
- Must return:
  - exit code `0` on success
  - non-zero on failure
- Must only write application changes to the provided output directory (as specified by scarf `$SCARF_WORK_DIR`).

