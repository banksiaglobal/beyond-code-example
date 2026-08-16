# Payment integration

## Boundary

The store sends charge requests to the payment provider represented by `PaymentGatewaySimulator`. The simulator owns a provider-side ledger; the store owns its separate local payment storage.

| Record | Owner | Meaning |
|---|---|---|
| Provider-side charge | Payment provider simulator | The provider accepted or completed a charge request associated with an attempt key |
| Local payment attempt | Store | The stable business attempt, persisted before the provider request |

## Stable attempt identity

```text
same attempt key → same local payment attempt → same provider-side charge
different attempt key → new payment attempt → new provider-side charge
```

A retry repeats transport for an existing attempt; it does not create a new business attempt. The simulator keeps an attempt-key lookup and reuses the provider payment ID it created for that key. This is the provider-side deduplication boundary represented by the example.

## Normal behaviour

```text
store sends charge request
→ store finds or creates the local payment attempt
→ provider finds or creates the charge for that attempt key
→ provider returns a successful confirmation
→ confirmation processing marks the payment successful and the order paid
```

## `timeout_after_acceptance`

```text
store sends charge request
→ store persists the local payment attempt
→ provider records an accepted charge for the attempt key
→ store receives no usable response
→ store observes an ambiguous timeout
→ local attempt identity and provider charge remain available for retry
```

A later retry with the same key reuses the provider-side charge. A different key represents a legitimately different attempt and may create another charge while the order remains unpaid.

A timeout is a caller observation, not proof of the provider outcome. It does not establish whether the provider rejected, accepted, or completed the requested operation.

## Current boundary

The integration represents only `normal` and `timeout_after_acceptance`. Stable-key reuse is implemented for the simulator, but no general retry policy, real-provider reconciliation, webhook deduplication, or distributed concurrency mechanism is represented.

## Related knowledge

- [System map](system-map.md)
- [Order lifecycle](order-lifecycle.md)
- [Incident evidence](../evidence/incidents.md)
