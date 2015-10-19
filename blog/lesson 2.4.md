# Lesson 4 - AJAX, Simple Roles, and Miscellaneous

This last lesson of the second course introduces a handful of additional topics that are mostly unrelated to one another but that can be valuable features of many (Rails) applications. Topics include Ajax with server generated Javascript, setting up simple roles, working with slugs, using timezones, building modules and gems and a few notes on APIs.


## Ajax the Rails way

As page reloads become more expensive, exchanging only smaller parts of a website becomes more important - for the user-experience as well as for our environment. Turning link and form actions into ajax requests used to be done by unobtrusive javascript that added event-handlers to html-elements. But the new way is to use so-called 'server generated javascript'. In order to ajaxify a link, it is now sufficient to add `remote: true` to the Rails link_to helper (or the form helper respectively), which will then add `data-remote=true` as an attribute to the link or form tag, and a piece of javascript provided by rails will finally turn the corresponding requests into Ajax requests.

On the server side, the request will be processed `as JS` and a Rails controller can distinguish it from other types accordingly using the respond_to helper as in

```ruby
respond_to do |format|
  format.html # default: try to render a .html(.erb) template
  format.js   # default: try to render a .js(.erb) template
end
```

The .html and .js methods take an optional block where rendering can be specified, but in its absence Rails will try to render templates according to the standard naming conventions. Javascript templates will also be preprocessed by the erb (or haml) preprocessors if the filenames end in .erb (or .haml). This is particularly helpful as the templates now have access to instance variables or local variables passed in from the controller.

Back in the presentation layer when the ajax-response has retured it is of course necessary to replace elements on the page with new content. Therefore it is helpful if those elements are easily identifiable. A common scenario is the rendering of a collection of elements where every item gets a special name dependent on the resource, for example like this: `id="post_<%= @post.id %>"`.


## Slugging

Slugs are unique identifiers for resources. They make for nicer urls, can help an app get SEO credits and provide some additional security by hiding primary ids from the outside world. At the model layer, a slug is simply another attribute stored in the database with the rest of the object's information. The tricky part is when and how to generate them.

As slugs are typically derived from other attributes like names or titles, an object has to have a valid name or title before the slug can be generated. Therefore, a good place to put slug-creation is in the `after_validation`-callback, but the optimal place depends on business requirements, of course. For example, when it is essential that slugs never change because they should be used for bookmarking, slug-creation should happen only once right before or after the resource's creation.

Slugs are typically unique identifiers, so in cases where they depend on attributes that might not be unique, their uniqueness has to be enforced, e.g. by appending a counter. Another caveat is that an application has to ensure that every object actually has a slug, otherwise it could not be retrieved and url generation would fail. While the introduction of basic slugs is not too complecated, using a gem like *FriendlyId* might help with a number of edge-cases.

Once slugs are set up at the model layer, it is not hard to actually use them. The named route helpers have passed in objects from which they create urls, and they implicitely call `to_param` on those objects. Overwriting `to_param` on the model to return not the id but the slug switches all urls to using slugs. The controllers will now, of course, have to retrieve models by slug instead of by id, which is trivial apart from the irritating issue that the slug will still be called `:id` in the params-hash when resourceful routing is used. Slugs can also be used when generating unique html-tags to use e.g. in the context of ajax-requests, so the post-element from above might now look like this: `id="post_<%= @post.slug %>"`.


## Simple Roles

Managing roles and permissions can become very complicated, but especially clients seem to like the idea of having really fine-grained control over who can do what and when. Building a fully-fledged permissions system requires setting up users that have many roles where each role has many permissions and then for each action joining users on roles on permissions and finding out whether access should be granted. This quickly becomes slow and tedious and complicated.

A simpler approach to roles, and one that is typically sufficient for small and medium sized applications, is to have just one user model and add a role column to it specifying the user's role. Then on the model there can just be a number of instance methods like:

```ruby
def admin?
  role.to_sym == :admin
end

def moderator?
  role.to_sym == :moderator
end
```

At the controller level it is now easy to check permissions for an action using methods like `require_admin` according to a standard check for logged-in users.


## Timezones

Rails and particularly ActiveSupport::TimeZone provide a number of convenient helpers to introduce time zones into an application. The first step when working with timezones is to set the default timezone in 'application.rb'. Which timezones are available can be seen from a number of rake tasks - run `rake -D time` to find out more.

In order to keep track of the time zone for a particular user, store it as a simple string in the database. Constructing an input field to help the user select from the available timezones is simple with a new form-helper method that comes with Rails 4:

```ruby
f.time_zone_select(:time_zone, ActiveSupport::TimeZone.all, default: Time.zone.name)
```

Note that `Time.zone` will refer to the default time zone set for the application whereas simply using `Time` will be the respective system time. For this reason, refrain from using `Time.now` but always use `Time.zone.now` or `Time.current` which is a short form for that.

When displaying timezone-information, `%Z` will put the timezone into the strftime format string. To convert a time to a user's set timezone use `some_time.in_time_zone(current_user.time_zone)` but make sure there is a current user and they have a timezone set.


## Working with APIs

While APIs will be covered extensively in the third course, here are a few introductory remarks on exposing and consuming them. I also had some trouble figuring out how to use curl with Rails and I'll put my findings here.

First of all, let there be a few general words of caution. When integrating an external API into your project, make sure never to expose the API keys in a public git-repository. There are malicious bots monitoring github that will steal them. A second issue to be aware of when exposing APIs is proper versioning. Once other services start using an API it can no longer be changed without the danger of breaking other applications. In order to deal with this, provide a version number of the API and make sure older versions are still supported (if your business logic permits that).

As far as Rails is concerned, building simple APIs is as easy as using the `respond_to` helper in the controller to return JSON, XML or any other requested format depending on the request type. This could be as simple as in this example:

```ruby
respond_to do |format|
  format.html
  format.json { render json: @posts }
  format.xml { render xml: @posts }
end
```

But it can, of course, be much more complicated and include, for instance, rendering json-templates that exactly define which model-attributes or associated models to return.

A url-tool like cURL can really help with developing and exploring APIs. But things can get a bit complicated when using cURL with a Rails app, especially when authentication is involved. Say I want to access the json-data for some records at `localhost:3000/api/records.json` which requires an authenticated user. In order to query this url with cURL I would need to perform the following steps:

1. `curl localhost:3000/ -c session | ag csrf-token`. This is the first step in simulating a login procedure. The response will contain a header which has a session-cookie that curl can now store in a file I call 'session'. The response will also include html that has the authenticity-token in its header. We can grep it out and use it in the next step.

2. `curl -X POST localhost:3000/login -F username=matthias -F password=123 -F authenticity_token=abc..xyz -b session -c session`. This simulates a login by posting to the login point. Rails will first check for a valid authenticity token (which we just got) and will make sure the post has a valid session (which we also have now). The response will contain another header containing a new session-cookie which is now the cookie for a valid login-session, so we can overwrite the old 'session'-file.

3. `curl localhost:3000/api/records.json -b session`. Finally, in order to perform the originally intendet API-query, we can now simply send along a valid session when curling.


## Extracting common code to Modules

DRYing up code is an essential part of refactoring. Sometimes it makes sense to extract common code to helper methods or to create superclasses, yet at other times extracting code to modules or gems may be the most commendable option. Finding a place for new modules within the Rails architecture can be a bit tricky. One option would be to have modules under the lib-directory, in which case we have to make sure that they are loaded when the app starts, so we want to extend the autoload paths in application.rb with

```ruby
config.autoload_paths += %W(#{config.root}/lib)
```

Extracting instance methods is as simple as putting them inside a new module (remember that module names end in 'able' by convention) and including the module in the relevant classes. But modules can do more. They can define class methods and they can execute code once at the moment the module gets included. While this originally required some meta-programming, ActiveSupport::Concern abstracts this away. To give an example, we can extract the code necessary to establish a polymorphic association with a 'Vote'-class to a module:

```ruby
module Voteable
  extend ActiveSupport::Concern

  # this will be executed when the module gets included
  included do
    has_many :votes, as: :voteable
  end

  # this will be an instance method
  def total_votes
    up_votes - down_votes
  end

  # the methods defined here will be class methods
  module ClassMethods
    def my_class_method
    end
  end
end
```

The block passed to 'included' will call the classes' `has_many`-method once when the module is included to establish the association with the vote.

Including the Voteable-module will add the specified behavior, but this is fixed in advanced an cannot be customized by the model including the module. Yet there are circumstances where we'd like to pass in configurations to the module. In these cases, we need to add a bit of metaprogramming. A common pattern that is used extensively in Rails is to pass in variables to the class methods that are used by the module to set the values of class_attributes. To demonstrate this pattern, in the following example I will add the ability to walk to different models and specify the number of legs for each class:

```ruby
module Walkable
  extend ActiveSupport::Concern

  included do
    # define the class attribute immediately
    class_attribute :legs
  end

  module ClassMethods
    # this allows the class using the module to set the number of legs
    def number_of_legs(legs)
      self.legs = legs
    end
  end

  # finally even instance methods can have access to the class attribute
  def how_many_legs_do_you_have
    puts "#{self.class.legs}"
  end
end

class Cat
  include Walkable
  number_of_legs 4
end

class Human
  include Walkable
  number_of_legs 2
end
```


Notice how the module gives access to the class_attribute at the instance-level. In the context of Rails, we might use a pattern like this to extract slugging to a module and specify the column to base a slug in each class that includes the module.


## Building Gems

Reusing code accross projects is best done with gems. In order to create a gem, set up a dedicated repository that includes a lib-subirectory for the source code and a spec-subdirectory for testing. It should also contain a .gemspec file that has metadata about the gem. A helpful guide for how to build a gem can be found on rubygems.org, so here are just some basics.

Once the code is written, and the tests pass, specify a version and a name in the specfile and from the root directory run `gem build my_gem.gemspec`. The build command comes with the gems-gem itself, its output will be a single file that has a version number appended to it and that will reside in the root folder. Now there are two ways to include this gem in a Rails project.

1. **Publish the gem** To do so, you will need to sign up for a free account on rubygems.org. After that, make sure the name you chose for the gem has not already been taken. Check this with `gem list -r my_gem_name`. If all is clear, install a gem called 'gemcutter' that can help with publishing (and removing) gems. With gemcutter installed, execute `gem push my_gem_0.0.0.gem`. Gems can be removed via `gem yank my_gem -v '0.0.0'`. With the gem published, it can now be included in the Rails project's gemfile.

2. **Hotwire the gem from its directory** While in development, it is rather tedious to update and publish the gem every time something changes. In this case, it is possible to specify the absolute path of the gem's directory on your machine and have it hotwired to your application (meaning there is no need to bundle and restart the app when the gem changes). In the Gemfile, simply say `gem 'my_gem', path: '/absolute/path/to/gem'`.

In case the gem defines a file that needs to be explicitely included, that is best done in application.rb. Simply add `require 'my_gem'` under `require 'rails/all'`.


## 2-factor authentication with Twilio

Some applications add addidtional layer of security by having a user type in a pin that gets send to their telephone before login is complete. This means that in order to use 2-factor-authentication, we need to add a phone (string) and a pin field to the user-data. When login is successful, a random (but unique) pin gets generated and sent via Twilio (easy to use API but, of course, costs something). The user is then redirected to a page where they can enter their pin. This page should not be accessible for users that are not in 'limbo'. After successfully entering the number, the user gets logged in and the pin is deleted. An appropriate method on the sessions controller to take care of that may look like this:

```ruby
def pin
  access_denied if session[:two_factor].nil?

  if request.post? # GET will just render the template
    user = User.find_by_pin(params[:pin])

    if user
      user.remove_pin!
      session[:two_factor] = nil
      login_user!(user)
    else
      flash['error'] = 'Something is wrong with your pin'
      redirect_to pin_path
    end
  end
end
```


## Fun Facts and Best Practices

- adding pagination is not too complicated. You need 1. the ActiveRecord methods `limit` and `offset`, 2. a way of determining which page to fetch (often done via query parameters), and 3. specify links that have proper query parameters
- you can define aliases for a model's attributes via `alias_attribute :home, :address` (provided by ActiveSupport)
- the difference between including and extending a module is that the first will create instance methods and the second will create class methods in the class that includes the module
- be careful in production when performing operations that touch all the data in a table, it might take really long or hinder execution of other processes
- Rails provides the two variables `request` and `response` that can be read from and written to. The controller's render-method for example changes the MIME-type and body of the response
- different database systems return data in different formats (e.g. SQLite3 returns arrays, postgres returns ARELs, but the respective Rails database adapters take care of these differences)
- note that after creating a resource in a controller, we want to perform a redirect because otherwise a page-refresh would create the resource a second time
- the *flash* is just a piece of the session that Rails conveniently clears after each request
- finally, and as guidance for next steps, here are some recommendations of helpful books:
  - basic
    - Eloquent Ruby (!) (by Russ Olsen)
    - Everyday Testing with RSpec
  - intermediate
    - Rspec Book (pragmatic programmers)
  - advanced
    - POODR by Sandy Metz
    - Design Patterns in Ruby by Russ Olsen
