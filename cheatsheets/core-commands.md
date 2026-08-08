# Core command cheatsheet

## Navigation

| Command | Purpose |
|--------|---------|
| `pwd` | print working directory |
| `cd path` | change directory |
| `cd -` | previous directory |
| `ls -la` | list all, long format |
| `tree` | directory tree (if installed) |

## Files

| Command | Purpose |
|--------|---------|
| `mkdir -p a/b` | create nested dirs |
| `touch f` | create empty file / update mtime |
| `cp -r src dst` | copy |
| `mv src dst` | move/rename |
| `rm -i f` | remove with confirm |
| `rm -r dir` | remove directory tree |

## Viewing

| Command | Purpose |
|--------|---------|
| `cat f` | print file |
| `less f` | page through file |
| `head -n 20 f` | first lines |
| `tail -n 20 f` | last lines |
| `tail -f f` | follow growing file |
| `wc -l f` | line count |

## Search / find

| Command | Purpose |
|--------|---------|
| `grep -Rni pat dir` | recursive search |
| `rg pat dir` | fast search (ripgrep) |
| `find dir -name '*.log'` | find by name |
| `fd -e log dir` | find by extension (fd) |

## Pipes / redirect

| Syntax | Purpose |
|--------|---------|
| `a \| b` | pipe stdout of a into b |
| `> f` | overwrite file |
| `>> f` | append |
| `2> f` | redirect stderr |
| `&> f` | redirect both (bash) |
| `tee f` | copy stream to file and stdout |
