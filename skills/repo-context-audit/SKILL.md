---
name: repo-context-audit
description: Audit and improve a repository's agent-facing context docs through guided questions and edits. Use when reviewing AGENTS.md, CONTEXT.md, README, ADRs, skill docs, repo mission, agent instructions, or context-bloat problems.
---

# Repo Context Audit

Review a repository's agent-facing documentation and improve it through a question-driven editing loop.

The goal is not to create more rules. The goal is to make the repo's mission, language, critical trade-offs, and verification expectations clear enough that future agents make better decisions with less context.

## Glossary

- **Mission Brief** — the repo-level operating context that tells agents what the repository is trying to achieve, what trade-offs matter, what quality looks like, and which docs to use when making decisions.
- **Root Context** — the repo-wide glossary. It should define shared language, not operating instructions or implementation detail.
- **Context Discipline** — keeping only task-relevant information in working context through targeted discovery, concise summaries, and references.
- **Verification Surface** — the public interface, workflow boundary, rendered artifact, command, or output through which behavior can be proven.

## Workflow

### 1. Inspect

Use targeted discovery before broad reads:

- Find root docs: `AGENTS.md`, `CONTEXT.md`, `CONTEXT-MAP.md`, `README.md`, `docs/adr/`.
- Find nested context docs, skill docs, or package-specific agent docs.
- Read only the files needed to understand the repo's mission, language, and agent workflow.

Assess:

- What mission the docs imply.
- Whether `AGENTS.md` reads like a Mission Brief or a generic rule dump.
- Whether `CONTEXT.md` is glossary-only and uses precise canonical terms.
- Whether ADRs explain surprising, hard-to-reverse trade-offs.
- Whether code-affecting guidance includes Verification Discipline and useful Verification Surfaces.
- Where docs duplicate, conflict, go stale, or create avoidable context load.

### 2. Present Audit

Summarize the repo's current documentation shape, then list the top 3 improvement candidates.

For each candidate include:

- **Files** — docs involved.
- **Problem** — why the current docs weaken agent decisions.
- **Recommended direction** — the edit you would make.
- **Question** — the one developer answer needed before editing.

Ask one question at a time. Provide your recommended answer with each question.

### 3. Edit Inline

After the developer answers, edit the relevant docs immediately. Do not batch resolved decisions.

Use this placement discipline:

- Put canonical vocabulary in `CONTEXT.md`.
- Put mission, critical judgment, repo operating context, and agent behavior in `AGENTS.md`.
- Put human setup and commands in `README.md`.
- Put hard-to-reverse, surprising trade-offs in `docs/adr/`.
- Put skill-specific domain language in the skill's own `LANGUAGE.md`.

### 4. Verify

After edits:

- Re-read changed docs for contradictions and stale terms.
- Search for old terms that should have been replaced.
- Verify links and repo scripts when the docs or manifest affect them.
- Report what changed, what was verified, and any remaining documentation gap.

## Output Shape

```md
## Repo context audit

Current shape:
- ...

Top candidates:
1. **...**
   - **Files** — ...
   - **Problem** — ...
   - **Recommended direction** — ...
   - **Question** — ...
```
