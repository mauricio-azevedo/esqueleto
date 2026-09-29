# 0003. Deploy as a Helm chart onto the platform cluster

Status: accepted

## Context

This service runs as a container (`Dockerfile`, `compose.yaml`). The platform provides a Kubernetes cluster on AWS, with an ingress controller and an OpenTelemetry collector already running. The service needs a way to describe how it runs there, and one command to get a commit onto it.

## Decision

The service ships a Helm chart in `deploy/`, installed into a namespace named after the service. `make deploy` builds the image, pushes it to the registry, and runs `helm upgrade --install` tagged with the commit. The chart carries the runtime rules: non-root, read-only filesystem, probes on `/healthz` and `/readyz`, resource requests and limits, a graceful shutdown window.

## Consequences

The service never touches the cluster itself; it only owns its namespace. Helm is one more tool to know. The chart is what a GitOps controller would watch if the platform adopts one. Anything the chart assumes about the platform, the collector's address and the ingress class, is a `values.yaml` entry so the assumption is visible.

## Revisit when

The service needs something a namespace cannot give it, such as its own network or its own account. Then it leaves the shared cluster, and this ADR is superseded by the one that says where it went.
