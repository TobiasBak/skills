---
name: retro
description: Review coding-agent sessions for concrete improvements to a repository's navigation, checks, tools, and instructions. Use for a repo-focused retrospective, not a vault knowledge review.
disable-model-invocation: true
---

# Repo retrospective

Improve the coding agent's environment from what happened in real sessions. Find changes that make the next agent's work easier, not more rules for their own sake.

A retrospective is read-only unless remediation is already authorized. Leave source histories unchanged and keep raw transcripts, extracts, and runtime state out of commits.

## Select the sessions

Use the repository and session window the user requested. If no session is specified, review the current one. For "last N sessions," select the latest N relevant sessions for that repository, not the machine's latest N files. Treat child-agent work as part of its parent run rather than an independent recurrence.

Use available session tools or local histories. Read the exchanges and tool results around each candidate; a summary alone can miss the cause. State which sessions were reviewed and any gaps. Do not claim a requested count when some histories were unavailable.

## Trace the friction

Connect the session event to the repository as it exists now. Find the current owner, callers, manifests, scripts, checks, and relevant instructions before proposing a fix. A historical problem already resolved needs no new patch.

Look for:

- **Navigation.** Failed searches, misleading names, stale pointers, hidden dependencies, or scattered ownership. Prefer clearer names and boundaries before adding a file map.
- **Automated checks.** Mistakes a deterministic check could catch. Inspect the existing check command and CI first; repair an unwired or broken check rather than inventing another. Missing CI alone does not justify new infrastructure.
- **Review and instructions.** Repeated steering, contradictory rules, duplicated guidance, or no-op coaching. Mechanically enforceable rules belong in existing checks; judgment belongs in scoped review guidance. Reviewers still need the affected callers and contracts, not just a diff.
- **Tools and information.** Repeated expensive calls, missing logs, awkward control interfaces, or inaccessible evidence. Recommend the smallest useful improvement without treating a retrospective as permission to install tools or connect accounts.

Distinguish recurring friction from an isolated mistake, normal exploration, changed intent, and useful clarification. Turn count, tone, or one slow search does not establish a recurring problem.

## Recommend the changes

Present the strongest candidates first. For each, give the session event, the current repository location, the likely cause, and a concrete improvement. Keep enough provenance to revisit the finding without reproducing private transcripts. State uncertainty where it changes the recommendation; no finding is a valid result.

Prefer fixes to code ownership, names, executable tooling, and feedback. Keep ordinary commands in their manifests or scripts. Add prose only for useful navigation, rationale, contracts, or hazards that still need explanation. Do not replace a confusing source design with another layer of AGENTS instructions.

Do not edit, save findings elsewhere, commit, push, or publish unless that action is already authorized. A request to review histories does not authorize those changes.

## Verification

For each proposed fix, name what would show it worked. When remediation is authorized, repeat the failed lookup, command, or user path and run the relevant behavioral checks. For navigation changes, confirm a fresh search reaches the actual owner and its callers. Report what was checked and what remains unverified; a shorter document or a passing build alone does not prove the original friction is gone.
