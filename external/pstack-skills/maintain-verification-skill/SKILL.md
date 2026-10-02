---
name: maintain-verification-skill
description: Check an existing project verification skill and feature map against source and live behavior, then fix proven drift. Use when asked to audit or maintain that verification workflow.
disable-model-invocation: true
---

# Maintain a verification skill

Keep the project's verification skill and feature map honest. Cover every mapped feature from source and in the running app; one convenient passing path is not full coverage.

## Scope

Find the existing skill with launch, drive, and feature-map instructions. Ask which one if the target is ambiguous. If none exists, point to `$create-verification-skill` rather than inventing a maintenance target.

Edit only that skill's directory, feature map, and helpers it owns. Do not change product code. Distinguish stale instructions, a broken control tool, and a product regression. Never redefine expected behavior to make a bug look correct.

Keep one writer and one owner of live application driving. For a broad map, delegate read-only source inspection by feature; source readers neither drive the app nor edit files.

## Check the map against source

Read the index and its feature files. Reconcile missing, duplicate, or dead entries without generating a source-file inventory.

For each feature, locate its implementation and user entry points, identify likely drift, and build a concise live-verification recipe. Check recent user-facing changes for missing mapped features; require a concrete source path, not a guess.

Combine recipes that share application state, while keeping coverage of every feature and materially distinct entry point visible. Use the intended product contract to judge results, not merely what today's implementation does.

## Run the live pass

Follow the verification skill's launch model. Drive a long-lived server or UI serially; use fresh isolated sessions where the skill calls for short-lived CLI invocations.

- Doctor before the first drive and after any failed or surprising drive. If a healthy process has a wedged UI, reset to a known state or relaunch instead of trusting process health alone.
- Capture each action and its result, including relevant side effects. Keep proof outside disposable state and check that it survives cleanup.
- Clean failed attempts and their residue. Stop only instances and sessions this run owns; never remove another session's state or process.
- When a prerequisite blocks a feature, record the attempted route and the missing authentication, entitlement, OS, or external state. A different passing path does not verify the blocked one.

If doctor fails because the skill is stale, correct it within scope and retry after restarting only what the correction invalidates. If it still fails, report the blocker and partial coverage.

## Triage and correct

- Wrong or missing instructions are map drift. Correct them against source and observed behavior.
- Working behavior the helper cannot drive is a harness gap. Repair helpers this skill owns and document their actual invocation; report gaps in tools owned elsewhere.
- Broken application behavior is a product regression. Preserve the expected result, capture evidence, and report it without editing product code.

Rerun each corrected instruction or helper against the app. An expected result is not proof that the helper can establish it.

## Verification and handoff

Exercise every mapped feature, then rerun affected workflows after corrections. Do the final teardown after those checks. Confirm evidence remains at the named location and no run-owned process or scratch state remains.

Report one outcome:

- **Clean.** Source and live coverage completed; no corrections needed.
- **Changed.** Proven corrections remain as one coherent, reviewable change set. Name any separate product failures.
- **Blocked.** Required coverage or verification could not finish. Name the blocker and what was checked.

List covered features, blocked paths, confirmed drift, product regressions, and artifact locations concisely. Keep raw run notes and captures in scratch space, not in the skill. Commit, push, or create a PR only when authorized.
