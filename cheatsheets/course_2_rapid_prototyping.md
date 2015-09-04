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


### Introduction to SQL

- find the resources at http://sqlbolt.com/

#### SQL Lesson 1: SELECT queries 101

- simplest query: `SELECT col1, col2 FROM my_items;`
- get the complete dump with `SELECT * FROM my_items;`

#### SQL Lesson 2: Queries with constraints (Pt. 1)

- conditions can be specified using WHERE and will be applied to every row in a table to check if it should be included in the result
- use multiple conditions like so: `SELECT col1, col2 FROM mytable WHERE condition1 AND / OR condition2 ... `
- common conditionals are
- `=, !=, < <=, >, >=` (numerical operators)
- `col_name BETWEEN 1.5 AND 10.5` (number in a range)
- `col_name NOT BETWEEN 1 AND 10`
- `col_name IN (2, 4, 6)` (element exists in a list)
- `col_name NOT IN (2, 4, 6)`

#### SQL Lesson 3: Queries with constraints (Pt. 2)

- when working with text-data, use `=` and `!=` or `<>` for *case sensitive* and *exact* string comparisons
- use `LIKE` and `NOT LIKE` for *case insensitive* yet still *exact* comparisons
- in combination with `LIKE` and `NOT LIKE` it is possible to use wildcars, namely `%` to match zero or more characters (e.g. `col_name LIKE "%AT%"`) and `_` to match a single character (e.g. `col_name LIKE "AN_"`)
- all strings must be in quotes, but remember that postgres uses single quotes
- to perform efficient full-text search, don't use plain SQL but use libraries like *Apache Lucene* or *Sphinx*. 

#### SQL Lesson 4: Filtering and sorting Query results

- to remove all duplicates from a query result, use `SELECT DISTINCT col1, col2, ...`
- results can be ordered via `select ... from ... where ... ORDER BY colx ASC / DESC;`
- to restrict the number of results, use limit to specify the number to return and offset to specify where to begin: `SELECT ... LIMIT num_limit OFFSET num_offset;`
- limiting usually happens at the end of the query

#### SQL Lesson 6: Multi-table queries with JOINs

- the process of breaking large datasets into smaller parts (tables) is called normalization
- to recombine tables and search across them, use joins
- in many SQL-implementations inner joins are just called joins
- when performing inner joins a cross product of the tables is generated and the rows that fulfill the `on` condition are selected
- schematic usage: `SELECT ... FROM my_table INNER JOIN another_table ORDER BY ...`

#### SQL Lesson 7: OUTER JOINs

- in a `LEFT JOIN` all rows from the first table will be kept, even if there are no matching rows in the second
- a `RIGHT JOIN` keeps all the rows from the second table regardless
- a `FULL JOIN` keeps all rows event if there are no matching rows in the other tables
- missing values will be filled in with NULL-values, so we will likely have to deal with those

#### SQL Lesson 8: A short note on NULLs

- NULL values are annoying because we have to specifically deal with them, so try to use sensible default-values if possible
- note that it is not always possible to avoid NULLs, e.g. when doing outer joins
- to handle those cases, use `WHERE colname IS / IS NOT NULL`

#### SQL Lesson 9: Queries with expressions



