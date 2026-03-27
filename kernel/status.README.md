Reviewed against the uploaded `kernel-gpt.zip`.

## Verdict

**Good foundation, but not release-complete yet.**

The main gap is exactly what you called out:

> **the bundle does not clearly define which items are actually intended to be present in ChatGPT project sources**

Right now it defines **registry/manifests about sources**, but not a crisp **project-source inclusion contract**.

---

## What is working

The bundle already has the right top-level pieces:

* `kernel/meta-manifest.yaml`
* scoped manifests under `kernel/manifests/`
* `kernel/sources/manifest.yaml`
* `kernel/AGENTS.md`

That gives you:

* authority routing
* source priority
* scoped registry structure
* behavioral guidance

So the shape is right.

---

## Main issue

Your current `kernel/sources/manifest.yaml` is acting as a **resolved ref inventory**, but not yet as a **definitive project-source pack manifest**.

### Why that matters

A ChatGPT project source pack needs to answer, unambiguously:

1. **Which files are actually mirrored into the project source folder**
2. **Which files are only external refs**
3. **Which files are canonical vs support vs reference-only**
4. **Which files must always be present for the project to be valid**

Right now that line is blurry.

---

## Concrete problems in the current bundle

### 1. Referenced assets are not included

Your source manifest references things like:

* `schemas/kernel.contract.schema.json`
* `schemas/kernel.workflow.schema.json`
* `policy/kernel/contracts.policy.yaml`
* `bundle/kernel-contract-pack.json`

But those files are **not present** in the zip you uploaded.

That means one of two things must be made explicit:

* either they are **required project sources and must be bundled**
* or they are **external refs and must not be listed as resolved project-source contents**

Right now they read like included assets, but they are not actually included.

---

### 2. No explicit inclusion class

You need a classification like:

* **required_in_project**
* **optional_in_project**
* **external_reference**
* **reference_only**
* **excluded_from_project**

Without that, the sidecar or kernel project can over-assume what is available.

---

### 3. `AGENTS.md` needs a clearer status

In `meta-manifest.yaml`, `AGENTS.md` is listed under `reference_only_sources`.

That is acceptable **only if** your bootstrap instruction says “use `AGENTS.md` from project sources as canonical behavior guidance.”

If it is part of the mirrored source pack and intended to be read by ChatGPT inside the project, I would classify it more explicitly as:

* `behavioral_source`
* or `required_in_project`

Not just “reference only.”

---

### 4. `refs.yaml` is weakly justified

`kernel/sources/refs.yaml` currently just restates file pointers already present elsewhere.

That is fine if it is meant to be:

* a stable machine lookup table
* a bootstrap index
* a sync/export helper

But if not, it is probably redundant.

---

## What you should add

You need a **project-source manifest section** that defines the actual mirrored pack.

## Recommended addition

Add this to `kernel/sources/manifest.yaml`, or split it into a dedicated `kernel/project-sources.yaml`.

### Example

```yaml
project_sources:
  project_id: kernel
  pack_id: kernel-project-pack
  pack_version: 0.1.0
  delivery_target: gdrive/project/kernel
  sync_mode: mirrored_release_bundle

  required_in_project:
    - kernel/AGENTS.md
    - kernel/meta-manifest.yaml
    - kernel/sources/manifest.yaml
    - kernel/manifests/contracts.yaml
    - kernel/manifests/workflows.yaml
    - kernel/manifests/publication.yaml
    - kernel/manifests/lineage.yaml
    - kernel/manifests/glossary.yaml
    - kernel/manifests/decision-register.yaml

  optional_in_project:
    - kernel/release.json
    - kernel/fingerprints.json
    - kernel/examples/

  external_references:
    - schemas/kernel.contract.schema.json
    - schemas/kernel.workflow.schema.json
    - schemas/kernel.publication.schema.json
    - schemas/kernel.lineage.schema.json
    - policy/kernel/contracts.policy.yaml
    - policy/kernel/workflows.policy.yaml
    - policy/kernel/publication.policy.yaml
    - policy/kernel/lineage.policy.yaml

  excluded_from_project:
    - raw_repo_history
    - unrelated_repo_docs
    - transient_build_outputs

  validity_rules:
    - all required_in_project files must be present
    - external_references must be marked unresolved unless mirrored
    - pack is invalid if any required file is missing
```

That is the missing contract.

---

## Strong recommendation

Do **not** use `resolved_refs` for both:

* files physically present in the mirrored ChatGPT source pack
* and files merely referenced somewhere in Git

Split them.

## Better split

### `included_files`

Files physically present in the mirrored bundle.

### `external_refs`

Files known to exist in Git or elsewhere, but not guaranteed inside the project source pack.

### `derived_outputs`

Generated artifacts that may exist outside the kernel pack.

---

## Minimal required items for the kernel project sources

If the goal is a compact but functional kernel pack, I would define the required project sources as:

### Required

* `kernel/AGENTS.md`
* `kernel/meta-manifest.yaml`
* `kernel/sources/manifest.yaml`
* `kernel/manifests/contracts.yaml`
* `kernel/manifests/workflows.yaml`
* `kernel/manifests/publication.yaml`
* `kernel/manifests/lineage.yaml`
* `kernel/manifests/glossary.yaml`
* `kernel/manifests/decision-register.yaml`

### Optional but recommended

* `kernel/release.json`
* `kernel/fingerprints.json`
* `kernel/examples/`
* `kernel/project-sources.yaml` if separated from `sources/manifest.yaml`

### Only include if you want ChatGPT to inspect them directly

* `schemas/*.json`
* `policy/**/*.yaml`

If those schema and policy files matter to reasoning inside the project, they should be mirrored too. If not, keep them as external refs and do not pretend they are present.

---

## Minimal required metadata per project directory

Your per-project registry directory should explicitly contain:

* `metadata.yaml`
* `AGENTS.md`
* `project-sources.yaml` or equivalent
* `release.json`
* `fingerprints.json`

### Suggested meanings

* `metadata.yaml` = identity, owner, bundle version, applied revision
* `AGENTS.md` = canonical behavior instructions
* `project-sources.yaml` = exact contents of the mirrored project pack
* `release.json` = publish metadata
* `fingerprints.json` = hash/diff/staleness controls

---

## Recommended review outcome

## Pass/fail

**Fail for release as a ChatGPT project pack**, but **close**.

## Why

Because the pack currently defines:

* authority structure
* source priority
* behavioral guidance

…but does **not yet define the exact project-source inclusion set**.

## Minimal repair

1. Add a `project_sources` contract.
2. Split **included files** from **external refs**.
3. Reclassify `AGENTS.md` explicitly.
4. Decide whether schema/policy files are:

   * mirrored project sources
   * or external references only.
5. Add `release.json` and `fingerprints.json` to the published pack.

---

## Cleanest target shape

```text
kernel/
  metadata.yaml
  AGENTS.md
  project-sources.yaml
  meta-manifest.yaml
  manifests/
    contracts.yaml
    workflows.yaml
    publication.yaml
    lineage.yaml
    glossary.yaml
    decision-register.yaml
  release.json
  fingerprints.json
  examples/
```

And only then optionally:

```text
  schemas/
  policy/
```

if you want them directly available in project context.

---

## Bottom line

Your structure is sound.

What is missing is an explicit answer to:

> **What exact files are included in the ChatGPT project source pack for this project?**

Until that is declared, the bundle is still a registry draft rather than a project-source release artifact.

I can draft `project-sources.yaml` for this exact kernel bundle next.
