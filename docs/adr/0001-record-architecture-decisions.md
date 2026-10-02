---
status: "accepted"
date: 2026-10-02
decision-makers: Maurício Azevedo
consulted: none
informed: none
---

# 0001. Record architecture decisions as MADR files in the repository

## Context and Problem Statement

Decisions that shape the system are made in PRs and chat, and the reasons are gone within months. A newcomer finds the shape and not the why, and either relitigates the decision or works around it. Where do decisions and their reasons live, and in what form?

## Decision Drivers

* The why has to survive the people who knew it.
* A reader should recognise the format without learning it here.
* Writing one must cost less than a page, or it goes unwritten.

## Considered Options

* No written record; decisions stay in PRs and chat.
* ADRs in a format of this repository's own.
* ADRs in [MADR](https://adr.github.io/madr/), a published template.

## Decision Outcome

Chosen option: "ADRs in MADR", because it is the only option a reader can look up outside this repository, and it holds the options considered, which a format with context and decision alone does not.

Decisions that are hard to reverse get an ADR in `docs/adr/`, in the PR that makes them, from `template.md`. The template is MADR 4.0 with one added section, "Revisit when". An accepted ADR's decision is not edited; a change of mind is a new ADR that supersedes it, and only the old one's status changes, to point forward. What is frozen is the decision, not the markup: a change of format that leaves every decision as it is may touch every accepted file.

### Consequences

* Good, because the why survives the people who knew it.
* Good, because the format and its tooling are documented outside this repository.
* Bad, because each such PR carries one more file.
* Bad, because an ADR whose "Revisit when" is empty is a decision its author cannot defend, and review has to say so.

### Confirmation

Review checks that a PR making a hard-to-reverse choice carries an ADR, and that the ADR's "Revisit when" names an observable.

## Pros and Cons of the Options

### No written record

* Good, because it costs nothing.
* Bad, because the reasons are gone within months, and the decision gets relitigated or worked around.

### A format of this repository's own

* Good, because it holds exactly what this repository needs and nothing else.
* Bad, because every reader learns it here, and no tool outside this repository reads it.
* Bad, because context, decision and consequences alone leave out the options not taken.

### MADR

* Good, because a reader can look it up, and tooling outside this repository reads it.
* Good, because the options considered and their pros and cons are part of the format.
* Neutral, because its metadata fields assume more than one person; here most read "none".
* Bad, because it has no section for when to reopen the decision, so one is added.

## More Information

MADR 4.0.0, released 2024-09-17. The one deviation, "Revisit when", is a required section after MADR's own: a decision that no evidence could overturn is a preference, and review has to be able to say so.

## Revisit when

ADRs go unwritten for decisions that clearly needed one, or accepted ADRs are being edited in place. Either means the format costs more than it returns and should be lightened, not abandoned.
