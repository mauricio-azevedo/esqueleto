---
status: "accepted"
date: 2026-10-02
decision-makers: Maurício Azevedo
consulted: none
informed: none
---

# 0001. Record architecture decisions as MADR files in the repository

## Context and Problem Statement

Decisions that shape the system are made in PRs and chat, and the reasons are gone within months. A newcomer finds the shape and not the why, and either relitigates the decision or works around it.

## Considered Options

* ADRs in a format of this repository's own, which is what the first version of this ADR chose.
* ADRs in [MADR](https://adr.github.io/madr/), a published template.

## Decision Outcome

Chosen option: "ADRs in MADR", because a published format is one a reader can look up outside this repository.

Decisions that are hard to reverse get an ADR in `docs/adr/`, in the PR that makes them, from `template.md`. The template is MADR 4.0 with one added section, "Revisit when", which MADR does not have. An accepted ADR's decision is not edited; a change of mind is a new ADR that supersedes it, and only the old one's status changes, to point forward. What is frozen is the decision, not the markup: a change of format that leaves every decision as it is may touch every accepted file.

### Consequences

* Good, because the why survives the people who knew it.
* Bad, because each such PR carries one more file, under a page.
* Bad, because an ADR whose "Revisit when" is empty is a decision its author cannot defend, and review says so.

## Revisit when

ADRs go unwritten for decisions that clearly needed one, or accepted ADRs are being edited in place. Either means the format costs more than it returns and should be lightened, not abandoned.
