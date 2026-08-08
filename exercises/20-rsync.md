# 20 — rsync

Docs: `man rsync` · often used over SSH (`man ssh`)

`rsync` copies files efficiently — it transfers only what changed. Over SSH it is the usual tool for syncing project trees to a server or bringing results back.

Use the [SSH lab](19-ssh.md) as the remote side.

## Goals

Dry-run syncs, push/pull over SSH, excludes, and safe use of `--delete`.

## Setup

```bash
./scripts/ssh-lab.sh up
command -v rsync
rsync --version | head -n 1
```

Helper for the lab SSH transport:

```bash
RSH="$(./scripts/ssh-lab.sh rsync-e)"
echo "$RSH"
```

## Drills — local rsync first

1. Sync a directory to another local path:

```bash
mkdir -p playground/scratch/rsync-src playground/scratch/rsync-dst
cp playground/notes.txt playground/data/people.csv playground/scratch/rsync-src/
rsync -av playground/scratch/rsync-src/ playground/scratch/rsync-dst/
ls -la playground/scratch/rsync-dst/
```

Trailing slash matters:

| Source | Meaning |
|--------|---------|
| `src/` | copy *contents* of `src` into destination |
| `src` | copy the directory `src` itself into destination |

2. Change a file and re-run — rsync should skip unchanged files (watch `-v` output).

## Drills — dry run over SSH

1. Push playground data to the lab (dry run first):

```bash
RSH="$(./scripts/ssh-lab.sh rsync-e)"
rsync -avn -e "$RSH" \
  playground/data/ \
  shelltut@127.0.0.1:/data/incoming/data/
```

`-n` / `--dry-run` = show what would happen without writing.

2. Do it for real:

```bash
rsync -av -e "$RSH" \
  playground/data/ \
  shelltut@127.0.0.1:/data/incoming/data/

./scripts/ssh-lab.sh ssh -- find /data/incoming -type f | sort
```

3. Pull back into scratch:

```bash
mkdir -p playground/scratch/from-lab
rsync -av -e "$RSH" \
  shelltut@127.0.0.1:/data/incoming/data/ \
  playground/scratch/from-lab/
```

## Drills — useful flags

1. Compress over the network (more helpful on slow links than localhost):

```bash
rsync -avz -e "$RSH" playground/logs/ shelltut@127.0.0.1:/data/incoming/logs/
```

2. Exclude junk:

```bash
rsync -av -e "$RSH" \
  --exclude '.git/' \
  --exclude '*.tmp' \
  --exclude 'scratch/' \
  ./ playground/scratch/rsync-tree-demo/
# local only demo; same flags work remotely
```

3. Show progress on a larger tree:

```bash
rsync -av --progress -e "$RSH" \
  playground/ \
  shelltut@127.0.0.1:/data/incoming/playground-copy/
```

4. Itemize changes (why did it copy?):

```bash
rsync -ain -e "$RSH" \
  playground/notes.txt \
  shelltut@127.0.0.1:/data/incoming/notes.txt
```

## Drills — `--delete` (careful)

`--delete` makes the destination match the source by **removing** extra files on the destination.

1. Always dry-run first:

```bash
# create an extra remote file
./scripts/ssh-lab.sh ssh -- 'echo orphan > /data/incoming/data/ORPHAN.txt'

rsync -avn --delete -e "$RSH" \
  playground/data/ \
  shelltut@127.0.0.1:/data/incoming/data/
# look for "deleting ORPHAN.txt"
```

2. Only run without `-n` when the delete list looks right.

Rule of thumb: **`-avn` first**, especially with `--delete`.

## Stretch

- `--partial` / `--append-verify` for large interrupted transfers
- `--bwlimit=5000` to cap bandwidth (KB/s)
- Sync over an `~/.ssh/config` Host alias once you use real machines: `rsync -av ./ mybox:~/proj/`
- Compare to `scp -r` (simpler, usually slower/less controllable)
- Backup pattern: `rsync -a --delete --backup --backup-dir=../backup-$(date +%F) src/ dst/`

## Check yourself

You can dry-run a push to the lab, sync `playground/data/` for real, pull it back to `playground/scratch/from-lab/`, and explain why trailing slashes matter.
