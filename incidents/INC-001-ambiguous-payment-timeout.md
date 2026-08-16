# INC-001 Ambiguous payment timeout

## Symptom

A customer retries payment after a timeout, and the provider may receive two charge requests for the same order.

## Initial hypothesis

The duplicate payment may be caused by the customer clicking **Pay** twice. This is a plausible hypothesis, not an established fact.

## Investigation

Source inspection showed that a provider can record an accepted charge before the store receives a response. The `timeout_after_acceptance` simulator behaviour makes that ordering visible: it records the provider-side charge, then returns an ambiguous timeout without creating a local payment record. A later normal retry sends a new request and creates another provider-side charge.

## Finding

A timeout is evidence about what the store observed, not proof that the provider rejected or did not execute the operation. Retrying the business operation after that timeout is sufficient to create a second provider-side charge request; an intentional double click is not required.

This reproduction shows two provider-side charges for one order and one successful local payment record. It does not establish that the customer was charged twice.

## Evidence

- [Incident reproduction test](../tests/BeyondCode/DuplicatePaymentIncidentTest.cls)
- [Gateway simulator ledger and timeout behaviour](../src/BeyondCode/PaymentGatewaySimulator.cls)
- [Store handling of the ambiguous response](../src/BeyondCode/PaymentService.cls)

The source and test scenario were reviewed. The ObjectScript was not compiled and the test was not executed.

## Unknowns

- Should an order have exactly one payment record?
- Can an order legitimately have several payment attempts?
- Is the real invariant one attempt, one accepted provider charge, or one successful charge?
- Who decides whether retry after an ambiguous timeout is allowed?

## Resolution in 0.2.0

The human correction established that an order may have several payment attempts but must not have more than one successful payment. That knowledge drove a narrow implementation response: each attempt now has a stable `AttemptKey`, is persisted before provider invocation, and is sent to the simulator with the same identity.

Retrying the same attempt reuses its existing local record and provider-side charge. A different key remains a different legitimate attempt while the order is unpaid. The updated [incident regression test](../tests/BeyondCode/DuplicatePaymentIncidentTest.cls) represents the original ambiguous timeout followed by a successful same-key retry with only one provider-side charge.

The changed ObjectScript and test source were reviewed, but they were not compiled or executed. The resolution covers the represented sequential simulator flow, not concurrent processing, real-provider reconciliation, or webhook deduplication.
