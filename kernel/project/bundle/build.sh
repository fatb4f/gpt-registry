#!/usr/bin/env bash

set -euo pipefail

project_root="$(cd "$(dirname "$0")/.." && pwd)"
package_root="$(cd "${project_root}/.." && pwd)"
jsonnet_bin="${JSONNET_BIN:-/home/_404/.local/share/cargo/bin/rsjsonnet}"
published_root="${package_root}/published"
release_path="${project_root}/bundle/release.json"
fingerprints_path="${project_root}/bundle/fingerprints.json"
agents_path="${project_root}/AGENTS.md"
md_mirror_template="${project_root}/render/jsonnet/md_mirrors.jsonnet"

timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
bundle_version="$(python - <<'PY'
from pathlib import Path
text = Path("/home/_404/src/gpt-registry/kernel/project/metadata.yaml").read_text().splitlines()
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

rm -rf "${published_root}"
mkdir -p "${published_root}"

"${jsonnet_bin}" -m "${published_root}" "${md_mirror_template}" >/dev/null
cp "${agents_path}" "${published_root}/AGENTS.md"

python - <<'PY'
from pathlib import Path
import json

published_root = Path("/home/_404/src/gpt-registry/kernel/published")
for path in published_root.rglob("*.md"):
    raw = path.read_text()
    try:
        decoded = json.loads(raw)
    except json.JSONDecodeError:
        continue
    if isinstance(decoded, str):
        path.write_text(decoded)

(published_root / "format-test.json").write_text(
    json.dumps(
        {
            "artifact_type": "gpt_project_format_stub",
            "artifact_version": "0.1.0",
            "format": "json",
            "purpose": "connector_retrieval_probe",
            "canonical_repo": "fatb4f/kernel",
            "canonical_project_root": "kernel/project",
            "published_root": "kernel/published",
            "message": "This JSON stub exists only to test ChatGPT project retrieval behavior for JSON files."
        },
        indent=2,
    )
    + "\n"
)

(published_root / "format-test.yaml").write_text(
    "artifact_type: gpt_project_format_stub\n"
    "artifact_version: 0.1.0\n"
    "format: yaml\n"
    "purpose: connector_retrieval_probe\n"
    "canonical_repo: fatb4f/kernel\n"
    "canonical_project_root: kernel/project\n"
    "published_root: kernel/published\n"
    "message: This YAML stub exists only to test ChatGPT project retrieval behavior for YAML files.\n"
)
PY

python - <<'PY'
from pathlib import Path
import hashlib
import json

project_root = Path("/home/_404/src/gpt-registry/kernel/project")
published_root = project_root.parent / "published"
release_path = project_root / "bundle" / "release.json"
fingerprints_path = project_root / "bundle" / "fingerprints.json"

files = sorted(p for p in published_root.rglob("*") if p.is_file() and p.name != ".gitkeep")
entries = []
for path in files:
    rel = path.relative_to(project_root.parent).as_posix()
    entries.append({
        "path": rel,
        "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
    })

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
    )((project_root / "metadata.yaml").read_text().splitlines()),
    "published_root": "kernel/published",
    "included_files": [e["path"] for e in entries],
}

fingerprints = {
    "artifact_type": "gpt_project_pack_fingerprints",
    "artifact_version": "0.1.0",
    "entries": entries,
}

release_path.write_text(json.dumps(release, indent=2) + "\n")
fingerprints_path.write_text(json.dumps(fingerprints, indent=2) + "\n")
PY

python - <<'PY'
from pathlib import Path
import json
from datetime import datetime, timezone

project_root = Path("/home/_404/src/gpt-registry/kernel/project")
release_path = project_root / "bundle" / "release.json"
fingerprints_path = project_root / "bundle" / "fingerprints.json"

release = json.loads(release_path.read_text())
release["generated_at"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
release["fingerprints_ref"] = "kernel/project/bundle/fingerprints.json"
release["included_files"] = sorted(release["included_files"])

fingerprints = json.loads(fingerprints_path.read_text())
fingerprints["generated_at"] = release["generated_at"]

release_path.write_text(json.dumps(release, indent=2) + "\n")
fingerprints_path.write_text(json.dumps(fingerprints, indent=2) + "\n")
PY

echo "${timestamp}"
