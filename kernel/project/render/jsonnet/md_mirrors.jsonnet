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

  'meta-manifest.md':
    doc(
      'Meta Manifest',
      'meta-manifest.yaml',
      importstr '../../meta-manifest.yaml',
      [
        'Authority router for the kernel project pack.',
      ],
    ),

  'manifest.md':
    doc(
      'Source Manifest',
      'sources/manifest.yaml',
      importstr '../../sources/manifest.yaml',
      [
        'Authority and source-inventory mirror.',
      ],
    ),

  'refs.md':
    doc(
      'Source Refs',
      'sources/refs.yaml',
      importstr '../../sources/refs.yaml',
      [
        'Bootstrap lookup table for automation and sync workflows.',
      ],
    ),

  'contracts.md':
    doc('Contracts Manifest', 'manifests/contracts.yaml', importstr '../../manifests/contracts.yaml'),

  'publication.md':
    doc('Publication Manifest', 'manifests/publication.yaml', importstr '../../manifests/publication.yaml'),

  'lineage.md':
    doc('Lineage Manifest', 'manifests/lineage.yaml', importstr '../../manifests/lineage.yaml'),

  'glossary.md':
    doc('Glossary Manifest', 'manifests/glossary.yaml', importstr '../../manifests/glossary.yaml'),

  'decision-register.md':
    doc('Decision Register Manifest', 'manifests/decision-register.yaml', importstr '../../manifests/decision-register.yaml'),
}
