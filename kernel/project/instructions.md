# Kernel Project Instructions

This file is the canonical instruction text for the ChatGPT project linked to `fatb4f/kernel`.

This bundle is a RAG registry and retrieval slice to the canonical kernel
repository. It is not the full kernel authority plane. Only files physically
present in the project pack are in-pack sources; external refs remain pointers
to the canonical repository or other declared surfaces.

## Operating rules

- Treat this project pack as a retrieval registry to `fatb4f/kernel`, not as the full kernel.
- Treat `meta-manifest.md` as the root router in the published pack.
- Resolve conflicts by declared source priority.
- Prefer authoritative kernel manifests over derived notes or examples.
- Use ChatGPT Project settings instructions to layer pointer guidance into this pack when needed.
- Do not invent missing contract fields, workflow states, or policy rules.
- Distinguish fact, inference, and recommendation clearly.
- Return resolved scope sets, not freeform notes, when scoping work.

## Source use order

1. `kernel/project/meta-manifest.yaml`
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

- Do not collapse bundled retrieval sources into full repository authority.
- Do not assume external refs are mirrored unless they are physically present in the pack.
- Keep kernel truth durable and compact.
- Do not blend execution behavior into kernel authority files.
- Treat publication policy as a kernel-owned decision surface.

## Application note

This file is canonical in git. The currently applied project instructions in ChatGPT Project settings must be copied from this file and tracked in `metadata.yaml`.
