# rsync cheatsheet

## Mental model

```bash
rsync [options] SRC DEST
```

Trailing slash: `src/` copies *contents*; `src` copies the directory itself.

## Common options

| Flag | Meaning |
|------|---------|
| `-a` | archive (recursive, preserve meta; implies `-r`) |
| `-v` | verbose |
| `-z` | compress in transit |
| `-n` / `--dry-run` | show only |
| `-i` / `--itemize-changes` | why each file differs |
| `--progress` | progress per file |
| `--exclude PATTERN` | skip matches |
| `--delete` | remove dest files not in source (**dangerous**) |
| `-e "ssh …"` | remote shell |

## Local

```bash
rsync -av src/ dst/
rsync -avn src/ dst/                 # dry run
```

## Over SSH (shelltut lab)

```bash
RSH="$(./scripts/ssh-lab.sh rsync-e)"
rsync -avn -e "$RSH" playground/data/ shelltut@127.0.0.1:/data/incoming/data/
rsync -av  -e "$RSH" playground/data/ shelltut@127.0.0.1:/data/incoming/data/
rsync -av  -e "$RSH" shelltut@127.0.0.1:/data/incoming/data/ playground/scratch/from-lab/
```

## Real host via ssh config

```bash
rsync -avz ./ mybox:~/project/
rsync -avz --exclude '.git' --exclude 'node_modules' ./ mybox:~/project/
```

## Safety

1. Start with `-avn` (dry run)
2. Read the file list before dropping `-n`
3. Be extra careful with `--delete`
