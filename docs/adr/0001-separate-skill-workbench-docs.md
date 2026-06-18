# Separate Skill Workbench glossary, agent instructions, and setup docs

We separate repository knowledge by audience and load pattern: `CONTEXT.md` defines only Skill Workbench vocabulary, `AGENTS.md` acts as the agent Mission Brief, and `README.md` defines human setup and installation guidance. This keeps shared language discoverable while giving agents mission-critical judgment instead of a generic rule dump, at the cost of requiring contributors and agents to choose the correct document for each change.
