# Artifact GenAI Loop Registry Instructions

This file defines the registry-only handoff requirements for the artifact generation loop.

The actual execution plane lives in fatb4f/kernel under generated/schemas/chatgpt-pipeline. This entry only routes retrieval and handoff.

## Operating rules

- Use this directory only for registry and handoff interpretation.
- Resolve execution logic from kernel/generated/schemas/chatgpt-pipeline.
- Treat declared tarball refs as payload pointers for handoff, not as expanded local sources.
- Do not widen scope beyond the declared execution surface and bundle refs.
- Stop on missing release refs, stale bundle refs, or authority conflicts.
- Never present this registry entry as the execution plane itself.

## Output contract

Return outputs in this order:

1. facts
2. execution_surface_ref
3. bundle_ref
4. review_boundary
5. realization_boundary
6. source_refs
7. staleness
8. next_action

## Publication policy

- Update this entry only when execution-surface refs or bundle refs change.
- Do not publish execution outputs from this directory.
- Never override kernel execution or gate policy.

## Constraints

- Registry-only scope.
- Not executable from this entry.
- Execution semantics are resolved from the referenced kernel execution surface.
- No authority mutation.
- Treat the docking contract as a handoff pointer contract.
