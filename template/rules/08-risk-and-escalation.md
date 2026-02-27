# Risk And Escalation

Not all changes carry the same risk. The agent must assess risk before committing and escalate
to a human when the change exceeds its safe operating envelope.

## Risk Indicators

A change is higher risk when any of these apply:

1. **New dependency.** Adding a crate, package, or module not already in the project.
2. **Security surface.** Touching authentication, authorization, cryptography, or secrets handling.
3. **Public API change.** Modifying or extending a public interface that consumers depend on.
4. **Blast radius.** The change touches more than 5 files or crosses multiple spec domains.
5. **Novelty.** The implementation requires a pattern not already present in the codebase.
6. **Infrastructure.** Changing CI, deployment, Nix configuration, or build tooling.

## What To Do

Low risk (0 indicators): implement, verify, commit as normal.

Medium risk (1–2 indicators): proceed, but add a note in the commit body explaining the risk
factor and why the approach is safe. If unsure, stop and document the uncertainty.

High risk (3+ indicators): stop. Do not implement. Instead:

1. Write a structured escalation block in `fix_plan.md` below the current item:

```markdown
### Escalation: <item title>

**Risk factors:** <list which indicators apply>
**What I tried:** <brief summary of approaches considered>
**Options:**
1. <option A> — <tradeoff>
2. <option B> — <tradeoff>
**Recommendation:** <which option and why>
**Confidence:** <low | medium | high>
```

2. Commit the escalation note.
3. Move to the next item or stop the loop.

## Dependency Policy

Do not add dependencies without explicit spec authorization. If a spec does not mention a
dependency, it is not authorized. If the implementation genuinely requires one:

1. Check if the functionality exists in the project's stdlib or current dependencies.
2. If not, escalate. Include the dependency name, what it provides, its maintenance status,
   and its transitive dependency count.

## Ask-For-Help Triggers

Stop and escalate (do not guess) when:

1. The spec is ambiguous and multiple interpretations lead to different implementations.
2. A test fails and the root cause is unclear after two attempts.
3. The change requires access to secrets, credentials, or external services not in the sandbox.
4. An architectural decision would affect multiple specs or services.
5. The verification commands themselves need to change.
