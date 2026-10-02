---
status: "accepted"
date: 2026-09-29
decision-makers: Maurício Azevedo
consulted: none
informed: none
---

# 0003. Deploy as a Helm chart onto the platform cluster

## Context and Problem Statement

This service runs as a container (`Dockerfile`, `compose.yaml`). The platform provides a Kubernetes cluster on AWS, with an ingress controller and an OpenTelemetry collector already running. The service needs a way to describe how it runs there, and one command to get a commit onto it.

## Considered Options

* A Helm chart in `deploy/`, installed into a namespace named after the service, on the platform cluster.
* A cluster, network or account of the service's own, outside the platform.

## Decision Outcome

Chosen option: "A Helm chart in `deploy/`, installed into a namespace named after the service", because the platform already runs the cluster and a chart is the one file that describes how the service runs there.

`make deploy` builds the image, pushes it to the registry, and runs `helm upgrade --install` tagged with the commit. The chart carries the runtime rules: non-root, read-only filesystem, probes on `/healthz` and `/readyz`, resource requests and limits, a graceful shutdown window.

### Consequences

* Good, because the service owns its namespace and nothing outside it; the cluster's own configuration is the platform's.
* Good, because the chart is what a GitOps controller would watch if the platform adopts one.
* Good, because anything the chart assumes about the platform, the collector's address and the ingress class, is a `values.yaml` entry so the assumption is visible.
* Bad, because Helm is one more tool to know.

## Revisit when

The service needs something a namespace cannot give it, such as its own network or its own account. Then it leaves the platform cluster, and this ADR is superseded by the one that says where it went.
