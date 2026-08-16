# TASK-003 Correct payment business model

## Goal

Apply the human correction to the payment invariant and reorganise accumulated knowledge into focused files without changing application behaviour.

## Context

The ambiguous-timeout investigation exposed an unresolved question about payment attempts. A domain expert corrected the earlier framing: multiple attempts may be legitimate, while an order must not have more than one successful payment.

## Completion criteria

- [x] The human correction is explicit in `BUSINESS.md` and durable knowledge.
- [x] Structure, Meaning, and Evidence remain the three representations across exactly seven focused files.
- [x] Historical links affected by the migration are repaired without rewriting task history.
- [x] `Code Delta` and `Knowledge Delta` have been evaluated.

## Work

Migrated the three accumulated knowledge files into seven focused documents, corrected the categorisation of timeout semantics, and updated lightweight repository guidance and links for the evolved layout.

## Code Delta

- None. Application source and behaviour are unchanged.

## Knowledge Delta

- Preserved the human correction that one order does not imply one payment attempt.
- Added the corrected invariant: multiple attempts are legitimate, but no more than one successful payment may complete an order.
- Separated system map, order lifecycle, payment integration, business rules, decisions, verification, and incident evidence into focused documents.
- Moved the timeout fact out of engineering decisions and into payment integration meaning supported by incident evidence.
- Updated guidance so future Codex work selects the relevant focused file within Structure, Meaning, or Evidence.

## Verification

| Check | Context or environment | Result | Limitations |
|---|---|---|---|
| `git diff --check` | LOCAL checkout | Passed | Formatting only |
| Knowledge tree inventory | LOCAL checkout | Passed: exactly seven expected files; three old top-level files absent | File presence only |
| Old knowledge-path search | LOCAL checkout | Passed: no references remain | Textual check |
| Markdown link validation | LOCAL checkout | Passed: repository-local file and heading links resolve | External links were not checked |
| Application source diff | LOCAL checkout | Passed: no changes | Confirms source scope, not runtime behaviour |

## Decisions, hypotheses, and corrections

- **Human correction:** One order does not imply one payment attempt.
- **Corrected invariant:** Multiple payment attempts are legitimate; an order must not have more than one successful payment.
- Structure, Meaning, and Evidence remain the three representations; only their physical organisation evolved.
- No enforcement mechanism or payment fix was selected.

## Related material

- [Business description](../BUSINESS.md)
- [Business rules](../knowledge/meaning/business-rules.md)
- [Order lifecycle](../knowledge/structure/order-lifecycle.md)
- [Human correction evidence](../knowledge/evidence/incidents.md#2026-08-16--human-correction-of-the-payment-invariant)
- [INC-001](../incidents/INC-001-ambiguous-payment-timeout.md)

## Open questions

- Which implementation mechanism should eventually enforce the corrected invariant?
