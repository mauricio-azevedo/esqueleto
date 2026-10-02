# Agents

First day. If `README.md` still says `<name>`, this project has not started. On day one the owner answers for every stakeholder. Ask the questions below in order; each answer fills the places in its Fills column. An answer the owner does not have becomes a row in `docs/product.md` Open questions, with the issue that will decide it in the Decided column. A number the owner does not give stays a placeholder. Don't invent anything.

| # | Ask | Fills |
|---|---|---|
| 1 | What value does it deliver, in one sentence | `docs/product.md` Objective; `docs/architecture.md` What it does; issue 1 title |
| 2 | For whom, and what running it may cost a month | Objective; Targets, monthly cost |
| 3 | The three most important functions | Requirements |
| 4 | How much time to spend before the work stops, finished or not | Issue 1, appetite |
| 5 | What it deliberately will not do | Out of scope; issue 1, no-gos |
| 6 | The three quality attributes that matter, ranked | Targets, each as a number |
| 7 | Neighbouring systems and external interfaces | Boundaries; the C4 context diagram |
| 8 | Major building blocks, if already seen | Components; the C4 container diagram |
| 9 | Technologies already decided | Step 5; an ADR if hard to reverse |
| 10 | Decisions already made | The first ADRs |
| 11 | What data is worth attacking, and who would | `docs/threat-model.md` What we hold, Who attacks |
| 12 | Biggest risk, and what is not known yet | Issue 1, rabbit holes; Open questions |

Questions 1 to 3, 6 to 10 and 12 are the boxes of the [Architecture Communication Canvas](https://canvas.arc42.org/); 4 and 5 are from the [Shape Up pitch](https://basecamp.com/shapeup/1.5-chapter-06); 11 is the first-day pair of `docs/threat-model.md`. Then, in order:

1. Open issue 1 with the Feature request form. Problem: the pitch's problem and appetite. Proposal: the solution sketch and a task list of the files in steps 2 to 4. Alternatives considered: rabbit holes and no-gos. The PR that writes the files closes it. Every branch starts from an issue, including the first.
2. Fill `docs/product.md`: objective, success metrics, requirements, open questions, out of scope.
3. `docs/architecture.md`: What it does, summarising `docs/product.md`, and Targets, even rough. The decisions this forces go in `docs/adr/`.
4. `docs/threat-model.md`: What we hold and Who attacks. The rest when the first component exists.
5. The language: Makefile bodies, the Dockerfile build stage, linter config in strict mode, testcontainers in `test`, a Dependabot block, `.env.example`, `api/openapi.yaml`, `README.md`.
6. `deploy/values.yaml` resources. `deploy/application.yaml` waits for ADR 0004.
7. Then the first PR that adds code, with `make check` green for a reason. Building starts when three things hold: `docs/product.md` and the What it does and Targets sections of `docs/architecture.md` have no placeholder that is not also a row in Open questions; every hard-to-reverse choice has an ADR; and `grep -rn '<' README.md SECURITY.md api/openapi.yaml` prints nothing except the `<date>` in `SECURITY.md`, which the owner fills after the repo settings are done.

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
