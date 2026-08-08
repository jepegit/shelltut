# 01 — Navigation & files

Work from the repo root unless noted.

## Goals

Move around the tree, inspect directories, create/copy/move/remove files safely.

## Drills

1. Print the current directory, then list files including hidden ones.
2. Enter `playground/`, list contents with human-readable sizes, then go back to the repo root with `cd -` or `cd ..`.
3. Create `playground/scratch/demo/` and an empty file `playground/scratch/demo/todo.txt`.
4. Copy `playground/notes.txt` into that demo folder.
5. Rename the copy to `notes-backup.txt`.
6. Move `notes-backup.txt` up one level into `playground/scratch/`.
7. Remove only the empty `demo/` directory (or remove the whole scratch tree when done).

## Stretch

- Use `tree` (if installed) on `playground/`.
- Practice tab-completion while typing long nested paths under `playground/nested/`.

## Check yourself

```bash
pwd
ls -la
ls playground/scratch
```
