#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  scripts/install-skill.sh --list
  scripts/install-skill.sh [--dry-run] <skill-name>

Install one optional skill from skills-catalog to ~/.codex/skills.

Options:
  -l, --list     List available optional skills.
  -n, --dry-run  Show what would change without writing files.
  -h, --help     Show this help.
EOF
}

die() {
  echo "$*" >&2
  exit 1
}

list_only=0
dry_run=0
skill_name=""

while (($# > 0)); do
  case "$1" in
    -l|--list)
      list_only=1
      shift
      ;;
    -n|--dry-run)
      dry_run=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -n "${skill_name}" ]]; then
        die "Only one skill can be installed at a time."
      fi
      skill_name="$1"
      shift
      ;;
  esac
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
catalog_dir="${repo_root}/skills-catalog"
dest_codex_dir="${HOME}/.codex"
dest_skills_dir="${dest_codex_dir}/skills"

[[ -d "${catalog_dir}" ]] || die "Catalog directory not found: ${catalog_dir}"
[[ -d "${dest_codex_dir}" ]] || die "Destination directory not found: ${dest_codex_dir}. Run codex once to initialize it."
command -v rsync >/dev/null 2>&1 || die "rsync command not found."

if ((list_only == 1)); then
  find "${catalog_dir}" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort
  exit 0
fi

[[ -n "${skill_name}" ]] || die "Specify <skill-name> or use --list."
[[ "${skill_name}" != */* ]] || die "skill-name must not include '/'."

src_skill_dir="${catalog_dir}/${skill_name}"
dest_skill_dir="${dest_skills_dir}/${skill_name}"
[[ -d "${src_skill_dir}" ]] || die "Skill not found in catalog: ${skill_name}"
[[ -f "${src_skill_dir}/SKILL.md" ]] || die "Missing SKILL.md in skill: ${skill_name}"

timestamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="${dest_skills_dir}/.backup/${timestamp}/${skill_name}"

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
  mkdir -p "${dest_skill_dir}"
  echo "Installing skill '${skill_name}' to ${dest_skill_dir}"
fi

rsync "${rsync_opts[@]}" "${src_skill_dir}/" "${dest_skill_dir}/"

if ((dry_run == 0)); then
  echo "Backup directory (if any files were replaced): ${backup_dir}"
fi
