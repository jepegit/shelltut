# 09 — tmux

Requires `tmux`. Prefix key is usually `Ctrl+b`.

## Goals

Keep sessions alive, split panes, and detach safely.

## Drills

1. Start a session named training:

```bash
tmux new -s training
```

2. Detach: `Ctrl+b` then `d`. List sessions: `tmux ls`. Reattach:

```bash
tmux attach -t training
```

3. Create a second window (`Ctrl+b` `c`), rename it (`Ctrl+b` `,`), switch with `Ctrl+b` `n` / `p`.
4. Split panes: horizontal `Ctrl+b` `"`, vertical `Ctrl+b` `%`. Move with arrow keys after `Ctrl+b`.
5. In one pane, `tail -f playground/logs/app.log`. In another, run searches with `rg`.

## Stretch

- `tmux new-session -d -s logs 'tail -f playground/logs/app.log'`
- Save a simple config in `~/.tmux.conf` (mouse on, larger history)

## Check yourself

Detach, close the terminal emulator, open a new one, and reattach to `training` still running.
