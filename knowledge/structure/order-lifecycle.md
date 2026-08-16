# Order lifecycle

## Concepts

| Concept | Meaning in the current model |
|---|---|
| Order | The commercial item that waits for one payment outcome |
| Payment attempt | One effort to pay an order, identified by one stable `AttemptKey`; an order may legitimately have several |
| Successful payment | The financial outcome that completes payment for an order; an order must not have more than one |

A payment attempt is not the same thing as the order or its successful financial outcome.

## Identity and relationships

```text
one Order → zero or more Payment Attempts
one Payment Attempt → one stable AttemptKey
```

Repeating transport with the same `AttemptKey` retries the existing attempt. Supplying a different key starts a new attempt while the order remains unpaid. The local attempt is persisted as `pending` before provider invocation so an ambiguous response does not erase its identity.

## Represented order states

| State | Meaning |
|---|---|
| `pending_payment` | The store does not yet regard the order as successfully paid |
| `paid` | The store has processed a successful provider confirmation for the order |

A new order starts as `pending_payment`. Payment attempts may occur while the order waits for its commercial payment outcome. Successful confirmation moves the represented order to `paid`, after which the store must not intentionally start another payment.

No declined, cancelled, refunded, reversed, authorised, or captured states are currently represented.

## Related knowledge

- [Business rules](../meaning/business-rules.md)
- [Payment integration](payment-integration.md)
- [Incident evidence](../evidence/incidents.md)
