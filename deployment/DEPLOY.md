# Run version 0.1.0 on IRIS

## Prerequisites

- InterSystems IRIS with an application namespace
- `curl` for the smoke test

These instructions record the intended first deployment path. They were not executed during this source-history demonstration.

## Import and initialise

Import and compile the classes under `src/` into the chosen namespace. For example, from an IRIS terminal in namespace `USER`:

```objectscript
do $system.OBJ.LoadDir("/path/to/beyond-code-example/src", "ck")
write $system.Status.GetErrorText(##class(BeyondCode.PaymentService).Reset())
```

The reset command deletes all demo orders and payments. It is the simple version 0.1.0 bootstrap mechanism, not a migration.

## Expose the REST API

Create an IRIS web application such as `/beyond-code` in the same namespace and set its dispatch class to `BeyondCode.REST`. No external payment service or credentials are required.

## Smoke test

With the web application available on the local IRIS web port:

```sh
curl -s -X POST http://127.0.0.1:52773/beyond-code/orders \
  -H 'Content-Type: application/json' \
  -d '{"amount":2599}'

curl -s -X POST http://127.0.0.1:52773/beyond-code/orders/1/pay

curl -s http://127.0.0.1:52773/beyond-code/orders/1
```

Use the actual local IRIS web port and the ID returned by order creation. The final response should show the order with status `paid`.

## Automated test

```objectscript
do ##class(%UnitTest.Manager).RunTest("/path/to/beyond-code-example/tests")
```

## Rollback

Restore the previous application revision and re-import its classes. Version 0.1.0 has no schema migration or production-data rollback procedure; `Reset()` is only for disposable demo data.
