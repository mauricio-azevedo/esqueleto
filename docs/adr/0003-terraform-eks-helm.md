# 0003. One shared EKS cluster from Terraform, one Helm chart per project

Status: accepted

## Context

Every project deploys on AWS as a container (0002 assumes Docker; `compose.yaml` defines one `app` service). Two things have to be chosen: what runs the container, and what writes the infrastructure.

ECS on Fargate is the smallest AWS-native answer and has no control plane fee. EKS costs about $73 a month per cluster before workload and is Kubernetes, which is the same on every cloud and in every company that runs it. The projects exist to learn and to be relevant on the market; Kubernetes and Terraform are the two words that get matched, and Kubernetes is what most of the surrounding tooling (Helm, Argo CD, observability stacks) sits on.

A cluster is created once and outlives every project on it. A project is deployed many times a day. Those lifecycles should not share a repo.

## Decision

One EKS cluster shared by all projects, defined in Terraform in a separate platform repo, one namespace per project. Each project ships a Helm chart in `deploy/` and `make deploy` installs it. The cluster is destroyed when idle and rebuilt from Terraform.

## Consequences

The cluster fee is paid while the cluster exists; `terraform destroy` stops it. The platform repo is a project like the others and follows the skeleton. A project's CI can never touch the cluster. Helm is one more tool to know; its chart is what a GitOps controller would watch later.

## Revisit when

The cluster is up for months with nothing on it, or a project needs something the shared cluster cannot give it (its own account, its own network). Then ECS on Fargate for that project, or its own cluster.
