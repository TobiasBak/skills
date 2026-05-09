---
name: feedback-loop
description: When invoked, immediately audit current working directory for missing closed local feedback loops and return a prioritized list of max 3 loop-closing opportunities; never ask whether to do repo audit or loop improvement. Use when user invokes /feedback-loop or asks about feedback loops, repo testability, local validation workflows, agent-verifiable code, or gaps from unit tests through e2e tests.
---

# Feedback Loop

Surface missing or weak **closed local feedback loops** — local commands that let humans and agents verify behavior with known input, observable output, loud failure, deterministic execution, cleanup, and no hidden manual steps.

Invocation means: audit current working directory now. Do not ask whether user wants repo audit, loop improvement, or target area. Do not wait for another prompt.

Ignore CI/CD unless user asks. Treat CI as later packaging of local loops; local closure comes first.

## Glossary

Use these terms exactly in every suggestion. Consistent language is the point. Full definitions in [LANGUAGE.md](LANGUAGE.md).

- **Loop** — local verification path with known input, observable output, loud failure, determinism, cleanup, and no hidden manual steps.
- **Signal** — specific failure or output proving behavior changed.
- **Fixture** — controlled input state: files, DB rows, env vars, services, clock, network responses, queues, browser state, or temp dirs.
- **Cleanup** — return repo and local machine to pre-loop state.
- **Scope** — how much system loop exercises: static, unit, component, integration, e2e, or manual.
- **Determinism** — same fixture + command -> same signal.
- **Closure** — one documented local command produces signal and cleanup.
- **Leverage** — how many future changes loop can verify per unit setup/runtime.
- **Locality** — how close signal is to changed behavior.

Key principles:

- **Closure beats coverage.** Coverage without fixture, signal, and cleanup is not closed.
- **The command is the interface.** If agents cannot find and run command locally, loop does not exist for them.
- **Prefer smallest useful scope.** Use integration/e2e only when real boundaries are behavior under test.
- **Fixtures are part of the loop.** Setup and reset must be explicit and repeatable.
- **Manual verification is a gap.** Screenshots, clicking, ad hoc curl, and hidden service setup are not closure.

## Process

### 1. Explore

Inspect repo for existing loops and missing closure. Start with fastest safe discovery commands. Avoid destructive commands unless user explicitly approves.

Read likely loop surfaces:

- README, AGENTS, package files, lockfiles, build files, Makefile/justfile/taskfile
- test dirs, fixtures, snapshots, e2e specs, docker/devcontainer files
- scripts for test, unit, integration, e2e, smoke, lint, typecheck, build
- seed/reset/cleanup helpers
- code areas with no direct tests or only manual verification

Explore organically. Note where agent verification gets stuck:

- command exists but required setup is tribal knowledge
- tests assert little or have vague signal
- fixture is shared, flaky, time-dependent, external, or order-dependent
- cleanup leaves files, DB state, services, ports, queues, caches, or temp data
- broad slow check exists but no smaller targeted loop
- behavior is only verified by manual UI/API inspection

### 2. Classify current loops

Classify important loops by **Scope**:

1. Static — format, lint, typecheck, schema checks.
2. Unit — pure functions/classes with fixed input/output.
3. Component — module plus fake deps, temp dirs, or controlled fixtures.
4. Integration — real boundary like DB/files/network behind controlled fixture.
5. E2E — user/system path with seeded data and full cleanup.
6. Manual — not closed; treat as gap.

For each important loop, note command, **Signal**, **Fixture**, **Determinism** risk, runtime roughness, and **Cleanup** quality.

### 3. Present loop-closing opportunities

Present a numbered list of at most 3 opportunities, prioritized by agent-verification pain and smallest useful fix.

For each opportunity include:

- **Files** — files/modules/scripts involved
- **Problem** — why current verification lacks **Closure**
- **Loop to close** — smallest concrete loop to add or repair, including **Scope**, command shape, **Fixture**, **Signal**, and **Cleanup**
- **Benefits** — explained in terms of **Locality**, **Leverage**, and agent-verifiable changes

Only recommend polishing existing loops when audit finds no meaningful missing or weak closed loops.

Do not ask follow-up questions before presenting audit. After presenting opportunities, ask: "Which loop would you like to close first?"

## Output format

```md
## Feedback loop audit

Current loops:
- ...

Missing or weak loops:
- ...

Loop-closing opportunities:
1. **...**
   - **Files** — ...
   - **Problem** — ...
   - **Loop to close** — ...
   - **Benefits** — ...

Which loop would you like to close first?
```

If fewer than 3 opportunities matter, return fewer. If repo lacks usable loops, say so plainly and recommend smallest first loop.
