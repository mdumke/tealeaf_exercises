# Lesson 2 - Manipulating Data via Forms

While the first lesson was about setting up data structures at the database level and manipulating data through Active Record, the second week goes one step further and deals with manipulating data through a user interface in the browser. The path we follow leads from getting user input through forms, transferring it to the controller and moving it down to the database layer before finally giving feedback on how this whole process went and whether it was successful or not.

## Rails form helpers

Writing an HTML-Form by hand is not only tedious, it also complicated to get the *authenticity token* into it. This token is used by Rails to protect against cross site scripting attacks and is checked whenever something is posted or patched to the application. This is the reason why `protect_from_forgery` is set for the application controller. Rails form helpers make sure the authenticity token is set when needed and they also help with generating proper names, data checking and even with displaying form errors.

There are two ways of building forms with Rails form helpers. First there are *non-model backed forms*, generated with the `form_tag` helper like so:

`form_tag('path/to/send', method: 'get') do { ... }`

Non-model backed forms use helper methods that end in `_tag` like `text_field_tag` or `label_tag`. They all take a name as their first argument and will output the expected html tag. Note that it is good practice to associate input fields and labels via the label's `for`-attribute, which is set automatically by Rails if the names correspond. This will help users with screen readers and will also allow users to click the label to activate the input field. Non-model backed forms can be used to construct every form that can be constructed with pure html. And there are helpers for all the different form types. But because they are very general, they cannot rely on conventions too much and hence cannot provide a lot of additional help out of the box.

*Model backed forms* on the other hand are used for a special purpose - manipulating model-related data at the database level - and are optimized for doing just that. They are constructed by passing a model (either an new one or one that already has some attributes set) to the `form_for` helper and optionally specifying a url or html-attributes. The `form_for` function will then yield a 'form-builder object' to a block and further helper methods can be called on this form-builder object to construct the form like so:

`form_for @post do |f|`
`  f.label :title`
`  f.text_field :title`
`  `
`  f.submit
`end`

In this example, the form will by convention be posted to `/posts`. When working with nested resources, however, `form_for` can create appropriately nested paths only when given more information in the form of the relevant parent options, which might then look like this:

`form_form [@user, @post] do |f| ...`

This will post to `/users/:id/posts` by default. There is something else to note about the above example. This example will only work if the `@post` model has either an attribute or a virtual attribute named `title`. Because `form_for` is used to collect data for manipulating a model, it will only work with valid (virtual) attributes of that model. The rationale behind this is that the data will be prepared in a way that it can easily be mass-assigned to create or update a model-instance once it has reached the controller.

And how will this data be prepared? According to the http-protocol, all query-data is transmitted in the form of name-value-pairs. The form_for-helper will set up the names according to Rails' strict naming conventions so that they can be parsed before they are added to the params-hash. For example, the pair `address[city]=Lima` will be part of the params-hash as `{ address: { city: 'Lima' }}. For another example, the pairs `category_ids[]=1` and `category_ids[]=2` will appear in the params-hash as `{ category_ids: ['1', '2'] }`. Following those naming conventions enables elegant code in the controller when it comes to mass-assigning attributes.


## Dealing with form data in the Controller

Following naming conventions for form-elements results in a params-hash that can be easily accessed for mass-assignment. Ideally, we would like to create or update models by simply writing something like `Post.new(params[:post])`. This, however, would mass-assign all data that might be send to the application by (potentiontially malicious or stupid or both) users. As a means of protection, parameters that are allowed for mass-assignment have to be whitelisted. In Rails 3, this was defined at the model layer via `attr_accessible`. Rails 4 instead brings whitelisting to the controller, which enables more detailed control over which attributes are allowed in which context.

The general syntax for whitelisting paramters from the params-hash is this:

`params.require(:some_model).permit(:first_attr, a_list: [], a_hash: {}, :and_so_on)`

or simply

`params.require(:some_model).permit!

to whitelist everything. Because whitelisting might be required for a number of controller actions, it is common practice to extract this to a helper method.

There are two other common patterns worth mentioning in this context. The first is the *before_action*. It is possible to specify at the top of a controller which methods to call before any of the action-methods is called. The main purposes of this are authentication and setting up instance variables, which is a common concern for different controller actions. See below for an example. The second common pattern is that the controller tries to save a model instance and depending on the success of this actions redirects or renders the form again. The following controller-skeleton for a posts controller demonstrates all three patterns mentioned:

`class PostsController < ApplicationController`
`  before_action :set_post`, only: [:update]`
`  `
`  def update`
`    if @post.update(post_params)`
`      flash['notice'] = 'update successful'`
`      redirect_to @post`
`    else`
`      render 'edit'`
`    end`
`  end`
`  `
`  private`
`  `
`  def post_params`
`    params.require(:post).permit(:title, :body, category_ids: [])`
`  end`
`  `
`  def set_post`
`    @post = Post.find_by_id(params[:id])`
`  `
`    unless @post`
`      flash['error'] = 'Post could not be found'`
`      redirect_to posts_path`
`    end`
`  end`
`end`


## Hitting the Database

Now why would creating or updating a post ever fail? Well, first of all there might be something wrong with the database or with the application's database connection, or we might try to assign attributes that don't exist on the model, etc. But even if all this is not the case, saving or updating might still fail because of *validation errors*.

When the controller issues a save- or update-request, ActiveRecord will, in a pre-save hook, trigger model validations and abort saving or updating, should they fail. Model validations are specified on the model, of course, and take the form of `validates presence: true` or `validates presence: { message: 'kaputt'}`. Validations can check for the existence of attributes on the model-instance to be saved, or for their form or content. They can check if strings are long enough or fancy enough or conform to a certain pattern or if numbers are in a certain range. This can impose harsh restrictions on the form of the data that gets stored in the database.

Another thing that validations do apart from potentially aborting a saving-process is generating error-messages. These can be Rails' default or custom messages. When validations for an attribute fail, the corresponding error message is saved 'on the model'. Error messages can then be retrieved via `my_model.errors.full_messages`. While saving error messages on the model might seem a little strange at first, it makes a lot of sense when it comes to generating feedback for users.


## And back to the Presentation Layer: user feedback

A successful saving or updating action will typically result in a redirect to some other useful place. But in case something goes wrong the expected behavior is that a form is rendered again with appropriate error messages specifying which inputs prevented the actions from being finished successfully.

The standard way this works in Rails is that instead of redirecting the controller just renders the form-view again. Inside the form, we can now render error messages if there are any errors on the underlying model. Here, the power of model-backed forms shows again. If Rails finds form-fields for attributes that have an associated error-message, it will automatically wrap the corresponding inputs in divs with class `fields_with_errors` that can be styled appropriately.

This concludes the circle from entering data into the form all the way to getting feedback on that input. There are, however, two important topics for this week that concern the presentation layer and that I haven't touched upon so far.

### View Partials

View Partials are a way of extracting html-elements that are shared by many views into reusable parts. They can then be rendered either from within a layout or from within another view using `render 'controller_name/partial_name'`. Note by the way that partials are named with a leading underscore but are referenced without. It is also possible to pass local variables to partials as in `render 'my_partial', title: 'Crazy Horse'`. There are some conventions as to how partials are expected to be named, and as always, going with those conventions can result in quite efficient code. For example, writing `render @post` will look for a `_post`-partial in the posts-view-folder and automatically render that. Likewise, `render @posts` will loop through all the posts, take the _post-partial, pass in the current post as a local variable named 'post' and render the partial. It is even possible to define spacer-templates that will be rendered in between the post-partials. With some extra work it is of course possible to deviate from the defaults and, say, render a different collection, specify another view-partial and so on.

### View Helpers

While partials are simply parts of views and hence contain mostly html and little logic, helpers come into play when more logic is needed within the views. Logic that is only relevant for presentation-concerns is not supposed to be placed at the controller of model layer. Instead, helpers are modules that are automatically mixed into the views so that they have access to all defined helper methods. Helpers defined within the application-helper-module will be available accross all controllers and views while those defined in model-related modules are only available in the appropriate views, of course. Helpers are not supposed to contain a lot of html. If you find yourself writing much html into a helper function, think about creating a partial instead.


## Fun Facts and Best Practices

Once again, I will put some interesting things at the end that didn't really fit into the lesson's overall narrative

- think early about urls because in a way they are part if the interface
- the `link_to`-helper can take a block to create more advanced link-texts
- when writing a migration, try to put only *data definition statements* in there. If you have to add data to the db, use a rake task instead (and don't use the seeds either, they are just for setting up the application)
- when migrations don't run end-to-end cleanly (which they should!), you can import the schema directly from schema.rb via `rake db:schema:import`
- this and other available rake tasks can be viewed via `rake -T`
- Rails simulates a PATCH-request by inserting a hidden field tag with a name of `_method` and a value of `patch`
- when you have to render checkboxes in a model-backed form, the check_box helper is quirky, by `collection_check_box` can be really helpful




