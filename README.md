# shelltut

Hands-on playground for learning shell and terminal tools.

Clone it, open a terminal in the repo root, and work through the exercises.
Sample files live under `playground/` so you can break things safely.

## Quick start

```bash
git clone https://github.com/jepegit/shelltut.git
cd shelltut
```

Optional: create a throwaway branch before experimenting:

```bash
git switch -c practice/$(date +%Y%m%d)
```

## Layout

```text
shelltut/
├── exercises/      # guided drills (one file per tool or topic)
├── playground/     # disposable files for practice
├── cheatsheets/    # short reference notes
└── README.md
```

## Suggested path

1. [Navigation & files](exercises/01-navigation.md) — `cd`, `ls`, `pwd`, `mkdir`, `cp`, `mv`, `rm`
2. [Viewing & paging](exercises/02-viewing.md) — `cat`, `less`, `head`, `tail`, `wc`
3. [Finding things](exercises/03-finding.md) — `find`, `fd`, `locate`
4. [Searching text](exercises/04-searching.md) — `grep`, `rg`
5. [Pipes & redirection](exercises/05-pipes.md) — `|`, `>`, `>>`, `<`, `tee`
6. [Text processing](exercises/06-text.md) — `cut`, `sort`, `uniq`, `tr`, `sed`, `awk`
7. [Processes & jobs](exercises/07-processes.md) — `ps`, `top`/`htop`, `kill`, jobs
8. [Shell scripting basics](exercises/08-scripting.md) — variables, loops, conditionals
9. [tmux](exercises/09-tmux.md) — sessions, windows, panes
10. [jq](exercises/10-jq.md) — JSON on the command line
11. [git in the terminal](exercises/11-git.md) — status, diff, log, stash, branches
12. [Herdr basics](exercises/12-herdr-basics.md) — [herdr.dev](https://herdr.dev/) workspaces, panes, detach/reattach
13. [Herdr CLI](exercises/13-herdr-cli.md) — automate panes/agents over the socket API

Pick any exercise; they are mostly independent after the first two.

## Tips

- Prefer reading man pages: `man <command>` or `tldr <command>` if installed.
- Use `history` and reverse search (`Ctrl+R`) while you practice.
- Reset playground sample data anytime:

```bash
./scripts/reset-playground.sh
```

## License

MIT
