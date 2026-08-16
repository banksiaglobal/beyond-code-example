# TASK-002 Investigate ambiguous payment timeout

## Goal

Reproduce and document how retrying payment after an ambiguous provider timeout can create two provider-side charges for one order, without implementing a fix.

## Context

The 0.1.0 baseline covered only a normal successful provider response. This task investigates the plausible hypothesis that duplicate payment requires a customer to click **Pay** twice.

## Completion criteria

- [x] The ambiguous-timeout scenario is represented in the simulator and focused test source.
- [x] The incident finding and unresolved business questions are preserved.
- [x] No corrective payment behaviour is included.
- [x] `Code Delta` and `Knowledge Delta` have been evaluated.

## Work

Added a transparent provider-side ledger and `timeout_after_acceptance` behaviour. The incident test source models one ambiguous attempt followed by a normal retry and compares provider-side charges with local payment records.

## Code Delta

- Added demonstration and investigation behaviour to reproduce the incident.
- Added an incident test source that exposes the undesirable current outcome.
- No production fix was implemented.

## Knowledge Delta

- Recorded that caller-observed timeout and provider-side execution are independent facts; after the Example 03 reclassification this is captured in `knowledge/structure/payment-integration.md`.
- Preserved the source evidence, weakened initial hypothesis, and runtime boundary; these are now organised under `knowledge/evidence/`.
- Added the provider-side ledger to the Structure representation and the investigation narrative to `incidents/INC-001-ambiguous-payment-timeout.md`.

## Verification

| Check | Context or environment | Result | Limitations |
|---|---|---|---|
| Source review | LOCAL checkout | Scenario and asymmetry are represented | Does not prove runtime behaviour |
| `git diff --check` | LOCAL checkout | Passed | Formatting check only |
| ObjectScript compilation | — | Not performed | Source-level demonstration only |
| Incident `%UnitTest` | — | Not executed | Test source is an incident reproduction, not a passing runtime result |

## Decisions, hypotheses, and corrections

- **Initial hypothesis, weakened:** Duplicate payment requires an explicit customer double click. The source scenario shows that a retry after an ambiguous timeout is sufficient to create the risk.
- Kept provider acceptance, provider success, local payment persistence, and paid order state as distinct observations.
- Did not choose a retry policy or final business invariant.

## Related material

- [Incident record](../incidents/INC-001-ambiguous-payment-timeout.md)
- [Payment integration](../knowledge/structure/payment-integration.md)
- [Business rules](../knowledge/meaning/business-rules.md)
- [Incident evidence](../knowledge/evidence/incidents.md)

## Open questions

- What invariant should govern payment attempts and provider charges after an ambiguous timeout?
