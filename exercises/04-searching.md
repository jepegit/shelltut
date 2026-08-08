# 04 — Searching text

## Goals

Search file contents with `grep` and `rg`.

## Drills (grep)

1. Find lines containing `ERROR` in `playground/logs/app.log`.
2. Case-insensitive search for `error` across `playground/logs/`.
3. Show surrounding context: 2 lines before and after each `WARN`.
4. List only filenames that match `NMC811` under `playground/`.
5. Invert match: lines in `app.log` that are not `DEBUG`.

## Drills (rg, if installed)

```bash
rg ERROR playground/logs
rg -i banana playground
rg -n Lovelace playground/data
rg -g '*.log' WARN playground
```

## Stretch

- Count matches: `rg -c ERROR playground/logs/app.log`
- Only words: `rg -w ok playground/data/cells.json`

## Check yourself

How many `ERROR` lines are in `app.log`? (Answer: 3)
