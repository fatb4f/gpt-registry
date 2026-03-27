# Source Manifest

Source: `sources/manifest.yaml`

Notes:
- Authority and source-inventory mirror.

```yaml
sources:
  project_id: kernel
  source_set_id: ks-2026-03-25-001
  status: active
  owner: _404
  last_updated: 2026-03-25
  project_source_contract_ref: kernel/project/sources/project-sources.yaml

purpose:
  summary: >
    Resolved source inventory for kernel authority, retrieval, contracts,
    publication, lineage, and decision records. Behavioral workflow guidance is
    carried by AGENTS.md for the published retrieval pack.

scope:
  in_scope:
    - manifest refs
    - schema refs
    - policy refs
    - validation refs
    - lineage refs
    - decision refs
  out_of_scope:
    - execution artifacts
    - sidecar runtime outputs

source_priority:
  order:
    - kernel/project/meta-manifest.yaml
    - kernel/project/sources/manifest.yaml
    - kernel/project/sources/project-sources.yaml
    - kernel/project/manifests/contracts.yaml
    - kernel/project/manifests/publication.yaml
    - kernel/project/manifests/lineage.yaml
    - kernel/project/manifests/glossary.yaml
    - kernel/project/manifests/decision-register.yaml

resolved_refs:
  manifests:
    - kernel/project/meta-manifest.yaml
    - kernel/project/manifests/contracts.yaml
    - kernel/project/manifests/publication.yaml
    - kernel/project/manifests/lineage.yaml
    - kernel/project/manifests/glossary.yaml
    - kernel/project/manifests/decision-register.yaml
  contracts:
    - schemas/kernel.contract.schema.json
    - schemas/kernel.workflow.schema.json
    - schemas/kernel.publication.schema.json
    - schemas/kernel.lineage.schema.json
    - schemas/kernel.docking-contract.schema.json
  policies:
    - policy/kernel/contracts.policy.yaml
    - policy/kernel/workflows.policy.yaml
    - policy/kernel/publication.policy.yaml
    - policy/kernel/lineage.policy.yaml
  validation:
    - kernel/project/validation/logic-tests.yaml
  lineage:
    - bundle/kernel-contract-pack.json
    - bundle/kernel-workflow-pack.json

freshness:
  review_cadence: on-change
  staleness_policy: any ref change invalidates the source set

```
