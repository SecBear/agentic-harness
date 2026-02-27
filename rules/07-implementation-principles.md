# Implementation Principles

Engineering defaults for how to approach implementation work. Apply these in order when building
any feature, pipeline, or artifact.

## Principles

1. **Define the contract.** Deliverables, constraints, success checks, non-goals — before writing
   code.
2. **Thin end-to-end first.** Produce a minimal run that generates the required artifact(s) before
   optimizing or expanding.
3. **Fast eval harness.** Create golden examples + invariants + "top suspicious" diagnostics early.
   If you cannot verify it, you cannot claim it works.
4. **Deterministic before heuristic.** Prefer deterministic logic first; gate LLM/heuristic paths
   behind flags and make runs reproducible.
5. **Cache expensive work.** Cache all expensive inputs/outputs; support warm-run workflows
   explicitly.
6. **Instrument every phase.** Timers + counts + error summaries. Fail loudly on missing
   prerequisites.
7. **Constrain the search space.** Rank, top-k, thresholds — avoid edge explosions and false
   positives.
8. **Reviewer-proof outputs.** Offline-capable, stable, minimal external dependencies at view time.
9. **Document the canonical run.** One path with exact commands + expected outputs + known
   limitations.
10. **Packaging pass.** Required artifacts included, secrets excluded, submission script verified.
