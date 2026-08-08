# 12 — Herdr basics

Docs: [herdr.dev](https://herdr.dev/) · [Quick start](https://herdr.dev/docs/quick-start/) · [Concepts](https://herdr.dev/docs/concepts/)

Herdr is a terminal workspace manager: a background server owns panes; clients attach, detach, and come back later. Agents and long jobs keep running after you close the terminal window.

## Goals

Install Herdr, run a session from this repo, move around with mouse and keyboard, detach safely, and reattach.

## Install (once)

```bash
curl -fsSL https://herdr.dev/install.sh | sh
# or: brew install herdr
herdr --version
```

Restart the shell if `herdr` is not on your `PATH`.

## Drills

1. From the `shelltut` repo root, start (or attach to) the default session:

```bash
herdr
```

2. Confirm a workspace opened for this project. Give active projects their own workspace later; the sidebar rolls up agent state per workspace.

3. Use the mouse (Herdr is mouse-native):
   - Click panes / tabs / workspaces to focus them
   - Drag split borders to resize
   - Right-click for split / new tab menus
   - Drag-select text to copy (no `Ctrl+C` required); double-click a token to copy it

4. Learn the five prefix keys (`Ctrl+b`, then the action):

| Action | Keys |
|--------|------|
| New tab | `prefix+c` |
| Split right / down | `prefix+v` / `prefix+minus` |
| Move between panes | `prefix+h/j/k/l` |
| Workspace navigation | `prefix+w` |
| Detach (leave everything running) | `prefix+q` |

Press `prefix+?` anytime to see all bindings.

5. Build a small layout for this repo:
   - Split right; in one pane run `tail -f playground/logs/app.log`
   - Split down or open a new tab; in another pane run `rg ERROR playground/logs`
   - Optionally rename the tab (`prefix+shift+t`) to something like `logs`

6. Detach with `prefix+q` (or close the terminal window). Confirm panes are still alive:

```bash
herdr status
herdr status server
```

7. Reattach with `herdr` and confirm the log `tail -f` is still running.

8. When you are done practicing, stop the session and its panes:

```bash
herdr server stop
```

## Stretch

- Create a second workspace (`prefix+shift+n`) pointed at another directory you care about; switch with `prefix+w`.
- Enter copy mode with `prefix+[`, search with `/`, yank with `y` / Enter.
- Compare with [tmux](09-tmux.md): same “detach and return” idea, but Herdr adds workspaces, mouse UI, and agent awareness.

## Check yourself

You can detach, close the outer terminal, open a new one, run `herdr`, and land back in the same layout with live panes.
