# Verification

This file is the single source of truth for verification commands and backpressure configuration.

## Backpressure Architecture

This project uses Nix for all tooling. Do not assume language tools exist on PATH.

Three layers of backpressure enforce correctness:

1. **treefmt** — unified formatter configured in `flake.nix` under `treefmt.programs`. Runs all
   language-specific formatters (rustfmt, prettier, ruff, gofmt, etc.) through a single interface.
2. **pre-commit hooks** — configured in `flake.nix` under `pre-commit.settings.hooks`. Runs
   treefmt automatically on every commit. You cannot commit unformatted code.
3. **Verification commands** — run manually or in CI to prove correctness.

The relationship:

- `nix fmt` runs treefmt (format everything).
- `nix flake check` validates formatting in CI.
- Pre-commit hooks call treefmt before each commit.
- Test and lint commands run inside `nix develop -c` to use flake-provided tooling.

## Commands

<!-- Bootstrap replaces these with the actual project commands. -->

1. Format: `nix fmt`
2. Tests: `nix develop -c echo "TODO: set by bootstrap"`
3. Lints: `nix develop -c echo "TODO: set by bootstrap"`

## Configuring Backpressure

To change formatting rules: edit `treefmt.programs` in `flake.nix`.
To add pre-commit hooks beyond treefmt: edit `pre-commit.settings.hooks` in `flake.nix`.
To add verification commands: update the Commands section above.

## Command Policy

If a command fails, do not guess. Read the output, find root cause, and fix it with a test-first
approach when behavior is changing.

## No Claims Without Evidence

Do not claim:

1. "Tests pass"
2. "Fixed"
3. "Done"

Unless the relevant command was run in the current session and you have the exit status and the
failure count.

## Minimal Verification Sets

1. Code change: run tests.
2. Public API change: run tests plus any boundary-touching tests.
3. Formatting-only change: `nix fmt` (treefmt handles it).
