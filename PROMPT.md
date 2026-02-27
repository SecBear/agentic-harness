# Agent Task (Ralph Loop)

You are an autonomous coding agent operating in this repository.

## Load Stack (Do This First, Every Loop)

1. Read `AGENTS.md` (operating instructions).
2. Read `SPECS.md` (spec index).
3. Read `fix_plan.md` (work queue).
4. Read the spec(s) linked from the top unchecked item in `fix_plan.md`.
5. Read any relevant files in `rules/` (process constraints).

## Context Hygiene

1. One task per context window.
2. Choose exactly one unchecked item from `fix_plan.md`. Only one.
3. If you drift (multiple tasks, inventing APIs, repeating mistakes), stop and restart a fresh loop.

## Execution (Single Item)

1. Search the codebase before assuming something is missing.
2. Pick the top unchecked (`[ ]`) item from `fix_plan.md`.
3. Read the spec(s) it links to. The spec defines what to build and what invariants must hold.
4. Implement it with TDD when behavior is changing:
   - write a failing test
   - implement minimal code
   - refactor after green
5. Run the verification commands defined in `rules/02-verification.md`.
6. If verification fails, fix it before moving on.
7. Commit. Use a conventional commit title.
8. Mark the item `[x]` in `fix_plan.md`.
9. Mark the corresponding spec Status item `[x]` if it is now satisfied.
10. If implementation revealed follow-up work, add new `[ ]` items to `fix_plan.md` at the
    appropriate priority position. Link each to its governing spec.
11. Commit the `fix_plan.md` and spec updates.

## Queue Empty — Refill From Specs

When all items in `fix_plan.md` are `[x]` (or the queue is empty), check the specs:

1. Read every spec in `specs/`.
2. Collect all `[ ]` items from their Status sections.
3. If there are unchecked spec items:
   - Turn them into new `fix_plan.md` entries (title, spec link, done-when, verification command).
   - Order by dependency then priority.
   - Commit the updated `fix_plan.md`.
   - Continue implementing (go back to Execution).
4. If all spec Status items are `[x]`, the specs are fully implemented. Stop and print a
   completion summary (see below).

This is not planning new work. The specs already define what needs to be built. You are
continuing to execute them.

## All Specs Satisfied — Stop

When every Status item across all specs is `[x]`, stop and print a summary for the person
running the loop:

```
== Specs Complete ==

What was built:
- <item title> (spec: specs/NN-name.md)
  <one sentence describing what was built/changed>
- ...

Commits:
- <hash> <title>
- ...

All spec Status items are satisfied. To add more work, add [ ] items to specs and re-run.
```

This summary is for a human who may not know the project internals. Be specific about what
changed and where to look.

## Do Not

1. Do not start multiple work items in the same loop.
2. Do not introduce opinionated workflow DSLs.
3. Do not add new public surface area without updating specs.
4. Do not implement something that contradicts a spec. If the spec is wrong, update the spec first.
5. Do not invent new requirements. Only implement what the specs define.
6. Do not invoke superpowers skills (brainstorming, TDD, debugging, writing-plans, etc.) during
   the Ralph loop. This loop has its own TDD, verification, and commit discipline defined in
   `rules/`. Superpowers skills are for interactive sessions, not the autonomous loop.

## Invocation (Human Runs This)

Default (Claude Code):

```bash
cat PROMPT.md | claude-code
```

Codex:

```bash
cat PROMPT.md | codex
```

Pure loop (supervised):

```bash
while :; do cat PROMPT.md | claude-code; done
```
