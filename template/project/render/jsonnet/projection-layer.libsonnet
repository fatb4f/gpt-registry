{
  kind: 'gpt_registry.template_projection_layer',
  version: '0.1.0',
  status: 'active',

  renderer: {
    engine: 'rsjsonnet',
    class: 'template_projection_only',
    binary_hint: '~/.local/share/cargo/bin/rsjsonnet',
  },

  purpose: {
    summary: 'Template projection layer for generating derived project-pack surfaces in gpt-registry.',
    in_scope: [
      'project-pack markdown mirrors',
      'published bundle projections',
      'review-facing derived outputs',
      'connector-compatibility render surfaces',
    ],
    out_of_scope: [
      'authority creation',
      'trust-root mutation',
      'project-specific policy invention',
      'post-approval realization',
    ],
  },

  admissible_inputs: [
    'template/project source files',
    'project parameter values',
    'declared manifest and source contracts',
  ],

  output_classes: [
    {
      kind: 'published_projection',
      description: 'Flat ChatGPT-facing published root derived from project source.',
    },
    {
      kind: 'markdown_mirror',
      description: 'Connector-compatible markdown mirror of structured source artifacts.',
    },
    {
      kind: 'review_projection',
      description: 'Human-readable review surfaces rendered from declared source contracts.',
    },
  ],

  invariants: [
    'rsjsonnet outputs are derived artifacts only.',
    'Template projection must not establish authority.',
    'Published output must remain flatter and narrower than project source.',
    'Projection must fail closed when required source contracts are missing.',
    'Project-specific semantics must be supplied by instantiated project source, not invented in the template layer.',
  ],

  notes: [
    'This is the first explicit template-level projection definition in gpt-registry.',
    'Concrete project packs should reuse this pattern rather than duplicating kernel by hand.',
  ],
}
