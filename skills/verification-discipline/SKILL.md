---
name: verification-discipline
description: Verification discipline for all code-affecting work. Use when an agent changes or shapes code, tests, UI, scripts, automation, generated artifacts, or plans expected to lead to code; when another skill needs a Verification Surface; or when verification exposes shallow modules, unclear seams, weak interfaces, missing behavioral coverage, or partial verification.
---

# Verification Discipline

Prove code-affecting work through behavior at the right interface. Verification is also design pressure: if the only available check reaches past the interface, relies on internals, or cannot observe the requested behavior, challenge the module shape before claiming completion.

Use the `/codebase-design` skill for the shared architecture vocabulary: **module**, **interface**, **implementation**, **depth**, **seam**, **adapter**, **leverage**, and **locality**. Do not redefine those terms here.

## Workflow

### 1. Identify the surface

Name the behavior being changed and the **Verification Surface** that can prove it: public interface, workflow boundary, rendered artifact, command output, runtime behavior, or generated file.

If a module is involved, identify its **interface** and the **seam** tests or checks should cross.

Completion criterion: you can state what observable behavior would fail before the work and pass after it.

### 2. Apply design pressure

Use `/codebase-design` when the surface is unclear, the interface is too wide, tests must reach into internals, dependencies are created instead of accepted, or verification would scatter across callers.

When this exposes shallow modules or a deepening opportunity, read `/codebase-design`'s `DEEPENING.md` and classify dependencies before changing the design.

Keep pressure scoped:

- Improve the module, interface, or seam when that is necessary to verify the requested behavior properly.
- If deepening is larger than the task, name the opportunity and verify the current change as honestly as possible.

Completion criterion: either the design supports a behavioral check through an appropriate surface, or the remaining design limitation is explicit.

### 3. Verify behavior

Run the strongest local check available for the task:

- Tests through the module interface or workflow boundary.
- A command or script with controlled inputs and observable output.
- A rendered UI, screenshot, browser interaction, or generated artifact inspection.
- A focused runtime check that exercises the changed behavior end to end.

Prefer Behavioral Coverage over shallow assertions. Compilation, lint, or type checks are supporting evidence unless they directly prove the requested behavior.

Completion criterion: the check would catch the bug, regression, or missing behavior the work is meant to address.

### 4. Report tersely

In the final answer for code-affecting work, include:

- **Verification Surface** — what behavior boundary was checked.
- **Verification** — exact command, runtime check, rendered artifact, or manual inspection performed.
- **Gap** — any partial verification, weak surface, or deferred deepening opportunity.

Completion criterion: the user can see what was proven, where it was proven, and what remains unproven.
