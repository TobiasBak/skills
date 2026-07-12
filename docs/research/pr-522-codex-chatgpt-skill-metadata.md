# PR 522: Codex and ChatGPT skill metadata

Research date: 2026-07-12

## Findings

- OpenAI documents Agent Skills for the ChatGPT desktop app, Codex CLI, and the Codex IDE extension. Codex initially exposes each skill's `name`, `description`, and path, then loads `SKILL.md` after selection. Concise, front-loaded `SKILL.md` descriptions therefore remain the main model-facing discovery mechanism. [OpenAI Agent Skills docs](https://developers.openai.com/codex/skills)
- `agents/openai.yaml` is optional OpenAI-specific harness metadata. `interface.display_name`, `short_description`, and `default_prompt` improve presentation and explicit launch UX. They do not replace `SKILL.md.description` for implicit discovery. [OpenAI Agent Skills docs](https://developers.openai.com/codex/skills) [OpenAI metadata reference](https://github.com/openai/skills/blob/main/skills/.system/skill-creator/references/openai_yaml.md)
- `policy.allow_implicit_invocation: false` prevents Codex from selecting a skill implicitly while preserving explicit `$skill-name` invocation. Pi uses `disable-model-invocation: true` in `SKILL.md` for the same user-only intent, so explicit-only skills need both controls. [OpenAI Agent Skills docs](https://developers.openai.com/codex/skills) [Pi Skills docs](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/skills.md)
- Pi follows the Agent Skills standard and reads `SKILL.md`; its documented skill model does not consume `agents/openai.yaml`. OpenAI metadata is additive and has no direct effect on Pi. Shared skill instructions and descriptions remain the portable performance surface. [Pi Skills docs](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/skills.md)
- OpenAI's API skill support likewise places each mounted skill's name, description, and path in prompt context. Explicitly telling the model to use a named skill gives more deterministic selection. [OpenAI API Skills guide](https://developers.openai.com/api/docs/guides/tools-skills)

## PR assessment

PR [mattpocock/skills#522](https://github.com/mattpocock/skills/pull/522) has three commits:

1. `e43a3b5` adds `agents/openai.yaml` to the main skills.
2. `4681148` expands and corrects metadata and dual-harness authoring guidance.
3. `dece63f` adds repository-specific validation and an `AGENTS.md` symlink.

The metadata and dual-policy pairing match current OpenAI and Pi behavior. The PR's Ruby validator, repository promotion wiring, handoff work, and symlink convention are specific to the upstream repository and should not be copied wholesale.

## Recommendation

Support all skills in this workbench with OpenAI metadata because the repository explicitly targets Pi, Codex, and ChatGPT desktop. Preserve model discovery triggers in `SKILL.md.description`; use `agents/openai.yaml` for OpenAI presentation, starter prompts, and invocation policy. Keep Pi's `disable-model-invocation` paired with Codex's `allow_implicit_invocation: false` on user-only skills.

Closest rejected alternative: add metadata only to the personal skill and wait for PR 522 to merge before refreshing vendored skills. That avoids temporary vendor divergence, but leaves the currently installed skill set inconsistent across the supported OpenAI surfaces. Reconsider the broader port if this repository stops treating Codex and ChatGPT desktop as supported targets.

## Verification status

Static checks prove metadata shape and paired invocation policy. `codex debug prompt-input` confirms model-invoked skills appear once, user-only skills stay out of the implicit list, and the bundled `openai-docs` skill is not duplicated. Actual model selection and ChatGPT desktop presentation still need manual inspection because the ChatGPT client implementation is not public.
