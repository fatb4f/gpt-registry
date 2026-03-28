local p = std.extVar('params');

local textFile(content) = {
  kind: 'text',
  content: content,
};

local yamlFile(entries) = {
  kind: 'yaml',
  entries: entries,
};

local bullets(items) = std.join('', ['- ' + item + '\n' for item in items]);
local numbered(items) = std.join('', [std.toString(i + 1) + '. ' + items[i] + '\n' for i in std.range(0, std.length(items) - 1)]);

local instructionsMd =
  p.instructions.working_set + '\n\n' +
  'Behavior:\n' +
  bullets(p.instructions.behavior) + '\n' +
  'Output contract:\n' +
  numbered(p.instructions.output_contract) + '\n' +
  'Style:\n' +
  bullets(p.instructions.style) + '\n' +
  'Publication policy:\n' +
  bullets(p.instructions.publication_policy);

local agentsMd =
  '# ' + p.agents.title + '\n\n' +
  p.agents.intro + '\n\n' +
  p.agents.summary + '\n\n' +
  '## Operating rules\n\n' +
  bullets(p.agents.operating_rules) + '\n' +
  '## Output contract\n\n' +
  'Return outputs in this order:\n\n' +
  numbered(p.agents.output_contract) + '\n' +
  '## Publication policy\n\n' +
  bullets(p.agents.publication_policy) + '\n' +
  '## Constraints\n\n' +
  bullets(p.agents.constraints);

{
  'meta-manifest.yaml': yamlFile([
    ['project', p.project],
    ['purpose', p.purpose],
    ['scope', p.scope],
    ['authority', p.authority],
    ['retrieval', p.retrieval],
    ['linked_manifests', p.linked_manifests],
    ['change_control', p.change_control],
  ]),

  'instructions.md': textFile(instructionsMd),

  'AGENTS.md': textFile(agentsMd),

  'docking-contract.yaml': yamlFile([
    ['docking_contract', {
      contract_version: p.docking_contract.contract_version,
      registry_entry_id: p.docking_contract.registry_entry_id,
      canonical_repo: p.docking_contract.canonical_repo,
      execution_surface_root: p.docking_contract.execution_surface_root,
      execution_surface_refs: p.docking_contract.execution_surface_refs,
      bundle_release: p.docking_contract.bundle_release,
      review_and_realization: p.docking_contract.review_and_realization,
      trust_boundary: p.docking_contract.trust_boundary,
      freshness: p.docking_contract.freshness,
      invariants: p.docking_contract.invariants,
    }],
  ]),

  'manifest.yaml': yamlFile([
    ['sources', {
      project_id: p.sources_manifest.project_id,
      source_set_id: p.sources_manifest.source_set_id,
      resolved_from: p.sources_manifest.resolved_from,
      included_refs: p.sources_manifest.included_refs,
      source_purpose: p.sources_manifest.source_purpose,
      excluded_refs: p.sources_manifest.excluded_refs,
    }],
  ]),

  'refs.yaml': yamlFile([
    ['refs', p.refs],
  ]),
}
