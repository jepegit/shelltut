# 11 — git in the terminal

Practice on a throwaway branch so `main` stays clean.

## Goals

Use everyday git from the CLI.

## Drills

1. Inspect state:

```bash
git status
git log --oneline -n 5
git remote -v
```

2. Create a practice branch and make a harmless change under `playground/scratch/` (create a file).
3. Stage and commit that file.
4. Show the commit with `git show` and the diff with `git diff HEAD~1`.
5. Stash a second dirty change, confirm clean tree, then `git stash pop`.
6. Switch back to `main` and delete the practice branch when finished.

## Stretch

- `git log --graph --oneline --all`
- `git blame README.md` on a few lines
- Interactive-free amend only if you know the safety rules; prefer a new commit here

## Check yourself

`git status` is clean on `main`, and your practice branch is deleted locally.
