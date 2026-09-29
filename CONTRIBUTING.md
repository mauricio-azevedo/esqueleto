# Contributing

## Branches and merges

- Trunk-based. Branch from `main`.
- Every branch starts from an issue. Use "Create a branch" in the issue sidebar, or `gh issue develop <number> --checkout`. Either way the branch is linked, so the PR closes the issue on merge.
- Issues use the forms in `.github/ISSUE_TEMPLATE/`. Blank issues are off, so every issue has what's needed to act on it.
- Squash only. Merge commits and rebase merges are disabled in repo settings.
- PR title is a [Conventional Commit](https://www.conventionalcommits.org/): `type(scope): summary`. It becomes the squash commit message, so it is the only line that survives.
- CI checks the PR title with [action-semantic-pull-request](https://github.com/amannn/action-semantic-pull-request).
- PR body comes from `.github/pull_request_template.md`.

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
