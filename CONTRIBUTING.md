# Contributing

## GitHub Actions

- We pin actions to a full commit SHA, version in a comment: `actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1`. Tags can be moved ([tj-actions](https://github.com/advisories/GHSA-mrrh-fwg8-r2c3)); SHAs can't.
- Dependabot bumps the SHAs.
- Repo policy rejects unpinned actions.

## Branches and merges

- Trunk-based. Branch from `main`, open a PR, merge within a day or two. Long-lived branches drift and turn merges into integration work.
- Every branch starts from an issue. Use "Create a branch" in the issue sidebar; it names the branch `<number>-<title>` and links it, so the PR closes the issue on merge. No issue, no branch.
- Squash only. One PR is one commit on `main`, so `git log` reads as a changelog and any change reverts cleanly. Merge commits and rebase merges are disabled in repo settings.
- PR title is a [Conventional Commit](https://www.conventionalcommits.org/): `type(scope): summary`. It becomes the squash commit message, so it is the only line that survives. Commit messages inside the PR don't matter; write whatever helps you.
- CI checks the PR title with [action-semantic-pull-request](https://github.com/amannn/action-semantic-pull-request) and is a required check, so a bad title can't be merged. It re-runs on title edit; no push needed.

## Releases

- Version and `CHANGELOG.md` come from [release-please](https://github.com/googleapis/release-please), computed from the commit types on `main`. `fix` bumps patch, `feat` bumps minor, `!` after the type or a `BREAKING CHANGE:` footer bumps major. Other types don't bump.
- release-please keeps one release PR open and updates it on every merge to `main`. Merging that PR tags the release and publishes the GitHub release. Until then, everything on `main` is unreleased.
- Don't edit the version or the changelog by hand. The next release PR overwrites both.
- Nothing to release? Don't merge the release PR. It waits.
