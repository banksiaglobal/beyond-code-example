# Payment integration

## Boundary

The store sends charge requests to the payment provider represented by `PaymentGatewaySimulator`. The simulator owns a provider-side ledger; the store owns its separate local payment storage.

| Record | Owner | Meaning |
|---|---|---|
| Provider-side charge | Payment provider simulator | The provider accepted or completed a charge request |
| Local payment record | Store | The store received enough response information to persist and process the attempt |

## Normal behaviour

```text
store sends charge request
→ provider records the charge
→ provider returns a successful confirmation
→ store persists the payment attempt
→ confirmation processing marks the payment successful and the order paid
```

## `timeout_after_acceptance`

```text
store sends charge request
→ provider records an accepted charge
→ store receives no usable response
→ store observes an ambiguous timeout
→ no local payment record is created for that attempt
```

A later retry can create another provider-side charge. The provider ledger and local payment storage can therefore describe different parts of the same interaction.

A timeout is a caller observation, not proof of the provider outcome. It does not establish whether the provider rejected, accepted, or completed the requested operation.

## Current boundary

The integration represents only `normal` and `timeout_after_acceptance`. No retry policy, idempotency mechanism, or reconciliation behaviour has been selected.

## Related knowledge

- [System map](system-map.md)
- [Order lifecycle](order-lifecycle.md)
- [Incident evidence](../evidence/incidents.md)
