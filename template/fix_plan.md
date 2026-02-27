# fix_plan.md

Working queue for the Ralph loop. Specs are the source of truth for what needs to be built.
This file is the buffer — it holds the current batch of work items decomposed from spec
Status sections.

## Format

- `[ ]` — pending (not started)
- `[x]` — done (verified and committed)

Each item must have:

1. A link to the governing spec(s).
2. A concrete "done when" with observable criteria.
3. A verification command.

Items are ordered by priority. The agent always picks the top unchecked item. When the queue is
empty, the agent refills it from remaining `[ ]` items in specs.

## Queue

<!-- Populated during spec session or by the loop when refilling from specs. -->
