# Introduction to Programming with Ruby, part II

cheatsheet

tealeaf academy

## The Object Model
- create new classes via `class MyClass; end`
- to write a module with reusable code, use `module MyModule; end`
- include a module in a class via a simple `include MyModule` (note that you might have to require the relevant file)
- the module has to be defined before it can be included
- instantiate new objects via `SuperMario.new`

## Classes and Objects I
- on initialization, the class method `new` will try to call the instance method `initialize` wich is called a *constructor*
- instance variables have the form `@my_instance_var`
- the initialize-method can take arguments that are passed from a call to new
- instance methods are accessed with dot-notation
- do not reference instance variables directly within an instance, it is better to go with accessor methods (`attr_accessor :name, :age`, `attr_reader :mind`, `attr_writer :mood`)
- accessor-methods will be provided in the form of `#name` and `#name=` (for which `#name =` is syntactic sugar)
- in order to disambiguate calls to setters from variable declarations, use self, as in `self.mood = "happy"`
