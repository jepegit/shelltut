# 08 — Shell scripting basics

## Goals

Write small, safe bash scripts.

## Drills

1. Run the sample script:

```bash
chmod +x playground/scripts/hello.sh
./playground/scripts/hello.sh
./playground/scripts/hello.sh Ada
```

2. In `playground/scratch/`, write `greet.sh` that:
   - uses `set -euo pipefail`
   - accepts a name argument (default `friend`)
   - prints a greeting and the current date

3. Write `count-errors.sh` that counts `ERROR` lines in `playground/logs/app.log` and exits `1` if count > 0.

4. Loop over all `.log` files and print their line counts.

## Stretch

- Add a `--help` flag
- Use a function and `[[ ]]` tests
- Read lines from `people.csv` with `while IFS=, read -r ...`

## Check yourself

`shellcheck` (if installed) reports no issues on your scripts.
