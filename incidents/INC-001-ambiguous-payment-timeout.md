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
