---
name: bug-fix-nudge
description: Compact correctness-focused loop for diagnosing and fixing bugs, regressions, failures, and incorrect behavior.
---

# Bug Fix Nudge

1. Reproduce the exact symptom. Turn the report into a behavioral checklist before editing.
2. Trace to the first incorrect state and its owning invariant. Test falsifiable hypotheses one variable at a time. Search every caller and implementation before changing a contract.
3. Cover the checklist at a public behavior boundary. Include relevant success, intermediate-state, failure-boundary, concurrency/restart, isolation, and old-data/caller cases.
4. See the regression fail, then make the smallest root-cause fix. Keep lifecycle transitions under one clear owner; every exit path must leave valid observable state.

## Verification

Map each requirement to evidence. Run the regression, original scenario, focused suite, and relevant static checks. Do not infer broad correctness from a narrow green test. Report cause, commands, results, uncovered cases, and residual uncertainty; remove temporary instrumentation.
