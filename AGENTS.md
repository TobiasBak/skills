# Agent Mission Brief

This repository is a Skill Workbench: it exists to shape reusable agent capabilities around recurring model weaknesses, missing workflow discipline, and tool-use habits that should not be trusted to the base model alone.

Read `CONTEXT.md` as the repo glossary before changing skill docs, installer scripts, or repository guidance. Use root `CONTEXT.md` for Skill Workbench language only; skill-specific domain language belongs in that skill's own `LANGUAGE.md`.

## What Good Looks Like

Good work in this repo makes future agents more effective without making them carry unnecessary context. Favor skills and docs that preserve judgment: why the workflow exists, what trade-offs matter, what quality means, and how the agent should prove its work.

Prefer forward guidance over prohibition. When a standard exists, express the behavior the agent should choose and the reason it matters.

## Operating Standards

**Context Discipline** keeps the working context focused. Use `rg` and `rg --files` for targeted discovery, read narrowly, summarize findings before broad edits, and use Subagent Delegation when broad exploration or parallel questions would otherwise flood the main context.

**Subagent Delegation** is a strong default for broad repo exploration, competing designs, disjoint implementation slices, or parallel verification. Give each subagent a bounded brief with the exact question, relevant paths, expected output, and edit permission. Prefer concise, source-backed findings with paths, line references, changed paths, and verification results over raw dumps.

**Design Ambition** means existing repo patterns are evidence, not law. When asked for the best solution, judge whether the current pattern is good enough, limiting, or harmful. Compare the cost of consistency against the value of improving the design, then keep the improvement scoped to the problem.

**Recommendation Standard** applies to non-trivial guidance. Give a clear recommendation, name the closest rejected alternative, explain the trade-off, state what would change the recommendation, and identify how to verify it locally.

**Verification Discipline** is mission critical for Code-Affecting Skills and code-affecting work. Run the produced code, relevant local command, focused test, or rendered UI before claiming completion. Prefer Behavioral Coverage through a useful Verification Surface with controlled fixtures and observable output. Weak verification surfaces are problems to improve or name clearly; shallow unit tests are sufficient only when they genuinely prove the requested behavior.

## Skill Authoring

Skills should provide Model Compensation for recurring failures, not collect generic advice. Before adding a personal skill, identify the repeated model weakness, workflow discipline, or tool-use habit it addresses. If the target is vague, improve an existing skill, README, or this Mission Brief instead.

Keep `SKILL.md` focused on trigger, orientation, workflow, and routing. Move long or situational detail into linked references, examples, language files, or scripts. Every new or materially edited Code-Affecting Skill needs a concise `Verification` section or checklist that reflects Verification Discipline and Behavioral Coverage.

When a skill can shape implementation even indirectly, treat it as code-affecting for verification purposes. Planning, architecture, and grilling skills should ask what Verification Surface proves the behavior and should challenge weak answers.

## Repository Map

- Personal skills live in `skills/<name>/`.
- Vendored external skills live in `external/mattpocock-skills/<name>/`.
- `skills.json` is the install manifest for both personal and external skills.
- Installer and verification scripts live in `scripts/`.
- Human setup and installation instructions belong in `README.md`.
- Architectural decisions belong in `docs/adr/`.

Vendored external skills may be edited locally. Use Vendored Skill Review when upstream updates are pulled in: protect uncommitted local skill-folder changes and review the resulting diff before accepting the update.

## Tooling

The required development tools are documented in `README.md`. Use `uv run python` for Python execution in repository scripts; avoid adding raw `python` or `python3` script dependencies.
