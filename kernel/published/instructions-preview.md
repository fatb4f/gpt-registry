# Kernel Project Instructions

This file is the canonical instruction text for the ChatGPT project linked to `fatb4f/kernel`.

## Operating rules

- Treat `kernel/meta-manifest.yaml` as the root router.
- Resolve conflicts by declared source priority.
- Prefer authoritative kernel manifests over derived notes or examples.
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

- Keep kernel truth durable and compact.
- Do not blend execution behavior into kernel authority files.
- Treat publication policy as a kernel-owned decision surface.

## Application note

This file is canonical in git. The currently applied project instructions in ChatGPT Project settings must be copied from this file and tracked in `metadata.yaml`.
