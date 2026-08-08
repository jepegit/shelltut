# Merge conflicts cheatsheet

## shelltut lab

```bash
./scripts/merge-conflict-lab.sh setup
./scripts/merge-conflict-lab.sh conflict-merge
cd "$(./scripts/merge-conflict-lab.sh path)"
./scripts/merge-conflict-lab.sh reset
```

## Markers

```text
<<<<<<< HEAD
current branch version
=======
incoming version
>>>>>>> branch-name
```

Delete the markers and leave the final correct text.

## Workflow (merge)

```bash
git status
git diff --name-only --diff-filter=U
# edit files
rg '^(<<<<<<<|=======|>>>>>>>)' -n
git add FILE...
git commit          # finishes the merge
# or
git merge --abort
```

## Workflow (rebase)

```bash
git rebase main
# fix + git add
git rebase --continue
# or
git rebase --abort
```

## Take one whole side

```bash
git checkout --ours PATH
git checkout --theirs PATH
git add PATH
```

Meanings flip between merge and rebase — verify with `git status` / file contents.

## Modify/delete

```bash
git add PATH    # keep file
git rm PATH     # confirm delete
```

## Inspect stages

```bash
git show :1:PATH   # base
git show :2:PATH   # ours
git show :3:PATH   # theirs
git mergetool
```

## Helpful config

```bash
git config --global merge.conflictStyle zdiff3
git config --global pull.rebase false    # or true — team choice
```

## After resolving a rebased PR branch

```bash
git push --force-with-lease
```
