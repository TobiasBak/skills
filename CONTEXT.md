# Skill Workbench

A shared language for a repository used to shape reusable agent capabilities.

## Language

**Skill Workbench**:
A place for authoring, curating, installing, and validating reusable agent skills.
_Avoid_: Skill repo, prompt repo, agent notes

**Skill**:
A reusable agent capability for handling a specific task, workflow, or domain.
_Avoid_: Prompt, snippet, agent note

**Context Discipline**:
Keeping only task-relevant information in an agent's working context by preferring targeted discovery, summarized findings, and reusable references over broad dumps.
_Avoid_: Context bloat, dumping files, overloading context

**Design Ambition**:
Treating existing repository patterns as evidence rather than law, while still seeking the best defensible solution for the current problem.
_Avoid_: Lazy suggestion, just follow the repo, overfitting to existing patterns

**Recommendation Standard**:
A minimum bar for non-trivial recommendations: clear direction, closest rejected alternative, trade-off, and verification path.
_Avoid_: Vibes, generic advice, lazy suggestion

**Progressive Disclosure**:
Organizing skill knowledge so agents load short entry-point instructions first and only load detailed references when the task needs them.
_Avoid_: Deep manuals, giant skill files, always-loaded context

**Root Context**:
The repository-wide glossary for Skill Workbench language, excluding vocabulary owned by individual skills.
_Avoid_: Skill glossary, domain vocabulary dump

**Model Compensation**:
A reason for a skill to exist: it reliably compensates for a recurring model weakness, missing workflow discipline, or tool-use habit that should not be trusted to the base model alone.
_Avoid_: AI tips, model complaints, prompt collection

**Verification Discipline**:
Proving completed work through the relevant local command, runtime check, or rendered artifact before claiming it is done.
_Avoid_: Looks good, should work, unverified fix

**Behavioral Coverage**:
Testing meaningful behavior through a useful Verification Surface with controlled fixtures and observable output.
_Avoid_: Shallow unit test, implementation-detail test, testing only the edited function

**Code-Affecting Skill**:
A skill whose output either changes executable artifacts directly or shapes decisions expected to lead to code, tests, UI, scripts, automation, or generated artifacts.
_Avoid_: Implementation skill, coding skill

**Verification Surface**:
The public interface, workflow boundary, rendered artifact, command, or system output through which behavior can be proven.
_Avoid_: Stable seam, test hook, unit boundary

**Vendored Skill Review**:
Reviewing upstream skill updates as incoming changes before accepting them, because local edits to vendored skills may intentionally diverge from upstream.
_Avoid_: Untouchable external skill, generated dependency, blind upstream sync

**Subagent Delegation**:
Assigning bounded, independent exploration, design, implementation, or verification tasks to subagents so the main agent receives concise findings instead of loading broad context directly.
_Avoid_: Context dump, solo exploration, unfocused delegation

**Mission Brief**:
The repo-level operating context that tells agents what the repository is trying to achieve, what trade-offs matter, what quality looks like, and which docs to use when making decisions.
_Avoid_: Rule dump, generic agent instructions, lint for agents
