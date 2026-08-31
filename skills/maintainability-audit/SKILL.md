---
name: maintainability-audit
description: Audit source-code design for codebases developed entirely through coding agents. Find structural smells that make agent implementation, refactoring, review, verification, and handoff accumulate debt. Do not use for agents operating the product or for general bug, reliability, security, performance, or coverage review.
disable-model-invocation: true
---

# Agent-native source maintainability audit

Audit whether repeated coding agents can keep the source simple, coherent, and changeable over time. Tobias performs software development through agents: exploration, design, implementation, review, validation, and continuation all happen through agent contexts. There is no later human coding or routine source-review pass that will repair locally convenient choices.

In this skill, **agent means a coding agent changing the source code**. It does not mean a product user, operator, deployment actor, support tool, autonomous runtime, or recovery process. A codebase can be agent-native for development even when no agent ever operates the product.

Invocation authorizes read-only inspection and recommendations. Do not edit code, configuration, tests, documentation, generated files, or history unless the user explicitly authorizes remediation. Preserve unrelated and concurrent work.

## Start from source-development work

Audit representative changes an implementation agent may realistically make. Ground them in current architecture, actual consumers, repository history, repeated feature areas, or stated product direction. Do not invent operational tasks merely because an agent could theoretically perform them.

Examples of relevant tasks include:

- add or change a domain field across intake, models, UI, planning, execution, and evidence;
- add a customer rule, order source, workflow stage, or integration behavior;
- replace a shared model, provider, persistence boundary, or public package contract;
- fix a recurring behavior whose ownership spans several modules;
- refactor an implementation while preserving its public behavior;
- review or continue another agent's incomplete source change.

For each representative change, trace:

- what names and paths repository search reveals;
- which module, package, type, or model appears to own the decision;
- the actual producers, consumers, effects, and edit sites;
- which changes are cohesive and which cross unrelated owners;
- which public or real-use verifier permits internal redesign;
- what durable source, tests, types, decisions, or checkpoints let another coding agent continue.

Use history to identify real change patterns and patch accumulation, not as a score. Age, churn, and commit count are clues only.

## Inspect development structure

Look for structural mechanisms that make repeated agent-written changes degrade the codebase:

- **competing ownership:** several source locations can independently decide the same domain fact or policy;
- **poor change locality:** one coherent product change requires scattered edits across unrelated modules or packages;
- **patch accretion:** cases and exceptions accumulate beside an uncorrected model or boundary;
- **lying source boundaries:** names, types, APIs, or dependency direction claim ownership that runtime wiring does not honor;
- **parallel implementations:** multiple plausible paths perform the same responsibility and can evolve independently;
- **context-heavy design:** a bounded change requires understanding unrelated subsystems because responsibilities are fused or effects leak across boundaries;
- **fragile verification:** tests lock local implementation details, validate only one copy of duplicated behavior, or cannot protect a coherent refactor at the public seam;
- **weak source handoff:** non-obvious rationale, invariants, generated authority, or incomplete implementation state cannot be recovered from durable repository artifacts;
- **speculative structure:** indirection, configuration, extension points, or generality increase the search and edit space without a current consumer.

Prefer the simplest coherent resulting system, not the smallest diff. A focused refactor may be simpler when it restores one owner or removes parallel paths. Do not turn local evidence into unrelated cleanup or a universal abstraction.

## Enforce the source-development boundary

A candidate is an agent-native source finding only when all of these are demonstrated:

1. A realistic design, implementation, refactor, review, verification, or handoff task is grounded in this codebase.
2. Repository structure, not merely a runtime defect, makes that source task hard to locate, contain, review, continue, or verify.
3. A fresh coding agent is likely to make a specific incomplete patch, miss an owner, preserve a false abstraction, or accept weak evidence.
4. Repeated source changes compound the problem through more branches, duplicated rules, wider ripple effects, or less trustworthy verification.
5. The proposed remedy primarily makes later source development simpler and more maintainable.

Reject the candidate when the chain is incomplete.

Do not audit whether an agent can use, deploy, administer, diagnose, or recover the running product unless the user explicitly requests that different review. Operational interruption, ambiguous side effects, runtime reconciliation, agent-facing CLI guidance, and deployment resumability are outside this skill by default.

A correctness, concurrency, reliability, security, performance, or usability problem is not a finding merely because agents wrote the code. If a normal local bug fix removes the problem and does not make later source changes easier to locate, contain, review, or verify, exclude it. Unsafe retries, non-atomic writes, task crashes, stale UI state, malformed input, missing pagination, and low coverage are ordinary engineering issues until a separate source-structure mechanism is proven.

Use this counterfactual:

> After the proposed change, will the next coding agent implementing a related feature or refactor need less unrelated context, face fewer plausible edit locations, touch fewer independent owners, and have a clearer behavioral verifier?

If not, the candidate does not belong in this audit.

Do not manufacture relevance by writing "a future agent might" before a generic bug scenario. Do not treat product runtime state as a coding-agent handoff merely because an agent could inspect it.

## Require source receipts

Support findings with exact definitions, references, imports, callers, runtime composition, tests, configuration, and narrow history where it proves repeated change behavior. Search alternate names and paths before claiming an owner or verifier is absent.

For a scattered-change finding, show the actual edit graph and why the sites own one decision rather than legitimate separate policies. For duplicated truth, show that both copies are live or plausible authorities. For a verifier finding, show the source change it falsely accepts or prevents. For a handoff finding, show which source intent or incomplete work cannot be reconstructed and why code, types, tests, history, or decisions do not already preserve it.

File size, age, TODOs, churn, low coverage, naming taste, abstraction depth, dependency count, long call chains, and stylistic dislike are not sufficient evidence. Large cohesive modules and small misleading modules are both possible.

When evidence is incomplete, report the suspicion and the decisive source check still needed. Do not promote it to a finding.

## Report findings

For each supported finding, include:

- the representative source-development task;
- the exact source receipt and expected owner;
- what a fresh coding agent will find and the incomplete or locally convenient patch it invites;
- the actual edit, review, context, or verification cost;
- how repeated agent changes compound that cost;
- the smallest coherent source redesign and its owning boundary;
- material alternatives and tradeoffs;
- behavioral verification at a stable public or real-use seam that permits internal refactoring;
- uncertainty, contrary evidence, and any unresolved product or architecture decision.

Explain when one ownership correction removes several symptoms. Recommend no change when the evidence does not support one. Keep ordinary bugs and operational improvements out of the report unless the user separately asks for them.

In an audit-only run, run checks only when they are known to leave the target unchanged or isolate their outputs outside it. Do not create caches or generated artifacts under a zero-write constraint.

## Remediate only when authorized

When the user authorizes code changes, resolve findings at the owning source boundary. Remove replaced paths and duplicate authority when current contracts allow it. Do not preserve parallel behavior through shims or fallbacks without a concrete consumer, persisted-data constraint, or deployment requirement.

Keep implementation proportional to the proven development problem. Do not add general frameworks, process, configuration, tests, or documentation for speculative variants.

## Verify source maintainability

Verify observable behavior through the public interface or a representative real-use flow at the affected seam. Then recheck the development trajectory that justified the finding:

- one owner now controls the changed decision;
- expected related changes are local and discoverable;
- removed or consolidated paths no longer remain plausible authorities;
- behavioral evidence permits internal redesign instead of freezing implementation details;
- another coding agent can locate the owner, understand the invariant, review the complete edit set, and continue from repository state without the audit transcript.

Compilation, type checks, lint, and private implementation tests may supplement this evidence but do not replace it. Report each check actually run and any source-change trajectory left unverified.
