#!/usr/bin/env bash
# Restore tracked playground files and clear local scratch.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not a git repo; cannot reset from git." >&2
  exit 1
fi

git checkout -- playground/
rm -rf playground/scratch
mkdir -p playground/scratch
echo "Playground restored. Scratch dir is empty at playground/scratch/"
