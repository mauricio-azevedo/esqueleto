# Threat model

Filled when the first real component exists, revised when a boundary changes. Reference: [OWASP Threat Modeling Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Threat_Modeling_Cheat_Sheet.html).

## What we hold

<The data worth attacking: personal data, credentials, money, anything regulated. Where each lives.>

## Who attacks

<Anonymous internet, authenticated users, insiders, a compromised dependency. What each can reach.>

## Trust boundaries

<Where untrusted input enters, where privilege changes, where we call something we don't control. One line each.>

## What each boundary defends against

<For each boundary: the attack it stops, the control that stops it, the ASVS items that verify it.>

## Accepted risks

<What we chose not to defend against, why, and when to revisit.>
