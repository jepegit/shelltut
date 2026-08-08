# vim cheatsheet

Run `vimtutor` once. In vim, `:help topic` (e.g. `:help motion`).

## Modes

| Mode | Enter | Leave |
|------|-------|-------|
| Normal | default | — |
| Insert | `i` `a` `I` `A` `o` `O` | `Esc` |
| Visual | `v` `V` `Ctrl+v` | `Esc` |
| Command | `:` `/` `?` | `Esc` / Enter |

Stuck? Mash `Esc`.

## Leave

| Action | Command |
|--------|---------|
| Save | `:w` |
| Quit | `:q` |
| Save + quit | `:wq` / `ZZ` |
| Quit discarding | `:q!` |
| Save as | `:w path` |

## Motions

| Keys | Move |
|------|------|
| `h j k l` | left down up right |
| `w b e` | word forward / back / end |
| `0 ^ $` | line start / first non-blank / end |
| `gg G` | file start / end |
| `nG` / `:n` | line n |
| `%` | matching bracket |
| `Ctrl+f` `Ctrl+b` | page down / up |

## Edit

| Keys | Action |
|------|--------|
| `x` | delete char |
| `dd` / `dw` / `d$` | delete line / word / to EOL |
| `cc` / `cw` | change line / word |
| `yy` / `yw` | yank line / word |
| `p` / `P` | put after / before |
| `u` / `Ctrl+r` | undo / redo |
| `.` | repeat last change |
| `>>` `<<` | indent / outdent line |

Pattern: **operator + motion** (`d`, `c`, `y` + `w`, `$`, `G`, …).

## Search & substitute

| Keys / command | Action |
|----------------|--------|
| `/pat` `?pat` | search forward / back |
| `n` `N` | next / previous match |
| `:noh` | clear highlight |
| `:s/a/b/` | replace once on line |
| `:%s/a/b/g` | replace all in file |
| `:%s/a/b/gc` | replace with confirm |

## Windows & files

| Command | Action |
|---------|--------|
| `:e file` | edit file |
| `:bn` `:bp` | next / prev buffer |
| `:split` `:vsplit` | split |
| `Ctrl+w h/j/k/l` | move window focus |
| `:!cmd` | run shell command |
| `:r file` | read file into buffer |

## Tiny vimrc starter

```vim
set nocompatible
set number relativenumber
set hlsearch incsearch
set ignorecase smartcase
syntax on
filetype plugin indent on
```
