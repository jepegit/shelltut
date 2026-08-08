# 15 — vim

Docs: `vimtutor` · `:help` · [vimhelp.org](https://vimhelp.org/)

vim is a modal editor: you spend most time in **Normal** mode moving and commanding, enter **Insert** to type text, and **Visual** to select.

## Goals

Open files, move efficiently, edit without fighting the modes, search/replace, save, and quit.

## Setup

```bash
vim --version | head -n 1
# optional guided tour (highly recommended once):
vimtutor
```

Practice on copies under `playground/scratch/` so you can reset later:

```bash
mkdir -p playground/scratch
cp playground/notes.txt playground/scratch/vim-practice.txt
cp playground/logs/app.log playground/scratch/vim-log.txt
vim playground/scratch/vim-practice.txt
```

## Modes (memorize this)

| Mode | Enter from Normal | Back to Normal |
|------|-------------------|----------------|
| Normal | (default) | `Esc` |
| Insert | `i` / `a` / `o` / `O` | `Esc` |
| Visual | `v` / `V` / `Ctrl+v` | `Esc` |
| Command-line | `:` / `/` / `?` | `Esc` or finish command |

If vim “does nothing” or beeps, you are probably not in Normal mode — press `Esc`.

## Drills — open, save, quit

1. Open the practice file, then from Normal mode:

| Action | Keys |
|--------|------|
| Save | `:w` Enter |
| Quit | `:q` Enter |
| Save and quit | `:wq` or `ZZ` |
| Quit without saving | `:q!` |
| Save as new name | `:w playground/scratch/vim-practice-copy.txt` |

2. Open two files and switch:

```bash
vim playground/scratch/vim-practice.txt playground/scratch/vim-log.txt
```

Inside vim: `:bn` / `:bp` (next/previous buffer), or `:e filename`.

## Drills — motion (Normal mode)

On `vim-practice.txt` / `vim-log.txt`, practice without inserting text yet:

| Motion | Keys |
|--------|------|
| Left / down / up / right | `h` `j` `k` `l` |
| Word forward / back | `w` / `b` |
| End of word | `e` |
| Line start / end | `0` / `^` / `$` |
| Top / bottom of file | `gg` / `G` |
| Go to line 5 | `5G` or `:5` |
| Page down / up | `Ctrl+f` / `Ctrl+b` |
| Match brace/paren | `%` |

Count multipliers: `3w`, `10j`, `2G`.

## Drills — edit

1. Insert text:
   - `i` insert before cursor, `a` after, `I` line start, `A` line end
   - `o` / `O` open line below / above

2. Delete / change / yank (copy) / put (paste):

| Action | Keys |
|--------|------|
| Delete character | `x` |
| Delete line | `dd` |
| Delete word | `dw` |
| Change word | `cw` (enters Insert) |
| Yank line | `yy` |
| Put after / before | `p` / `P` |
| Undo / redo | `u` / `Ctrl+r` |

Operators + motions: `d$` delete to end of line, `c3w` change three words, `yG` yank to end of file.

3. Visual select: `V` (line), `v` (character), then `d` / `y` / `>` (indent).

## Drills — search & replace

1. Search forward `/ERROR` then `n` / `N` for next / previous. Backward: `?WARN`.
2. Clear highlight: `:noh`
3. Substitute on the current line: `:s/ERROR/ERR/`
4. Whole file, all occurrences: `:%s/ERROR/ERR/g`
5. Confirm each: `:%s/banana/orange/gc`

Try these on `playground/scratch/vim-log.txt`.

## Drills — windows & survival kit

1. Split: `:split` or `:vsplit`, move with `Ctrl+w h/j/k/l`, close with `:q` in that window.
2. Show line numbers: `:set number` (session only). Permanent later via `~/.vimrc`.
3. Run a shell command: `:!rg ERROR playground/logs/app.log`
4. Read another file below the cursor: `:r playground/notes.txt`

## Stretch

- Finish `vimtutor` (about 30 minutes).
- Repeat last change: `.`
- Jump to last edit: `gi` / `` `. ``
- Marks: `ma` mark a, `'a` jump to it.
- Minimal `~/.vimrc`:

```vim
set nocompatible
set number
set hlsearch
set ignorecase smartcase
set incsearch
syntax on
```

- Try vim motions in the terminal: set your shell to vi-mode (`set -o vi` in bash) and edit the command line with `Esc` then `v`.

## Check yourself

You can open `playground/scratch/vim-practice.txt`, fix a typo, search for a word, save, and quit — without killing the terminal or losing track of which mode you are in.
