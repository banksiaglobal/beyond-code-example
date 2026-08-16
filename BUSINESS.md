# Business

This project describes the payment part of a small online store.

## What the business does

The store accepts customer orders and collects payment for them. The current scope begins when an order is created and ends when the store knows that payment succeeded.

## Value

A customer can pay for an order, while the store receives confirmation from a payment provider before treating that order as paid.

## Participants

<!-- Who participates in the business and what role do they play? -->

| Participant | Role | Goal or responsibility |
|---|---|---|
| Customer | Creates an order and asks to pay | Complete payment for the order |
| Store | Records orders and their payment state | Know whether an order has been paid |
| Payment provider | Accepts payment and confirms its outcome | Tell the store that payment succeeded |

## Processes

| Process | Trigger | Outcome | Participants |
|---|---|---|---|
| Order payment | A customer creates an order and requests payment | The provider confirms success and the order becomes paid | Customer, store, payment provider |

## Rules and constraints

- A new order awaits payment.
- An order may involve more than one payment attempt.
- The store must not treat more than one payment as successfully completing the same order.
- An order becomes paid only after the payment provider confirms success.
- The store must not intentionally start another payment for an order it already knows is paid.
- Each order has one amount; currency handling is outside the current scope.

## Terms

| Term | Meaning |
|---|---|
| Order | A customer's request to buy goods for a recorded amount |
| Payment attempt | One effort to pay an order; several attempts may legitimately occur |
| Provider-side charge | A charge request recorded by the payment provider |
| Accepted provider charge | A provider-side charge the provider accepted, whether or not the store received a usable response |
| Successful payment | The financial outcome that completes payment for an order; at most one may complete the same order |
| Payment confirmation | The provider's statement that a payment succeeded |
| Store-observed timeout | The store did not receive a usable response; the provider outcome remains unknown |
| Pending payment | The order has not yet received a successful payment confirmation |
| Paid | The store has received a successful payment confirmation for the order |

## Open questions

- Which currency will the store use?
- Who decides whether another payment attempt is appropriate after an ambiguous provider response?

## Related knowledge

- [System map](knowledge/structure/system-map.md)
- [Order lifecycle](knowledge/structure/order-lifecycle.md)
- [Payment integration](knowledge/structure/payment-integration.md)
- [Business rules](knowledge/meaning/business-rules.md)
- [Evidence and verification](knowledge/evidence/verification.md)
