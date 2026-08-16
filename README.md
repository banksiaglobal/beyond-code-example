# Beyond Code

> Develop code. Preserve what you learn.

## The problem

After a task is completed, usually only the code remains. Discussions, research, verification, hypotheses, and decisions that led to the result are lost. The next team or the next Codex session has to reconstruct that context from scratch.

## The solution

Keep useful knowledge about the system and the business alongside the code. Every substantial task can produce two results:

```text
Code Delta
Knowledge Delta
```

- **Code Delta** — a change to the product.
- **Knowledge Delta** — new durable understanding that will help with future work.

The main cumulative result is a living description of the business in [`BUSINESS.md`](BUSINESS.md).

## How it works

```text
Task discussion
+ research
+ tests and verification
+ decisions
→ code + knowledge
```

Knowledge is represented in three simple forms:

- **Structure** — what exists in the system and how it is connected. Stored in [`knowledge/structure.md`](knowledge/structure.md).
- **Meaning** — why it exists and which business rules it implements. Stored in [`knowledge/meaning.md`](knowledge/meaning.md).
- **Evidence** — what the knowledge is based on and where it was verified. Stored in [`knowledge/evidence.md`](knowledge/evidence.md).

[`tasks/TASK-TEMPLATE.md`](tasks/TASK-TEMPLATE.md) provides a concise record of a substantial task. [`AGENTS.md`](AGENTS.md) tells Codex how to work with this knowledge.

The [pull request template](.github/pull_request_template.md) shows both what changed in the code and what the team learned about the business and the system while making the change.

## How to use it

1. Copy the template into a project.
2. Connect Codex through `AGENTS.md`.
3. Work on tasks as usual: discuss, research, change code, and verify the result.
4. After a substantial task, identify the `Code Delta` and `Knowledge Delta`.
5. Preserve only knowledge that will be useful in the future.
6. Update `BUSINESS.md` only when new durable business understanding emerges.

## What not to preserve

- the full chat;
- noise and temporary thoughts;
- unverified assumptions presented as facts;
- unnecessary documentation with no future value.

Unknown or conflicting facts may be preserved when they matter, but they must be clearly marked as unknown or requiring verification.

## Practical value (ROI)

- fewer repeated explanations for people and Codex;
- fewer tokens spent rebuilding context;
- less time spent repeating investigations;
- faster onboarding for new contributors;
- knowledge survives beyond individual tasks;
- previous investigations can be reused;
- less drift in the shared understanding of the system.

In short:

```text
less context → fewer tokens → faster development
```

## Working with external instructions

Sometimes a task includes an additional prompt block. It may be embedded in a document or temporarily extend Codex's behavior.

First, analyze the instruction and integrate it carefully into the existing document:

```text
instruction → analysis → careful integration → updated document
```

If the new instruction materially changes the purpose or structure of the document, the document may evolve into a new version:

```text
instruction → analysis → document evolution (v2)
```

Do not create new versions without a reason. If the meaning can be integrated clearly, update the existing document.
