---
name: create-verification-skill
description: Create a project-local verification skill and feature map that drive the real app. Use when asked to build a reusable verification or control workflow for a project.
disable-model-invocation: true
---

# Create a verification skill

Give the next agent a tested way to launch the real app, exercise its features, and keep proof of what happened. Write for an agent arriving cold, not for someone who remembers this session.

## Interview the repo, not the user

Find these in the code and existing tooling. Ask only about decisions or prerequisites you cannot discover:

- What users actually touch: browser, CLI/TUI, desktop, mobile, API, or library. Pick the primary interface and note others that matter.
- How the intended build starts, becomes ready, and gets its test data, configuration, and authentication.
- How to drive it. Reuse existing application commands, tests, browser tools, PTY helpers, or HTTP endpoints before building a control interface.
- What proves the result: visible state, responses, exit codes, persisted data, requests, screenshots, or traces.
- How to isolate runs through data directories, profiles, ports, or sessions. If isolation is unavailable, state the single-driver restriction.

Use a verification-owned instance and disposable state. If the checkout cannot start, fix it within the authorized scope or report the blocker. Do not write instructions against a broken base or drive the user's live instance by default.

## Write the skill

Follow the project's skill convention, defaulting to `.agents/skills/verify-<app>/`. Include `SKILL.md` with a name and description, plus `agents/openai.yaml` for Codex discovery. Its starter prompt names `$verify-<app>`. Keep invocation policy consistent with the target repository.

Ground every instruction in the application and commands you inspected. Include:

- **Launch.** Start the intended build, identify this run's instance and state, check readiness, and describe teardown. A short-lived CLI needs a fresh invocation or isolated PTY per drive, not a pretend server.
- **Doctor.** A cheap read-only check that establishes whether this is the intended build and instance, with the prerequisites needed for the workflow. Run it before driving and again after surprising behavior.
- **Drive.** Real commands or selectors. Prefer stable handles such as accessible names, route paths, or prompt strings over coordinates and tab order.
- **Evidence.** Name the artifact location. Capture the action and resulting state, not just a final screen. Check meaningful side effects through a second observable view. Keep secrets out of artifacts intended for sharing.
- **Cleanup.** Stop only processes and sessions this run owns; never kill by process name. Remove disposable state, not proof artifacts. Clean failed attempts too.
- **Verification.** Exercise the real user path and check its observable result. Fixtures establish starting state; internal setters or test-only endpoints must not manufacture the result. Use doubles at existing external boundaries and state what still needs a live check.

Any shipped helper is executable and has a documented invocation. Build only missing operations; ordinary command definitions belong in their existing executable owners, not a second prose copy.

Do not trust a mode's name. When verification uses dry-run or test mode, observe what it actually writes or contacts.

## Seed the feature map

Add a `features/README.md` index and feature files beside the generated skill. Start with a few important workflows found in routes, commands, menus, tests, or product documentation.

Each entry explains what the feature does, how users reach it, required starting state, how to drive it, and what observable result proves it worked. Include distinct entry points that affect behavior and useful gotchas. Keep shared setup in the skill or its tools, not copied into every feature.

If a worked shape would help, read [the feature-map example](references/feature-map-example/README.md). It is fictional; do not copy its commands or selectors into a real project.

## Verification

Run the generated instructions from launch through cleanup, including doctor and at least one mapped feature. Capture the actual interaction and result. Confirm the proof still exists after cleanup and that no run-owned process or scratch state remains.

Repair failed steps and rerun them. A skill never executed against the app is a draft, not a completed deliverable. Report what passed and what remains blocked or unverified.

Leave the generated skill and map reviewable. Commit, push, or publish only when authorized. Point to `$maintain-verification-skill` for later upkeep; suggest a schedule only if requested.
