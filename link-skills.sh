#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./link-skills.sh [--dry-run] [--target DIRECTORY]...

Symlink every skill in this repository into user-level skill directories.
A skill is an immediate child directory containing a SKILL.md file.

By default, links are created in:
  ~/.agents/skills  (Codex, OpenCode, and Agent Skills-compatible tools)
  ~/.claude/skills  (Claude Code)

Options:
  -n, --dry-run           Show what would change without changing anything.
  -t, --target DIRECTORY  Use a custom destination. May be repeated.
  -h, --help              Show this help text.
EOF
}

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
dry_run=false
targets=()

while (($# > 0)); do
  case "$1" in
    -n|--dry-run)
      dry_run=true
      shift
      ;;
    -t|--target)
      if (($# < 2)); then
        echo "error: --target requires a directory" >&2
        exit 2
      fi
      targets+=("$2")
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if ((${#targets[@]} == 0)); then
  targets=(
    "$HOME/.agents/skills"
    "$HOME/.claude/skills"
  )
fi

skills=()
for candidate in "$script_dir"/*/; do
  [[ -f "${candidate}SKILL.md" ]] || continue
  skills+=("${candidate%/}")
done

if ((${#skills[@]} == 0)); then
  echo "No skills found in $script_dir" >&2
  exit 1
fi

linked=0
unchanged=0
conflicts=0

for target in "${targets[@]}"; do
  if [[ "$dry_run" == true ]]; then
    [[ -d "$target" ]] || echo "Would create directory: $target"
  else
    mkdir -p -- "$target"
  fi

  for skill_dir in "${skills[@]}"; do
    skill_name=${skill_dir##*/}
    link_path="$target/$skill_name"

    if [[ -L "$link_path" ]]; then
      existing_target=$(readlink "$link_path")
      if [[ "$existing_target" == "$skill_dir" ]]; then
        echo "Unchanged: $link_path"
        ((unchanged += 1))
      else
        echo "Conflict: $link_path is a symlink to $existing_target" >&2
        ((conflicts += 1))
      fi
      continue
    fi

    if [[ -e "$link_path" ]]; then
      echo "Conflict: $link_path already exists and was not changed" >&2
      ((conflicts += 1))
      continue
    fi

    if [[ "$dry_run" == true ]]; then
      echo "Would link: $link_path -> $skill_dir"
    else
      ln -s -- "$skill_dir" "$link_path"
      echo "Linked: $link_path -> $skill_dir"
    fi
    ((linked += 1))
  done
done

echo "Summary: $linked linked, $unchanged unchanged, $conflicts conflicts"

if ((conflicts > 0)); then
  exit 1
fi
