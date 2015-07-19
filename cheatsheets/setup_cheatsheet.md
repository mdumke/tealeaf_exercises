# Setup cheatsheet

## How to solve the fish / tmux - issues
- tipp: when changing /etc/tmux.conf, make sure all tmux-processes have stopped before you start another session, otherwise you might not see the changes
- create ~/.config/fish/config.fish if it does not exist and from here, source the rvm-scripts like so:
  `bash "$HOME/.rvm/scripts/rvm"`
- make sure the PATH-varialbe is ok, i.e. it starts with the rvm-path and there is no unnecessary repetition
- remember, the order of loading is: `~/.bash_profile` sources `~/.profile` sources `~/.bashrc`
- you need a bash-wrapper for fish which can be integrated as fish-functions, check out rvm-fish-integration and download a piece of code to put in `~/.config/fish/functions/rvm.fish`


