# Introduction to Programming with Ruby

cheatsheet

tealeaf academy

## Preparations
- use pry for debugging with: `require 'pry'` and `binding.pry`
- pry will open a repl, where you can check and manipulate variables in the current environment

## The Basics
- symbols, `:some_sym`, are used when something is neither intended to be *printed* to the screen nor *changed*
- print to STDOUT with `$stdout.puts stuff` (or just `puts stuff`) and to STDERR with `$stderr.puts error`
- type-conversion `'123.4'.to_i` will convert all trailing ciphers to an integer
- the new hash-syntax as of Ruby 1.9.3 (?) is `key: value`, not `:key => value`

## Variables
- be aware of the different variable types
1. CONSTANT
2. $global_var
3. @@class_var
4. @instance_var
5. local_var


