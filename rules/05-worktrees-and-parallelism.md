# Worktrees And Parallel Sessions

When work items are disjoint, isolate them using git worktrees and separate agent sessions.

## When To Use A Worktree

Use a worktree when:

1. Two or more tasks touch different files with no shared state.
2. You want to run agents in parallel without merge conflicts.
3. A task is exploratory and you want to discard it cleanly if it fails.

Do not use a worktree when:

1. Tasks share files or depend on each other's output.
2. The task is small enough to finish in a single loop iteration.

## Rules

1. One task per worktree.
2. One agent session per worktree.
3. Keep worktrees scoped to a single spec domain.
4. Prefer merges over rebases for integrating agent work (minimize history rewriting).
5. The harness files (AGENTS.md, PROMPT.md, rules/, specs/) are shared via git — they are the
   same in every worktree. Do not diverge them.

## Creating A Worktree

```bash
git worktree add -b feat/<name> .worktrees/<name> <base-branch>
```

This creates a branch `feat/<name>` checked out in `.worktrees/<name>`.

To run the ralph loop in a worktree:

```bash
cd .worktrees/<name> && ./scripts/ralph.sh
```

## Avoiding Context Mixing

Do not share agent context windows across worktrees.

If you must coordinate across multiple parallel worktrees:

1. Treat your main session as a scheduler only.
2. Delegate implementation to one agent per worktree.
3. Delegate build/test verification to exactly one session at a time.

## Cleanup

When a worktree task is complete and merged:

```bash
git worktree remove .worktrees/<name>
git branch -d feat/<name>
```
