# gpt-registry

`gpt-registry` is the Git-backed registry for ChatGPT-facing project packs,
retrieval bundles, and handoff surfaces.

It is not the kernel authority plane. The kernel remains authoritative in
[`fatb4f/kernel`](https://github.com/fatb4f/kernel). This repository packages
bounded, reviewable project surfaces that ChatGPT can consume through supported
delivery channels such as Google Drive project sources.

## Purpose

This repository exists to:

- keep canonical ChatGPT project pack definitions in Git
- build flat, ChatGPT-compatible published bundles from those definitions
- preserve clear boundaries between:
  - canonical project source and tooling
  - published retrieval bundles
  - external authority references
- support handoff of governed artifacts produced by the ChatGPT pipeline

In practice:

- `kernel` authority lives in `fatb4f/kernel`
- `gpt-registry` publishes retrieval packs that point at that authority
- ChatGPT reads the published pack, not the full kernel repo

## Repository Model

Each project pack should follow this split:

- `project/`
  - human-authored source
  - local tooling
  - manifests
  - render/build/publish logic
- `published/`
  - flat ChatGPT-facing bundle
  - markdown-first where connector compatibility matters
  - only the files intended for project-source retrieval

This keeps the pack understandable to both humans and the ChatGPT connector
surface.

## Current Reference Pack

[`kernel/project`](/home/_404/src/gpt-registry/kernel/project) is the current
reference implementation.

It models a project pack as a RAG registry to `fatb4f/kernel` and publishes a
flat retrieval surface under
[`kernel/published`](/home/_404/src/gpt-registry/kernel/published).

That published root is intentionally narrower than the source tree:

- `AGENTS.md` provides bundled behavioral guidance
- `meta-manifest.md` is the visible-root router
- root markdown manifests expose the retrieval surface
- optional format stubs exist only for connector behavior testing
- release and fingerprint outputs stay local unless explicitly needed

## Relation to chatgpt-pipeline

The ChatGPT pipeline in `fatb4f/kernel` now has a native, review-gated,
`problem_set`-driven packet lane.

This repository is the likely handoff surface for those outputs:

- the pipeline emits governed packet artifacts
- `gpt-registry` can package the bounded retrieval context and project-facing
  instructions needed for ChatGPT project use
- delivery remains separate from kernel authority and separate from local
  realization

## Operating Rule

Use this repository for:

- project-pack definition
- published retrieval bundle generation
- delivery packaging
- handoff-oriented registry content

Do not use it as the source of truth for kernel authority, trust root, or local
realization policy.
