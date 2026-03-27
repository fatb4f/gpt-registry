#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
bundle_root="${repo_root}/bundle"
published_root="${repo_root}/published"

rclone_bin="${RCLONE_BIN:-rclone}"
remote_name="${RCLONE_REMOTE:-gdrive}"
remote_root="${RCLONE_ROOT:-OpenAI/ChatGPT/kernel}"
current_target="${remote_name}:${remote_root}/current"
releases_target="${remote_name}:${remote_root}/releases"
dry_run="${DRY_RUN:-0}"

archive_path="$("${bundle_root}/archive.sh")"

rclone_args=()
if [[ "${dry_run}" == "1" ]]; then
  rclone_args+=(--dry-run)
fi

"${rclone_bin}" mkdir "${current_target}"
"${rclone_bin}" mkdir "${releases_target}"

"${rclone_bin}" sync "${published_root}" "${current_target}" "${rclone_args[@]}"
"${rclone_bin}" copy "${archive_path}" "${releases_target}" "${rclone_args[@]}"

printf 'published_root=%s\n' "${published_root}"
printf 'archive_path=%s\n' "${archive_path}"
printf 'current_target=%s\n' "${current_target}"
printf 'releases_target=%s\n' "${releases_target}"
