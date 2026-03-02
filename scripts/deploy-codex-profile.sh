#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/deploy-codex-profile.sh [--dry-run]

Copy files from this repository's .codex directory to ~/.codex
without using symbolic links.

Options:
  -n, --dry-run  Show what would change without writing files.
  -h, --help     Show this help.
EOF
}

die() {
  echo "$*" >&2
  exit 1
}

dry_run=0
while (($# > 0)); do
  case "$1" in
    -n|--dry-run)
      dry_run=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
src_dir="${repo_root}/.codex"
dest_dir="${HOME}/.codex"
timestamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="${dest_dir}/.backup/${timestamp}"

command -v codex >/dev/null 2>&1 || die "codex command not found. Install codex before deploying."
command -v rsync >/dev/null 2>&1 || die "rsync command not found."
[[ -d "${src_dir}" ]] || die "Source directory not found: ${src_dir}"
[[ -d "${dest_dir}" ]] || die "Destination directory not found: ${dest_dir}. Run codex once to initialize it."

rsync_opts=(
  -a
  --itemize-changes
  --backup
  "--backup-dir=${backup_dir}"
)

if ((dry_run == 1)); then
  rsync_opts+=(--dry-run)
  echo "Dry run mode"
else
  echo "Deploying to ${dest_dir}"
fi

rsync "${rsync_opts[@]}" "${src_dir}/" "${dest_dir}/"

if ((dry_run == 0)); then
  echo "Backup directory (if any files were replaced): ${backup_dir}"
fi
