# 21 — Fixing merge conflicts (in depth)

Related: [git basics](11-git.md) · [vim](15-vim.md) · [gh](14-gh.md)

A **merge conflict** means Git cannot automatically combine two edits to the same place. You decide the final text, then mark the conflict resolved.

This exercise uses a **throwaway lab repo** under `playground/scratch/merge-lab` so you never mess up `shelltut` itself.

## Goals

Recognize conflict markers, resolve content / both-add / modify-delete conflicts, finish merges and rebases, abort safely, and use tools that make conflicts less painful.

## Mental model

```text
        o main   (changed app.py lines 3–12)
       /
  o---o
       \
        o feature (also changed app.py lines 3–12)
```

Git can auto-merge *different* lines/files. When both sides change the **same region**, you get a conflict.

Common situations:

| Situation | What you see |
|-----------|----------------|
| Both edited same lines | Conflict markers inside the file |
| Both added same new path | “both added” / conflict markers |
| One edited, one deleted | “deleted by us/them” — keep or drop the file |
| Rebase conflict | Same markers, but you are replaying commits onto a new base |

## Setup

```bash
./scripts/merge-conflict-lab.sh setup
cd "$(./scripts/merge-conflict-lab.sh path)"
git log --oneline --graph --all --decorate
```

Reset the lab anytime:

```bash
./scripts/merge-conflict-lab.sh reset
./scripts/merge-conflict-lab.sh setup
```

## Part A — Anatomy of a conflict

1. Create a merge conflict:

```bash
./scripts/merge-conflict-lab.sh setup
./scripts/merge-conflict-lab.sh conflict-merge
cd "$(./scripts/merge-conflict-lab.sh path)"
git status
```

2. List conflicted files:

```bash
git diff --name-only --diff-filter=U
# or
git status --short
```

`UU` / `unmerged` means “still conflicted”.

3. Open `app.py` in your editor (vim is fine). Find markers:

```text
<<<<<<< HEAD
... current branch (main, during this merge) ...
=======
... incoming branch (feature) ...
>>>>>>> feature
```

During a merge:

| Side | Meaning |
|------|---------|
| `HEAD` / before `=======` | the branch you had checked out (`main`) |
| after `=======` | the branch being merged in (`feature`) |

During a rebase, labels feel “backwards” to many people: `HEAD` is the branch you are rebasing *onto*. Prefer reading the commit message/`git status` over memorizing colors alone.

4. Also open `config.toml` and `notes/changelog.md` — multiple files can conflict in one merge.

## Part B — Resolve a content conflict by hand

Goal: produce a sensible combined `app.py` that keeps:

- a clear version story (pick one version string, or invent `1.2.0`)
- improved `greet()` from feature
- docstring on `add()` from main
- `shout()` from feature

1. Edit until **all** `<<<<<<<`, `=======`, `>>>>>>>` markers are gone.
2. Sanity-check:

```bash
rg '^(<<<<<<<|=======|>>>>>>>)' -n . || echo "no markers left"
python -c 'import app; print(app.greet("  ada  "), app.shout("ok"), app.VERSION)'
```

3. Mark resolved and finish the merge:

```bash
git add app.py config.toml notes/changelog.md
git status
git commit   # opens editor with a merge message; save/quit
git log --oneline --graph --all --decorate -n 15
```

Notes:

- `git add` on a conflicted file means “I accept this content as resolved”
- Do **not** leave markers in the committed file
- Resolve `config.toml` deliberately (staging vs timeout vs port) — there is no single right answer; document your choice in the changelog if you want

## Part C — Abort vs finish

1. Reset and create a fresh conflict:

```bash
cd /path/to/shelltut
./scripts/merge-conflict-lab.sh reset && ./scripts/merge-conflict-lab.sh setup
./scripts/merge-conflict-lab.sh conflict-merge
cd "$(./scripts/merge-conflict-lab.sh path)"
```

2. Abort — back to pre-merge state:

```bash
git merge --abort
git status
git log --oneline --graph --all --decorate -n 10
```

Use `--abort` when you realize you started the wrong merge or need a cleaner plan. Nothing is “half merged” afterward.

3. Run `conflict-merge` again and resolve for real (Part B).

## Part D — Choosing a whole side (ours / theirs)

Sometimes one side is entirely right for a file.

```bash
# from a conflicted merge on main:
git checkout --ours config.toml      # keep main's file
git checkout --theirs config.toml    # take feature's file
git add config.toml
```

During a **merge** on `main`:

| Option | Keeps |
|--------|--------|
| `--ours` | `main` |
| `--theirs` | branch being merged (`feature`) |

During a **rebase**, ours/theirs swap meaning relative to your intuition. When unsure, open the file or use a mergetool instead of guessing.

Practice:

```bash
./scripts/merge-conflict-lab.sh reset && ./scripts/merge-conflict-lab.sh setup
./scripts/merge-conflict-lab.sh conflict-merge
cd "$(./scripts/merge-conflict-lab.sh path)"
git checkout --theirs config.toml
git add config.toml
# still resolve app.py and changelog by hand, then commit
```

## Part E — Rebase conflicts

Rebasing replays your commits on top of another tip. Conflicts are resolved **commit by commit**.

```bash
./scripts/merge-conflict-lab.sh reset && ./scripts/merge-conflict-lab.sh setup
./scripts/merge-conflict-lab.sh conflict-rebase
cd "$(./scripts/merge-conflict-lab.sh path)"
git status
```

1. Fix markers in the listed files.
2. `git add` each resolved file.
3. Continue:

```bash
git rebase --continue
```

If more conflicts appear, repeat. To escape:

```bash
git rebase --abort
```

When to rebase vs merge (practical rule):

- **Merge**: preserves exact history; common on shared `main` via PRs
- **Rebase**: linear history on *your* feature branch before opening/updating a PR; avoid rebasing commits already shared with others unless your team expects it

## Part F — Modify/delete conflicts

```bash
cd /path/to/shelltut
./scripts/merge-conflict-lab.sh conflict-modify-delete
cd "$(./scripts/merge-conflict-lab.sh path)"
git status
```

Git will say one side deleted `notes/changelog.md` while the other modified it.

Keep the file (take the modified version):

```bash
git add notes/changelog.md
```

Or confirm deletion:

```bash
git rm notes/changelog.md
```

Then `git commit` to finish the merge.

## Part G — Both sides added the same file

```bash
./scripts/merge-conflict-lab.sh conflict-both-add
cd "$(./scripts/merge-conflict-lab.sh path)"
git status
cat notes/owners.md
```

Merge the content (maybe list both owners), remove markers, `git add`, `git commit`.

## Part H — Tools that help

### Diff while conflicted

```bash
git diff                 # unresolved conflict hunks
git diff --ours          # vs our stage
git diff --theirs
git show :1:app.py       # common ancestor stage
git show :2:app.py       # ours
git show :3:app.py       # theirs
```

### Mergetool

If you have one configured (`meld`, `kdiff3`, `vimdiff`, VS Code):

```bash
git mergetool
```

VS Code / Cursor: open the file → “Accept Current / Incoming / Both” UI, then stage.

### Prefer merge.conflictStyle=zdiff3 (optional)

Shows the common ancestor too — often easier:

```bash
git config merge.conflictStyle zdiff3   # lab only already has local config; use --global if you want it everywhere
```

Markers become `<<<<<<<` / `|||||||` / `=======` / `>>>>>>>`.

### Avoid conflicts upstream

- Pull/rebase onto latest `main` **before** your PR grows stale
- Keep PRs small and focused
- Don’t reformat unrelated code in the same commit as logic changes
- Communicate when two people must edit the same hot file

## Part I — PR / GitHub workflow sketch

On a real project (not the lab):

```bash
git switch main
git pull
git switch feature
git merge main          # or: git rebase main
# resolve conflicts, test, commit (merge) or rebase --continue
git push                # if you rebased a branch already on the remote: git push --force-with-lease
gh pr checks
```

Prefer `--force-with-lease` over `--force` when updating a rebased remote branch.

## Check yourself

You can:

1. Create a conflict with `./scripts/merge-conflict-lab.sh conflict-merge`
2. Explain what `HEAD` vs the other side means in that merge
3. Remove all markers, `git add`, and finish with `git commit`
4. Abort a merge and a rebase cleanly
5. Resolve a modify/delete conflict intentionally (keep **or** delete)

## Stretch

- Resolve the Part B merge using `vim -d` / `vimdiff` on `app.py`
- Configure `merge.conflictStyle zdiff3` in the lab and re-run a conflict
- Practice `gh pr checkout` on a real PR that conflicts, then merge `main` into the PR branch
- Read `git help merge` section “HOW CONFLICTS ARE PRESENTED”
