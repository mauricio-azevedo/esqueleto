# 0002. Tests start their own dependencies

Status: accepted

## Context

Tests that touch a database run against a real one, not a mock (CONTRIBUTING, Testing). That database has to come from somewhere. Two options: the tests use the one `make dev` runs, or each test run starts its own throwaway container with testcontainers.

Sharing the dev database means test runs share state with each other and with whatever the developer was doing. Cleanup becomes every test's job, two runs at once collide, and a bad test can wipe development data. Those are the usual sources of order-dependent and flaky database tests.

## Decision

Tests start their own dependencies with testcontainers. `make test` needs no service running first; Docker is the one prerequisite. Each run begins with an empty database and ends by discarding it.

## Consequences

One library per language and a few seconds of container startup per run. Docker is required to run tests, which it already is for `make dev`. The dev database is never touched by tests. Parallel runs are safe.

## Revisit when

A language in use has no testcontainers library, or container startup pushes `make test` past what people run before every push. The fallback is the dev database with a reset before each run, and it is a fallback, not a return.
