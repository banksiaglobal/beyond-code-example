# Evidence

This file records what knowledge about the business and the system is based on: requirements, observations, research, verification, tests, logs, incidents, human corrections, and disproved hypotheses.

Do not preserve the entire process. Preserve only what helps someone understand or repeat the verification of an important conclusion.

## How to record evidence

For every entry, include:

- the question being investigated;
- the source or verification method;
- the date and context, including the environment when relevant;
- the observed result;
- the conclusion supported or disproved;
- limitations and remaining unknowns;
- related entries in `BUSINESS.md`, `structure.md`, or `meaning.md`.

Verification in one environment does not prove behavior in another. When relevant, explicitly state `LOCAL`, `DEV`, `TEST`, `UAT`, `STAGING`, or `LIVE`. For external research, preserve the source link and access date.

## Entries

### 2026-08-16 — baseline payment flow

- **Question:** Does the first implementation support order creation, normal successful payment, provider confirmation, and paid-order protection?
- **Source or verification:** The task requirements and review of the ObjectScript source, focused test source, business description, and knowledge files in this change.
- **Context or environment:** Source review in the LOCAL checkout; no IRIS runtime verification was performed.
- **Observation:** The source represents the required routes, separate persistent order and payment records, normal gateway confirmation, and paid-order protection. A focused `%UnitTest` scenario documents the intended baseline checks, but it was not executed.
- **Conclusion:** The change establishes the IRIS source baseline and its associated durable knowledge. Runtime behaviour is not claimed as verified.
- **Limitations:** Only normal payment-provider behaviour is in scope. Timeouts, retries, delayed events, duplicate events, and out-of-order events have not been tested or claimed to be safe.
- **Related knowledge:** [Business rules](../BUSINESS.md#rules-and-constraints), [system flow](structure.md#flows-and-interactions), and [behaviour meaning](meaning.md#business-rules).
