# Decisions

| Decision | Why it was made | Consequences |
|---|---|---|
| Represent money as positive integer cents | Keeps the baseline amount exact and easy to read | Fractional and non-positive amounts are rejected |
| Use native IRIS persistent records | Keeps the example focused on the business flow in its intended runtime | Orders and payments are separate IRIS records |
| Keep the order lifecycle deliberately small | Only `pending_payment` and `paid` have been required | Other order states should appear only when evidence requires them |
| Keep simulator behaviour limited to investigated scenarios | The source should expose knowledge as it emerges | Only `normal` and `timeout_after_acceptance` are represented |
| Organise knowledge as focused files within three representations | Accumulated knowledge no longer fits clearly in one file per representation | Structure, Meaning, and Evidence remain stable while their physical files can grow |
| Use a stable payment-attempt key across store and provider simulator | The incident showed that transport failure does not define a new business attempt | Retrying the same attempt reuses its local record and provider-side charge; a different key creates a different attempt |

## Corrected classification

The statement “a timeout is a caller observation, not proof of provider outcome” was previously stored under decisions. It is learned integration meaning, not an engineering choice, and now lives in [payment integration](../structure/payment-integration.md).

The attempt-key decision addresses the represented sequential retry path. It does not provide a general retry policy, strong concurrent or distributed guarantees, real-provider reconciliation, or webhook deduplication.

## Related knowledge

- [Business rules](business-rules.md)
- [System map](../structure/system-map.md)
- [Incident evidence](../evidence/incidents.md)
