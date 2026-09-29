# Contributing

## Branches and merges

- Trunk-based. Branch from `main`.
- Every branch starts from an issue. Use "Create a branch" in the issue sidebar, or `gh issue develop <number> --checkout`. Either way the branch is linked, so the PR closes the issue on merge.
- Issues use the forms in `.github/ISSUE_TEMPLATE/`. Blank issues are off, so every issue has what's needed to act on it.
- Squash only. Merge commits and rebase merges are disabled in repo settings.
- PR title is a [Conventional Commit](https://www.conventionalcommits.org/): `type(scope): summary`. It becomes the squash commit message, so it is the only line that survives.
- CI checks the PR title with [action-semantic-pull-request](https://github.com/amannn/action-semantic-pull-request).
- PR body comes from `.github/pull_request_template.md`.

## Running locally

- `make dev` brings everything up from a fresh clone. It runs `docker compose up`; the services are in `compose.yaml`. `make down` stops and removes them.
- `make dev-obs` adds a local Grafana with logs, metrics and traces at `http://localhost:3000`, fed by the same OpenTelemetry endpoint the code uses everywhere.
- Config comes from `.env`, which is not committed. Copy `.env.example` to start. It lists every variable with a safe local default; add a line there when the code reads a new one.

## Code

Review checks these. Nothing else does.

- Strictest mode the language has. An escape hatch (`any`, `unsafe`, `type: ignore`) means the type isn't understood yet. The linter rejects them.
- Explicit names. The name says what the thing does, not how it was built.
- Focused files. A big file is usually a file doing more than one thing.
- Comments explain why. What is already in the code; if it isn't, fix the code.
- Errors are handled where there is something to do about them, otherwise they propagate. Queues fail, databases go down, networks flap; the sad path is part of the feature.

## Decisions

- A decision that is hard to reverse, or that a newcomer would ask "why?" about, gets an ADR in `docs/adr/`, in the PR that makes it. Database, sync or async, how services talk. Not naming, not formatting.
- One file per decision, numbered, from `docs/adr/template.md`. Accepted ADRs are not edited; a change of mind is a new ADR that supersedes the old one, and the old one's status points forward.
- Context, decision, consequences, and what would change it, under a page. "Revisit when" is required: a decision that no evidence could overturn is a preference.
- CONTRIBUTING holds how we work. ADRs hold why the system is shaped the way it is.

## Testing

Review checks these too.

- Tests are part of the change. A PR that changes behavior changes tests in the same PR, sad path included.
- Test behavior, not implementation. A test that fails on a refactor that changed no behavior is testing the wrong thing.
- The name states the behavior: `rejects an expired token`, not `testValidate`. A failure should say what broke without opening the file.
- Real dependencies, not mocks of them. A database test runs against a database that the test starts itself with testcontainers, so `make test` needs nothing running and each run starts clean. Mocks belong at boundaries we don't own.
- Fast and deterministic. No sleeps, no real network, no order dependence. A flaky test is fixed or deleted the day it flakes, never retried.

## Observability

- Structured logs to stdout, one JSON object per line. The platform collects; the code never opens a log file.
- One line per unit of work, at the end: who, what, how long, outcome, every field known by then. Not a narrative of steps.
- A trace id on everything. It arrives on the request or is minted there, goes out on every call, and sits on every log line, span and metric. OpenTelemetry, so the backend is config.
- Levels mean something. `error`: someone acts. `warn`: degraded, self-healed. `info`: a business event happened. `debug`: off outside development.
- Errors are logged once, where they stop. A layer that can't handle an error passes it up without logging it.
- No secrets, no personal data in logs. Redact at the logger, not at each call site.
- `/healthz` says the process is up; `/readyz` says its dependencies are reachable.
- An alert isn't done until its entry in `docs/runbook.md` exists: what it detects, what to check, the usual fix.

## Quality gate

- `make check` runs the whole gate. CI runs the same target, so green locally means green in CI.
- Each step is its own target: `make fmt`, `make lint`, `make typecheck`, `make test`, `make build`. Run one while iterating, `check` before pushing.
- `make fmt` rewrites files; `check` runs `fmt-check` instead. Everything under `check` only verifies and fails if it would change something; CI never rewrites.
- `make` alone lists the targets.
- `make check` is the contract. Add a step by adding a target and putting it under `check`; don't add steps to CI that aren't in `check`.

## CI

- The `check` workflow runs `make check` on every PR and on push to `main`. It is a required check on `main`.
- Actions pinned to a full commit SHA, version in a comment: `actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1`. Tags can be moved ([tj-actions](https://github.com/advisories/GHSA-mrrh-fwg8-r2c3)); SHAs can't.
- Dependabot bumps the SHAs.
