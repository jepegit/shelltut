# 06 — Text processing

Use `playground/data/people.csv` and the logs.

## Goals

Slice columns, sort, dedupe, and do light transforms with `sed`/`awk`.

## Drills

1. Print only the `name` column from `people.csv` (no header).
2. Sort people by `score` descending.
3. Count how many people have `role=engineer`.
4. From `access.log`, print HTTP status codes and count each with `sort | uniq -c`.
5. With `sed`, replace `ERROR` with `ERR` in a copy of `app.log` under `scratch/`.
6. With `awk`, print names of people with score >= 96:

```bash
awk -F, 'NR>1 && $5+0 >= 96 { print $2 }' playground/data/people.csv
```

## Stretch

- `awk` average score
- `sed -n 's/.*status=\([0-9][0-9][0-9]\).*/\1/p'` on `app.log`

## Check yourself

Unique roles in the CSV: analyst, engineer, researcher
