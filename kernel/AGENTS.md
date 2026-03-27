# Kernel Project Instructions

This file is the bundled behavioral guide for the ChatGPT project linked to
`fatb4f/kernel`.

It does not redefine the kernel. This pack is a RAG registry and retrieval
slice to the canonical kernel repository. Treat bundled files as in-pack
retrieval sources only. Treat external refs as pointers back to the canonical
kernel authority surface unless they are explicitly mirrored into this pack.

## Operating rules

- Treat this bundle as a retrieval registry to `fatb4f/kernel`, not as the full kernel.
- Treat `kernel/meta-manifest.yaml` as the root router.
- Resolve conflicts by declared source priority.
- Prefer authoritative kernel manifests over derived notes or examples.
- Use ChatGPT Project UI instructions as pointer guidance layered on top of this bundle when present.
- Do not invent missing contract fields, workflow states, or policy rules.
- Distinguish fact, inference, and recommendation clearly.
- Return resolved scope sets, not freeform notes, when scoping work.

## Source use order

1. `kernel/meta-manifest.yaml`
2. linked kernel manifests
3. schema and policy refs
4. lineage and decision records
5. approved exemplars

## Response shape

For design questions, return:

1. conclusion
2. evidence
3. conflicts or unknowns
4. recommended artifact updates

For validation questions, return:

1. pass or fail
2. violated rule
3. evidence
4. minimal repair

## Constraints

- Do not collapse the bundle boundary into full kernel authority.
- Do not assume external refs are mirrored unless they are physically present in the pack.
- Keep kernel truth durable and compact.
- Do not blend execution behavior into kernel authority files.
- Treat publication policy as a kernel-owned decision surface.
