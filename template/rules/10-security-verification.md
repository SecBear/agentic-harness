# Security Verification

Security scanning is backpressure. It runs alongside formatting and tests, not after deployment.

## Layers

Three categories of security check, in order of priority:

1. **Secrets.** No credentials, API keys, tokens, or private keys in committed code. Ever.
2. **Dependencies.** No known-vulnerable dependencies. No unnecessary new dependencies.
3. **Static analysis.** No obvious vulnerability patterns in application code.

## Pre-Commit: Secret Scanning

The pre-commit hook must catch secrets before they enter history. Configure in `flake.nix`
under `pre-commit.settings.hooks`:

```nix
# Example: trufflehog or git-secrets as a pre-commit hook
# Uncomment and configure during bootstrap based on project needs.
# trufflehog.enable = true;
```

If no automated secret scanner is configured, the agent must manually verify:

1. No hardcoded strings that look like keys, tokens, or passwords.
2. No `.env` files, credential files, or key files staged for commit.
3. Sensitive values are read from environment variables or a secrets manager.

## On Dependency Changes

When `Cargo.lock`, `package-lock.json`, `go.sum`, `uv.lock`, or equivalent lock files change:

1. Run the project's dependency audit command (e.g., `cargo audit`, `npm audit`, `pip-audit`).
2. If vulnerabilities are found, do not proceed. Fix or escalate per `rules/08-risk-and-escalation.md`.

Bootstrap should add the appropriate audit command to the verification commands in
`rules/02-verification.md`.

## Static Analysis

If the project has a SAST tool configured (clippy, eslint security plugin, bandit, gosec, semgrep),
run it as part of the lint step in `rules/02-verification.md`.

If no SAST tool is configured, apply these manual checks before committing:

1. No user input passed directly to shell commands, SQL queries, or file paths.
2. No `unsafe` blocks (Rust), `eval()` (JS/Python), or equivalent without a comment justifying why.
3. No disabled TLS verification, certificate pinning bypasses, or weakened crypto.

## What Agents Must Not Do

1. Do not commit secrets, even as "examples" or "placeholders."
2. Do not add dependencies to work around a problem that has a stdlib solution.
3. Do not disable or weaken security checks to make tests pass.
4. Do not introduce `allow(unsafe_code)`, `# nosec`, `// nolint`, or equivalent suppressions
   without a spec-authorized justification in a comment.

## Incident Response

If you discover a committed secret or vulnerability in existing code:

1. Do not fix it silently. Create a fix_plan item referencing the issue.
2. If it is a secret: note that history rewriting or key rotation may be needed. Escalate.
3. If it is a vulnerability: fix it via normal TDD flow with a test that proves the
   vulnerability is closed.
