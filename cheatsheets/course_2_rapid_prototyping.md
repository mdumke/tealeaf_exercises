# Rapid Prototyping with Ruby on Rails

tealeaf academy

cheatsheet

## pre-course

### relational databases

- find the text at http://archive.oreilly.com/pub/a/ruby/excerpts/ruby-learning-rails/intro-ruby-relational-db.html
- because Rails lets you choose a database backend, it only allows for a limited number of general types to be used within a schema, they are: `:string, :text, :integer, :float, :decimal, :datetime, :timestamp, :time, :date, :binary, ` and `:boolean`
- if you have lots of data that doesn't fit easily into relational databases (e.g. lots of hierarchical information), look for some other kind of tool
- it is possible but very inconvenient to represent many-to-many relationships with two tables, each of which would have multiple (but how many?) foreign keys; The better way to solve these problems is through a third table that just connects the ids
- when designing databases, the question of *granularity* is important: how small should our units of information be? e.g. do we want to record the first name and last name separately or together. This has to be decided in the context of the application, but in general it is easier to put smaller pieces together than to break larger ones apart.
- For combining smaller pieces Rails has a `composed_of` method
- The purpose of Active Record is to abstract from writing SQL queries by hand, but in case you need them, there is a `find_by_sql`-method
