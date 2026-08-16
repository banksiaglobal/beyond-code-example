# Verification evidence

## 2026-08-16 — baseline payment flow

- **Question:** Does the first implementation represent order creation, normal successful payment, provider confirmation, and paid-order protection?
- **Source or verification:** Task requirements and review of the ObjectScript source, focused test source, business description, and knowledge files.
- **Context or environment:** Source review in the LOCAL checkout; no IRIS runtime verification was performed.
- **Observation:** The source represents the required routes, separate persistent order and payment records, normal gateway confirmation, and paid-order protection. A focused `%UnitTest` scenario documents the intended checks, but it was not executed.
- **Conclusion:** The baseline established the IRIS source shape and associated durable knowledge. Runtime behaviour was not claimed as verified.
- **Limitations:** Only normal payment-provider behaviour was in scope. The ObjectScript was not compiled, tests were not executed, and runtime behaviour was not verified.
- **Related knowledge:** [Business rules](../meaning/business-rules.md), [system map](../structure/system-map.md), and [order lifecycle](../structure/order-lifecycle.md).

## 2026-08-16 — knowledge migration checks

- **Question:** Was accumulated knowledge moved into the intended seven-file layout without changing application behaviour or losing the evidence boundary?
- **Source or verification:** Repository diff, file inventory, old-path search, and Markdown link validation in the LOCAL checkout.
- **Observation:** All seven expected knowledge files exist, the three old top-level files are absent, repository-local Markdown file and heading links resolve, no references to the old knowledge paths remain, and the diff contains no application source, deployment, or release changes.
- **Conclusion:** The documentation migration is internally consistent at the repository level and preserves the source-only verification boundary.
- **Limitations:** Documentation checks do not verify application runtime behaviour.

## 2026-08-16 — 0.2.0 ambiguous-retry fix

- **Question:** Does the 0.2.0 source represent same-attempt retry without another provider-side charge while preserving distinct legitimate attempts and paid-order protection?
- **Source or verification:** Line-by-line review of the changed ObjectScript classes and focused test source; call-site search; repository diff and formatting checks; repository-local Markdown file and heading link validation.
- **Context or environment:** Source review in the LOCAL checkout. An unrelated IRIS container was present for another project, but no immediately available runtime was configured for this repository.
- **Observation:** `PaymentRecord` stores a unique `AttemptKey` before provider invocation; the simulator reuses its provider payment ID for that key; same-key retry source expects one local attempt and one provider charge; different-key source expects two attempts; the paid-order test remains. Documentation checks passed, and the knowledge tree remains the existing seven files.
- **Conclusion:** The source and tests consistently describe the intended sequential 0.2.0 fix and its operational guidance.
- **Limitations:** ObjectScript compilation, `%UnitTest` execution, SQL diagnostic execution, and HTTP smoke testing were not performed. No strong concurrent or distributed successful-payment guarantee is claimed.
- **Related material:** [INC-001](../../incidents/INC-001-ambiguous-payment-timeout.md), [payment integration](../structure/payment-integration.md), [TASK-004](../../tasks/TASK-004-fix-and-ship.md), and [release 0.2.0](../../releases/0.2.0.md).
