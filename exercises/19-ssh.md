# 19 — SSH

Docs: `man ssh` · `man ssh_config` · `man ssh-keygen`

SSH gives you a secure shell on another machine — and the transport under tools like `scp`, `rsync`, and `git+ssh`.

Practice against a **local Docker sshd** so you do not need a remote server. The same commands work for any real host you already use.

## Goals

Create keys, connect, use `~/.ssh/config`, copy files with `scp`/`sftp`, and run remote commands safely.

## Setup (local lab)

Needs Docker ([exercise 18](18-docker.md)).

```bash
./scripts/ssh-lab.sh up
./scripts/ssh-lab.sh info
./scripts/ssh-lab.sh ssh
# you should get a shell as user `shelltut`
```

Lab details:

| Item | Value |
|------|--------|
| Host | `127.0.0.1` |
| Port | `2222` |
| User | `shelltut` |
| Key | `playground/ssh/keys/shelltut_ed25519` (generated, gitignored) |

Stop when done: `./scripts/ssh-lab.sh down`.

## Drills — keys & first login

1. Inspect the lab key (do not commit private keys):

```bash
ls -l playground/ssh/keys/
ssh-keygen -lf playground/ssh/keys/shelltut_ed25519.pub
```

2. Connect with explicit options:

```bash
ssh -i playground/ssh/keys/shelltut_ed25519 \
  -p 2222 \
  -o IdentitiesOnly=yes \
  -o StrictHostKeyChecking=accept-new \
  -o UserKnownHostsFile=playground/ssh/known_hosts \
  shelltut@127.0.0.1
```

Or simply: `./scripts/ssh-lab.sh ssh`

3. Run a one-shot remote command (no interactive shell):

```bash
./scripts/ssh-lab.sh ssh -- uname -a
./scripts/ssh-lab.sh ssh -- 'hostname; pwd; ls -la /data'
```

## Drills — ssh_config

1. Read `playground/ssh/ssh_config.example`.
2. Connect using that file:

```bash
ssh -F playground/ssh/ssh_config.example shelltut-lab
ssh -F playground/ssh/ssh_config.example shelltut-lab 'echo hello from $(hostname)'
```

3. For real machines, put durable `Host` blocks in `~/.ssh/config`:

```sshconfig
Host mybox
  HostName example.com
  User you
  IdentityFile ~/.ssh/id_ed25519
  IdentitiesOnly yes
```

Then: `ssh mybox`.

## Drills — copy files (scp / sftp)

1. Copy a single file **to** the lab:

```bash
scp -F playground/ssh/ssh_config.example \
  playground/notes.txt \
  shelltut-lab:/data/incoming/notes.txt

./scripts/ssh-lab.sh ssh -- ls -l /data/incoming
```

2. Copy **back** to the host:

```bash
mkdir -p playground/scratch
scp -F playground/ssh/ssh_config.example \
  shelltut-lab:/data/incoming/notes.txt \
  playground/scratch/notes-from-lab.txt
```

3. Try `sftp` for interactive browsing:

```bash
sftp -F playground/ssh/ssh_config.example shelltut-lab
# inside: ls /data/incoming   get /data/incoming/notes.txt   bye
```

For everyday sync of directories, prefer [rsync](20-rsync.md).

## Drills — agent & hardening habits

1. See what the agent holds (may be empty):

```bash
ssh-add -l || true
```

2. Habits worth keeping on real hosts:

- Prefer **keys** over passwords; use a passphrase on personal keys
- Use `IdentitiesOnly yes` so SSH does not offer every key
- Pin hosts via `known_hosts` (lab uses a file under `playground/ssh/`)
- Never commit private keys or paste them into tickets/chat
- On shared jump setups, learn `ProxyJump` / `ProxyCommand` when you need them

## Stretch

- Port forward a lab service (conceptual): `ssh -L 9000:127.0.0.1:54329 mybox` on a real host that can reach Postgres
- `ProxyJump bastion` to reach an internal host through a jump box
- Compare `ssh host command` vs entering an interactive shell for scripting
- Wire this lab into Herdr/tmux: keep an SSH pane open while you rsync in another

## Check yourself

`./scripts/ssh-lab.sh ssh -- hostname` works, and you can `scp` `playground/notes.txt` into `/data/incoming/` and back out again.
