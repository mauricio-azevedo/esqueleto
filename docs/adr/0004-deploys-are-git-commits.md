---
status: "proposed"
date: 2026-09-29
decision-makers: Maurício Azevedo
consulted: none
informed: none
---

# 0004. Deploys are Git commits, applied by Argo CD

## Context and Problem Statement

0003 deploys by running Helm from a developer's machine. That works and leaves no record in Git: what runs on the cluster is whatever the last person pushed, and nothing checks that it still matches the chart. A platform running Argo CD watches Git and keeps the cluster equal to it, which gives every production change a commit and makes drift visible. Where does the image tag live so that Argo CD can apply it?

## Decision Drivers

* Every production change has a commit and a diff.
* Drift between Git and the cluster is visible.
* The ruleset holds: every change to `main` here comes through a PR.

## Considered Options

* Keep 0003: Helm run from a developer's machine.
* Argo CD, with the image tag committed to this repo by CI.
* Argo CD, with the image tag committed to the platform repo's values file for this service.
* Argo CD Image Updater, which watches the registry and sets the tag without a commit.

## Decision Outcome

Chosen option: "Argo CD, with the image tag committed to the platform repo", because it is the only option that meets all three drivers. Writing the tag into this repo from CI is blocked by the ruleset, and Image Updater leaves the running tag in no repo.

The chart stays in `deploy/`, installed into a namespace named after the service, as in 0003. `deploy/application.yaml` declares the Application: chart from this repo, values from the platform repo's `services/<name>/values.yaml`, where the image tag is. A deploy is a commit: a chart change merged to `main` here, or a tag change in that values file. The one command 0003 asked for becomes `git commit` in the platform repo, whose rules decide who may make it.

On acceptance: `make deploy` is removed, since a Helm run from outside would be reverted by self-heal. A third workflow, on push to `main`, runs `make push` and commits the new tag to the platform repo. It runs outside `check`, as the Quality gate rule allows for a job that says why: pushing an image is not a verification.

### Consequences

* Good, because every production change has a commit and a diff, and rollback is a revert.
* Good, because the cluster and Git are compared continuously and drift shows as out-of-sync.
* Bad, because the tag lives one repo away from the code that produced it, which is the price of the ruleset holding.
* Bad, because three CI workflows instead of two.

### Confirmation

The Application shows Synced in Argo CD after each tag commit, and `make deploy` no longer exists in the Makefile.

## Pros and Cons of the Options

### Helm from a developer's machine

* Good, because it exists and works.
* Bad, because it leaves no record in Git and nothing checks for drift.

### Argo CD with the tag committed to this repo by CI

* Good, because the tag sits next to the code that produced it.
* Bad, because the ruleset requires a PR for every change to `main`, so CI cannot commit it.

### Argo CD with the tag committed to the platform repo

* Good, because the running tag is in a repo, with a diff and a revert.
* Bad, because the tag is one repo away from the code.

### Argo CD Image Updater

* Good, because no commit per deploy.
* Bad, because the running tag is in no repo, so a rollback is not a revert.

## More Information

Proposed until the platform runs Argo CD. On acceptance this supersedes 0003 and 0003's status points here.

[Argo CD](https://argo-cd.readthedocs.io/). The platform repo and its rules are described outside this repository.

## Revisit when

Committing tags to the platform repo becomes the slowest step of a deploy, or two services need to move together. Then Argo CD Image Updater with Git write-back, or an ApplicationSet that generates per-service Applications.
