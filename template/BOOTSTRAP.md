# Bootstrap

You are bootstrapping the agentic harness for this project. This is a one-time setup. After you
finish, the normal loop (`PROMPT.md` + `fix_plan.md`) takes over.

## What This Harness Is

This repo uses a structured markdown-based system to drive autonomous coding agents. The structure:

- `AGENTS.md` — stable agent operating instructions (do not modify)
- `PROMPT.md` — stable loop prompt (do not modify)
- `CLAUDE.md` — points agents at `AGENTS.md` (do not modify)
- `rules/` — operational constraints and backpressure configuration
- `specs/` — project requirements (you create these)
- `fix_plan.md` — prioritized work queue (you create this)
- `flake.nix` — nix dev shell, treefmt, and pre-commit hooks (you configure this)
- `SPECS.md` — spec index (you populate this)

## Your Job

### 1. Examine the project

Look at everything that already exists in this repo outside the harness files:

- Source code, language, build system
- Existing tests, CI, configs
- README or docs that describe intent
- Package manifests (Cargo.toml, package.json, go.mod, pyproject.toml, etc.)

### 2. Configure the nix flake

Edit `flake.nix`. The template has three things to configure:

**a) Language toolchain inputs and packages.**
Uncomment and configure the input and devShell packages for the project's language. If the project
uses multiple languages, enable all of them.

If the project already has a `flake.nix`, merge the harness features (treefmt, git-hooks) into
the existing one instead of replacing it.

**b) treefmt formatters.**
Under `treefmt.programs`, enable the formatters for the project's language(s). `nixfmt` is already
enabled since every harness project has nix files. Common options:

- Rust: `rustfmt`, `taplo` (TOML)
- Node/TS: `prettier`
- Python: `ruff-format`
- Go: `gofmt`

treefmt is the unified formatting layer. `nix fmt` runs all enabled formatters. Pre-commit hooks
run treefmt on every commit, so unformatted code cannot be committed.

**c) pre-commit hooks.**
The template already wires treefmt as a pre-commit hook. Add additional hooks if the project
needs them (e.g., `clippy` for Rust, `eslint` for JS). These go under
`pre-commit.settings.hooks` in flake.nix.

**d) Update the flake description.**

### 3. Fill in `rules/02-verification.md`

This file is the single source of truth for verification commands. Update the Commands section:

1. Format is always `nix fmt` (treefmt handles it).
2. Tests: the project's test command, prefixed with `nix develop -c`.
3. Lints: the project's lint command, prefixed with `nix develop -c`.

### 4. Add project-specific rules (if needed)

If the project has constraints that agents need to follow, add rules in `rules/`. Examples:

- A stability contract ("do not change these public APIs without updating specs")
- Dependency policy ("do not add dependencies to the core crate")
- Platform constraints ("must work on both Linux and macOS")

Only add rules for real constraints you find in the project. Do not invent hypothetical rules.
Number them starting from `11-`.

Rules 08 (risk and escalation), 09 (retry and failure), and 10 (security verification) are
already included in the template. Review them during bootstrap:

- `rules/08-risk-and-escalation.md` — tune the risk indicators for the project's domain.
- `rules/09-retry-and-failure.md` — adjust the retry budget if needed (default: 3 attempts).
- `rules/10-security-verification.md` — enable the security pre-commit hooks in `flake.nix`
  that match the project's language (trufflehog, cargo-audit, clippy, etc.).

### 5. Write initial specs

Examine the project and create specs in `specs/` that capture:

- `specs/00-vision-and-non-goals.md` — what this project is and is not (ask the user if unclear)
- Additional specs as needed for the domains you find in the codebase

Each spec must have:

- **Content sections** describing requirements, invariants, and behavior.
- **A Status section** with checkboxes tracking what is implemented and what is not.

The Status section is critical. It is how the loop knows what work remains. Mark items `[x]` for
things that already exist and work. Mark items `[ ]` for things that still need to be built.

Example:

```markdown
## Status

- [x] Core data types defined
- [x] Basic CRUD operations
- [ ] Pagination support
- [ ] Error handling for concurrent writes
```

See `rules/04-docs-and-specs.md` for the full spec format rules.

Update `SPECS.md` to index all specs you create.

### 6. Create the initial fix_plan.md

Derive the initial queue from the `[ ]` items in your specs. Each fix_plan item must:

- Use checkbox format: `- [ ]` for pending items
- Link to its governing spec
- Have a concrete "done when" with observable criteria
- Have a verification command (referencing the commands in `rules/02-verification.md`)

Order items by priority. The loop will pick the top unchecked item each iteration.

If the project is already fully functional and all spec items are `[x]`, the queue can be empty.

### 7. Verify the flake works

Run `nix flake check` and `nix develop -c echo "shell works"` to confirm the flake evaluates.
Fix any issues before committing.

### 8. Commit

Commit everything with: `chore: bootstrap agentic harness`

## Important

- Ask the user if anything is ambiguous. Do not guess at project intent.
- Do not modify `AGENTS.md`, `PROMPT.md`, `CLAUDE.md`, or rules 01, 03-06.
- Do not over-specify. Write the minimum specs that capture real invariants.
- If the project has no code yet, ask the user what they want to build before writing specs.
