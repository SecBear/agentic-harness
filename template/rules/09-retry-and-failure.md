# Retry And Failure

Agents operating in a loop will encounter failures. Without a retry policy, the loop either
gives up too early or retries forever. This rule defines the failure budget and recovery behavior.

## Retry Budget

Each fix_plan item gets a maximum of 3 attempts within a single loop session.

An attempt is: read the spec, implement, run verification. If verification fails, that is one
failed attempt.

## After Each Failed Attempt

1. Read the verification output carefully. Identify the root cause, not just the symptom.
2. Do not repeat the same approach. If the same strategy failed, change the strategy.
3. If the root cause is unclear, add a diagnostic step (print state, add a temporary test,
   inspect intermediate output) before the next attempt.

## After 3 Failed Attempts

Stop. Do not retry further in this session. Instead:

1. Mark the item in `fix_plan.md` with a failure note:

```markdown
- [ ] <item title> (spec: specs/NN-name.md)
  **Blocked after 3 attempts.**
  Tried: <one-line summary of each approach>
  Failure: <what verification reported>
  Suspected cause: <best guess>
```

2. Commit the updated fix_plan.md.
3. Move to the next unchecked item. If no items remain, stop the loop.

The human will review the failure note and either clarify the spec, fix the environment, or
adjust the approach before the next loop run.

## Circuit Breaker

If 3 consecutive fix_plan items fail in the same session, stop the loop entirely. Something
systemic is wrong (broken environment, bad dependency, flawed spec assumptions). Print:

```
== Circuit breaker tripped ==

3 consecutive items failed. Suspected systemic issue.
Failed items:
- <item 1>: <failure summary>
- <item 2>: <failure summary>
- <item 3>: <failure summary>

Recommended: check the dev environment, re-read affected specs, run verification manually.
```

## Reduce Scope Fallback

If an item is partially complete after exhausting retries (e.g., 3 of 4 tests pass), commit
the partial progress on a branch — not on the main line. Name the branch
`wip/<item-slug>`. Document what works and what does not in the commit message. This preserves
progress without polluting the verified main line.

## Transient vs Persistent Failures

Transient failures (network timeout, flaky test, tool crash) deserve a simple retry. Do not
count a transient failure against the retry budget if the same command succeeds on immediate
re-run.

Persistent failures (compilation error, logic bug, missing dependency) consume a retry attempt
each time.

If you are unsure whether a failure is transient: re-run the command once. If it passes, it was
transient. If it fails again, it is persistent.
