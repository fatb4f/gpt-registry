#!/usr/bin/env bash

set -euo pipefail

template_root="$(cd "$(dirname "$0")" && pwd)"
jsonnet_bin="${JSONNET_BIN:-/home/_404/.local/share/cargo/bin/rsjsonnet}"

params_path="${1:?usage: render_project.sh <params.json> <target-dir>}"
target_dir="${2:?usage: render_project.sh <params.json> <target-dir>}"

mkdir -p "${target_dir}"

render_json="$(mktemp)"
trap 'rm -f "${render_json}"' EXIT

"${jsonnet_bin}" \
  --ext-code-file params="${params_path}" \
  -o "${render_json}" \
  "${template_root}/project/render/jsonnet/project-source.libsonnet"

python - "${render_json}" "${target_dir}" <<'PY'
import json
import sys
from collections import OrderedDict
from pathlib import Path

import yaml

class TemplateYamlDumper(yaml.SafeDumper):
    def increase_indent(self, flow=False, indentless=False):
        return super().increase_indent(flow, False)

def represent_ordered_dict(dumper, data):
    return dumper.represent_dict(data.items())

def represent_str(dumper, data):
    return dumper.represent_scalar("tag:yaml.org,2002:str", data, style="")

TemplateYamlDumper.add_representer(OrderedDict, represent_ordered_dict)
TemplateYamlDumper.add_representer(str, represent_str)

def to_ordered(value):
    if isinstance(value, list):
        if value and all(isinstance(item, list) and len(item) == 2 and isinstance(item[0], str) for item in value):
            return OrderedDict((key, to_ordered(item)) for key, item in value)
        return [to_ordered(item) for item in value]
    if isinstance(value, dict):
        return OrderedDict((key, to_ordered(item)) for key, item in value.items())
    return value

render_json = Path(sys.argv[1])
target_dir = Path(sys.argv[2])
files = json.loads(render_json.read_text())

for rel, spec in files.items():
    path = target_dir / rel
    path.parent.mkdir(parents=True, exist_ok=True)
    kind = spec["kind"]
    if kind == "text":
        content = spec["content"]
    elif kind == "yaml":
        data = to_ordered(spec["entries"])
        content = yaml.dump(
            data,
            sort_keys=False,
            default_flow_style=False,
            allow_unicode=False,
            indent=2,
            width=80,
            Dumper=TemplateYamlDumper,
        )
    else:
        raise SystemExit(f"unsupported rendered file kind for {rel}: {kind}")

    path.write_text(content)
PY
