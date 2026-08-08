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
│   ├── docker/     # sample Dockerfile + Compose web demo
│   ├── postgres/   # Dockerized Postgres + seed SQL
│   └── ssh/        # local sshd lab for SSH/rsync drills
├── cheatsheets/    # short reference notes
├── scripts/        # helpers (reset playground, postgres, ssh-lab, …)
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
12. [Merge conflicts](exercises/21-merge-conflicts.md) — markers, merge/rebase, ours/theirs, abort (in depth)
13. [Herdr basics](exercises/12-herdr-basics.md) — [herdr.dev](https://herdr.dev/) workspaces, panes, detach/reattach
14. [Herdr CLI](exercises/13-herdr-cli.md) — automate panes/agents over the socket API
15. [GitHub CLI (`gh`)](exercises/14-gh.md) — auth, repos, issues, PRs, `gh api`
16. [vim](exercises/15-vim.md) — modes, motions, edit, search/replace
17. [API testing](exercises/16-api-testing.md) — curl, httpie/xh, jq asserts
18. [Docker](exercises/18-docker.md) — run/build/Compose, ports, volumes
19. [PostgreSQL](exercises/17-postgresql.md) — Dockerized Postgres, `psql`, SQL, `\copy`, dump/restore
20. [SSH](exercises/19-ssh.md) — keys, config, remote commands, scp/sftp (local Docker lab)
21. [rsync](exercises/20-rsync.md) — dry-run, push/pull over SSH, excludes, `--delete`

Pick any exercise; they are mostly independent after the first two.

## Tips

- Prefer reading man pages: `man <command>` or `tldr <command>` if installed.
- Use `history` and reverse search (`Ctrl+R`) while you practice.
- Reset playground sample data anytime:

```bash
./scripts/reset-playground.sh
```

Postgres practice container:

```bash
./scripts/postgres.sh up     # then: ./scripts/postgres.sh psql
./scripts/postgres.sh reset  # wipe volume + reseed
./scripts/postgres.sh down
```

SSH / rsync practice lab (sshd on port 2222):

```bash
./scripts/ssh-lab.sh up
./scripts/ssh-lab.sh ssh
./scripts/ssh-lab.sh down
```

Merge-conflict practice repo:

```bash
./scripts/merge-conflict-lab.sh setup
./scripts/merge-conflict-lab.sh conflict-merge
cd "$(./scripts/merge-conflict-lab.sh path)"
```

## License

MIT
