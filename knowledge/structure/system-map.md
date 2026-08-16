# System map

## System boundary

The demo contains an IRIS REST application, a payment service, persistent order and payment records, and a local payment gateway simulator. A real payment provider and retail concerns outside the payment flow are outside the current boundary.

## Main parts

| Part | Responsibility | Connections |
|---|---|---|
| IRIS REST dispatcher | Exposes order and payment operations | Calls the payment service and receives confirmations |
| Payment service | Coordinates the represented order-payment flow | Uses persistent records and the gateway simulator |
| Order storage | Persists order amount and state | Updated by order creation and successful confirmation processing |
| Payment storage | Persists payment attempts separately from orders | Links each local attempt to an order and provider payment ID |
| Payment gateway simulator | Represents investigated provider behaviours | Records provider-side charges before returning a response |
| Provider-side ledger | Makes simulated provider charges inspectable | Stores provider payment ID, order ID, amount, and provider-side status independently of local payment storage |
| Payment confirmation boundary | Applies a successful provider confirmation | Updates the matching local payment and order |

## Connections

The REST dispatcher delegates business operations to the payment service. The service persists local records and calls the simulator. Provider-side records and local payment records remain separate, and only confirmation processing updates an order to `paid`.

## External dependency

| Dependency | Purpose | Responsibility boundary |
|---|---|---|
| InterSystems IRIS | Runs ObjectScript, exposes REST routes, and persists records | Application runtime and database |

## Related knowledge

- [Order lifecycle](order-lifecycle.md)
- [Payment integration](payment-integration.md)
- [Business rules](../meaning/business-rules.md)
