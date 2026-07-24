---
name: repo-context-audit
description: Audit repository instructions, documentation ownership, and lexical retrieval; recommend or make authorized context improvements.
disable-model-invocation: true
---

# Repository Context Audit

Keep the always-active contract small and make authoritative repository knowledge easy to retrieve when needed. Active context is a metered working set; the repository is the system of record.

A request to audit authorizes read-only inspection and recommendations. Edit only when the request or a follow-up explicitly authorizes improvement. Authorization to improve repository context does not authorize inventing repository policy or broadening into unrelated code changes.

## Audit

Use progressive disclosure:

1. Read the governing root and nested `AGENTS.md`.
2. Locate relevant README files, context documents, ADRs, manifests, generated-file markers, source boundaries, and behavior-named tests.
3. Search representative task, error, and domain terms.
4. Read complete artifacts only when their full context is needed to evaluate authority, meaning, or a proposed change.

Do not infer absence from an empty or narrow search. Try a small number of meaningful alternate terms or routes before concluding that an authority, caller, test, or rationale does not exist.

Assess always-loaded instructions, documentation ownership, and repository retrieval as one system.

### Distinguish policy, fact, and preference

Before evaluating or proposing an instruction, identify what supports it:

- **Policy or authorization** comes from an explicit governing user, task, organization, or repository instruction. Preserve its scope and force. General risk cannot create permission, prohibition, or an approval requirement.
- **Invariant or hazard** is a factual condition and consequence established by code, tool behavior, generated ownership, an external contract, or concrete failures. State its trigger and consequence without inventing authority.
- **Workflow or preference** is a chosen way of working. Do not promote convention, silence, a one-off example, or an inferred preference into durable policy.

Treat existing governing instructions as active during the audit. They may be challenged, narrowed, relocated, or proposed for removal, but must not be silently weakened, broadened, or superseded.

Do not generalize a command-specific, environment-specific, or subsystem-specific hazard into a blanket filesystem or network permission, prohibition, protected area, or approval gate. When authority is ambiguous, report the question instead of guessing.

### Admit only grounded, irreducible instructions

A proposed new rule first needs a concrete basis:

- explicit governing policy;
- a repository-specific invariant or hazard;
- or an observed or credibly recurring meaningful failure.

Generic precaution, possible harm, agent preference, or common practice is not enough. A hazard can justify a factual warning, safer default, retrieval pointer, or mechanical guard, but authorization rules require explicit governing authority.

Every proposed rule, and every existing rule considered for retention, must then be:

1. **Durable** - likely to remain correct across many tasks.
2. **Scope-correct** - relevant throughout the governed scope, or guarding a rare consequential action that can arise anywhere in that scope and cannot be intercepted more narrowly.
3. **Needed before action** - not cheaply recoverable from code, tools, the task, or authoritative documentation before the rule matters.
4. **Behavior-changing** - prevents a specific meaningful error, policy violation, or consequential failure.
5. **Best expressed as instruction** - not enforced more reliably by permissions, tools, code, types, tests, lint, hooks, CI, or a narrower task contract.

Ask whether deleting the line would cause a meaningful mistake under its stated trigger. If not, omit or relocate it. Generic engineering coaching, command inventories, architecture narration, implementation summaries, and speculative safeguards normally fail this test.

Phrase the trigger and boundary narrowly. Reserve `always` and `never` for real invariants or explicit policy.

Use the narrowest owning artifact:

- Root or nested `AGENTS.md` for irreducible behavioral constraints at that scope.
- The current task for temporary requirements, decisions, and acceptance criteria.
- Permissions and tool interfaces for mechanically enforceable side-effect boundaries.
- Code and types for implemented structure, states, and contracts.
- Tests and examples for intended observable behavior.
- Definition-local comments for non-obvious rationale, invariants, or hazards.
- README for human setup, installation, and user-facing behavior.
- ADRs for surprising, hard-to-reverse tradeoffs.
- Context documents for compact shared terminology, ownership boundaries, hazards, and routes to narrower authorities.
- Skills or scripts for reusable but occasional workflows.

Do not create documentation categories merely to fill them. Do not create or recommend `MISSION.md`; put concise user-facing purpose in README when useful.

### Prefer authoritative implementation over parallel prose

For implemented behavior, code is authoritative. Tests and examples express intended observable behavior. Prose should preserve knowledge they cannot communicate reliably:

- rationale and hard-to-reverse tradeoffs;
- non-obvious invariants and hazards;
- shared domain semantics and preferred terminology;
- external contracts;
- short navigation routes to owning artifacts.

Ask:

1. Could names, modules, types, states, tests, or examples express this more faithfully?
2. Does the prose add knowledge rather than narrate mechanics or repeat signatures?
3. Is one artifact clearly authoritative?
4. Can an agent reach that authority through a short search or link chain?

Do not use context documents to compensate for opaque code or maintain a prose copy of implementation.

### Audit lexical retrieval

Try representative task, error, and domain searches. Check whether they reach the owning definition, important callers, rationale, and behavioral evidence without irrelevant results obscuring the authority.

Look for:

- generic or overloaded public names;
- multiple spellings or aliases for one concept;
- barrels or indirection that hide reverse references;
- grab-bag files with unclear ownership;
- vague types or signatures that force multi-file inference;
- tests whose names do not reveal protected behavior;
- important rationale separated from its owning definition;
- obsolete paths that remain plausible search results;
- context terminology that does not continue into filenames, symbols, types, tests, errors, and UI language.

Prefer distinctive public names, one preferred term per concept, precise domain types, concept-owned modules, behavior-named tests, and short rationale on owning definitions.

Longer names and lower match counts are not objectives by themselves. Judge whether a representative search reaches the needed authority efficiently.

## Recommend

Present at most three high-leverage changes. Recommend none when the evidence does not support a worthwhile change.

For each recommendation include:

- the observed instruction or retrieval failure, with exact paths or representative searches;
- its evidence and effect on task success, safety, context use, unnecessary approvals, or maintenance;
- the narrowest owning artifact;
- the proposed change and closest material alternative rejected;
- how to verify improvement without blocking adjacent correct work.

For an instruction change, also include its policy, invariant, hazard, or failure basis and the exact candidate wording.

Treat deletion, relocation, mechanical enforcement, and code discoverability as equal candidates. Do not assume the answer is more documentation.

Unsupported restrictions, approval gates, and policy promotion are not recommendations. Record the unresolved authority question instead.

Before materially changing always-loaded behavior, show the exact additions, removals, relocations, and mechanically enforced replacements. Proceed when the user has authorized that policy direction; do not ask again when scope and direction are already explicit.

## Edit

Make the smallest coherent authorized change. Preserve authoritative knowledge while removing duplicated or misleading views.

Prefer permissions, tool constraints, code names, types, module boundaries, tests, examples, and local rationale when they carry the requirement more faithfully than general prose.

Do not:

- broaden an audit into a repository rewrite;
- turn a context edit into a code or API refactor without explicit scope;
- invent a new documentation category;
- weaken or expand governing policy without showing the change.

Preserve unrelated and concurrent work.

## Verify

Use verification proportional to the change.

For instruction changes:

- reapply the grounding and admission tests;
- confirm the rule triggers only at its stated boundary;
- check that a nearby safe scenario is not blocked by an invented prohibition or approval request;
- search for duplicated or conflicting governing language.

For retrieval changes:

- rerun representative searches;
- inspect whether definitions, callers, rationale, and behavioral evidence are easier to reach;
- confirm context terminology continues into the owning artifacts.

For documentation ownership changes:

- confirm pointers reach existing authorities through short routes;
- check that removed prose remains represented by an authoritative artifact when the knowledge must be preserved.

For code-affecting changes, run focused public-interface, real-use, or behavior-named checks appropriate to the affected contract. Compilation, type checks, and lint may supplement behavioral evidence but are not automatically sufficient.

Verify links and executable contracts only when affected. Do not add tests for prose wording or source layout itself.

Report:

- context removed or relocated;
- retrieval routes improved;
- governing policies and hazards preserved;
- unsupported restrictions rejected;
- checks performed and their results;
- remaining high-cost ambiguity.
