# 0003. One shared EKS cluster from Terraform, one Helm chart per project

Status: accepted

## Context

Every project deploys on AWS as a container (0002 assumes Docker; `compose.yaml` defines one `app` service). Two things have to be chosen: what runs the container, and what writes the infrastructure.

ECS on Fargate is the smallest AWS-native answer and has no control plane fee, and it is AWS-only: its task definitions, service discovery and deployment model transfer nowhere else. EKS costs about $73 a month per cluster before workload and is Kubernetes: the same API on every cloud and on-premises, and the platform that Helm, GitOps controllers, ingress controllers and the observability stacks target first. One cluster shared by every project amortizes the fee to a few dollars per service and matches how Kubernetes is run in practice, one cluster with a namespace per service.

A cluster is created once and outlives every project on it. A project is deployed many times a day. Those lifecycles should not share a repo.

## Decision

One EKS cluster shared by all projects, defined in Terraform in a separate platform repo, one namespace per project. Each project ships a Helm chart in `deploy/` and `make deploy` installs it. The cluster is destroyed when idle and rebuilt from Terraform.

## Consequences

The cluster fee is paid while the cluster exists; `terraform destroy` stops it. The platform repo is a project like the others and follows the skeleton. A project's CI can never touch the cluster. Helm is one more tool to know; its chart is what a GitOps controller would watch later.

## Revisit when

The cluster is up for months with nothing on it, or a project needs something the shared cluster cannot give it (its own account, its own network). Then ECS on Fargate for that project, or its own cluster.
