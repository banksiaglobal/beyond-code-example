# Incident evidence

## 2026-08-16 — ambiguous payment timeout investigation

- **Initial hypothesis:** Duplicate-payment risk requires an explicit customer double click.
- **Investigation:** Source inspection and the written incident scenario show that the simulator records an accepted provider-side charge before returning `timeout_after_acceptance`. A later retry can create another provider-side charge.
- **What weakened the hypothesis:** The retry path is sufficient to produce two provider-side charge requests for one order; an intentional double click is not required.
- **Observed asymmetry:** The represented scenario has two provider-side charges and one successful local payment record.
- **Limitations:** This was source review only. The ObjectScript was not compiled and the incident test was not executed. Provider-side charge records are not proof that the customer was charged twice.
- **Related incident:** [INC-001 ambiguous payment timeout](../../incidents/INC-001-ambiguous-payment-timeout.md)

## 2026-08-16 — human correction of the payment invariant

- **Source:** Human/domain correction following the unresolved questions from INC-001.
- **Previous framing:** The investigation left open whether an order should have exactly one payment or payment attempt.
- **Correction:** An order may legitimately have multiple payment attempts. The invariant applies to successful financial outcome: an order must not have more than one successful payment.
- **Consequence for knowledge:** Payment attempt and successful payment must remain distinct concepts. The earlier one-attempt framing must not be treated as a business rule.
- **Implementation boundary:** No application behaviour changed and no enforcement mechanism was selected in this task.
- **Related knowledge:** [Business rules](../meaning/business-rules.md) and [order lifecycle](../structure/order-lifecycle.md).

## 2026-08-16 — implementation response in 0.2.0

- **Resolution design:** A retry of the same payment attempt reuses its stable `AttemptKey`, so the local attempt and simulator reuse the existing provider-side charge.
- **Preserved distinction:** A different key starts a different legitimate attempt; the fix does not impose one attempt per order.
- **Invariant protection:** Successful confirmation still moves the order to `paid`, and the represented sequential flow rejects another successful payment for that order.
- **Regression evidence:** [Duplicate payment incident test](../../tests/BeyondCode/DuplicatePaymentIncidentTest.cls) now describes one charge across an ambiguous timeout and same-key retry.
- **Limitations:** The ObjectScript source was reviewed but not compiled or executed in this repository task. Concurrent processing, reconciliation, and webhook deduplication remain outside the example.
- **Related release:** [0.2.0 payment retry identity](../../releases/0.2.0.md)
