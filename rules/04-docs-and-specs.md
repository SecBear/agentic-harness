# Specs Vs Rules Vs Docs

Use the right mechanism for the right kind of truth.

## Specs (`specs/`)

Specs are durable product and technical requirements.

Use specs when:

1. You are defining behavior, semantics, or public API constraints.
2. You want to prevent silent drift across refactors.
3. You need to communicate "what must be true" to future contributors and agents.

### Spec Format

Every spec must have:

1. **Content sections** — the actual requirements, organized by domain topic.
2. **A Status section** — a checkbox list tracking what is implemented and what is not.

Example:

```markdown
# Authentication

## Requirements

Users authenticate via API key passed in the Authorization header. Keys are scoped to a single
project. Invalid or expired keys return 401.

## Status

- [x] API key validation middleware
- [x] Project-scoped key lookup
- [ ] Key expiration and rotation
- [ ] Rate limiting per key
```

Each status item must be concrete and testable. "Authentication works" is not a status item.
"API key validation middleware" is.

When an agent completes work that satisfies a status item, it marks the checkbox `[x]` in the
spec and commits the update.

### Authoring Specs

When working with a human to write or revise specs:

1. Ask what the project should do. Listen for concrete behaviors, not abstractions.
2. Organize into domain-topic files (one spec per domain, e.g. `specs/01-auth.md`,
   `specs/02-api.md`).
3. Write requirements as clear, testable statements.
4. Add a Status section. Mark `[x]` for things that already exist and work. Mark `[ ]` for
   things that need to be built.
5. Update `SPECS.md` with the new spec.
6. When the human is satisfied with the specs, populate `fix_plan.md` from the `[ ]` items
   (see Populating The Queue below).

### Populating The Queue

After specs are written or revised, turn `[ ]` status items into `fix_plan.md` entries:

1. Collect all `[ ]` items across all specs.
2. For each item (or group of related items), create a fix_plan entry with:
   - A clear title
   - A link to the governing spec
   - "Done when" criteria (observable, testable)
   - A verification command from `rules/02-verification.md`
3. Order by dependency first (foundation before things that depend on it), then priority.
4. Show the proposed queue to the human. Adjust before writing.

Keep items small enough for one loop iteration. Split large items if needed.

### Spec Rules

1. Each spec is a separate domain topic file.
2. Update `SPECS.md` when adding a new spec.
3. If a spec item is ambiguous, clarify the spec before implementing.

## Rules (`rules/`)

Rules are operational constraints and repeated steering lessons.

Use rules when:

1. A failure mode keeps recurring.
2. You want deterministic "how to work here" guidance for agents.
3. You need verification discipline and context hygiene.

Rules should be small and composable. Avoid giant omnibus documents.

## Loop (`PROMPT.md` + `fix_plan.md`)

The loop is how we operationalize specs and rules:

1. `PROMPT.md` is the deterministic instruction set for each iteration.
2. `fix_plan.md` is the single queue of prioritized work items.
3. fix_plan items link back to specs. Specs track implementation status.

The flow: specs define what → fix_plan decomposes into work items → loop implements one at a time
→ agent marks spec status items `[x]` as they are satisfied.

## Docs (`docs/`)

Docs are explanations, rationale, and teaching materials. They are not requirements by default.

Use docs when:

1. You are explaining why a decision exists.
2. You are providing tutorials or walkthroughs.
3. You are recording research or analysis.

If a doc contains a requirement, it should be promoted into `specs/`.
