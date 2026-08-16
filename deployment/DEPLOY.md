# Run version 0.2.0 on IRIS

## Prerequisites

- InterSystems IRIS with an application namespace
- `curl` for the smoke test

These instructions record the intended 0.2.0 deployment path. They were not executed during this source-history demonstration.

## Before deployment

Inspect existing demo data for orders with more than one locally successful payment:

```sql
SELECT "Order" AS OrderId, COUNT(*) AS SuccessfulPaymentCount
FROM BeyondCode.PaymentRecord
WHERE Status = 'succeeded'
GROUP BY "Order"
HAVING COUNT(*) > 1;
```

An empty result is expected. Any returned row needs investigation before treating the stored data as compatible with the corrected business invariant.

## Deploy

Import and compile the classes under `src/` into the chosen namespace. For example, from an IRIS terminal in namespace `USER`:

```objectscript
do $system.OBJ.LoadDir("/path/to/beyond-code-example/src", "ck")
write $system.Status.GetErrorText(##class(BeyondCode.PaymentService).Reset())
```

Version 0.2.0 changes `PaymentRecord`, `PaymentGatewaySimulator`, `PaymentService`, and `REST`. `PaymentRecord` gains the required `AttemptKey`, a unique attempt-key index, and a `pending` status; its provider payment ID is empty until a usable provider response arrives.

The reset command deletes all demo orders, payment attempts, and simulator ledger data. It is the bootstrap path for this disposable demonstration, not a production migration. Existing demo rows are not backfilled with attempt keys.

## Expose the REST API

Create an IRIS web application such as `/beyond-code` in the same namespace and set its dispatch class to `BeyondCode.REST`. No external payment service or credentials are required.

## Smoke test

With the web application available on the local IRIS web port:

```sh
curl -s -X POST http://127.0.0.1:52773/beyond-code/orders \
  -H 'Content-Type: application/json' \
  -d '{"amount":2599}'
```

Use the returned order ID below; the commands assume it is `1`. In an IRIS terminal, make the first provider response ambiguous:

```objectscript
do ##class(BeyondCode.PaymentGatewaySimulator).SetBehaviour("timeout_after_acceptance")
```

Send attempt A once. The response should report the ambiguous timeout:

```sh
curl -s -X POST http://127.0.0.1:52773/beyond-code/orders/1/pay \
  -H 'Content-Type: application/json' \
  -d '{"attempt_key":"smoke-attempt-A"}'
```

Confirm that the simulator has one provider-side charge, then make its response usable:

```objectscript
write ##class(BeyondCode.PaymentGatewaySimulator).CountChargesForOrder(1),!
do ##class(BeyondCode.PaymentGatewaySimulator).SetBehaviour("normal")
```

Retry the same attempt and inspect the order:

```sh
curl -s -X POST http://127.0.0.1:52773/beyond-code/orders/1/pay \
  -H 'Content-Type: application/json' \
  -d '{"attempt_key":"smoke-attempt-A"}'

curl -s http://127.0.0.1:52773/beyond-code/orders/1
```

The provider charge count should still be `1`, and the final order response should show status `paid`:

```objectscript
write ##class(BeyondCode.PaymentGatewaySimulator).CountChargesForOrder(1),!
```

## Automated test

```objectscript
do ##class(%UnitTest.Manager).RunTest("/path/to/beyond-code-example/tests")
```

## Rollback

Restoring and re-importing the previous application source does not make 0.2.0 payment-attempt data compatible with the earlier class model. Do not blindly delete newer data as a rollback strategy. For this disposable demo, `Reset()` is the explicit clean-bootstrap option; no production rollback or data-migration procedure is claimed.

## Verification boundary

The diagnostic, import, smoke test, automated test, and rollback steps above were reviewed for internal consistency but were not executed. They describe intended IRIS operations, not verified runtime results.
