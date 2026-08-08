# 13 — Herdr CLI & automation

Docs: [CLI reference](https://herdr.dev/docs/cli-reference/) · [How to work](https://herdr.dev/docs/how-to-work/)

The CLI talks to the running Herdr server over the same local socket API agents use. Most commands print JSON — pipe through `jq` when you want readable fields.

## Goals

Drive workspaces, tabs, and panes from another terminal (or a script) without clicking through the TUI.

## Setup

1. Start a session from the repo (leave it running; detach with `prefix+q` if you want a free terminal):

```bash
cd /path/to/shelltut
herdr
```

2. In a normal shell (outside Herdr, or in another pane), confirm the server:

```bash
herdr status server
herdr session list
```

## Drills — topology

1. List workspaces and create one labeled for this training repo:

```bash
herdr workspace list
herdr workspace create --cwd "$(pwd)" --label shelltut --no-focus
```

Note the JSON ids: `.result.workspace.workspace_id`, `.result.tab.tab_id`, `.result.root_pane.pane_id`.

2. Create a tab named `logs` in that workspace (pass `--workspace <id>`):

```bash
herdr tab create --workspace <workspace_id> --label logs --cwd "$(pwd)" --no-focus
```

3. Split a pane right, then down:

```bash
herdr pane split <pane_id> --direction right --no-focus
herdr pane split <pane_id> --direction down --no-focus
herdr pane list --workspace <workspace_id>
```

4. Rename panes so the layout is readable:

```bash
herdr pane rename <pane_id> logs
herdr pane rename <other_pane_id> shell
```

## Drills — run commands & read output

1. Run a command in a pane (submits text + Enter):

```bash
herdr pane run <logs_pane_id> 'tail -n 20 playground/logs/app.log'
```

2. Read what the pane shows:

```bash
herdr pane read <logs_pane_id> --source visible
herdr pane read <logs_pane_id> --source recent-unwrapped --lines 40
```

3. Wait until output appears (useful for servers and long jobs):

```bash
herdr pane run <logs_pane_id> 'rg ERROR playground/logs/app.log'
herdr pane wait-output <logs_pane_id> --match ERROR --timeout 5000
```

4. Inspect the focused / current pane metadata:

```bash
herdr pane get <pane_id>
herdr pane process-info --pane <pane_id>
```

Tip: inside a Herdr pane, `echo $HERDR_PANE_ID` shows the pane id for `--current` commands.

## Drills — sessions & cleanup

1. Try a named session (separate namespace from the default):

```bash
herdr --session shelltut-practice
# detach with prefix+q
herdr session list
herdr session stop shelltut-practice
```

2. Prefer workspaces for day-to-day project separation; use named sessions when you need completely separate panes, sockets, and persisted runtime state.

3. Clean up practice topology:

```bash
herdr workspace close <workspace_id>
# or stop everything in the default session:
herdr server stop
```

## Stretch — agents (optional)

Only if you have a supported agent CLI installed (`claude`, `codex`, `opencode`, `cursor`, …).

```bash
herdr agent list
# Start into an idle shell pane (pane must be a free interactive shell):
herdr agent start trainer --kind claude --pane <pane_id>
herdr agent prompt trainer 'Summarize playground/notes.txt in one sentence.' --wait
herdr agent read trainer --source visible --lines 40
```

Install deeper integrations when you want more accurate state:

```bash
herdr integration status
# herdr integration install claude   # example
```

## Stretch — remote

Read [How to work with Herdr](https://herdr.dev/docs/how-to-work/) and try one path:

```bash
# tmux-style: SSH first, then herdr on the remote
ssh you@server
herdr

# thin client from your laptop (uses local keybindings by default)
herdr --remote workbox
```

## Check yourself

From a non-Herdr shell you can create a workspace/tab, `pane run` a command against `playground/logs/app.log`, `pane read` the result, then close the workspace — all without using the mouse.
