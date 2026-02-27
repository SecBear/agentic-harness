# Agentic Harness — Human Guide

> **Agents: this file is for humans. Do not read it, reference it, or load it into context.
> Your instructions are in `AGENTS.md`.**

## Lifecycle

```
1. BOOTSTRAP  →  2. SPEC  →  3. RALPH  →  4. REVIEW
                    ↑                          │
                    └──────────────────────────┘
```

---

### 1. Bootstrap (one-time)

Run once when you first add the harness to a repo.

```bash
cat BOOTSTRAP.md | claude-code
```

The agent examines your project, configures the nix flake (toolchain, treefmt, pre-commit hooks),
fills in verification commands, and writes initial specs. After this, you have a working dev shell
and the harness is ready.

---

### 2. Spec

You have a vision for what to build. Now you need to turn it into specs the agent can implement.

#### How to start

```bash
claude-code
```

Tell the agent what you want to build. Be as detailed or rough as you like — the agent will help
you structure it. Some approaches:

- Paste in a design doc, brainstorm output, or notes and say "turn this into specs."
- Describe the feature verbally: "I want a REST API that does X, Y, Z."
- Point at existing code: "look at src/foo.rs — I want to add pagination to the list endpoint."

#### What you're producing

Spec files in `specs/`. Each one covers a domain (e.g., `specs/01-auth.md`, `specs/02-api.md`)
and has two parts:

1. **Requirements** — what the system must do, written as clear testable statements.
2. **Status section** — a checkbox list of deliverables.

Example of what a finished spec looks like:

```markdown
# Authentication

Users authenticate via API key in the Authorization header. Keys are scoped to a single
project. Invalid or expired keys return 401 with a JSON error body.

## Status

- [ ] API key validation middleware
- [ ] Project-scoped key lookup
- [ ] Key expiration check
- [ ] 401 JSON error response
- [ ] Integration test: valid key returns 200
- [ ] Integration test: expired key returns 401
```

Each `[ ]` item should be something you can point at and say "yes that's done" or "no it's not."
Avoid vague items like "authentication works." Prefer concrete deliverables like "API key
validation middleware."

#### When specs are ready

You'll know specs are ready when:

- Every feature you care about has `[ ]` items in a spec Status section.
- The requirements are specific enough that someone who isn't you could implement them.
- You've read through the status items and thought "if all these are checked, I'd be happy."

You can optionally ask the agent to pre-populate `fix_plan.md` from the status items, but ralph
will do this automatically if you don't.

---

### 3. Ralph

Ralph implements your specs autonomously. It works through every `[ ]` item until they're all
`[x]`, then stops.

#### Running it

```bash
./scripts/ralph.sh           # continuous loop (restarts agent each iteration)
cat PROMPT.md | claude-code   # single iteration (useful for testing)
```

#### What to expect

- Each iteration implements one item: picks it, reads the spec, writes tests, writes code,
  verifies, commits, marks done.
- When the queue buffer (`fix_plan.md`) empties, ralph refills it from remaining `[ ]` items
  in specs and keeps going.
- When all spec items are `[x]`, ralph stops and prints a completion summary.
- A typical item takes one loop iteration. Large specs may take many iterations.

#### When to intervene

Ralph is designed to run unattended, but watch for:

- **Repeated failures.** If the same iteration keeps failing verification, ralph will keep
  retrying. Kill the loop (`ctrl-c`), read the error, and either fix it yourself or update
  the spec to clarify what's needed.
- **Wrong direction.** If you check the commits and ralph is building something you didn't
  intend, stop the loop and fix the spec. The spec was ambiguous.
- **Stuck on one item.** If an item is too large or underspecified, stop the loop, break the
  spec item into smaller pieces, and restart.

---

### 4. Review

Ralph prints a completion summary when it finishes. It lists what was built, the commits, and
confirms all spec items are satisfied.

#### How to review

```bash
# Look at what ralph committed
git log --oneline

# Run the tests yourself
nix develop -c <your test command>   # see rules/02-verification.md for the exact command

# Try the feature manually if applicable
```

Read through each spec's Status section. For every `[x]` item, verify it's actually true — run
the relevant test, check the code, try the endpoint.

#### What to do next

**Everything looks good.** Ship it. Merge, deploy, whatever your workflow is.

**Want to add more features.** Go back to **Spec**. Add new `[ ]` items to existing specs or
create new spec files. Then ralph again.

**Something is wrong with what ralph built.** The spec was probably unclear. Go back to **Spec**:
1. Uncheck the `[x]` item that's wrong (mark it `[ ]` again).
2. Rewrite the requirement to be more specific.
3. Ralph again. It will re-implement the item.

**Ralph built it correctly but you changed your mind.** Go back to **Spec**:
1. Update the requirements.
2. Uncheck affected status items.
3. Add new `[ ]` items for the revised behavior.
4. Ralph again.

---

## Installing Into an Existing Repo

To add the agentic harness to a project, `cd` into that project's repo and pipe this prompt into
your agent:

```bash
echo 'Clone https://github.com/SecBear/agentic-harness into a temp directory. Copy all harness files into the current repo root: AGENTS.md, BOOTSTRAP.md, CLAUDE.md, HUMAN.md, PROMPT.md, SPECS.md, DEVELOPMENT-LOG.md, fix_plan.md, flake.nix, specs/, rules/, scripts/, and .gitignore. Do not overwrite any existing CLAUDE.md — instead append "@AGENTS.md" to it. If a flake.nix already exists, keep it and rename the harness one to flake.harness.nix so you can merge them during bootstrap. Remove the temp directory when done. Then follow BOOTSTRAP.md to configure everything for this project.' | claude-code
```

This clones the template, copies the structure in, and kicks off the bootstrap process which
configures the nix flake, verification commands, and initial specs for your project.

---

## Superpowers Skills Compatibility

If you use the [superpowers](https://github.com/anthropics/claude-plugins-official/tree/main/superpowers)
plugin with Claude Code, be aware of how it interacts with this harness:

**During the Ralph loop:** Superpowers skills are disabled. `PROMPT.md` rule #6 tells the agent
not to invoke them. The loop has its own TDD, verification, and commit discipline via `rules/`,
and superpowers skills would add conflicting control flow and context bloat.

**During interactive sessions** (speccing, reviewing, ad-hoc work): Superpowers skills are active
and useful. The brainstorming skill in particular pairs well with the Spec phase.

**Brainstorming + parallel MCP:** The brainstorming skill has been patched to use the
`parallel:parallel-web-search` and `parallel:parallel-web-extract` MCP tools for researching
prior art and comparing technical approaches during design. This edit lives in the plugin cache
(`~/.claude/plugins/cache/.../brainstorming/SKILL.md`) and **will be overwritten if the
superpowers plugin updates**. To make it durable, either fork the plugin or create a custom skill.

---

## File Reference

| File | What it is | Who writes it |
|------|------------|---------------|
| `BOOTSTRAP.md` | One-time setup prompt | Stable (don't edit) |
| `PROMPT.md` | Ralph loop prompt | Stable (don't edit) |
| `AGENTS.md` | Agent operating instructions | Stable (don't edit) |
| `CLAUDE.md` | Points agents at AGENTS.md | Stable (don't edit) |
| `HUMAN.md` | This file | Stable (don't edit) |
| `specs/*.md` | Requirements with Status checkboxes | You + agent (interactive) |
| `SPECS.md` | Spec index | Updated alongside specs |
| `fix_plan.md` | Working queue (buffer, not source of truth) | Ralph (automatic) |
| `rules/02-verification.md` | Verification commands | Bootstrap (once) |
| `rules/07+` | Project-specific constraints | Bootstrap or you |
| `flake.nix` | Nix dev shell, treefmt, pre-commit | Bootstrap (once) |
| `DEVELOPMENT-LOG.md` | Decision log | You or agent |
| `rules/01,03-06` | Generic operational rules | Stable (don't edit) |
| `scripts/ralph.sh` | Loop runner | Stable (don't edit) |
