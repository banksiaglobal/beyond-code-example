# Meaning

This file describes why parts of the system exist, what value they support, and which business rules they implement.

## System capabilities

| Capability | Purpose | Who receives value |
|---|---|---|
| Create and inspect an order | Gives the store a record of an amount awaiting payment | Customer and store |
| Start payment | Asks the payment provider to collect the order amount | Customer and store |
| Process payment confirmation | Lets provider evidence change the order from awaiting payment to paid | Store |

## Business rules

| Rule | Reason | Evidence |
|---|---|---|
| A new order is `pending_payment` | Creation alone does not prove that money was collected | [Baseline evidence](evidence.md#2026-08-16--baseline-payment-flow) |
| Starting payment records a payment separately from its order | The provider interaction and the commercial order represent different facts | [Baseline evidence](evidence.md#2026-08-16--baseline-payment-flow) |
| Only successful provider confirmation makes an order `paid` | Provider confirmation is the current proof of successful payment | [Baseline evidence](evidence.md#2026-08-16--baseline-payment-flow) |
| An already paid order must not intentionally start another payment | The store already has the outcome requested for that order | [Baseline evidence](evidence.md#2026-08-16--baseline-payment-flow) |

## Important decisions

| Decision | Why it was made | Consequences |
|---|---|---|
| Represent money as positive integer cents | Keeps the baseline amount exact and easy to read | Fractional and non-positive amounts are rejected |
| Use native IRIS persistent records | Keeps the example focused on the business flow in its intended runtime | Orders and payments are separate IRIS records |
| Keep only `pending_payment` and `paid` order states | They are the only states required by the current scope | Other provider outcomes have no claimed meaning yet |
| Use only the gateway's normal behaviour | The first release establishes a happy-path baseline | Failures and unusual event sequences remain outside current knowledge |

## Unknowns and contradictions

- The business response to unsuccessful or unusual provider behaviour is not yet known.

## Related documents

- [Coherent business description](../BUSINESS.md)
- [System structure](structure.md)
- [Evidence and verification](evidence.md)
