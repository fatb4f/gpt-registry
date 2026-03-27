local doc(title, sourceRef, content, notes=[]) =
  '# ' + title + '\n\n' +
  'Source: `' + sourceRef + '`\n\n' +
  (if std.length(notes) == 0 then '' else
    'Notes:\n' +
    std.join('', [ '- ' + note + '\n' for note in notes ]) +
    '\n') +
  '```yaml\n' + content + '\n```\n';

{
  'project-pack.md':
    doc(
      'Project Pack',
      'metadata.yaml',
      importstr '../../metadata.yaml',
      [
        'Canonical project registry metadata in Git.',
        'Rendered as Markdown for ChatGPT project-source compatibility.',
      ],
    ),

  'sources/manifest.md':
    doc(
      'Source Manifest',
      'sources/manifest.yaml',
      importstr '../../sources/manifest.yaml',
      [
        'Authority and source-inventory mirror.',
      ],
    ),

  'sources/project-sources.md':
    doc(
      'Project Source Contract',
      'sources/project-sources.yaml',
      importstr '../../sources/project-sources.yaml',
      [
        'Defines required, optional, external, and excluded project-source classes.',
        'All listed paths are relative to published/sources/.',
      ],
    ),

  'sources/refs.md':
    doc(
      'Source Refs',
      'sources/refs.yaml',
      importstr '../../sources/refs.yaml',
      [
        'Bootstrap lookup table for automation and sync workflows.',
      ],
    ),

  'sources/meta-manifest.md':
    doc(
      'Meta Manifest',
      'meta-manifest.yaml',
      importstr '../../meta-manifest.yaml',
      [
        'Authority router for the kernel project pack.',
      ],
    ),

  'sources/manifests/contracts.md':
    doc('Contracts Manifest', 'manifests/contracts.yaml', importstr '../../manifests/contracts.yaml'),

  'sources/manifests/workflows.md':
    doc('Workflows Manifest', 'manifests/workflows.yaml', importstr '../../manifests/workflows.yaml'),

  'sources/manifests/publication.md':
    doc('Publication Manifest', 'manifests/publication.yaml', importstr '../../manifests/publication.yaml'),

  'sources/manifests/lineage.md':
    doc('Lineage Manifest', 'manifests/lineage.yaml', importstr '../../manifests/lineage.yaml'),

  'sources/manifests/glossary.md':
    doc('Glossary Manifest', 'manifests/glossary.yaml', importstr '../../manifests/glossary.yaml'),

  'sources/manifests/decision-register.md':
    doc('Decision Register Manifest', 'manifests/decision-register.yaml', importstr '../../manifests/decision-register.yaml'),
}
