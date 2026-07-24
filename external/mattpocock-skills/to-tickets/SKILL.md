---
name: to-tickets
description: Break a plan, spec, or the current conversation into tracer-bullet tickets with explicit blocking edges, published to an authorized configured tracker or one local file per ticket.
disable-model-invocation: true
---

# To Tickets

Break a plan, spec, or conversation into a set of **tickets** — tracer-bullet vertical slices, each declaring the tickets that **block** it.

Use a repository or user tracker configuration only when it explicitly names the destination and conventions. A configured tracker does not by itself authorize an external write; publish remotely only when the user has authorized it for this work. Otherwise use the local-file default below. Apply only labels or workflow fields explicitly configured for that repository or requested by the user.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a reference (a spec path, an issue number or URL) as an argument, fetch it and read its full body and comments.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Ticket titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Draft vertical slices

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests) — vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

</vertical-slice-rules>

Give each ticket its **blocking edges** — the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change — rename a column, retype a shared symbol — whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand–contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in a ticket blocked by every migrate batch. When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket — green is promised only there.

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each ticket, show:

- **Title**: short descriptive name
- **Blocked by**: which other tickets (if any) must complete first
- **What it delivers**: the end-to-end behaviour this ticket makes work

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct — does each ticket only depend on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown.

### 5. Publish the tickets

Publish the approved tickets to the explicitly configured and authorized tracker. If no such destination is available, use the local-file default. The tickets are the same either way; only the representation of blocking edges changes:

- **Local default** → write one file per ticket under `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01` in dependency order (blockers first). Each file's "Blocked by" lists the numbers/titles it depends on. Use the per-ticket file template below — one ticket per file, never a single combined file.
- **Authorized real tracker (GitHub, Linear, …)** → publish one issue per ticket in dependency order so blocking edges can reference real identifiers. Use a native blocking relationship when available; otherwise record explicit "Blocked by" references in each ticket. Do not create labels, statuses, projects, or other tracker configuration, and apply only values already configured or explicitly requested.

A ticket may start when every ticket in its "Blocked by" list is complete. Tickets with no blockers form the initial frontier; completing them may unblock the next frontier. Do not treat numbering alone as a dependency.

Do NOT close or modify any parent issue.

<local-ticket-template>

# <NN> — <Ticket title>

**What to build:** the end-to-end behaviour this ticket makes work, from the user's perspective — not a layer-by-layer implementation list.

**Blocked by:** the numbers/titles of the tickets that gate this one, or "None — can start immediately".

## Acceptance criteria

- [ ] Observable behavior criterion 1
- [ ] Observable behavior criterion 2

## Verification

- **Behavioral surface:** the public interface, real workflow, rendered artifact, command output, or other observable surface to exercise.
- **Coverage:** the meaningful success and failure behavior this ticket must prove.
- **Supporting checks:** relevant compile, type, lint, or focused unit checks that supplement the behavioral evidence.
- **Partial verification:** if full verification is blocked, report what ran, what remains unverified, why, and the residual risk.

</local-ticket-template>

<issue-template>

## Parent

A reference to the parent issue on the tracker (if the source was an existing issue, otherwise omit this section).

## What to build

The end-to-end behaviour this ticket makes work, from the user's perspective — not layer-by-layer implementation.

## Acceptance criteria

- [ ] Observable behavior criterion 1
- [ ] Observable behavior criterion 2

## Verification

- **Behavioral surface:** the public interface, real workflow, rendered artifact, command output, or other observable surface to exercise.
- **Coverage:** the meaningful success and failure behavior this ticket must prove.
- **Supporting checks:** relevant compile, type, lint, or focused unit checks that supplement the behavioral evidence.
- **Partial verification:** if full verification is blocked, report what ran, what remains unverified, why, and the residual risk.

## Blocked by

- A reference to each blocking ticket, or "None — can start immediately".

</issue-template>

In either form, avoid specific file paths or code snippets — they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.
