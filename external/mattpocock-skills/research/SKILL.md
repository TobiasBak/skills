---
name: research
description: Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched, docs or API facts gathered, open-source library internals or change history investigated, or reading legwork delegated to a background agent.
---

Spin up a **background agent** to do the research, so you keep working while it reads.

Its job:

1. Investigate the question against **primary sources** — official docs, source code, specs, first-party APIs — not a secondary write-up of them. Follow every claim back to the source that owns it.
2. Write the findings to a single Markdown file, citing each claim's source.
3. Save it where the repo already keeps such notes; match the existing convention, and if there is none, put it somewhere sensible and say where.
4. For open-source implementation or history claims, inspect source and git history directly. Cite immutable GitHub permalinks with full commit SHAs and exact line ranges; use commit, blame, issue, and PR evidence when explaining why something changed.

## Verification

Before finishing, verify that the findings file exists, cited URLs resolve, immutable source links use full commit SHAs and correct line ranges, and the write-up clearly distinguishes evidence from inference.
