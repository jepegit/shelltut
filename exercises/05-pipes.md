# 05 — Pipes & redirection

## Goals

Chain commands and control stdout/stderr.

## Drills

1. List `playground/logs/` and pipe into `wc -l`.
2. Extract `ERROR` lines from `app.log` and save them to `playground/scratch/errors.txt`.
3. Append a timestamped note to that file with `>>`.
4. Sort roles from the CSV (skip header) and write unique roles to a file:

```bash
tail -n +2 playground/data/people.csv | cut -d, -f3 | sort | uniq
```

5. Use `tee` so you both see output and save it:

```bash
rg ERROR playground/logs/app.log | tee playground/scratch/errors-tee.txt
```

6. Redirect stderr: run a failing command and send errors to a file.

```bash
ls playground/does-not-exist 2> playground/scratch/stderr.txt
```

## Stretch

- Merge streams: `cmd > playground/scratch/all.txt 2>&1`
- Pipeline exit status with `pipefail` in a tiny script

## Check yourself

`playground/scratch/errors.txt` exists and contains the ERROR lines from `app.log`.
