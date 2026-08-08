# tmux cheatsheet

Prefix: `Ctrl+b` (shown as `C-b`).

## Sessions

| Action | Keys / command |
|--------|----------------|
| New named session | `tmux new -s name` |
| List | `tmux ls` |
| Attach | `tmux attach -t name` |
| Detach | `C-b d` |
| Kill session | `tmux kill-session -t name` |

## Windows

| Action | Keys |
|--------|------|
| New window | `C-b c` |
| Rename | `C-b ,` |
| Next / previous | `C-b n` / `C-b p` |
| Select by number | `C-b 0` … `C-b 9` |

## Panes

| Action | Keys |
|--------|------|
| Split horizontal | `C-b "` |
| Split vertical | `C-b %` |
| Move focus | `C-b` + arrow |
| Zoom pane | `C-b z` |
| Close pane | `exit` or `C-b x` |
