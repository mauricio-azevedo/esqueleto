# Runbook

For whoever is on call and has never seen the code. Commands, not descriptions.

1. If it started after a deploy, roll back first and diagnose after.
2. Write down what you did, with times, as you go. The postmortem needs it.
3. After an hour without progress, or as soon as users can see it, call the second person named below.

Owner: <name, and how to reach them when it breaks>
Second person: <name, and how to reach them>

## Deploy and roll back

<How to deploy, how to tell it worked, how to roll back, how to tell that worked.>

## Alerts

<One entry per alert. Page or ticket. What it detects. What changed last: the deploy log is the first thing to check. Then what to check next, the fix that usually works, who to wake if it doesn't.>

### <alert name>

## Rare and dangerous

<Rotate a secret. Restore from backup. Run a migration by hand. Drain a queue. Each with the exact commands.>

## Dependencies

<What this service needs to run, who owns each, where its status page is, its timeout and retry policy, what the service does without it. Also the load test's breaking point and how it failed.>
