# AGENTS.md

This file is the entrypoint for any coding agent (Codex, Claude Code, etc.) working in this repo.
It defines what to load, in what order, and what quality gates must be satisfied before claiming
work is complete.

## Prime Directive: One Task Per Context

Treat the context window like a fixed-size allocation: once you mix tasks, you lose coherence.

Rules:

1. One task per context window. If scope changes, start a fresh session.
2. When you notice drift (conflicting goals, repeating mistakes, inventing APIs), stop and restart.
3. Each loop must re-load the same stable stack (specs + rules) deterministically.

## Required Load Order (Every Session)

Load these documents in order before doing any implementation work:

1. `AGENTS.md` (this file)
2. `SPECS.md` (spec index)
3. The specific spec(s) that govern the task in `specs/`
4. The relevant operational rules in `rules/`

If you are unsure which spec applies, read `specs/00-vision-and-non-goals.md` first.

## Where Truth Lives

1. Requirements and intended behavior live in `specs/`.
2. Operational constraints (how we work, how to verify, how to avoid repeated failure modes)
   live in `rules/`.
3. Deep rationale and history live in `docs/` and `DEVELOPMENT-LOG.md`.

If there is a conflict:

1. Specs override rules.
2. Rules override ad-hoc agent behavior.
3. If the specs are ambiguous, update the specs (do not invent behavior).

## Backpressure (Verification Gates)

Verification commands are defined in `rules/02-verification.md`. That file is the single source
of truth for how to format, test, and lint this project.

Do not claim "done" unless you have fresh evidence from the relevant command(s) for the change.

## TDD Policy

When feasible:

1. Write a failing test that demonstrates the required behavior (RED).
2. Implement the minimum to pass (GREEN).
3. Refactor while keeping tests green (REFACTOR).

Exceptions are allowed only for:

1. Pure formatting changes.
2. Pure documentation changes.
3. Configuration-only changes where tests are not meaningful (but verification is still required).

## Codifying Learnings (Build Your Stdlib)

When a failure mode repeats or an agent needs steering:

1. Fix the immediate issue.
2. Encode the lesson so it does not recur:
   - If it's a behavior requirement: update/add a spec in `specs/` and link it from `SPECS.md`.
   - If it's a process constraint: update/add a rule in `rules/`.

Goal: make the correct outcome the path of least resistance.

## Do Not Read

`HUMAN.md` is for humans operating the harness. It contains no agent-relevant information.
Do not read it or load it into context.

## Loop Files

This repo is designed to be run in a deterministic loop:

1. `PROMPT.md` is the loop prompt.
2. `fix_plan.md` is the single prioritized queue.
