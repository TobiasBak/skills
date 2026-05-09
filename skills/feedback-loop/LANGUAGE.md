# Language

Shared vocabulary for feedback-loop audits. Use these terms consistently in every suggestion.

## Terms

**Loop**
A local way to verify behavior with known input, observable output, loud failure, deterministic execution, cleanup, and no hidden manual steps.

**Signal**
The specific failure or output proving behavior changed. Good signal is narrow, fast, and hard to misread.

**Fixture**
Controlled input state for a loop: files, DB rows, env vars, service state, clock, network responses, queue messages, browser state, or temp dirs.

**Cleanup**
Everything that returns the repo and local machine to pre-loop state: files, DB state, services, ports, queues, temp data, env vars, caches, and background processes.

**Scope**
How much system the loop exercises: static, unit, component, integration, e2e, or manual.

**Determinism**
Same fixture and command produce same signal. Flaky clocks, random data, shared state, external services, and ordering assumptions weaken determinism.

**Closure**
Loop can run locally from one documented command and finish with signal + cleanup. No manual setup, hidden service, or remembered sequence.

**Leverage**
How many future changes the loop can verify per unit of setup and runtime.

**Locality**
How close the signal is to the behavior being changed. Better locality means smaller debug surface when loop fails.

## Principles

- **Closure beats coverage.** Coverage without fixture, signal, and cleanup is not a closed loop.
- **The command is the interface.** If agents cannot find and run the command locally, loop does not exist for them.
- **Prefer smallest useful scope.** Start with static/unit/component when they can produce reliable signal; use integration/e2e when real boundaries are the behavior.
- **Fixtures are part of the loop.** Seed/reset/setup data must be explicit and repeatable.
- **Cleanup is not optional.** Loops that leave ports, files, DB rows, queues, or services behind create future false failures.
- **Manual verification is a gap.** Treat screenshots, clicking, ad hoc curl, or undocumented service setup as missing closure.
