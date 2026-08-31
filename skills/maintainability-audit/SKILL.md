---
name: maintainability-audit
description: Audit whether a codebase stays understandable, changeable, resumable, and honestly verifiable across fresh agent contexts. Invoke manually for agent-native maintainability; do not use as a general bug, reliability, security, performance, or test-coverage review.
disable-model-invocation: true
---

# Maintainability audit

Audit the repository as the durable handoff between agents. Find structural problems that cause repeated fresh agents to misunderstand the system, change the wrong place, accumulate parallel patches, lose unfinished state, or trust evidence that does not prove the behavior they are changing.

Judge the simplest coherent resulting system, not the smallest diff. A larger change may be simpler when it removes competing truths or restores one clear owner. A tiny patch may be worse when it adds another exception or path.

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

Trace representative change trajectories, not just runtime behavior. Start with a realistic task a later agent may receive. Follow what repository search reveals, which owner appears authoritative, which other files must move with it, what state survives interruption, and what public evidence would let a fresh agent accept the result.

## Enforce the agent-native boundary

A correctness, concurrency, reliability, performance, security, or usability problem is not an agent-native finding merely because it is serious. Admit it only when repository structure or durable project state creates a repeatable agent-maintenance failure.

A supported finding must show at least one concrete mechanism such as:

- competing truths or plausible paths lead a fresh agent to change one owner while another remains authoritative;
- the apparent owner hides required changes across unrelated components, so locally correct patches predictably leave the system inconsistent;
- names, contracts, types, dependency direction, or runtime wiring describe a boundary that the implementation does not honor;
- unfinished work, applied state, rationale, or acceptance evidence cannot be reconstructed from durable artifacts, so another agent cannot resume safely;
- the available verifier accepts a materially different behavior from the public or production boundary, causing agents to accept false evidence;
- repeated changes or history show agents repairing symptoms at several sites because the owning model or seam remains wrong.

For every candidate, state the agent task, the repository evidence a fresh agent would encounter, the wrong or unnecessarily expensive action that evidence invites, and how the damage compounds across later changes. If that chain is missing, the candidate is out of scope.

Use this counterfactual: if a normal local bug fix completely removes the problem and leaves no agent-specific ownership, handoff, change-locality, or verifier problem, exclude it. For example, an unsafe retry, non-atomic write, task crash, UI race, missing test, or malformed input handler is ordinarily a bug. It belongs here only when the codebase's competing authority, lying boundary, unreconstructable state, or misleading verifier is the demonstrated reason repeated agents will misunderstand or compound it.

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

Follow the evidence beyond the named smell when the real problem has a different shape. Do not recommend documentation to conceal unclear ownership or duplicated behavior that the implementation itself should resolve. Do not convert an ordinary code review into an agent-native audit by adding the phrase "a future agent" to a generic failure scenario.

## Separate clues from findings

Do not call something technical debt merely because it is old, large, frequently changed, has TODOs, or has low test coverage. Naming taste, style dislike, abstraction depth, dependency count, a long call chain, and an ordinary runtime defect are not findings either. Use them as clues about where to inspect.

Report a finding when you can show how repository structure makes a realistic agent change harder to locate, understand, contain, resume, or verify. Support it with exact paths, symbols, callers, wiring, history, durable state, or verifier behavior. Runtime observations may demonstrate the consequence, but they do not supply the agent-native mechanism by themselves.

When evidence is incomplete, report a suspicion and the decisive check still needed. Do not promote it to a finding.

## Report findings

For each supported finding, include:

- the smell and its exact evidence receipt;
- the realistic task a fresh agent is likely to receive;
- what stable repository evidence misdirects, underspecifies, or fails that agent;
- the concrete wrong patch, missed owner, broken handoff, or false acceptance that follows;
- how repeated work compounds the cost rather than ending with one local defect;
- the boundary that should own the behavior, state, decision, or effect;
- the smallest coherent remedy, judged by the resulting system rather than diff size;
- material alternatives and their tradeoffs;
- a verification plan at the affected public or real-use seam that would give later agents trustworthy acceptance evidence;
- uncertainty, contrary evidence, and any unresolved authority or product decision.

Explain interactions between findings when one remedy would remove several symptoms. Prefer that shared cause over separate local patches. Recommend no change when the evidence does not support one.

Keep ordinary bugs and general engineering improvements out of the findings. If they are useful context, list them briefly as explicitly out-of-scope observations only when the user asked for them. Do not let their severity displace the agent-native question.

In an audit-only run, a verification plan does not authorize executing mutating checks. Run checks only when they are known to leave the target unchanged, or isolate their outputs outside the target when the user's authorization permits it. Under a zero-write constraint, do not run tools that may create caches or generated artifacts.

## Remediate only when authorized

If the user authorizes code changes, confirm the exact scope and resolve findings at their owning boundary. Remove replaced paths and duplicate authority when current contracts allow it. Do not preserve parallel behavior through shims or fallbacks without a concrete consumer, persisted-data constraint, or deployment need.

Keep the implementation proportional to the proven problem. Do not add general frameworks, configuration, tests, or documentation for speculative variants.

## Verification

For code-affecting remediation, verify observable behavior through the public interface or a representative real-use flow at the affected seam. Cover the maintenance scenario from the finding and confirm the intended owner now controls the behavior. Check that removed or consolidated paths no longer remain live or plausible authorities.

Compilation, type checks, lint, and private implementation tests may supplement behavioral evidence but do not replace it. Report each check actually run, its result, and any behavior left unverified. If the environment blocks a meaningful check, state the limitation and give the exact continuation route.

Recheck continuation quality after the change. A fresh agent should be able to locate the owner, follow the data and effect flow, identify the public verifier, and resume from stable repository evidence without relying on the audit transcript. Report any ambiguity that remains.
