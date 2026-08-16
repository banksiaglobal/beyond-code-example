# TASK-004 Fix and ship

## Goal

Use the knowledge accumulated through INC-001 and the human business correction to fix ambiguous payment retries and describe version 0.2.0.

## Context

Earlier work established before implementation that a store-observed timeout does not prove provider non-execution, that retry is not automatically a new payment attempt, and that multiple attempts may be legitimate while no more than one successful payment may complete an order.

## Completion criteria

- [x] A same-key retry reuses the local attempt and provider-side charge.
- [x] Different keys remain different attempts while the order is unpaid.
- [x] The paid-order and successful-payment protections remain represented.
- [x] Release, deployment, incident, and focused knowledge updates describe the new behaviour and its limits.

## Work

Added stable payment-attempt identity to the IRIS source, changed the payment flow to persist an attempt before provider invocation, made the simulator reuse provider operations by attempt key, and changed the INC-001 source scenario into a focused regression scenario.

## Code Delta

- Introduced `AttemptKey` as the stable identity of a persisted payment attempt.
- Persisted a `pending` attempt before calling the provider simulator.
- Made same-key provider retries reuse the existing provider-side charge.
- Kept different keys as distinct attempts and rejected new attempts after the order is paid.
- Added a sequential successful-payment guard and focused regression test source.

## Knowledge Delta

- Retry of an existing attempt and creation of a new attempt are now explicit, different operations.
- The selected attempt-key mechanism is an engineering decision derived from previously preserved business and incident knowledge.
- Deployment verification now includes the ambiguous-timeout path and a reusable diagnostic for multiple local successes.

Most knowledge needed for this implementation existed before coding began; this task primarily converts that knowledge into Code Delta, tests, release knowledge, and deployment knowledge.

## Verification

| Check | Context or environment | Result | Limitations |
|---|---|---|---|
| ObjectScript source review | LOCAL checkout | Passed: changed classes and all call sites reviewed | Does not prove compilation or runtime behaviour |
| Regression test source review | LOCAL checkout | Passed: same-key retry, different keys, and paid-order protection represented | Tests are descriptive until executed |
| ObjectScript compilation | — | Not performed | No immediately available project IRIS runtime identified |
| `%UnitTest` execution | — | Not performed | No immediately available project IRIS runtime identified |
| Documentation and diff checks | LOCAL checkout | Passed: formatting, local links and anchors, release links, knowledge file count, and scope checks | Repository-level checks only |

## Decisions, hypotheses, and corrections

- **Previously stored knowledge used:** timeout does not prove provider non-execution; payment attempt and successful payment are distinct; several attempts may be legitimate; an order must not have more than one successful payment.
- **Implementation decision:** use a stable `AttemptKey` so transport retries reuse the same business attempt and simulator operation.
- **Scope limit:** the successful-payment guard represents a sequential flow and is not claimed as a strong concurrent or distributed guarantee.

## Related material

- [INC-001](../incidents/INC-001-ambiguous-payment-timeout.md)
- [Payment integration](../knowledge/structure/payment-integration.md)
- [Implementation decisions](../knowledge/meaning/decisions.md)
- [Verification evidence](../knowledge/evidence/verification.md)
- [Release 0.2.0](../releases/0.2.0.md)
- [Deployment guidance](../deployment/DEPLOY.md)

## Open questions

- How a real provider exposes idempotent operation lookup and reconciliation remains outside this example.
