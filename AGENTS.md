# Agents

Before changing anything:

1. Read `CONTRIBUTING.md`. It is the rulebook, and review holds you to it.
2. Read `docs/adr/`. Don't relitigate an accepted decision; a change of mind is a new ADR that supersedes it.
3. Work on a branch from an issue. The PR title is a Conventional Commit.

Before finishing:

4. Run `make check`. Green is the bar. Don't report done on red.
5. Tests are part of the change, sad path included. `make test-unit` is the loop.
6. A decision that is hard to reverse gets an ADR in the same PR, with "Revisit when" filled.
7. Say what you did and what you did not verify.
