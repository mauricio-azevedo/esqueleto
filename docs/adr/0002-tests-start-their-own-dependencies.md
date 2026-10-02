---
status: "accepted"
date: 2026-09-29
decision-makers: Maurício Azevedo
consulted: none
informed: none
---

# 0002. Tests start their own dependencies

## Context and Problem Statement

Tests that touch a database run against a real one, not a mock (CONTRIBUTING, Testing). That database has to come from somewhere.

## Considered Options

* Tests use the database `make dev` runs.
* Each test run starts its own throwaway container with testcontainers.

## Decision Outcome

Chosen option: "Each test run starts its own throwaway container with testcontainers". Sharing the dev database means test runs share state with each other and with whatever the developer was doing. Cleanup becomes every test's job, two runs at once collide, and a bad test can wipe development data. Those are the usual sources of order-dependent and flaky database tests.

`make test` needs no service running first; Docker is the one prerequisite. Each run begins with an empty database and ends by discarding it.

### Consequences

* Good, because the dev database is never touched by tests.
* Good, because parallel runs are safe.
* Bad, because each language needs a testcontainers library and each run pays a few seconds of container startup.
* Bad, because Docker is required to run tests. It already is for `make dev`, so nothing new is installed.

### Confirmation

`make test` passes with no service started.

## Revisit when

A language in use has no testcontainers library, or container startup pushes `make test` past what people run before every push. The fallback is the dev database with a reset before each run, and it is a fallback, not a return.
