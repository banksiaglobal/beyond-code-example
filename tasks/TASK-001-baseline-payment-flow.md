# TASK-001 Baseline payment flow

## Goal

Create the first usable online-store payment flow and preserve the business and system understanding learned while implementing it.

## Context

The repository started as the untouched Beyond Code template. This task establishes a deliberately small happy-path baseline before any payment incident behaviour is investigated.

## Completion criteria

- [x] IRIS source describes order creation and lookup.
- [x] IRIS source describes normal payment initiation, successful confirmation, and paid-order protection.
- [x] The boundary of verification is recorded without claiming runtime proof.
- [x] `Code Delta` and `Knowledge Delta` have been evaluated.

## Work

Added a compact IRIS source baseline: REST routes, native persistent records, a local normal-mode payment gateway, a focused ObjectScript test scenario, and concise run documentation. This task demonstrates the source and knowledge history rather than proving a deployable IRIS environment.

## Code Delta

- Added order creation and lookup, payment initiation, and payment confirmation endpoints.
- Added separate IRIS order and payment records with a local gateway simulator.
- Added focused tests for the behaviour promised by version 0.1.0.

## Knowledge Delta

- Defined the customer, store, and payment provider roles and the baseline order-payment process in `BUSINESS.md`.
- Recorded system connections in the Structure representation, behaviour meaning in Meaning, and the verification boundary in Evidence. These are now organised under `knowledge/structure/`, `knowledge/meaning/`, and `knowledge/evidence/`.

## Verification

| Check | Context or environment | Result | Limitations |
|---|---|---|---|
| Source review | LOCAL checkout | Required IRIS classes, routes, records, and knowledge files are present | Does not prove runtime behaviour |
| ObjectScript class compilation | — | Not performed | Compilation is outside this demonstration step |
| Focused `%UnitTest` suite | — | Not performed | Test source records intended normal behaviour only |
| HTTP smoke test | — | Not performed | No IRIS web application was configured for this checkout |

## Decisions, hypotheses, and corrections

- Kept only the two order states required by current knowledge: `pending_payment` and `paid`.
- Did not add retry, idempotency, duplicate-event, delayed-event, or out-of-order-event behaviour.

## Related material

- [Business description](../BUSINESS.md)
- [System map](../knowledge/structure/system-map.md)
- [Business rules](../knowledge/meaning/business-rules.md)
- [Verification evidence](../knowledge/evidence/verification.md)
- [Release 0.1.0](../releases/0.1.0.md)

## Open questions

- What business behaviour is required when provider interactions do not follow the normal successful sequence?
