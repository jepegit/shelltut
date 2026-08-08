# 07 — Processes & jobs

## Goals

Inspect running processes, background jobs, and signals.

## Drills

1. List your processes: `ps` and `ps aux | rg "$USER"` (or `grep`).
2. Start a long sleep in the background:

```bash
sleep 300 &
jobs
```

3. Bring it to the foreground with `fg`, then pause with `Ctrl+Z`, then `bg`.
4. Kill that job by PID or with `%1`.
5. Compare `top` and `htop` (if installed). Quit with `q`.

## Stretch

- `pgrep -a sleep` / `pkill sleep` (careful on shared machines)
- `kill -l` to list signals; try `kill -TERM` vs `kill -KILL`

## Check yourself

You can start, pause, resume, and stop a background job without closing the terminal.
