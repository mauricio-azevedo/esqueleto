---
status: "accepted"
date: 2026-09-29
decision-makers: Maurício Azevedo
consulted: none
informed: none
---

# 0002. Tests start their own dependencies

## Context and Problem Statement

Tests that touch a database run against a real one, not a mock (CONTRIBUTING, Testing). That database has to come from somewhere. Where does a test run get its database?

## Decision Drivers

* Test runs must not share state with each other or with development.
* Two runs at once must not collide.
* A bad test must not be able to wipe development data.

## Considered Options

* Tests use the database `make dev` runs.
* Each test run starts its own throwaway container with testcontainers.

## Decision Outcome

Chosen option: "Each test run starts its own throwaway container with testcontainers", because it is the only option that meets all three drivers: each run begins with an empty database and ends by discarding it. `make test` needs no service running first; Docker is the one prerequisite.

### Consequences

* Good, because the dev database is never touched by tests.
* Good, because parallel runs are safe.
* Bad, because of one library per language and a few seconds of container startup per run.
* Neutral, because Docker is required to run tests, which it already is for `make dev`.

### Confirmation

`make test` passes on a machine with Docker and no service started. CI runs it without service containers.

## Pros and Cons of the Options

### The database `make dev` runs

* Good, because no library and no startup time.
* Bad, because runs share state with each other and with whatever the developer was doing, so cleanup becomes every test's job.
* Bad, because two runs at once collide, and a bad test can wipe development data. These are the usual sources of order-dependent and flaky database tests.

### Testcontainers

* Good, because each run starts empty and ends discarded.
* Good, because the library exists for the languages a service here is likely to use.
* Bad, because a few seconds of startup per run.

## More Information

[Testcontainers](https://testcontainers.com/).

## Revisit when

A language in use has no testcontainers library, or container startup pushes `make test` past what people run before every push. The fallback is the dev database with a reset before each run, and it is a fallback, not a return.
