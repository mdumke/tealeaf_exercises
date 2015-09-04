# Setup cheatsheet

## How to solve the fish / tmux - issues
- tip: when changing /etc/tmux.conf, make sure all tmux-processes have stopped before you start another session, otherwise you might not see the changes
- create ~/.config/fish/config.fish if it does not exist and from here, source the rvm-scripts like so:
  `bash "$HOME/.rvm/scripts/rvm"`
- make sure the PATH-varialbe is ok, i.e. it starts with the rvm-path and there is no unnecessary repetition
- remember, the order of loading is: `~/.bash_profile` sources `~/.profile` sources `~/.bashrc`
- you need a bash-wrapper for fish which can be integrated as fish-functions, check out rvm-fish-integration and download a piece of code to put in `~/.config/fish/functions/rvm.fish`

## Testing with minitest
- in your spec, use `require 'minitest/autorun'
- from the spec, link to the code-file with `require_relative 'my_file'`
- general structure: describe-block, before-blocks, it-blocks
- matchers are `must_equal`, `wont_equal`, `must_be_instance_of`
- use a Rakefile to execute the testsuite

