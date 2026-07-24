# PR 522: Codex and ChatGPT skill metadata

Research date: 2026-07-12

## Current repository status (2026-07-24)

PR 522 was closed unmerged. Upstream later landed the slimmer PR 551 with display metadata and invocation policy but without PR 522's default prompts. This repository keeps locally owned `agents/openai.yaml` metadata, including explicit starter prompts, for every retained skill. The previously vendored `external/openai-skills/openai-docs` skill and its updater have been removed; references below to OpenAI's public documentation describe the external harness contract, not a current local skill.

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

Closest rejected alternative at research time: add metadata only to the personal skill and wait for PR 522 to merge before refreshing vendored skills. PR 522 did not merge, and the repository instead retained local metadata across the final pruned catalog. Reconsider the broader metadata policy if this repository stops treating Codex and ChatGPT desktop as supported targets.

## Verification status

At research time, static checks covered metadata shape and paired invocation policy, and `codex debug prompt-input` covered implicit-list behavior. Those observations predate the final catalog pruning and are historical evidence, not verification of the current installed set. Current repository verification should enumerate the retained catalog, validate paired invocation controls and `$skill-name` starter prompts, and inspect actual Codex or ChatGPT presentation separately when needed.
