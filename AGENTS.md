# Agents

First day. If `README.md` still says `<name>`, this project has not started. Do these in order, and ask the owner for what only the owner knows: the name, what it does, for whom, the targets. Don't invent them.

1. Open issue 1 with the idea. Every branch starts from an issue, including the first.
2. `docs/architecture.md`: What it does, and Targets, even rough.
3. The first design doc, `docs/design/0001-<slug>.md`, from the template: goals, non-goals, requirements, the shape. The ADRs it produces go in `docs/adr/`.
4. `docs/threat-model.md`: What we hold and Who attacks. The rest when the first component exists.
5. The language: Makefile bodies, the Dockerfile build stage, linter config in strict mode, testcontainers in `test`, a Dependabot block, `.env.example`, `api/openapi.yaml`, `README.md`.
6. `deploy/values.yaml` resources. `deploy/application.yaml` waits for ADR 0004.
7. Then the first PR that adds code, with `make check` green for a reason. `grep -rn '<' README.md SECURITY.md api/openapi.yaml` prints nothing except the `<date>` in `SECURITY.md`, which the owner fills after the repo settings are done.

Before changing anything:

8. Read `CONTRIBUTING.md`. It is the rulebook, and review holds you to it.
9. Read `docs/adr/`. Don't relitigate an accepted decision; a change of mind is a new ADR that supersedes it.
10. Read the code where the change lands before introducing a pattern. If an adapter, a helper or a convention already exists, use it.
11. Read `docs/add-when.md`. If the change fires one of its triggers, say so in the PR and do what the entry says.
12. Work on a branch from an issue. The PR title is a Conventional Commit.
13. A change that spans more than one process, datastore or external system is answered against `docs/design-checklist.md` before it is built; its Concurrency section, for any change that touches shared mutable state. Every answer, including "n/a" and why, goes in the PR's Design section.
14. When several designs satisfy the Code section of `CONTRIBUTING.md`, the simplest wins.

Before finishing:

15. Run `make check`. Green is the bar. Don't report done on red.
16. Tests are part of the change, sad path included. `make test-unit` is the loop.
17. A decision that is hard to reverse gets an ADR in the same PR, with "Revisit when" filled.
18. A change to auth, sessions, input handling, crypto or secrets is checked against the relevant OWASP ASVS chapter and cheat sheet, and the PR's Security section names what was checked.
19. A change to a doc, template or config gets a cold review: an agent that has not seen the work that produced it gets `docs/cold-review.md` and the paths it asks for, nothing else. Fix its findings before the PR opens, or say why not in the PR's What and why.
20. Say what you did and what you did not verify.

When reviewing:

21. Approve when the change improves the overall health of the codebase. Block only on what `CONTRIBUTING.md` requires. Say why on every comment; `Nit:` on the optional ones.
