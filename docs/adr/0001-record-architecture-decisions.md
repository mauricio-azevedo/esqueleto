---
status: "accepted"
date: 2026-09-29
decision-makers: Maurício Azevedo
consulted: none
informed: none
---

# 0001. Record architecture decisions in the repository

## Context and Problem Statement

Decisions that shape the system are made in PRs and chat, and the reasons are gone within months. A newcomer finds the shape and not the why, and either relitigates the decision or works around it.

## Considered Options

* Decisions stay in the PRs and chat that made them.
* One file per decision in `docs/adr/`, in the PR that makes it.

## Decision Outcome

Chosen option: "One file per decision in `docs/adr/`", because the PR and the chat are gone within months and the file is not.

Decisions that are hard to reverse get an ADR in `docs/adr/`, in the PR that makes them, from `template.md`. An accepted ADR's decision is not edited; a change of mind is a new ADR that supersedes it, and only the old one's status changes, to point forward.

### Consequences

* Good, because the why survives the people who knew it.
* Bad, because each such PR carries one more file, under a page.

### Confirmation

Review rejects an ADR whose "Revisit when" is empty: a decision no evidence could overturn is a preference.

## More Information

The template is [MADR](https://adr.github.io/madr/) 4.0 with one added section, "Revisit when". A change of template is applied to every file; the decisions do not change with it.

## Revisit when

ADRs go unwritten for decisions that clearly needed one, or accepted decisions are being changed in place. Either means the format costs more than it returns and should be lightened, not abandoned.
