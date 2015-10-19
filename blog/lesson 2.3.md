# Lesson 3 - Authentication and Polymorphic Associations

The third week continues the previous narrative of manipulating data through a user interface. We now add another layer of complexity in that we don't want just anybody to perform any action. Instead, authentication is introduced in order to restrict access to controller actions and hide information in views. Two other topics that are addressed are polymorphic associations, an extension of the first week's discussion of data structures, and the Rails asset pipeline.


## Authentication from Scratch

While there are a number of gems that help with the authentication process, most of them, like e.g. Device, are heavy-weight and provide a lot of functionality that is not needed for a simple authentication mechanism. If all we want to do is check whether a user has a valid password that allows them to perform certain actions we might as well use Rails' built in authentication mechanism which is backed by the `bcrypt` gem. Authentication affects every part of the MVC structure and we go through them layer by layer.

### The database and model layer

Adding authentication to a model is as easy as adding `has_secure_password` to the class definition. Rails will now expect that the database table for this model has a column named `password_digest` of type string that can store a hashed version of the password. The bcrypt library that performs the hashing comes with a salt that is added to each password before computing the hash and thereby obsoletes the older practice of storing password_salt with each password explicitely. The has_secure_password-method will add the virtual attributes `password` and `password_confirmation` to the model as well as perform default validations like requiring the password, the password_confirmation and making sure they match. At times it may be preferable to skip the default validations and perform them manually, in order to for instance omit the confirmation and only check the password when the resource is created. This may look like the following:

```ruby
has_secure_password validations: false
validates :password, presence: true, confirmation: true, on: :create
```

Note that the `confirmation: true` part is only relevant when there is actually a password_confirmation. To enforce confirmation add a `validates :password_confirmation, presence: true` validation.

### Routing and login handling

Since HTTP is a stateless protocol we need a way of keeping track of whether a user is already authenticated or not. This is typically done via the session-cookie that Rails conveniently manages for us. The concept of a session is of central importance in this context because it makes little sense to handle login and logout actions at e.g. a users controller since this does not affect the user-resource. While a session is not itself a resource it still makes sense to have a sessions-controller that handles user login and logout, only that the routes will not be set up as resourceful routes, but rather explicitely like e.g.

```ruby
get '/login', to: 'sessions#new'
post '/login', to: 'sessions#create'
get '/logout', to: 'sessions#destroy'
```

This will also generate the named routes `login` and `logout`. As an aside: we can get an aptly named route for registering in the same manner: `get '/register', to: 'users#new'` and in turn remove the new route from the users resource. As another aside: note that the form that handles the login action will be a non-model backed form which means we have to manually handle login-errors in the form. In the view-template, this may look something like `text_field_tag :username, params[:username] || ''`.

To perform user authentication, we can refer to the `authenticate`-method that `has_secure_password` also provides. It takes a potential password and checks it against the hash, returning either false or the successfully authenticated model. After a successful login, we can now store the user id in the session (e.g. `session[:user_id] = user.id`) and redirect. Logging out now simply means removing the user_id from the session. Here's the code for a simple create action on the sessions controller:

```ruby
def create
  user = User.find_by_name(params[:name])

  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect_to root_path
  else
    render 'new'
  end
end
```


# Securing controller actions

Once user authentication and session login are set up, it is important to restrict access to sensitive controller actions. Two common concerns are that certain actions should only be performed by users that are logged in and certain other actions should only be performed by users that own a resource. In both cases, restricting access is usually implemented in a before_action hook. As an example, we might want to only allow logged in users to vote on a post, so in the respective controller (e.g. posts or votes), we can specify `before_action :require_user, only: [:vote]`. Or as another example, if we only want to allow users that wrote a post to edit it, we could put `before_action :require_same_user, only: [:edit, :update]` at the top of the posts controller. How the require_same_user method looks depends on the context and how the user is determined, in the user controller where we've already setup a @user instance variable it might look like this:

```ruby
def require_same_user
  if current_user != @user
    flash['error'] = 'You are not allow to do that'
    redirect_to root_path
  end
end
```


The `require_user`-method on the other hand is so common that it is typically implemented in the Application Controller together with other helper methods. A common Application Controller for this simple tracking might look like this:

```ruby
class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    # memoization
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def require_user
    redirect_to root_path unless logged_in?
  end
end
```


The `helper_method`-call in the application controller makes the methods provided as symbols available in the views, which will be important in the next step, at the presentation layer. Note also another important technique, memoization, that is used to limit querying the database within a single request.

### The presentation layer

Since some users are not allowed to perform certain actions or even see certain information, the views have to be adapted accordingly. This is simple using the logged_in? or current_user helper methods exposed in the application controller. All that remains to do is show or hide view-content depending on whether or not a user is logged in (or fulfills other requirements we might want to add).


## Polymorphic Associations

Polymorphic Associations are an addendum to the first week's discussion on Active Record and database schemas because they are a special way of setting up 1:M associations. Simply put, polymorphic associations are associations where a resource can belong to not just one other type of resource but multiple other types. For a better understanding, it is helpful to distinguish between a subject and an object side of an association. A comment may be made *by* a user (so the user would be subject) but it can be *on* something, and potentially on different things (movies, posts, articles, the wheather, ...). Polymorphic associations can have different types of resources *on the object side*.

The problem with setting up these kinds of associations in the classic has-many way is that we would need a foreign key on the resource for every type of associated resource. Given that you could for example like one hundred different types of things, the likes-table would have one hundred columns holding e.g. `picture_id`, `movie_id`, `post_id`, etc. Moreover, the resulting matrix would be very sparse because the association could only be with one of these resouces. A table might hence look like this:

    id  user_id photo_id  video_id  post_id
    1     4                           12
    2     7        3
    3     2                   6

In order to condense this it is possible to keep all the foreign keys in one column and have an additional column that specifies the type of resource the id belongs to. This yields a so called *composite foreign key* that has two parts, the type and an id. Rails, of course, has some conventions for setting up these foreign keys:

1. the name of the associated resource should end in -able (e.g. voteable, likeable, commentable, etc.)
2. the foreign key columns have to end in '_type' and '_id' respectively (like voteable_type, voteable_id)
3. the type column is of type string and contains the model name of the associated resource

With these conventions in place, the above example table can be reduced to this one:

    id  user_id  likeable_type   likeable_id
    1      4       Video           12
    2      7       Post            3
    3      2       Photo           6


At the Active Record layer, there are some conventions for setting up polymorphic associations as well. On the belongs_to side, we don't specify each associated model but only the general name, e.g. `belongs_to :voteable, polymorphic: true`. On the many side, we can pick a name for the association like `has_many :votes, as: :voteable` or `has_many :comments, as: :commentable`. Note that it is also possible to have hmt-associations based on polymorphic associations:

```ruby
has_many :votes, as: :voteable
has_many :voters, through: :votes, source: :user
```

A note on routing. If we set up a polymorphic association like votes, we might want to create a votes-controller, pass in the associated type of resource and handle voting at this one place. The downside of this (besides having to pass in which type of resouce we're dealing with) would be that votes would become another top-level route. As an alternative, the resources themselves could handle the voting (or liking or commenting). In this case, it would make sense to extend the resourceful routes for the resources to handle a new vote action. The way routes are set up in Rails, there are ways to extend the index-route as well as the routes for each single resouce (which we would want in this case). The syntax for this is as follows:

```ruby
resources :posts do
  member do
    post :vote # this will add POST /posts/:id/vote
  end

  collection do
    get :archive # this would add GET /posts/archive
  end
end
```


## The Rails Asset Pipeline

Before Rails introduced the asset pipeline, it was necessary to manually minify and obfuscate Javascript and CSS files, combine them into a single file and manage caching for them. There are a number of tools to automate this process, and one of them, sprockets, has found its way into standard Rails and is now the default asset managing tool. In order for sprockets to know which files to process, it uses manifest files with the somewhat weird `//= require`-syntax.

To manually compile assets there is a rake task: `rake assets:precompile`. This will take the specified files, which can be under app/assets or lib/assets, process them and put them as a big javascript and a big css file under public/assets. The compiled files will have a large hash-number appended to their names. This is a *cache-buster*: it changes with each processing and browsers will now know to download the new version.

There are two general strategies for when to perform the processing. One is to have assets automatically compiled on deployment. This is convenient and clean but may take a while depending on the amount of assets to process. Another is to run the compilation manually and after deployment copy the finished files into public/assets. Which method is more adequate depends on the context of the project.


## Fun Facts and Best Practices

- To render a flash within the same request, e.g. when a controller just renders a template, use `flash.now['notice'] = ...`
- Including icons with bootstrap is simple: `<i class='icon-pencil'></i>`
- if you want to write custom validators, put them in app/validators
- to redirect users back to wherever they came from use `redirect_to :back`, also note that a redirect is not just calling another controller but is an actual 302 redirect that the browser will perform
- adding parameters to named routes is easy: `link_to user_path(user, additional: 'argument', something: :else, truth: false)`
- Rails has a piece of javascript (in jquery_ujs) that can turn a link into a form and make it a post, so in the Ruby code, we can simply say `link_to 'here', '#', method: 'post'`
- to validate that a user cannot vote more than once on one *particular* voteable, use the `validates_uniqueness_of`-validator and pass it a scope like so: `validates_uniqueness_of :creator, scope: :voteable` or `validates_uniqueness_of :creator, scope: [:voteable_type, :voteable_id]`
- heroku has a number of helpful tools to help with inspection and debugging. Check out `heroku help`, `heroku rename`, `heroku run console` and `heroku restart`.
