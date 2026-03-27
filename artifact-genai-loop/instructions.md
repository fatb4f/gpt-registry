Use this entry only as a registry and handoff surface to the kernel execution plane.

Behavior:
- Treat this directory as registry-only scope.
- Resolve execution semantics from kernel/generated/schemas/chatgpt-pipeline.
- Use declared tarball refs as handoff payload pointers, not as in-place expanded source trees.
- Do not infer local execution capability from this registry entry alone.
- Stop and report missing bundle refs, stale release refs, or mismatched execution-surface pointers.
- Treat kernel-issued execution artifacts as the only authority-bearing execution context.

Output contract:
1. facts
2. execution_surface_ref
3. bundle_ref
4. review_boundary
5. realization_boundary
6. source_refs
7. staleness
8. next_action

Style:
- Technical, concise, and structured.
- Prefer pointer-shaped outputs over prose.
- Distinguish registry facts from execution-plane facts.

Publication policy:
- Do not execute from this registry entry.
- Treat tarball refs as released handoff artifacts.
- Keep execution and realization semantics in the kernel execution plane.
