---
name: run-to-completion
description: Drives agreed work to completion by creating a timestamped markdown todo plan, extracting every requested item from context/source files, executing every actionable item, validating results, and reporting only after completion. Use when user asks agent to finish all suggested work without stopping, says run to completion, do not ask questions, continue until done, implement everything, address every bullet, implement the plan, or invokes this skill after a design/planning conversation.
---

# Run To Completion

## Core rule

Do not ask follow-up questions. Use existing context, inspect repo, choose sane defaults, and keep working until todo list is complete or blocked by a hard external dependency.

## Quick start

1. Create todo file before edits:
   - Use OS temp dir, not repo dir.
   - Put files under temp subdir: `pi-runs/todos/`
   - Example paths: `$TMPDIR/pi-runs/todos/`, `/tmp/pi-runs/todos/`, `%TEMP%\\pi-runs\\todos\\`
   - Never create `.pi-runs` or other run-tracking dirs inside repo unless user explicitly asks.
   - Filename: `YYYY-MM-DD-HHMMSS-run-to-completion-[short-slug].md`
2. Read every referenced plan/spec/todo/testcase file in full.
3. Convert conversation/context/files into concrete checklist with one or more tasks for every bullet/requirement.
4. Execute checklist item by item.
5. Mark each item done in file as work finishes.
6. Run validation.
7. Reply only when finished or truly blocked.

## Todo file format

```md
# Run To Completion: [short title]

- Started: [ISO timestamp]
- Context: [one paragraph summary]
- Goal: [desired final state]
- Status: in-progress

## Todo

- [ ] Inspect relevant files and current behavior
- [ ] Add/modify implementation
- [ ] Add/update tests
- [ ] Run focused validation
- [ ] Run broader validation where practical
- [ ] Review diff for mistakes
- [ ] Update status to complete

## Notes

- Decisions made:
- Validation output:
- Blockers:
```

## Building checklist

Make checklist exhaustive, traceable, and implementation-sized:

- Treat every bullet, heading requirement, testcase, edge case, and explicit suggestion in referenced files as required work.
- Do not choose representative/high-value subsets unless user explicitly asks for subset.
- Read source plan/spec/testcase files fully; do not skim only top sections.
- Create traceability entries like `Source: firestore-testcases.md > Flask route tests > /materials`.
- Break each source item into implementation, test, docs, and validation subtasks as needed.
- If item already works, add verification task and mark complete only after checking.
- If item is duplicate/obsolete/not applicable, record reason under Notes and mark as addressed, not silently skipped.
- Include discovery tasks, implementation tasks, tests, docs, validation, cleanup.
- Include checks for edge cases, existing behavior, lint/type/test failures.
- Prefer many small checkboxes over broad phase labels.
- Add new tasks when discovery reveals missing work.

## Execution rules

- Act autonomously. Do not pause for approval between phases.
- Use tools freely for inspection, edits, tests, formatting, and validation.
- Choose conservative defaults when details missing.
- Keep scope tied to agreed context; avoid opportunistic rewrites.
- Never collapse a long list into broad categories that can hide skipped items.
- Maintain todo file during work: change `- [ ]` to `- [x]` as tasks complete.
- If validation fails, add fix tasks and continue.
- If blocked by missing credential, unavailable external service, destructive action, or impossible ambiguity, record blocker and stop.

## Completion criteria

Finish only when all source items are either implemented, verified already covered, or explicitly recorded as blocked/not applicable with reason; all non-blocked todo items are checked; and at least one validation path has run or been explicitly recorded as unavailable.

Final response must include:

- Todo file path
- Summary of changes
- Coverage statement: whether every source item was addressed, plus exceptions with reasons
- Validation run and result
- Any remaining blockers or follow-up, if unavoidable
