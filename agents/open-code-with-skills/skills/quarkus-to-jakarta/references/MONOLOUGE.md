# Verbose Intermediate Monologue and Artifact Capture Standard

This document defines how to record migration execution details as verbosely as possible.

## Goal

Ensure every migration run is fully auditable and replayable, including:

- all intermediate thinking/monologue steps
- all tool/command calls and inputs
- all raw outputs
- output interpretation
- explicit next-step decisions

## Required Output File (Single Flat Format)

For each migration run, create and maintain exactly one append-only artifact file:

- `migration-artifacts/MONOLOUGE.log.md`

Record all sections in this single file in strict chronological order unless correcting factual errors.

## 1) Session Metadata

Record at start:

- timestamp in ISO8601 UTC
- migration direction
- workspace root
- detected build system
- detected module layout
- key assumptions
- risk notes

## 2) Plan and Monologue

Record the complete evolving thought process for each step:

- what was inspected
- why the inspection was chosen
- expected outcomes
- alternatives considered
- confidence level before execution

For each monologue block, include:

- timestamp
- step id
- context summary
- intended action
- success criteria

## 3) Tool Call Logging

For every tool or shell call, log:

- timestamp
- tool/command name
- full input arguments
- working directory
- environment assumptions
- reason for the call
- expected output

No call should be omitted, including retries.

## 4) Raw Output Logging

Store complete output for every call:

- stdout (full)
- stderr (full)
- exit code
- truncation note if any limit was hit

If output is very large, keep it in the same file using clearly labeled fenced blocks and entry ids.

## 5) Interpretation and Decision Trace

After each output, add:

- what changed in understanding
- confirmed facts
- unresolved questions
- immediate next action
- why that action is safest/minimal

Every next step must be justified by the previous output.

## 6) Error and Recovery Trace

For each error, record:

- first observed timestamp
- failing file/symbol/module
- root cause hypothesis
- fix attempts in order
- result of each attempt
- final status: resolved, mitigated, or blocked

If blocked, include exact manual follow-up actions.

## 7) Replay Timeline

Build a final chronological timeline in the same file that can reconstruct the run end-to-end:

- step number
- action summary
- entry ids for tool call/output blocks
- decision made
- resulting state

A reviewer should be able to replay the migration from this timeline without additional context.

## Entry Template

Use this template for each action:

```
[Timestamp UTC] [Step X.Y] [Severity: info|warning|error]
Context:
Action:
Why:
Tool/Command:
Inputs:
Raw Output:
Interpretation:
Next Step:
```

## Verbosity Rules

- Prefer over-logging to under-logging.
- Do not summarize away important output details.
- Record failed attempts fully.
- Keep wording precise and operational.
- Ensure each entry has explicit cause-and-effect.

## Completion Criteria

The artifact set is complete only if the single flat file contains:

- every executed action has a corresponding tool-call and output record
- every output has interpretation and next-step linkage
- all errors include recovery history
- final replay timeline covers the entire run
