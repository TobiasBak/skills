---
name: maintainability-audit
description: Audit a codebase for evidence-backed structural smells that hinder repeated agent-mediated development. Invoke manually when maintainability, change cost, resumability, or verification quality needs focused review.
disable-model-invocation: true
---

# Maintainability audit

Find structural problems that make the codebase harder for an agent to understand, change, resume, or verify across repeated work. Judge the simplest coherent resulting system, not the smallest diff. A larger change may be simpler when it removes competing truths or restores one clear owner. A tiny patch may be worse when it adds another exception or path.

Invocation authorizes read-only inspection and recommendations. Do not edit code, configuration, tests, documentation, generated files, or history unless the user explicitly authorizes remediation. Preserve unrelated and concurrent work.

## Establish the real system

Start from the requested scope and governing repository instructions. Adapt the investigation to the codebase and question. Do not impose one sequence, checklist score, numeric threshold, or finding count.

Trace representative behavior through its actual boundaries:

- public entry points and callers;
- ownership of decisions, data, state, and effects;
- transformations and control flow between those owners;
- persistence, network, filesystem, process, clock, randomness, and other effects;
- public or real-use verification seams;
- relevant history when it explains why a boundary exists, whether a path is still live, or how repeated patches accumulated.

Use definitions, reverse references, runtime wiring, configuration, tests, and narrow history queries as evidence. Search alternate names and routes before concluding that an owner, caller, verifier, or replacement does not exist. Treat code and runtime wiring as current implementation evidence. Treat tests and prose as intended contracts only where their authority is established.

Keep observed facts, interpretations, and proposals separate. Do not infer runtime use from mere existence or infer obsolescence from age.

## Look for structural smells

Consider these as prompts, not automatic findings:

- patch accretion, where new cases stack beside an uncorrected model or boundary;
- duplicate truth, where several artifacts can independently decide the same fact;
- blurred ownership, where no component clearly owns a decision, invariant, state transition, or effect;
- ripple-heavy coupling, where one behavior change requires unrelated owners to move together;
- lying abstractions, whose name or interface hides special cases, narrower semantics, or leaked implementation details;
- hidden effects or state that callers cannot see, control, isolate, or reconstruct;
- weak public verifiers, where the claimed behavior cannot be checked at the boundary users or callers rely on;
- poor resumability, where a fresh agent cannot recover the current owner, state, decision, or next meaningful check from stable artifacts;
- obsolete or parallel paths that remain plausible, reachable, or authoritative enough to misdirect changes;
- speculative complexity that adds indirection, configuration, extension points, or generality without a current requirement or consumer.

Follow the evidence beyond the named smell when the real problem has a different shape. Do not recommend documentation to conceal unclear ownership or duplicated behavior that the implementation itself should resolve.

## Separate clues from findings

Do not call something technical debt merely because it is old, large, frequently changed, has TODOs, or has low test coverage. Naming taste, style dislike, abstraction depth, dependency count, and a long call chain are not findings either. Use them as clues about where to inspect.

Report a finding when you can show how the code makes a realistic future change harder to understand, contain, resume, or verify. Support it with exact paths, symbols, callers, wiring, history, runtime observations, or verifier behavior. Explain the concrete maintenance scenario and what would go wrong or become unnecessarily expensive.

When evidence is incomplete, report a suspicion and the decisive check still needed. Do not promote it to a finding.

## Report findings

For each supported finding, include:

- the smell and its exact evidence receipt;
- a concrete maintenance scenario and impact;
- the boundary that should own the behavior, state, decision, or effect;
- the smallest coherent remedy, judged by the resulting system rather than diff size;
- material alternatives and their tradeoffs;
- a verification plan at the affected public or real-use seam;
- uncertainty, contrary evidence, and any unresolved authority or product decision.

Explain interactions between findings when one remedy would remove several symptoms. Prefer that shared cause over separate local patches. Recommend no change when the evidence does not support one.

In an audit-only run, a verification plan does not authorize executing mutating checks. Run checks only when they are known to leave the target unchanged, or isolate their outputs outside the target when the user's authorization permits it. Under a zero-write constraint, do not run tools that may create caches or generated artifacts.

## Remediate only when authorized

If the user authorizes code changes, confirm the exact scope and resolve findings at their owning boundary. Remove replaced paths and duplicate authority when current contracts allow it. Do not preserve parallel behavior through shims or fallbacks without a concrete consumer, persisted-data constraint, or deployment need.

Keep the implementation proportional to the proven problem. Do not add general frameworks, configuration, tests, or documentation for speculative variants.

## Verification

For code-affecting remediation, verify observable behavior through the public interface or a representative real-use flow at the affected seam. Cover the maintenance scenario from the finding and confirm the intended owner now controls the behavior. Check that removed or consolidated paths no longer remain live or plausible authorities.

Compilation, type checks, lint, and private implementation tests may supplement behavioral evidence but do not replace it. Report each check actually run, its result, and any behavior left unverified. If the environment blocks a meaningful check, state the limitation and give the exact continuation route.

Recheck continuation quality after the change. A fresh agent should be able to locate the owner, follow the data and effect flow, identify the public verifier, and resume from stable repository evidence without relying on the audit transcript. Report any ambiguity that remains.
