# 02 — Viewing & paging

## Goals

Read files without opening an editor, and sample the start/end of logs.

## Drills

1. Print all of `playground/notes.txt` with `cat`.
2. Open `playground/logs/app.log` in `less`. Practice: space (page), `/ERROR` (search), `n` (next), `q` (quit).
3. Show the first 5 and last 5 lines of `app.log`.
4. Count lines, words, and bytes in `playground/data/people.csv`.
5. Follow a growing log (simulate with another terminal):

```bash
# terminal A
touch playground/scratch/live.log
tail -f playground/scratch/live.log

# terminal B
echo "tick $(date -Iseconds)" >> playground/scratch/live.log
```

## Stretch

- `less -N playground/logs/app.log` (line numbers)
- Compare `head -n 3` vs `sed -n '1,3p'`

## Check yourself

You can find the first `ERROR` line in `app.log` without opening an editor.
