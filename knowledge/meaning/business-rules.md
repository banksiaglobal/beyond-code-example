# Business rules

## Human correction

Following the ambiguous-timeout investigation, a domain expert corrected the earlier framing: one order does not imply one payment attempt.

> An order may have multiple payment attempts, but it must not have more than one successful payment.

This rule comes from human/domain correction, not from AI inference over the source. The correction and its evidence history are recorded in [incident evidence](../evidence/incidents.md#2026-08-16--human-correction-of-the-payment-invariant).

## Current rules

| Rule | Reason | Evidence |
|---|---|---|
| A new order awaits payment | Creation alone does not prove money was collected | [Baseline verification](../evidence/verification.md#2026-08-16--baseline-payment-flow) |
| An order may legitimately have multiple payment attempts | Declines, failures, and ambiguous outcomes may require another attempt | [Human correction](../evidence/incidents.md#2026-08-16--human-correction-of-the-payment-invariant) |
| An order must not have more than one successful payment | Only one successful financial outcome may complete the order | [Human correction](../evidence/incidents.md#2026-08-16--human-correction-of-the-payment-invariant) |
| Provider confirmation is what currently allows the store to regard a payment as successful | A request or caller timeout alone does not establish success | [Baseline verification](../evidence/verification.md#2026-08-16--baseline-payment-flow) |
| An already paid order must not intentionally start another payment | The order already has its successful financial outcome | [Baseline verification](../evidence/verification.md#2026-08-16--baseline-payment-flow) |

## Important distinctions

Order, payment attempt, provider-side charge, accepted provider charge, successful payment, store-observed timeout, and order state are separate concepts. See [order lifecycle](../structure/order-lifecycle.md) and [payment integration](../structure/payment-integration.md).

## Unknowns

- The mechanism that will enforce the corrected invariant has not been selected.
- The authority and policy for retry after an ambiguous timeout remain open.
