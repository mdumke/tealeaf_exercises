# Lesson 3: More RSpec, Transactions, and Feature Tests with Capybara

Lesson 3 contains two main topics, both of which are about testing with RSpec. The first is a collection of techniques for eliminating repetition in test code with the help of macros and RSpec shared examples. The second topic are feature tests using Capybara. The lesson concludes with some helpful general advice on approaching testing and a little aside on Rails transactions.


## DRYing up tests with macros and shared examples

Both macros and shared examples are strategies to factor out common logic from different parts of a testsuite. While macros are simply custom functions that can be called from within the tests, shared examples rely on an infrastructure that RSpec provides and that allows reusing tests accross different contexts.

To use macros and shared examples, create a folder named `spec/support/` and make sure it's content is loaded when RSpec starts, either by requiring it explicitely at the start of a spec file, or by requiring it in the spec helper file, which will load it for any test. To achieve the latter, include this line in `spec_helper.rb`:

```ruby
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
```

Macros might quite reasonably live in a file named `spec/support/macros.rb` and as has been said, they simply contain functions to be called from withing tests. Useful examples might be controller test macros for setting, retrieving or clearing a current user:

```ruby
def set_current_user
  jane = Fabricate(:user)
  session[:user_id] = jane.id
end

def clear_current_user
  session[:user_id] = nil
end

def current_user
  User.find(session[:user_id])
end
```

Shared examples can live in `spec/support/shared_examples.rb` and are defined by calling `RSpec.shared_examples` with a string to recognize them by and a block to be executed. Here's an example of sharing specs for authentication tests of controller actions:

```ruby
# in spec/support/shared_examples.rb
shared_examples "require_sign_in" do
  it 'redirects to the front page' do
    clear_current_user
    action
    expect(response).to redirect_to root_path
  end
end
```

When this is called from a controller test, it is executed from the top until it reaches the action-method, which is a custom-defined method whose content can be specified from where the test is called. For instance, to test the index action of a controller, we might call the shared examples like this:

```ruby
# in spec/controllers/users_controller.rb
it_behaves_like 'require_sign_in' do
  let(:action) { get :index }
end
```

A spec for another method might reuse the same example and simply specify a different action to perform.


## Features tests with Capybara

Feature specs define application behavior from a user's point of view. Which content do they see on a page? Which forms are filled in and with which content and which buttons get clicked? Here, everything comes together: View, Routes, Helper methods, and Mailers. By combining diverse elements on different layers of the application, feature specs are at the same time *vertical integration* tests. Horizontal integration on the other hand refers to series of requests to be executed and are handled by RSpec in *request specs*. These specify series of actions that all concern the routing- and controller layer and do not involve the browser.

A popular gem for performing integration tests is *capybara* that will also be used in this course. Capybara is built on top of RSpec and provides aliases for some RSpec methods, hence extending it's DSL to allow for a more adequate terminology:

    feature    <-> describe
    background <-> before
    scenario   <-> it
    given      <-> let

Capybara can test browser-interaction, visit urls and fill out forms. It does this using *RackTest*, it's default driver, which, however, is unable to test javascript execution. This needs drivers like Selenium (rather slow) or Capybara-webkit (not as slow because it uses a headless browsser).

To work with capybara, require it in the spec_helper via `require capybara/rails` and put files like `login_spec.rb` under `spec/features`. A simple login test could look like this:

```ruby
require 'spec_helper'

feature 'User signs in' do
  background do
    User.create(username: Johann)
  end

  scenario 'with existing username' do
    visit root_path
    fill_in 'Username', with: 'Johann'
    click_button 'Sign in'
    page.should have_content "Johann Do"
  end
end
```

While this is a perfectly valid test, it might be a good idea to refactor parts of it into a macro because login is something that a lot of feature tests might require.

In the above example, we used `fill_in` to enter a string in the 'Username'-field, where 'Username' could be either an id, a field-name or a label of an input element (try to refer to elements by label if possible because this will test the association of the label as well). There are other ways of finding elements. If for example a link does not have an anchor text we can search by href:

`find("a[href='/video/#{my_video.id}]").click`

Or if we need to identify elements but cannot use the ids, we can create data-attributes with the form helpers via, e.g.

`=text_field_tag 'name[]', 'value', data: {help_id: unique_id}`

However, when using data-attributes, we cannot rely on Capybara to automatically fill in fields, but we have to first find them explicitely:

`find("input[data-help-id]='abc'").set(3)`

This will find the field and update the value to 3. Yet another way to identify elements is by first identifying their scope or context and then selecting them. An example would be selecting input fields that have been grouped in a table. Here, `xpath` is going to be helpful:

```ruby
within(:xpath, "//tr[contains(.,'#{my_video.title}')]") do
  fill_in "the_relevant_fields_name", with: 3
end
```

And here's an example for finding an input element of type text within a table row:

```ruby
find(:xpath, "//tr[contains(.,'#{my_video.title}')]//input[@type='text']")
```

Xpath can be very helpful in finding elements in the DOM, but it brings its own syntactic rules. Here's how to read the last example:

- the first `//` means to start anywhere in the document
- the `.` refers to the current level, i.e. the tr
- the second `//` looks under the previously found elements
- `@` is used for querying attributes

When the same elements have to be retrieved from different places in the testcode or when the xpath-queries become bloated, remember to factor them out.

Finally, two helpful tips when working with capybara. First, `launchy` is a helpful gem when it comes to debugging. Launchy allows to halt the execution of testcode an open a browser at the current state. To do this, simply call `save_and_open_page` from within the test code (or from within a `binding.pry`). Second, working with Javascript is not so simple. It requires a dedicated driver (see above) and you have to tell the test to use it (via adding `js: true` to the test as in `it 'supports js', js: true do`). On top of that, using a differnt setup will bring problems with database-entries, which can be solved by including the 'database_cleaner' gem and setting using transactions to `false` in the rails helper.


## Some good practices when it comes to testing

Here are a number of helpful ideas when it comes to testing in general:
- Find the proper level of abstraction. This is advisible in programming in general, and so it is a good idea to be aware of this when writing tests. This could mean to, for instance, make sure that feature tests that operate on the level of user interaction factor lower level details like finding elements on a page into helper methods.
- When you find a bug, don't just fix it, but write a test that reproduces it, then make the test pass and finally verify thatt this has actually solved the problem.
- While developing, run the tests often and take small steps. This way, you will have a better overview over where in the process you are. People have called this *exception driven development*.
- When you're refactoring to push code from the controller down to the model layer, this is often more or less a copy and paste job. In these cases it should suffice to have existing tests passing after the refactoring. If, however, you start to extend the code and implement new features on the model layer, make sure to move the tests to the model layer accordingly.


## Bonus: Transactions

There are situations in which we want database updates to either be all successful of not happen at all. In those cases transactions are used to ensure any prior actions will be reverted of later ones fail. In Rails, a failing validation will raise a `ActiveRecord::RecordInvalid` error that can trigger a rollback, when the execution is wrapped in a transaction.

The following is an example of updating a group of items for which updates should only happen when the whole group updates successfully.

```ruby
def update_items
  ActiveRecord::Base.transaction do
    @items.each do |item|
      item.update_attributes!(
        feature_1: :new_value,
        feature_2: :another_value)
    end
  end
end
```

To gain more control, this whole block could be wrapped in a `begin`, `rescue`, `end` block that rescues the `ActiveRecord::RecordInvalid` error which will be thrown if `update_attributes!` fails with a validation error.


## Stuff

As with the last lessons' summaries, I will end this one with a collection of helpful ideas and good practices:

- Within a spec, use `reload` when the code execution changes an object at the database layer: `expect(item.reload.value).to eq :y`
- Ryan Bates has a Railscast on Capybara (#257)
- When refactoring to get more code to the model layer, be careful not to pass content from the params to the model. This is considered bad practice because it will tightly couple the model to the params.
- There's a nice regex-tutorial on `www.regular-expression.info`
- When `include_blank: true` is passed to the select_tag, it will show a blank option
- Read more about the idea of skinny controllers in a classic post at `weblog.jamisbuck.org/2006/10/18/skinny-controller-fat-model`
- `some_string.try(:strip)` will call `.strip` on the value only if it is not nil
- If you provide a `model#feature=(arg)` method, you can use this as a virtual attribute in e.g. `update_attributes(feature: some_value)`
- `MyModel.find_by(user: user, feature: feature)` is equivalent to `MyModel.where(user: user, feature: feature).first`
- To use the latest version of a gem, simply point to it with the syntax `gem 'capybara', git: 'https://github.com/...'`
- Here are some helpful command line shortcuts I found this week
  - `CTRL + U` - Cuts text up until the cursor.
  - `CTRL + K` - Cuts text from the cursor until the end of the line
  - `CTRL + Y` - Pastes text
  - `CTRL + E` - Move cursor to end of line
  - `CTRL + A` - Move cursor to the beginning of the line
  - `ALT + F` - Jump forward to next space
  - `ALT + B` - Skip back to previous space
  - `ALT + Backspace` - Delete previous word
  - `CTRL + W` - Cut word behind cursor

- Here's what my spec-directory-structure looks like after the first three weeks of the last course:
  - spec/
    - controllers/
    - fabricators/
    - features/
    - models/
    - spec_helper.rb
    - support/
        - macros.rb
        - shared_examples.rb

