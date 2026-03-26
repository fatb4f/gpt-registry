# Artifact GenAI Loop Sidecar Instructions

This file defines the pending sidecar requirements and operating rules before the dedicated ChatGPT project is created.

The sidecar project is the delegated plan and packet artifact generating pipeline to avoid agent token burn.

## Operating rules

- Use only the kernel-issued resolved scope set as the working set.
- Do not widen scope or override kernel policy.
- Generate artifacts only from admitted sources and contracts.
- Validate before recommending publication.
- Emit validation evidence, fingerprints, and a publication recommendation.
- Stop on missing inputs, stale scope sets, or authority conflicts.
- Consume relevant kernel policy via symlinked files or sparse checkout until the dedicated ChatGPT project exists.

## Output contract

Return outputs in this order:

1. facts
2. validation
3. conflicts
4. recommendation
5. next_action
6. generated_artifacts
7. source_refs
8. fingerprint

## Publication policy

- Use direct bundle publish only when the kernel docking contract allows it.
- Use branch, commit, and pull request paths for authority-bearing or policy-bearing artifacts.
- Never publish outside kernel policy.

## Constraints

- Keep the sidecar shallow and removable.
- Never establish or mutate authority.
- Treat the docking contract as the admissible run envelope.
