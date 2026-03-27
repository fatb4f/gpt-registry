#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
jsonnet_bin="${JSONNET_BIN:-/home/_404/.local/share/cargo/bin/rsjsonnet}"
published_root="${repo_root}/published"
published_sources="${published_root}/sources"
published_manifests="${published_sources}/manifests"
published_examples="${published_sources}/examples"
release_path="${repo_root}/bundle/release.json"
fingerprints_path="${repo_root}/bundle/fingerprints.json"
source_manifest="${repo_root}/sources/manifest.yaml"
project_sources_manifest="${repo_root}/sources/project-sources.yaml"
refs_manifest="${repo_root}/sources/refs.yaml"
metadata_path="${repo_root}/metadata.yaml"
instructions_path="${repo_root}/instructions.md"
agents_path="${repo_root}/AGENTS.md"
meta_manifest="${repo_root}/meta-manifest.yaml"
contracts_manifest="${repo_root}/manifests/contracts.yaml"
workflows_manifest="${repo_root}/manifests/workflows.yaml"
publication_manifest="${repo_root}/manifests/publication.yaml"
lineage_manifest="${repo_root}/manifests/lineage.yaml"
glossary_manifest="${repo_root}/manifests/glossary.yaml"
decision_register_manifest="${repo_root}/manifests/decision-register.yaml"
examples_dir="${repo_root}/sources/examples"
md_mirror_template="${repo_root}/render/jsonnet/md_mirrors.jsonnet"

timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
bundle_version="$(python - <<'PY'
from pathlib import Path
text = Path("/home/_404/src/gpt-registry/kernel/metadata.yaml").read_text().splitlines()
in_bundle = False
for line in text:
    if line.strip() == "bundle:":
        in_bundle = True
        continue
    if in_bundle and line and not line.startswith("  "):
        break
    if in_bundle and line.strip().startswith("version:"):
        print(line.split(":", 1)[1].strip())
        break
PY
)"

mkdir -p "${published_sources}" "${published_manifests}" "${published_examples}"
find "${published_root}" -name .gitkeep -delete

cp "${metadata_path}" "${published_root}/project-pack.yaml"
cp "${instructions_path}" "${published_root}/instructions-preview.md"
cp "${agents_path}" "${published_sources}/AGENTS.md"
cp "${source_manifest}" "${published_sources}/manifest.yaml"
cp "${project_sources_manifest}" "${published_sources}/project-sources.yaml"
cp "${refs_manifest}" "${published_sources}/refs.yaml"
cp "${meta_manifest}" "${published_sources}/meta-manifest.yaml"
cp "${contracts_manifest}" "${published_manifests}/contracts.yaml"
cp "${workflows_manifest}" "${published_manifests}/workflows.yaml"
cp "${publication_manifest}" "${published_manifests}/publication.yaml"
cp "${lineage_manifest}" "${published_manifests}/lineage.yaml"
cp "${glossary_manifest}" "${published_manifests}/glossary.yaml"
cp "${decision_register_manifest}" "${published_manifests}/decision-register.yaml"
find "${published_examples}" -mindepth 1 -delete
if find "${examples_dir}" -mindepth 1 -type f ! -name .gitkeep | read -r _; then
  cp -R "${examples_dir}/." "${published_examples}/"
  find "${published_examples}" -name .gitkeep -delete
else
  rmdir "${published_examples}" 2>/dev/null || true
fi

"${jsonnet_bin}" -m "${published_root}" "${md_mirror_template}" >/dev/null

python - <<'PY'
from pathlib import Path
import hashlib
import json

repo_root = Path("/home/_404/src/gpt-registry/kernel")
published_root = repo_root / "published"
release_path = repo_root / "bundle" / "release.json"
fingerprints_path = repo_root / "bundle" / "fingerprints.json"

files = sorted([
    p for p in published_root.rglob("*")
    if p.is_file() and p.name != ".gitkeep"
])

fingerprints = {
    "artifact_type": "gpt_project_pack_fingerprints",
    "artifact_version": "0.1.0",
    "generated_at": Path("/tmp").joinpath("unused").as_posix()
}

entries = []
for path in files:
    rel = path.relative_to(repo_root).as_posix()
    entries.append({
        "path": rel,
        "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
    })

fingerprints = {
    "artifact_type": "gpt_project_pack_fingerprints",
    "artifact_version": "0.1.0",
    "entries": entries,
}

release = {
    "artifact_type": "gpt_project_pack_release",
    "artifact_version": "0.1.0",
    "project_id": "kernel",
    "bundle_id": "kernel-project-pack",
    "bundle_version": (
        lambda lines: next(
            line.split(":", 1)[1].strip()
            for idx, line in enumerate(lines)
            if line.strip() == "bundle:"
            for line in lines[idx + 1:]
            if line.startswith("  ")
            if line.strip().startswith("version:")
        )
    )((repo_root / "metadata.yaml").read_text().splitlines()),
    "published_root": "kernel/published",
    "included_files": [e["path"] for e in entries],
}

release_path.write_text(json.dumps(release, indent=2) + "\n")
fingerprints_path.write_text(json.dumps(fingerprints, indent=2) + "\n")
PY

python - <<'PY'
from pathlib import Path
import json
from datetime import datetime, timezone

repo_root = Path("/home/_404/src/gpt-registry/kernel")
release_path = repo_root / "bundle" / "release.json"
fingerprints_path = repo_root / "bundle" / "fingerprints.json"
release = json.loads(release_path.read_text())
release["generated_at"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
release["fingerprints_ref"] = "kernel/bundle/fingerprints.json"
for path in ("published/sources/release.json", "published/sources/fingerprints.json"):
    if path not in release["included_files"]:
        release["included_files"].append(path)
release["included_files"] = sorted(release["included_files"])
fingerprints = json.loads(fingerprints_path.read_text())
fingerprints["generated_at"] = release["generated_at"]
release_path.write_text(json.dumps(release, indent=2) + "\n")
fingerprints_path.write_text(json.dumps(fingerprints, indent=2) + "\n")
PY

cp "${release_path}" "${published_sources}/release.json"
cp "${fingerprints_path}" "${published_sources}/fingerprints.json"

echo "${timestamp}"
