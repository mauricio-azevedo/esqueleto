# Design checklist

For a change that touches more than one process, datastore or external system; the Concurrency section, for any change that touches shared mutable state. Answer each question for the change before implementing it. Address the ones that apply; for the rest, "not applicable" is an answer a reviewer may ask you to defend.

## Failure

- The dependency is unavailable. What does the caller do, and what does the user see?
- The call times out. Is the timeout set, and is it shorter than the caller's own?
- The dependency is slow but under the timeout. What fills up: a pool, a queue, threads? Do your own callers degrade with you?
- The call succeeded but the acknowledgment was lost. Is the next attempt safe?
- The operation is retried. Is it idempotent, or does something detect the duplicate?
- The process crashes between two steps. What state is left, and who repairs it?
- The same request or message arrives twice. Same outcome?
- The dependency comes back after an outage. Does the backlog drain, or does it fall over again?

## Data

- Can durable state and an externally visible effect diverge? A row committed and an event never sent, or the reverse.
- Old and new versions of this code run at once during a deploy. Is the schema, the event and the API compatible with both?
- After a failure, is the data recoverable, and from what?
- If users can delete something: can it be undone, for how long, and does the backup retention outlast that window?

## Concurrency

- Is there shared mutable state? What is the strategy: lock, version, single writer, none?
- Two of these run at once. Is there a race, and what prevents it?
- Under overload, what is shed, what queues, and what times out?

## API

- Does a correct caller still work? If not, `!` in the PR title.
- Is input validated where it enters, not deeper?
- Is the error behavior part of the contract, and in the spec?

## Security

- Does this cross a trust boundary in `docs/threat-model.md`? Is the boundary still described correctly?
- Is authorization enforced here, or relied on from elsewhere? Which elsewhere?
- Could anything sensitive reach a log, an error message or a response?
