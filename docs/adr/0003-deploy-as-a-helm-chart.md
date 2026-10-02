---
status: "accepted"
date: 2026-09-29
decision-makers: Maurício Azevedo
consulted: none
informed: none
---

# 0003. Deploy as a Helm chart onto the platform cluster

## Context and Problem Statement

This service runs as a container (`Dockerfile`, `compose.yaml`). The platform provides a Kubernetes cluster on AWS, with an ingress controller and an OpenTelemetry collector already running. How does the service describe how it runs there, and how does one command get a commit onto it?

## Decision Drivers

* One command from a commit to the cluster.
* The runtime rules live with the service: non-root, read-only filesystem, probes, limits.
* What the service assumes about the platform is visible, not buried.

## Considered Options

* Plain manifests in the repository, applied with `kubectl`.
* A Helm chart in `deploy/`, installed into a namespace named after the service.
* A cluster or account of the service's own.

## Decision Outcome

Chosen option: "A Helm chart in `deploy/`", because it meets all three drivers.

`make deploy` builds the image, pushes it to the registry, and runs `helm upgrade --install` tagged with the commit. The chart carries the runtime rules: non-root, read-only filesystem, probes on `/healthz` and `/readyz`, resource requests and limits, a graceful shutdown window. Anything the chart assumes about the platform, the collector's address and the ingress class, is a `values.yaml` entry.

### Consequences

* Good, because the service owns its namespace and nothing outside it; the cluster's own configuration is the platform's.
* Good, because the chart is what a GitOps controller would watch if the platform adopts one.
* Bad, because Helm is one more tool to know.

### Confirmation

`make deploy` is the only deploy path in the Makefile, and the chart's templates carry every runtime rule named above.

## Pros and Cons of the Options

### Plain manifests with `kubectl`

* Good, because no extra tool.
* Bad, because the platform's addresses and the image tag are edited into files by hand, or templated by a script that is Helm again.

### A Helm chart

* Good, because values make every platform assumption a visible entry.
* Good, because one command installs or upgrades.
* Bad, because Helm is one more tool to know.

### A cluster or account of its own

* Good, because nothing is shared.
* Bad, because the service then owns a cluster, which is the platform's job, and this ADR's "Revisit when" is the case where that becomes right.

## More Information

The platform cluster is described outside this repository. [Helm](https://helm.sh/).

## Revisit when

The service needs something a namespace cannot give it, such as its own network or its own account. Then it leaves the platform cluster, and this ADR is superseded by the one that says where it went.
