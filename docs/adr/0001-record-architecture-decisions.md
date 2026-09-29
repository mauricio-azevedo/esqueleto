# 0001. Record architecture decisions

Status: accepted

## Context

Decisions that shape the system are made in PRs and chat, and the reasons are gone within months. A newcomer finds the shape and not the why, and either relitigates the decision or works around it.

## Decision

Decisions that are hard to reverse get an ADR in `docs/adr/`, in the PR that makes them, using `template.md`. An accepted ADR's body is not edited; a change of mind is a new ADR that supersedes it, and only the old one's status line changes, to point forward.

## Consequences

Each such PR carries one more file, under a page. The why survives the people who knew it. An ADR whose "Revisit when" is empty is a decision its author cannot defend, and review says so.

## Revisit when

ADRs go unwritten for decisions that clearly needed one, or accepted ADRs are being edited in place. Either means the format costs more than it returns and should be lightened, not abandoned.
