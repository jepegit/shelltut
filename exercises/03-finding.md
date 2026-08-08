# 03 — Finding things

## Goals

Locate files by name and type under `playground/`.

## Drills (find)

1. Find all `.log` files under `playground/`.
2. Find files named `secret-note.txt`.
3. Find files modified in the last day (adjust if needed):

```bash
find playground -type f -mtime -1
```

4. Find empty directories under `playground/scratch/` (create one first if needed).

## Drills (fd, if installed)

```bash
fd -e log playground
fd secret-note playground
fd -t d deep playground
```

## Stretch

- Combine with `-exec` or `xargs` to run `wc -l` on every `.log` file.
- Exclude a directory: `find playground -path 'playground/scratch' -prune -o -type f -print`

## Check yourself

Print the full path to the file that contains `banana-split-42`.
