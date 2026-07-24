---
name: theory-lab
description: Develop mechanistic, cross-domain theories and convert promising ones into discriminating experiment proposals. Invoke manually for anomaly explanation, theory development, paradigm search, or high-leverage Autoresearch directions beyond incremental optimization.
disable-model-invocation: true
---

# Theory Lab

Use research, cross-domain synthesis, first-principles reasoning, and experiment history to expand the hypothesis space. Optimize this phase for explanatory leverage and information gain, not the smallest safe implementation. A paradigm candidate must change the causal decomposition, controllable variable, representation, objective, scale, or unit of operation, not merely use unfamiliar language.

Invocation authorizes read-only investigation and synthesis. It does not by itself authorize file edits, costly experiments, external side effects, evaluator changes, or promotion of a hypothesis into living knowledge.

## Frame the inquiry

Establish a compact inquiry contract:

- phenomenon, anomaly, or target system;
- desired outcome and what would count as a meaningful breakthrough;
- observations and existing experimental results;
- physical, safety, resource, and deployment constraints;
- current explanation, baseline, or champion;
- evaluator and intervention surface, if they exist;
- research and experiment budget and desired stopping point.

Ask only for missing information that would materially change the investigation. Otherwise proceed with explicit assumptions. Separate observed constraints from conventions inherited from the current design.

## Build a reconstructable working set

When operating in Tobias's knowledge bank, search it before concluding that knowledge is absent. Do not infer absence from `index.md`. Read relevant linked notes, especially `Agentic engineering/Context and orchestration/Agent context engineering.md` and, for empirical loops, `Agentic engineering/Evaluation and improvement/Autoresearch.md`.

Use progressive disclosure:

1. map terminology, relevant notes, artifacts, and experiment records;
2. retrieve focused matches and narrow source sections;
3. load complete artifacts only when their full context is necessary;
4. retain stable paths, source identities, revisions, or URLs for exact recovery.

Treat active context as a working set, not the system of record. Keep bulky papers, logs, traces, and run artifacts outside the reasoning summary. Preserve a compact reconstruction block containing:

- inquiry contract and governing constraints;
- authoritative evidence references;
- observations, assumptions, and anomalies;
- live candidate mechanisms and important rejected mechanisms;
- unresolved questions, current decision, and next action.

Refresh it at semantic boundaries, before compaction, and before handoff. Save it only to an explicitly authorized project or experiment workspace. Never silently write speculative conclusions into the knowledge bank.

Research and theory generation may be interleaved. Research early when facts or mechanisms are missing; generate before searching exact formulations when dominant literature is likely to anchor the search; research afterward to test novelty and find contrary evidence. There is no mandatory research-first or research-last sequence.

Use context isolation when the expected gain justifies it. Give bounded subagents reduced, deliberately different evidence packets for independent mechanism search, adjacent-field research, or adversarial analysis. Do not pass the full transcript or require fixed roles. Keep synthesis, unresolved decisions, and final selection with the orchestrator, and request compact findings with source pointers rather than full traces.

## Reconstruct mechanisms before proposing fixes

Build the strongest current causal account of the phenomenon. Distinguish:

- observations from explanations;
- necessary constraints from design choices;
- correlation from intervention;
- static, dynamic, conditional, and substrate-dependent regimes;
- the resource apparently saved from where its cost, information, or complexity moved.

Identify bottlenecks, feedback loops, scaling behavior, selection effects, hidden state, coordination costs, and anomalies the current account does not explain. State what evidence would make the current account wrong.

## Expand the hypothesis space

Do not begin from the smallest plausible fix. Explore the levels that fit the inquiry:

- **Local:** modify a parameter or component within the current mechanism.
- **Mechanism:** change the explanation of what controls the outcome.
- **Paradigm:** change the representation, decomposition, objective, topology, timescale, or unit of computation.

Develop a small set of mechanistically distinct candidates rather than a long list of slogans. When plausible, preserve at least one branch that challenges the dominant framing until evaluation. Useful transformations include:

- split one concept into independent axes or states;
- invert, remove, or condition a supposedly necessary assumption;
- change the unit of analysis, granularity, timescale, or boundary;
- distinguish numerical value from topology, storage, routing, control, or execution;
- turn a static mechanism into a conditional or adaptive one, or the reverse;
- compose mechanisms from fields that solve structurally related constraints;
- explain an anomaly or repeated failure rather than optimizing around it;
- relocate computation, information, risk, or coordination and account for the receiving subsystem;
- ask what substrate or implementation overhead could reverse the theoretical gain.

A cross-domain analogy is evidence only after mapping the structures explicitly: entities, state, dynamics, constraints, feedback, scale, controllable intervention, bridge premise, and where the mapping fails. Shared vocabulary or mathematical appearance alone is not a mechanism.

Research can contribute known mechanisms, anomalies, negative results, boundary conditions, and unexplored combinations. Search adjacent fields by causal structure, not only by the target field's terminology. Do not reject an idea merely because components are known; determine whether their composition creates a different mechanism or prediction.

## Develop and challenge theory cards

For each serious candidate, provide:

- **Core claim:** the proposed explanation and intervention.
- **Causal chain:** how the intervention produces the outcome.
- **Departure:** which current assumption or mechanism changes.
- **Basis:** supporting observations, research, analogies, and derivation.
- **Bridge assumptions:** what must be true for transferred mechanisms to apply.
- **Rivals:** the strongest alternative explanations.
- **Divergent predictions:** observations expected under this theory but not its rivals.
- **Falsifier:** the strongest feasible result that would kill or sharply weaken it.
- **Failure signature:** what an unsuccessful implementation would look like and what could still be learned.
- **Scope and substrate:** where the theory should and should not generalize.
- **Novelty status:** known, adapted, new combination, or apparently new, with the nearest known work.
- **Discriminating test:** the cheapest safe experiment with high information gain.

Develop a mechanism enough to make predictions before criticizing it for feasibility. Then challenge it aggressively. Do not certify global novelty from limited search, rename prior work as new, or call a combination novel unless the composition changes a causal account, prediction, or intervention.

Compare candidates on separate dimensions rather than hiding tradeoffs in one score:

- explanatory leverage and anomaly coverage;
- divergence and specificity of predictions;
- fit with current evidence;
- potential impact if true;
- experiment cost, reversibility, and time to evidence;
- dependence on fragile assumptions or substrate behavior;
- safety, evaluator integrity, and risk of Goodharting.

Prefer a discriminating experiment over choosing between empirically indistinguishable stories.

## Hand off to Autoresearch

When the inquiry has a bounded intervention surface and trustworthy evaluator, convert promising theories into an executable experiment portfolio. Read the authoritative Autoresearch note before planning or executing trials. Preserve evaluator isolation and immutable run evidence.

For each proposed experiment, state:

- theory mechanism and rivals;
- candidate intervention and champion or control;
- controlled variables, correctness gates, and confounds;
- predictions under each rival theory, not only an expected aggregate improvement;
- expected information gain, cost, novelty, and reversibility;
- success, falsification, near-miss, inconclusive, and invalid signatures;
- rollback and resource limits;
- reopening condition and successor experiments.

Keep protocol or evaluator changes separate from candidate changes. Invocation of this skill proposes experiments but does not authorize their execution. Use surprising results, repeated failure signatures, and plateaus to revise the causal model or switch mechanism rather than producing endless nearby variants.

## Verification

When a theory could shape code, architecture, automation, or another executable artifact, identify the Verification Surface before recommending implementation. Map the claimed mechanism to observable predictions at that surface, include rivals or ablations that can distinguish the mechanism, and preserve correctness and safety gates. An improved aggregate score alone does not verify the proposed explanation.

Execute trials only when separately authorized. Report the exact checks and results that were actually run, any predictions not covered, and residual uncertainty. If the available surface cannot distinguish the theories, recommend improving the experiment rather than treating implementation success as confirmation.

## Return

Return a decision-oriented result:

1. inquiry contract;
2. compact evidence map with important conflicts or gaps;
3. current causal account and unexplained anomalies;
4. the strongest few theory cards;
5. multidimensional comparison and novelty findings;
6. ordered experiment portfolio with a recommended first discriminating test;
7. reconstruction block for continuation.

Clearly distinguish retrieved findings, derivations, and speculative hypotheses. Cite sources where authority, volatility, exact measurements, or novelty comparisons matter, but do not turn the result into a bibliography or research dump.

Stop when the requested depth is reached, the evidence cannot distinguish candidates, the evaluator is unsuitable, the budget is exhausted, or progress requires a user decision or new authorization. If no testable theory survives, report the unresolved bottleneck and the evidence needed next rather than manufacturing a breakthrough.
