# Agentic Harness

A Nix flake template that stamps a structured, markdown-driven harness onto any repository for
autonomous coding agents. Specs define what to build. Rules define how agents work. A deterministic
loop (Ralph) implements one task per iteration with TDD and backpressure from Nix tooling.

## Quick Start

```bash
mkdir my-project && cd my-project && git init
nix flake init -t github:SecBear/agentic-harness
direnv allow
cat BOOTSTRAP.md | claude-code
```

Bootstrap examines your project, configures the Nix flake (toolchain, treefmt, pre-commit hooks),
fills in verification commands, and writes initial specs.

## Lifecycle

```
1. BOOTSTRAP  →  2. SPEC  →  3. RALPH  →  4. REVIEW
                    ↑                          │
                    └──────────────────────────┘
```

**Bootstrap** (one-time) — configure tooling and write initial specs.
**Spec** — define requirements as testable statements with status checkboxes.
**Ralph** — autonomous loop implements specs one task at a time.
**Review** — verify, ship, or refine specs and loop again.

## What You Get

```
├── .envrc              direnv hook (use flake)
├── AGENTS.md           Agent operating instructions (stable)
├── BOOTSTRAP.md        One-time setup prompt (stable)
├── CLAUDE.md           Points agents at AGENTS.md (stable)
├── HUMAN.md            Human lifecycle guide (stable)
├── PROMPT.md           Ralph loop prompt (stable)
├── SPECS.md            Spec index
├── fix_plan.md         Working queue (populated by ralph)
├── flake.nix           Nix dev shell, treefmt, pre-commit hooks
├── rules/              Operational constraints and backpressure
├── specs/              Project requirements with status checkboxes
├── scripts/ralph.sh    Loop runner
└── docs/               Project-specific documentation
```

## Running the Loop

```bash
./scripts/ralph.sh           # continuous loop
cat PROMPT.md | claude-code   # single iteration
```

See [HUMAN.md](template/HUMAN.md) for the full guide — spec authoring, when to intervene,
review workflow, and file reference.

## License

MIT
