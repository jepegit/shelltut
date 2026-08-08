# Herdr cheatsheet

Site: [herdr.dev](https://herdr.dev/) · Full CLI: [docs/cli-reference](https://herdr.dev/docs/cli-reference/)

Prefix defaults to `Ctrl+b` (shown as `prefix`).

## Launch / leave

| Action | Command / keys |
|--------|----------------|
| Start or attach (default session) | `herdr` |
| Named session | `herdr --session name` |
| Detach client (keep server + panes) | `prefix+q` |
| Stop default session + panes | `herdr server stop` |
| Status | `herdr status` / `herdr status server` |
| Remote thin client | `herdr --remote host` |

## Keyboard (learn these first)

| Action | Keys |
|--------|------|
| New tab | `prefix+c` |
| Split right / down | `prefix+v` / `prefix+minus` |
| Focus panes | `prefix+h/j/k/l` |
| Next / previous tab | `prefix+n` / `prefix+p` |
| Workspace navigation | `prefix+w` |
| New workspace | `prefix+shift+n` |
| Zoom pane | `prefix+z` |
| Copy mode | `prefix+[` |
| Show bindings | `prefix+?` |
| Detach | `prefix+q` |

## Model

| Concept | Role |
|---------|------|
| Session | Persistent server namespace (`default` or named) |
| Workspace | Project container (tabs + panes + rolled-up agent state) |
| Tab | Layout inside a workspace |
| Pane | Real terminal process |
| Agent | Detected coding-agent process in a pane |

Agent states: `working`, `blocked`, `done`, `idle`, `unknown`.

## Useful CLI

```bash
herdr workspace list
herdr workspace create --cwd PATH --label NAME --no-focus
herdr tab create --workspace ID --label NAME --no-focus
herdr pane list --workspace ID
herdr pane split PANE --direction right|down --no-focus
herdr pane run PANE 'command'
herdr pane read PANE --source visible|recent-unwrapped --lines N
herdr pane wait-output PANE --match TEXT --timeout MS
herdr agent list
herdr agent start NAME --kind KIND --pane PANE
herdr session list
herdr session stop NAME
```

Most CLI commands print JSON. Pipe to `jq` as needed.

## Env inside panes

| Variable | Meaning |
|----------|---------|
| `HERDR_ENV` | `1` when inside a Herdr-managed pane |
| `HERDR_PANE_ID` | Current pane id |
| `HERDR_TAB_ID` | Current tab id |
| `HERDR_WORKSPACE_ID` | Current workspace id |
