#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
bundle_root="${repo_root}/bundle"
published_root="${repo_root}/published"
project_id="kernel"

"${bundle_root}/build.sh" >/dev/null

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

archive_name="${project_id}-project-pack-${bundle_version}.zip"
archive_path="${bundle_root}/${archive_name}"
staging_root="$(mktemp -d)"
trap 'rm -rf "${staging_root}"' EXIT

mkdir -p "${staging_root}/${project_id}"
cp -R "${published_root}/." "${staging_root}/${project_id}/"
find "${staging_root}" -name .gitkeep -delete

rm -f "${archive_path}"
(
  cd "${staging_root}"
  zip -qr "${archive_path}" "${project_id}"
)

echo "${archive_path}"
