---
name: to-spec
description: Turn the current conversation into a spec and publish it to an explicitly configured tracker or a local file — no interview, just synthesis of what you've already discussed.
disable-model-invocation: true
---

This skill takes the current conversation context and codebase understanding and produces a spec (you may know this document as a PRD). Do NOT interview the user — just synthesize what you already know.

Use a repository or user tracker configuration only when it explicitly names the destination and conventions. A configured tracker does not by itself authorize an external write; publish remotely only when the user has authorized it for this work. Otherwise write the spec to `.scratch/<feature-slug>/spec.md`. Apply only labels or workflow fields explicitly configured for that repository or requested by the user.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the project's domain glossary vocabulary throughout the spec, and respect any ADRs in the area you're touching.

2. Sketch out the seams at which you're going to test the feature. Existing seams should be preferred to new ones. Use the highest seam possible. If new seams are needed, propose them at the highest point you can. The fewer seams across the codebase, the better - the ideal number is one.

Check with the user that these seams match their expectations.

3. Write the spec using the template below, then publish it to the explicitly configured and authorized tracker. If no such destination is available, use the local-file default above.

<spec-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

## Verification Decisions

Describe the behavioral verification expected from implementation. Include:

- The public interface, real workflow, rendered artifact, command output, or other observable surface that proves the feature works
- The meaningful behaviors and failure states that must be exercised
- Relevant prior art in the codebase
- Supporting compilation, type, lint, or unit checks where useful, without treating implementation-detail checks as sufficient by default
- What an implementer must report when environmental limits allow only partial verification, including unverified behavior and residual risk

## Out of Scope

A description of the things that are out of scope for this spec.

## Further Notes

Any further notes about the feature.

</spec-template>
