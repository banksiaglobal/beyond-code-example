# Instructions for Codex

This repository preserves both code and useful knowledge gained during software development.

## Core principle

After every substantial task, evaluate two possible outcomes:

```text
Code Delta
Knowledge Delta
```

`Code Delta` describes a change to the product. `Knowledge Delta` describes new durable understanding of the business or the system. A task may produce either outcome, both outcomes, or neither.

Do not preserve the full conversation. Preserve only knowledge that can help with future development, verification, investigation, or decision-making.

## Where knowledge belongs

- `BUSINESS.md` — the central, coherent, living description of the business.
- `knowledge/structure.md` — what exists in the system and how its parts are connected.
- `knowledge/meaning.md` — why parts of the system exist and which rules they implement.
- `knowledge/evidence.md` — sources, observations, verification, and limitations of conclusions.
- `tasks/` — concise records of substantial tasks based on `tasks/TASK-TEMPLATE.md`.

## Update rules

1. Before starting work, read the knowledge relevant to the task.
2. During the work, distinguish facts from hypotheses and verification in one environment from verification in another.
3. After the work, determine whether a useful `Knowledge Delta` emerged.
4. Update `BUSINESS.md` only when new durable business understanding emerges.
5. Put system details in the appropriate representation: Structure, Meaning, or Evidence.
6. Connect important conclusions to the evidence on which they are based.
7. Clearly mark unknown facts, contradictions, disproved hypotheses, and verification limits.
8. Respect human corrections to AI conclusions; do not hide disagreements with earlier conclusions.
9. Avoid duplicating the same knowledge in multiple places; link to it instead.

## Preparing a pull request

1. Review the implemented change and the results of any research.
2. Decide whether durable knowledge emerged.
3. First update `BUSINESS.md` and the relevant files in `knowledge/`.
4. Then prepare the PR description using `.github/pull_request_template.md`.

A PR is a concise summary, not the only place where knowledge is stored. Do not copy the full task trace, long logs, the full chat, or a detailed research narrative into it. If no durable knowledge emerged, say so directly. Claim only verification that was actually performed, and clearly identify unverified assumptions, risks, and questions that require a human decision.

## What not to add

- the full chat or chain of thought;
- temporary noise;
- assumptions presented as verified facts;
- documentation with no future value;
- new tools or infrastructure created only to manage knowledge.

Keep the documents simple, concise, and consistent. If there is no `Knowledge Delta`, do not invent one.
