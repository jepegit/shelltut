#!/usr/bin/env bash
# Build a disposable git repo with intentional merge conflicts for practice.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab="${MERGE_LAB_DIR:-$root/playground/scratch/merge-lab}"

die() { echo "$*" >&2; exit 1; }

usage() {
  cat <<EOF
Usage: $(basename "$0") <command>

Creates an isolated practice repo at:
  $lab

Commands:
  setup              Fresh repo with main + feature + diverging edits
  conflict-merge     Merge feature into main (leaves conflicts for you)
  conflict-rebase    Rebase feature onto main (leaves conflicts for you)
  conflict-modify-delete
                     Modify/delete conflict scenario
  conflict-both-add  Both sides added the same new file differently
  status             Show lab git status / graph
  path               Print lab directory
  reset              Delete the lab directory

Work inside the lab:
  cd "\$(./scripts/merge-conflict-lab.sh path)"
EOF
}

ensure_clean_lab_parent() {
  mkdir -p "$(dirname "$lab")"
}

init_base() {
  ensure_clean_lab_parent
  rm -rf "$lab"
  mkdir -p "$lab"
  git -C "$lab" init -b main >/dev/null
  git -C "$lab" config user.email "shelltut@example.com"
  git -C "$lab" config user.name "shelltut learner"
  # Avoid global hooks / CRLF noise surprising the lab
  git -C "$lab" config core.hooksPath /dev/null
  git -C "$lab" config core.autocrlf false

  cat > "$lab/README.md" <<'EOF'
# merge-lab

Tiny throwaway repo for practicing merge conflicts.
EOF

  cat > "$lab/app.py" <<'EOF'
"""Toy app used for conflict drills."""

VERSION = "1.0.0"


def greet(name: str) -> str:
    return f"Hello, {name}!"


def add(a: int, b: int) -> int:
    return a + b
EOF

  cat > "$lab/config.toml" <<'EOF'
[app]
name = "merge-lab"
env = "dev"
port = 8080
EOF

  mkdir -p "$lab/notes"
  cat > "$lab/notes/changelog.md" <<'EOF'
# Changelog

## Unreleased

- Initial toy app
EOF

  git -C "$lab" add README.md app.py config.toml notes/changelog.md
  git -C "$lab" commit -m "Initial merge-lab commit" >/dev/null
}

diverging_branches() {
  # main moves forward
  git -C "$lab" switch main >/dev/null
  cat > "$lab/app.py" <<'EOF'
"""Toy app used for conflict drills."""

VERSION = "1.1.0"


def greet(name: str) -> str:
    return f"Hello, {name}!"


def add(a: int, b: int) -> int:
    """Return the sum of a and b."""
    return a + b
EOF

  cat > "$lab/config.toml" <<'EOF'
[app]
name = "merge-lab"
env = "dev"
port = 8080
timeout_s = 30
EOF

  cat >> "$lab/notes/changelog.md" <<'EOF'

## 1.1.0

- Document add()
- Bump version to 1.1.0
EOF

  git -C "$lab" add app.py config.toml notes/changelog.md
  git -C "$lab" commit -m "main: bump version and document add()" >/dev/null

  # feature branched from first commit, with overlapping edits
  git -C "$lab" switch -c feature main~1 >/dev/null
  cat > "$lab/app.py" <<'EOF'
"""Toy app used for conflict drills."""

VERSION = "1.0.1-feature"


def greet(name: str) -> str:
    name = name.strip().title()
    return f"Hi, {name}!"


def add(a: int, b: int) -> int:
    return a + b


def shout(msg: str) -> str:
    return msg.upper()
EOF

  cat > "$lab/config.toml" <<'EOF'
[app]
name = "merge-lab"
env = "staging"
port = 9090
EOF

  cat >> "$lab/notes/changelog.md" <<'EOF'

## Feature

- Friendlier greet()
- Add shout()
- Point config at staging:9090
EOF

  git -C "$lab" add app.py config.toml notes/changelog.md
  git -C "$lab" commit -m "feature: greet/shout + staging config" >/dev/null
  git -C "$lab" switch main >/dev/null
}

cmd="${1:-}"
case "$cmd" in
  setup)
    init_base
    diverging_branches
    echo "Lab ready at: $lab"
    echo "Branches: main and feature (diverged)."
    echo "Next: $(basename "$0") conflict-merge"
    ;;
  conflict-merge)
    [[ -d "$lab/.git" ]] || die "Lab missing. Run: $(basename "$0") setup"
    git -C "$lab" switch main >/dev/null
    git -C "$lab" merge feature || true
    echo
    echo "Merge conflict created in: $lab"
    echo "Inspect with: cd \"$lab\" && git status"
    ;;
  conflict-rebase)
    [[ -d "$lab/.git" ]] || die "Lab missing. Run: $(basename "$0") setup"
    # Ensure clean starting point from setup state
    if git -C "$lab" merge-base --is-ancestor feature main 2>/dev/null; then
      :
    fi
    git -C "$lab" merge --abort >/dev/null 2>&1 || true
    git -C "$lab" rebase --abort >/dev/null 2>&1 || true
    # Recreate clean divergence if someone already resolved things
    if ! git -C "$lab" rev-parse feature >/dev/null 2>&1; then
      die "feature branch missing. Run: $(basename "$0") setup"
    fi
    git -C "$lab" switch feature >/dev/null
    git -C "$lab" rebase main || true
    echo
    echo "Rebase conflict created in: $lab (on branch feature)"
    echo "Inspect with: cd \"$lab\" && git status"
    ;;
  conflict-modify-delete)
    init_base
    git -C "$lab" switch -c feature >/dev/null
    cat >> "$lab/notes/changelog.md" <<'EOF'

## Feature note

Keep this changelog; it still matters.
EOF
    git -C "$lab" add notes/changelog.md
    git -C "$lab" commit -m "feature: extend changelog" >/dev/null
    git -C "$lab" switch main >/dev/null
    git -C "$lab" rm notes/changelog.md >/dev/null
    git -C "$lab" commit -m "main: remove changelog" >/dev/null
    git -C "$lab" merge feature || true
    echo
    echo "Modify/delete conflict created in: $lab"
    echo "Inspect with: cd \"$lab\" && git status"
    ;;
  conflict-both-add)
    init_base
    git -C "$lab" switch -c feature >/dev/null
    cat > "$lab/notes/owners.md" <<'EOF'
# Owners

- feature-team@example.com
EOF
    git -C "$lab" add notes/owners.md
    git -C "$lab" commit -m "feature: add owners" >/dev/null
    git -C "$lab" switch main >/dev/null
    cat > "$lab/notes/owners.md" <<'EOF'
# Owners

- platform@example.com
EOF
    git -C "$lab" add notes/owners.md
    git -C "$lab" commit -m "main: add owners" >/dev/null
    git -C "$lab" merge feature || true
    echo
    echo "Both-added conflict created in: $lab"
    echo "Inspect with: cd \"$lab\" && git status"
    ;;
  status)
    [[ -d "$lab/.git" ]] || die "Lab missing. Run: $(basename "$0") setup"
    git -C "$lab" status
    echo
    git -C "$lab" log --oneline --graph --all --decorate | head -n 30
    ;;
  path)
    echo "$lab"
    ;;
  reset)
    rm -rf "$lab"
    echo "Removed $lab"
    ;;
  ""|-h|--help|help)
    usage
    ;;
  *)
    usage
    die "unknown command: $cmd"
    ;;
esac
