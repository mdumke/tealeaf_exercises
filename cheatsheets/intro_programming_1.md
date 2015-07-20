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

## Control Flow
- the case-statement can be used without an argument! Just `case` and then provide a number of conditionals in the `when`-clauses and the first matching option will be taken
- there are only two falsy values in Ruby: nil and false

## Loops and Iterators
- The simplest loop construct is `loop do...`
- all looping constructs have return values, usually either the collection they loop over or nil
- `break` and `next` work as expected
- the while-loop has a counterpart, the until-loop
- to create a do-while-loop, add a breaking-condition to a simle loop. It is not recommended to use the `begin...end while`-construct

## Arrays
- some useful array-methods would be `indlude?`, `sort`, `each_index`, `each_with_index`, `flatten`
- it might be a good idea to double-check whether or not an array-method is destructive
- to transform a range into an array, use e.g. `Array(1..3)`
