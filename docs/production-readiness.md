# Production readiness

Walked before the first production deploy, and again when an ADR changes the architecture. Every box is checked or says why not. Reference: Google SRE, *Site Reliability Engineering*, the Production Readiness Review, and the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

- [ ] SLOs exist for availability and latency, with numbers. Where: `docs/adr/` or below.
- [ ] Every alert fires on a symptom and has an entry in `docs/runbook.md`.
- [ ] Latency, traffic, errors and saturation are on a dashboard.
- [ ] `/healthz` and `/readyz` are wired to whatever restarts or routes around the service.
- [ ] Deploy and rollback have each been done once, per `docs/runbook.md`.
- [ ] Every dependency has a timeout, a retry policy, and a defined behavior when it is down. Where: `docs/threat-model.md` lists them.
- [ ] Expected load is written down. A load test exists if throughput or latency is a requirement.
- [ ] A backup has been restored, not just taken. Where: `docs/runbook.md`.
- [ ] Secrets live in a manager, not in `.env` on a server, and rotation has been done once.
- [ ] `docs/threat-model.md` is filled, accepted risks included.
- [ ] An owner is named and reachable when it breaks. Where: `docs/runbook.md`, Dependencies.
- [ ] On SIGTERM, in-flight requests finish before the process exits.
- [ ] Expected monthly cost is written down and an AWS Budgets alert exists at that number.
- [ ] The workload has a Well-Architected review in the AWS console. Each high-risk item is fixed or listed under Why not.

## Why not

<For each unchecked box: the reason, and when to revisit.>
