# Production readiness

Walked before the first production deploy, and again when an ADR changes the architecture. Every box is checked or says why not. Reference: *Site Reliability Engineering* (Google), "Launch Coordination Engineering" and Appendices B and E, and the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

- [ ] SLOs exist for availability and p99 latency, with numbers, in `docs/architecture.md`. The dashboard shows each indicator against its target. The number is achievable with this replica count and the response time the owner can actually give; for one replica and one person that is usually 99.5%, stated honestly.
- [ ] The Targets section of `docs/architecture.md` says what happens for the rest of the month when an SLO is missed: features stop, reliability work starts.
- [ ] Every alert fires on a symptom or a definite imminent cause, is a page or a ticket, and has an entry in `docs/runbook.md`.
- [ ] A probe from outside the cluster hits the public URL, and its alert reaches a channel that does not depend on the cluster, the collector or the service.
- [ ] Latency, traffic, errors and saturation are on a dashboard.
- [ ] `/healthz` and `/readyz` are wired to whatever restarts or routes around the service.
- [ ] Deploy and rollback have each been done once, per `docs/runbook.md`. A deploy is watched on the dashboard for ten minutes after, and not started in the last hour before nobody is watching.
- [ ] Every dependency has a timeout, a retry policy (capped, exponential backoff with jitter, retriable errors only, at one layer), a defined behavior when it is down, and its failures visible on the dashboard. Where: `docs/runbook.md`, Dependencies, lists them.
- [ ] Requests have a server-side deadline, and past a concurrency cap the service returns 503 instead of queueing until it is killed.
- [ ] Expected load is written down, and a load test was run once to the breaking point, with the number and the failure mode in the runbook. A recurring load test exists if throughput or latency is a requirement.
- [ ] A backup has been restored, not just taken, and the restore is on the quarterly schedule. How much data may be lost and how long recovery takes are in `docs/architecture.md`, Targets. The restore procedure is in `docs/runbook.md`.
- [ ] Secrets live in a manager, not in `.env` on a server, and rotation has been done once.
- [ ] `docs/threat-model.md` is filled, accepted risks included.
- [ ] An owner is named and reachable when it breaks. Where: `docs/runbook.md`, the Owner line.
- [ ] On SIGTERM, in-flight requests finish before the process exits.
- [ ] Expected monthly cost is written down and an AWS Budgets alert exists at that number.
- [ ] The workload has a Well-Architected review in the AWS console. Each high-risk item is fixed or listed under Why not.

## Why not

<For each unchecked box: the reason, and when to revisit.>
