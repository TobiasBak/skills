# AGENTS.md

- Every installed skill must contain `SKILL.md` and `agents/openai.yaml`. Keep invocation policy synchronized: model-invoked skills omit both `disable-model-invocation` and `policy.allow_implicit_invocation`; user-only skills set the former to `true` and the latter to `false`.
- Do not run skill installers or vendored-skill updaters without explicit approval. They mutate global links or replace vendored files.
- A new or materially changed code-affecting skill must name the behavioral verification expected from work it guides; do not treat compilation or implementation-detail tests as sufficient by default.
