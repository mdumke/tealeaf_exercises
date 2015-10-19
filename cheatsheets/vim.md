# vim cheatsheet

From the vim-tutorial book

## Basic Editing

- `i` will enter insertion-mode
- `ESC` will exit any current special mode
- `h`, `j`, `k`, `l` are for basic navigation
- toggle line wrapping with `:set wrap` and `set nowrap`
- `x` will delete the current letter
- use `u` for undo and `CTRL-r` for redo
- `ZZ` saves and exist
- `:w` simply saves, `:q` quits if there are no changes, and `:q!` quits anyway
- `U` undoes all changes that have been made to a particular *line*, but just while working on it
- `a` inserts *after* the cursor, in particular at the end of a line
- on unix, vim will be started in vi-compatible mode unless a `~/.vimrc` exists or it is explicitely turned off using `:set nocompatible`
- `dd` will delete the current line (and copy it to the clipboard)
- `o` will open up a new line *below* the curser, and `O` will open one *above* it
- any command can be repeated by prefixing it with a number, e.g. `2dd` will delete two lines
- there is a lot of help available, to start off, use `:help`

## Editing a little faster

- `w` moves the cursor forward one word
- `b` moves back one word
- `$` is one command that moves to the end of a line, multiples, like `2$` move down multiple lines
- `0` goes to the beginning of a line
- `^` goes to the first character in the line
- `fx` searches the current line for the next 'x' to the right
- `tx` is the same but stops 1 character before the goal
- `Fx` searches the current line for the next 'x' to the left
- `Tx` is the same but stops 1 character before the goal
- `3G` goes to line 3, just as `:3` does
- use `:set number` and `:set nonumber` to switch between displaying line number
- `CTRL-g, CTRL-g` (twice) can give a status line for where you are in a file
- `CTRL-u` and `CTRL-d` scroll half a page up and down, respectively
- `d<motion>` deleted everything the motion specifies, left or right or multiple lines or a word, as with `dw` 
- `D` is a shortcut for deleting to the end of a line


## Other stuff

- to set the syntax highlighting for, e.g. markdown, use `:set syntax=markdown`
