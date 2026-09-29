# 0004. Deploys are Git commits, applied by Argo CD

Status: proposed. Accepted if and when the platform runs Argo CD; on acceptance this supersedes 0003 and 0003's status points here.

## Context

0003 deploys by running Helm from a developer's machine. That works and leaves no record in Git: what runs on the cluster is whatever the last person pushed, and nothing checks that it still matches the chart. A platform running Argo CD watches Git and keeps the cluster equal to it, which gives every production change a commit and makes drift visible.

The image tag has to live in Git for that to work. Writing it into this repo from CI is blocked by the ruleset, which requires a PR for every change to `main`. Argo CD Image Updater can watch the registry and set the tag without a commit, at the cost of the running tag not being in any repo.

## Decision

The chart stays in `deploy/`, installed into a namespace named after the service, as in 0003. `deploy/application.yaml` declares the Application: chart from this repo, values from the platform repo's `services/<name>/values.yaml`, where the image tag is. A deploy is a commit: a chart change merged to `main` here, or a tag change in that values file. The one command 0003 asked for becomes `git commit` in the platform repo, whose rules decide who may make it.

On acceptance: `make deploy` is removed, since a Helm run from outside would be reverted by self-heal. A third workflow, on push to `main`, runs `make push` and commits the new tag to the platform repo. It runs outside `check`, as the Quality gate rule allows for a job that says why: pushing an image is not a verification.

## Consequences

Every production change has a commit and a diff. Rollback is a revert. The cluster and Git are compared continuously and drift shows as out-of-sync. The tag lives one repo away from the code that produced it, which is the price of the ruleset holding. Three CI workflows instead of two.

## Revisit when

Committing tags to the platform repo becomes the slowest step of a deploy, or two services need to move together. Then Argo CD Image Updater with Git write-back, or an ApplicationSet that generates per-service Applications.
