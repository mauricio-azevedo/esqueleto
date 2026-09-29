# Contributing

## Branches and merges

- Trunk-based. Branch from `main`.
- `main` is always deployable. Every merge could go to production; the gate, squash and short branches exist to keep that true.
- Unfinished work merges behind a feature flag, off by default. A change that takes days still merges on day one.
- Small PRs, readable in fifteen minutes.
- Every branch starts from an issue. Use "Create a branch" in the issue sidebar, or `gh issue develop <number> --checkout`. Either way the branch is linked, so the PR closes the issue on merge.
- Issues use the forms in `.github/ISSUE_TEMPLATE/`. Blank issues are off, so every issue has what's needed to act on it.
- Squash only. Merge commits and rebase merges are disabled in repo settings.
- PR title is a [Conventional Commit](https://www.conventionalcommits.org/): `type(scope): summary`. It becomes the squash commit message, so it is the only line that survives. `!` marks a breaking change: a correct caller would fail.
- CI checks the PR title with [action-semantic-pull-request](https://github.com/amannn/action-semantic-pull-request).
- PR body comes from `.github/pull_request_template.md`.

## Review

- Approve when the change improves the overall health of the codebase, even if it isn't perfect. Block only on what the sections below require. Reference: [Google's code review guide](https://google.github.io/eng-practices/review/).
- Look in this order: design, behavior, complexity, tests, naming, comments, style. A review that starts at style never reaches design. For anything spanning systems, design means `docs/design-checklist.md`.
- Every comment says why. Optional ones start with `Nit:` so the author knows they don't block. Within a business day, or say when.
- With one person on the project, review is self-review plus an agent review, and the ruleset requires CI only. With a team, one approval.

## Running locally

- `make dev` brings everything up from a fresh clone. It runs `docker compose up`; the services are in `compose.yaml`. `make down` stops and removes them.
- `make dev-obs` adds a local Grafana with logs, metrics and traces at `http://localhost:3000`, fed by the same OpenTelemetry endpoint the code uses everywhere.
- Config comes from `.env`, which is not committed. `make dev` creates it from `.env.example` when it is missing. The example lists every variable with a safe local default; add a line there when the code reads a new one.

## Code

Review checks these. Where a tool does too, the bullet says so.

- Strictest mode the language has. An escape hatch (`any`, `unsafe`, `type: ignore`) means the type isn't understood yet. The linter rejects them.
- Explicit names. The name says what the thing does, not how it was built.
- Focused files. A big file is usually a file doing more than one thing.
- Comments explain why. What is already in the code; if it isn't, fix the code.
- Errors are handled where there is something to do about them, otherwise they propagate. Queues fail, databases go down, networks flap; the sad path is part of the feature.
- Adding a dependency is a decision: license, maintenance, size. A large one gets an ADR.
- Durable state and its externally visible effects don't diverge after a partial failure. A row committed with its event never sent, or the reverse, is a design bug, not a network one.
- Anything that can be retried is safe to run twice, or detects that it already ran.
- Delivery is at-least-once and unordered until something proves otherwise. Consumers tolerate duplicates; an ordering requirement is written down.
- Old and new versions run at once during every deploy. So schema migrations live in the PR, run forward only, and work with both: add, deploy, backfill, drop in a later PR. Events and APIs the same: a breaking change keeps the old behavior beside the new until every consumer has moved. The `!` goes on the PR that removes the old behavior, since that is when a correct caller fails.
- Logic that decides is separate from code that does I/O, so the decision is testable without a database.
- External systems sit behind an interface this code owns. The database, the broker and the vendor API are details at the edge.
- Boring technology, unless a concrete benefit is written down; in an ADR if the choice is hard to reverse.
- A change that spans more than one process, datastore or external system answers `docs/design-checklist.md` before it is built.
- The HTTP API is `api/openapi.yaml`, the contract. Written first or generated from code, it is committed. The running service serves it at `/openapi.json` with docs at `/docs`; those two paths are outside the contract by convention.
- A change to the spec that breaks a correct client is a breaking change: `!` in the PR title. `make api-diff`, under `check`, compares the spec with `main` and fails on a breaking change without the `!`.
- Anything that takes input from the internet meets [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/) Level 1; anything holding personal data, Level 2. `docs/threat-model.md` says where the boundaries are.

## Decisions

- A decision that is hard to reverse, or that a newcomer would ask "why?" about, gets an ADR in `docs/adr/`, in the PR that makes it. Database, sync or async, how services talk. Not naming, not formatting.
- One file per decision, numbered, from `docs/adr/template.md`. Accepted ADRs are not edited; a change of mind is a new ADR that supersedes the old one, and the old one's status points forward.
- Context, decision, consequences, and what would change it, under a page. "Revisit when" is required: a decision that no evidence could overturn is a preference.
- CONTRIBUTING holds how we work. ADRs hold why the system is shaped the way it is.

## Testing

Review checks these too.

- Tests are part of the change. A PR that changes behavior changes tests in the same PR, sad path included.
- TDD when you can: the test first, seen failing, then the code. A test that never failed proves nothing. A bug fix starts with the test that reproduces it. `make test-unit` is the loop; it runs in seconds.
- Test behavior, not implementation. A test that fails on a refactor that changed no behavior is testing the wrong thing.
- The name states the behavior: `rejects an expired token`, not `testValidate`. A failure should say what broke without opening the file.
- Real dependencies, not mocks of them. A database test runs against a database that the test starts itself with testcontainers, so `make test` needs no service running first, only Docker, and each run starts clean. Mocks belong at boundaries we don't own.
- Fast and deterministic. No sleeps, no real network, no order dependence. A flaky test is fixed or deleted the day it flakes, never retried.
- Each kind is owed when its risk exists. Unit: always. Integration: the code touches a database, filesystem, broker or service. Contract: two independently deployed services call each other. E2E: critical paths through the whole system, few. Load: throughput or latency is a requirement. Chaos: availability is; at minimum, a test that kills a dependency and checks the sad path.
- Unit tests run in `make test-unit`. Unit, integration and contract run in `make test` and `make check`. E2E runs there while it stays fast, otherwise on `main`. Load and chaos run on a schedule or before a release, never in the PR gate.

## Observability

- Structured logs to stdout, one JSON object per line. The runtime environment collects; the code never opens a log file.
- One line per unit of work, at the end: who, what, how long, outcome, every field known by then. Not a narrative of steps.
- A trace id on everything. It arrives on the request or is minted there, goes out on every call, and sits on every log line, span and metric. OpenTelemetry, so the backend is config.
- Levels mean something. `error`: someone acts. `warn`: degraded, self-healed. `info`: a business event happened. `debug`: off outside development.
- Errors are logged once, where they stop. A layer that can't handle an error passes it up without logging it.
- No secrets, no personal data in logs. Redact at the logger, not at each call site.
- Authentication failures, access denials and privilege changes are always logged, with who and what. That is the OWASP logging baseline, and the incident timeline.
- `/healthz` says the process is up; `/readyz` says its dependencies are reachable.
- An alert isn't done until its entry in `docs/runbook.md` exists: what it detects, what to check, the usual fix.

## Production

- Nothing goes to production before `docs/production-readiness.md` is walked. Every box is checked or says why not.
- An ADR that changes the architecture walks it again. The checklist is the gate for operations the way `make check` is for code.
- Everything deploys on AWS. The [Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) is the reference for how; its review is part of the checklist.
- `make deploy` builds the image from `Dockerfile`, pushes it to `REGISTRY`, and installs the Helm chart in `deploy/` on the platform's cluster: a shared Kubernetes cluster run outside this repo by the platform, described in ADR 0003. This repo owns only its namespace there. If the platform runs Argo CD, deploys become commits instead and `make deploy` goes; ADR 0004 holds that decision as proposed.

## Quality gate

- `make check` runs the whole gate. CI runs the same target, so green locally means green in CI.
- Each step is its own target: `make fmt`, `make lint`, `make typecheck`, `make test`, `make build`, `make api-diff`. Run one while iterating, `check` before pushing.
- `make fmt` rewrites files; `check` runs `fmt-check` instead. Everything under `check` only verifies and fails if it would change something; CI never rewrites.
- `make` alone lists the targets.
- `make check` is the contract. Add a step by adding a target and putting it under `check`; don't add steps to CI that aren't in `check`. The PR title check is the one exception: it reads the PR, not the code.

## CI

- The `check` workflow runs `make check` on every PR and on push to `main`. It is a required check on `main`.
- Actions pinned to a full commit SHA, version in a comment: `actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1`. Tags can be moved ([tj-actions](https://github.com/advisories/GHSA-mrrh-fwg8-r2c3)); SHAs can't.
- Dependabot bumps the SHAs.
