# Commits And Backpressure

Commits are the unit of progress. Pre-commit hooks are the enforcement mechanism.

## Rules

1. Commit after every meaningful change. A meaningful change is: a test passes that didn't before,
   a bug is fixed, a feature works, a refactor is complete. Do not batch unrelated changes.
2. No commit without fresh verification evidence.
3. If pre-commit hooks fail, fix the issue immediately. Do not bypass hooks (`--no-verify`).
4. Keep commits small and scoped. One logical change per commit.

## Why Commit Often

- Pre-commit hooks (treefmt) enforce formatting on every commit. If you don't commit, the hooks
  don't run, and backpressure is lost.
- Small commits are easy to revert. Large commits are not.
- Each commit is a checkpoint. If the agent drifts or context degrades, progress is preserved.

## Conventional Commit Titles

Use:

1. `feat(<scope>): ...`
2. `fix(<scope>): ...`
3. `test(<scope>): ...`
4. `docs(<scope>): ...`
5. `chore(<scope>): ...`

## Workflow

1. Make a change (test, implementation, refactor — one at a time).
2. Run the verification commands from `rules/02-verification.md`.
3. Commit with a conventional commit title.
4. Repeat.
