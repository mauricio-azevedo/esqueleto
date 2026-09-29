# Agents

Before changing anything:

1. Read `CONTRIBUTING.md`. It is the rulebook, and review holds you to it.
2. Read `docs/adr/`. Don't relitigate an accepted decision; a change of mind is a new ADR that supersedes it.
3. Read the code where the change lands before introducing a pattern. If an adapter, a helper or a convention already exists, use it.
4. Read `docs/add-when.md`. If the change fires one of its triggers, say so in the PR and do what the entry says.
5. Work on a branch from an issue. The PR title is a Conventional Commit.
6. A change that spans more than one process, datastore or external system is answered against `docs/design-checklist.md` before it is built; its Concurrency section, for any change that touches shared mutable state. Every answer, including "n/a" and why, goes in the PR's Design section.
7. When several designs satisfy the Code section of `CONTRIBUTING.md`, the simplest wins.

Before finishing:

8. Run `make check`. Green is the bar. Don't report done on red.
9. Tests are part of the change, sad path included. `make test-unit` is the loop.
10. A decision that is hard to reverse gets an ADR in the same PR, with "Revisit when" filled.
11. A change to auth, sessions, input handling, crypto or secrets is checked against the relevant OWASP ASVS chapter and cheat sheet, and the PR's Security section names what was checked.
12. Say what you did and what you did not verify.

When reviewing:

13. Approve when the change improves the overall health of the codebase. Block only on what `CONTRIBUTING.md` requires. Say why on every comment; `Nit:` on the optional ones.
