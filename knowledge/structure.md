# Structure

This file describes what exists in the system and how its parts are connected. It answers “what is connected to what” without replacing the description of business meaning or evidence.

## System boundaries

The demo contains an IRIS REST application, persistent order and payment records, and a local payment gateway simulator. A real payment provider and all retail concerns outside the payment flow are outside the current boundary.

## Main parts

| Part | Responsibility | Connections |
|---|---|---|
| IRIS REST dispatcher | Exposes order and payment operations | Calls the payment service and receives confirmations |
| Payment service | Applies the baseline order-payment rules | Uses both persistent record types and the gateway simulator |
| Order storage | Persists order amount and status | Updated by order creation and successful confirmation processing |
| Payment storage | Persists payment attempts separately from orders | Links each payment to an order and to a provider payment identifier |
| Payment gateway simulator | Accepts a charge and produces one successful confirmation | Called during payment initiation; returns a confirmation to the application |
| Payment confirmation boundary | Applies a provider success confirmation | Updates the matching payment and its order |

## Flows and interactions

1. The application creates a `pending_payment` order in order storage.
2. Payment initiation sends the order amount to the local gateway simulator.
3. The accepted payment is recorded separately and linked to the order.
4. The simulator's successful confirmation crosses the same processing boundary exposed by the payment webhook.
5. Confirmation processing marks the payment successful and the linked order paid.

## External dependencies

| Dependency | Purpose | Responsibility boundary |
|---|---|---|
| InterSystems IRIS | Runs ObjectScript, exposes REST routes, and persists records | Application runtime and database |

## Unknowns and contradictions

- Behaviour outside the simulator's normal successful sequence is not defined or verified.

## Related documents

- [Coherent business description](../BUSINESS.md)
- [Meaning and business rules](meaning.md)
- [Evidence and verification](evidence.md)
