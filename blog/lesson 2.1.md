# Lesson 2.1 - Datastructures, Routing, and a few notes on Rendering

This is the starting week of course 2: Rapid Prototyping with Ruby on Rails. We begin this course at the very bottom of an application, at the database layer, and see how much more comfortable dealing with the data gets once Rails models are introduced according to the ActiveRecord pattern. While this is the major topic of the week, we also take a look at the basics of routing in Rails and finally glance at the rendering process.


## The Relational Database

When beginning to build a new application, we start from the mockups and from there begin to think about how the data that is necessary to support the app should be managed. It is typical for a Rails application to have a relational database as its backend, and this will be assumed throughout the course. The important thing to remember is that the database is not part of Rails, but that it is a completely different application. Hence all relevant information as to how different sets of data belong together, how users relate to accounts and to newsletters and how carts relate to orders has to be already encoded at the database level. In fact, it is possible to keep a database and 'simply' switch the framework. There is nothing that is particular to Rails about one-to-one, one-to-many or many-to-many associations.

When creating an application, we draw an entity-relationship-diagram (ERD) and setup the structure of the database. At this point, we can extract all the information via SQL.

Just a quick aside because I'm glad I finally understood how outer joins work. Start with inner joins. Here we build a cross-product of the tables to join and eliminate all rows for which the join condition is met. As a result, some rows of the tables might not make it into the final result because there are no matching keys. If you still want to make sure every row of the first table is included, even when unmatched fields are just filled with NULL, use a left join. For the second table, a right outer join. For both tables, a full join. All these are so called outer joins.

Setting up the database is not done manually, but by Rails. This can happen via migrations that create and change tables and columns. And it can also happen with the help of the schema.rb-file. This file has the authoritative current schema of the database, so if there is for instance a test-database to setup, Rails will not run all the migrations, but simply use schema.rb to do the setup.


## Introducing Active Record

As was mentioned, Rails uses the ActiveRecord as its 'object-relational-mapper' (ORM) pattern. This pattern is not original to Rails. It is a general pattern according to which rows in database-tables are mapped to in-memory-objects, and columns in a table are mapped to attributes of these objects. The value for the name column of the first row maps to the name attribute of a certain object, etc. By declaring models that inherit from ActiveRecord::Base this mapping is already fully functional.

While relations among data are established via foreign keys and join tables at the database level, Rails only knows of these relations when explicitely told. There are six associations that Rails supports: `belongs_to`, `has_one`, `has_many`, `has_many :through`, `has_one :through`, and `has_and_belongs_to_many`. I will not discuss them all here, just make a few remarks.

First of all, if an object 'belongs to' another object, it has to have a foreign key for this object. There are conventional names for how to name foreign keys, but Rails can be told to use custom ones like so:

    belongs_to :creator, foreign_key: 'user_id', class_name: 'User'

or

    has_many :subscribers, through :subscriptions, source: :user

Secondly, there are no many-to-many-associations without join tables. In this respect, `has_many :through` (hmt) and `has_and_belongs_to_many` (habtm) are similar. The difference between them is that the hmt-association requires the join table to have its own model on which validations can be run and which might hold more information that just the two ids that link the models. It is recommended to always use this type of M:M-association because when requirements for a project change, it might be necessary to store information at the join-level. As a simple example, think of a many-to-many associations between users and newsletters. They might be linked through subscriptions. And it might at one point be useful to keep track of the kind of subscription, or when it started.

Specifying associations at the Rails model level also has the advantage that Rails adds methods for conveniently creating and retrieving objects that belong together. For example, say we've specified a user who has many posts as follows:

```ruby
class User < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :user
end
```


Now we have access to multiple methods both on the post and on the user side such as

```ruby
User.first.posts                    # to retrieve all associated posts
User.first.posts.build              # to setup, but not save, a new associated post object
User.first.post_ids                 # to get a list of, well, the associated post_ids
User.first.posts = [post1, post2]   # to assign an array of posts
User.first.posts.delete(some_post)  # to revoke an association (but not delete the post)
User.first.posts << some_post       # to add another post
```

The list goes on. This way, Rails adds a layer on top of the underlying database for conveniently manipulating data. It cannot do anything you couldn't do with raw SQL, but it can make things much, much more convenient. This might actually result in a pretty complex application for working with data, say, from the console. So far, there is no controller and no routing involved and hence there's no way yet to get to this data from the outside.


## The router as the porter

Say you have this request to make to this big organization. They inhabit this huge building, many floors, with so many rooms. How do you find your way around? You ask the porter, of course. Show her your request, she reads (parses) it, and she will tell you a floor and a room you have to go to. This is exactly the job the router does for you and your http-requests in a Rails application. It determines which controller and which action is responsible for handling a request. Additionally, it will extract any variable parts (think ':id') and query parameters and put them in the params-hash.

There are many, many ways to setup routes, there are modules and concerns and namespaces, custom routes can be created by matching wildcards or reserved symbols like `:controller` and `:action`. However, in applications where actions are RESTful, routes can be generated automatically via *resourceful routing*. These routes can be set up for models that have multiple entities like

    resources :images, except: [:destroy]

or for resources that exist only once, e.g.

    resource :account

This will generate routes for the basic CRUD actions. Needless to say that they can easily be nested. The `except` and `only` keys can be specified to restrict the creation of routes. This may not seem too important at first, but think about it. The routes define your application's endpoints that can be accessed by the outside world. They are like the different doors through which you can enter a building. If you don't want anybody to use a certain door, what's more effective than - not building the door.

The Rails helpers also provide named routes, which are methods that return the correct routes. They are the way to go when building links and outputting urls. Never never ever hardcode an internal url in your application. Imagine you have to switch to the https-protocol at one point. That's not so terrible when all your paths are created by these helper methods.


## A few words about layouts and rendering

The one big thing I've learned this week about layouts is that there is a different layout supposed to exist for every controller. Rails will try to find these layouts in the respective view subfolders. If you can do with an overall layout, use one at the application level. In addition, it is fairly easy to specify which layout to render for which controller in case you want to deviate from the defaults. This can be specified for each action, or on top of the controller for the whole controller or just a subset of actions, or at the application controller level. It is even possible to specify the layout at runtime:

```ruby
class MoviesController < ApplicationController
  layout :current_layout

  private

  def current_layout
    ['layoutA', 'layoutB', 'layoutC'].sample
  end
end
```

Layouts provide the common structure into which the different views are inserted. According to the basic mechanism, the layout will `yield` and the view will be inserted at this position. But notice that this can take arguments to insert parts of the view in special places, say the head or a sidebar.

Another way to insert views into one another is by using partials. These are named with a leading underscore but referred to without it. They can be inserted via a simple call to render with an appropriate path as argument. Partials can also be inserted while rendering collections, which is particularly helpful because a spacer_template can be inserted between them. A call might look like so:

```ruby
= render partial: 'my_impartial_partial', collection: @items, spacer_template: 'simple_rule'
```

This will not only render the '_my_impartial_partial'-partial as many times as there are items in the collection passed, but it will also provide the corresponding @item as a local variable named after the template, in this case `my_impartial_partial`.


## Fun Facts and Best Practices

I will end with a collection of some quick ideas and things that I found helpful:

- Bundler is a gem that manages rubies and gems. It provides a sandbox for each rails project and loads the corresponding gems into it. Use `bundle exec` to be sure to use these gems instead of the system versions
- In development, `localhost:3000/rails/info` will have a convenient list of available routes
- The last result that was generated in the console is stored in `_`. Use `x = _` to assign it to x if you feel like it. This can be very helpful and I'm using it on a daily basis now.
- When a view file is named `index.html.erb` the middle part determines the filetype, and the last part determines which templating engine will be invoked to compile it
- Hey, gemsets are actually easy to use. Take a look at `rvm gemset list`
- When defining associations, considers using `inverse_of`, which will allow for memory-optimizations
- Associations also take scopes!
