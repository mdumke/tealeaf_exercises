# building and running a command line program

- to run a program from the command name as in `./my_program.rb`, simpley put the #! at the beginning of the file to specify the interpreter, e.g. `#! /home/tias/.rvm/rubies/ruby-2.1.5/bin/ruby`
- make sure you have the appropriate rights to run it
- if you add the current directory to your path, you can execute the program without the leading `./`. In bash say `PATH=/my/current/path:$PATH`, in fish this would be `set PATH /my/current/path $PATH`
- but note that rvm is going to complain if the rvm-path is not first in the path-variable, so you might want to append the pwd to the path instead of prepending it
- also note that you have to stop all tmux processes when changing the PATH in the source files
- there is a yaml-library in core Ruby for reading yaml-files in ruby, load it via `require 'yaml'` and access files via `YAML.load_file('path/to/file')` which will return a nested hash
- it may be convenient to make a hidden directory for your program and have the config in there
- if you have to navigate through folders in different operating systems, use the `File::SEPARATOR` in your script
