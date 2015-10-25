# Lesson 2: More RSpec and best practices for testing

The gist of the week seems to be to learn by observing and practicing while seeing a number of helpful good practices along the way. The overall theme is, of course, test driven development with RSpec and main topics are writing controller tests, techniques for DRYing up RSpec code, and generating test data.

## Controller Tests

Controller tests in the Rails framework typically involve a number of diverse elements such as different models, views and routes. Hence, expect controller tests to be functional rather than unit tests. Here is a longer example of some basic controller tests together with some annotations:

```ruby
describe TodosController do
  # use a describe-block for each action
  describe "GET index" do
    it 'sets the @todos variable' do
      # setup
      cook = Todo.create(name: 'cook')
      sleep = Todo.create(name: 'sleep')

      # action
      get :index

      # evaluate results
      expect(assigns(:todos)).to eq([cook, sleep])
    end

    it 'renders the index template' do
      # all http verbs are available as functions
      get :index

      expect(response).to render_template :index
    end
  end

  describe "GET new" do
    it 'sets the @todo variable' do
      get :new

      assigns(:todo).should be_new_record
      assigns(:todo).should be_instance_of(Todo)
    end
  end

  describe "POST create" do
    it 'creates the todo record when the input is valid' do
      # this is the way to pass arbitrary parameters
      post :create, todo: {name: 'cook', descriptions: 'this is valid input'}

      expect(Todo.first.name).to eq 'cook'
      expect(Todo.first.description).to eq 'this is valid input'
    end

    it 'redirects to the root path when the input is valid' do
      post :create, todo: {name: 'cook', descriptions: 'this is valid input'}

      # redirection test
      response.should redirect_to root_path
    end

    it 'does not create a todo when the input is invalid' do
      post :create, todo: {descriptions: 'this is an in valid input'}

      expect(Todo.count).to eq 0
    end
  end
end
```

A few remarks on this code may be helpful. First of all, some of the specs have two assertions in them, which is strictly speaking a violation of the *single assertion priniple*. Yet in practice this is fine as long as both cases are very closely related. Secondly, while it is certainly reasonable to test when unexpected views are being rendered from a controller action, it is not necessary to test for default views. The above is only an example for demonstrating the syntax of render-tests.

Note that all test cases follow the same pattern: 1. Setup, 2. Action, 3. Evaluation of results. A fourth step, cleanup, is done implicitely by RSpec as long as only basic tests are concerned. When writing tests however, it is not always easy to come up with the code in this orderly manner. Sometimes it can be really helpful to start with the action and then step by step find out which data have to be supplied during the setup.


## DRYing up RSpec test code

RSpec has a number of helper methods to avoid repetition of test code, a few of them will be introduced here.

1. **let**. When a variable is used within multiple tests in a describe- or context-block, it can be made available via `let(:sound) { Sound.create }`. Note that let-blocks are lazily evaluated, which can improve performance but can also lead to unexpected results. For example, the sound-variable can not be retrieved from the database unless it was actually called within a test. To eagerly load let blocks, use `let!(:life) { Life.create }`.
2. **subject**. The testing condition can be extracted from the tests as well using the subject variable or function as in `let(:subject) { todo.do_something }` or just `subject { todo.do_something }`. This will make `subject` available in all the tests so that an evaluation may be shortened to `expect(subject).to be 'some result'`. In a case where this expect-statement is the only line in a test, RSpec has a shortcut, which is `it { is_expected.to eq('some value') }`. The `it` will be substituted by the subject.
3. **context**. This is an alias for `describe` and typically used to groups test cases together that need some common setup like e.g. users with and without a valid session or post-requests with and without valid form-data. Variables introduced via `let` are scoped to these context- or describe-blocks. Also, working with context can significantly enhance readability.
4. **before**. The block passed to the `before`-function will be executed before every test in the current block. This is a good way to extract common setup for a context.

These techniques can be very helpful when refactoring tests, though not so much when initially writing them - it is easier to extract common structure than to know in advance what will be similar accross all tests. While the use of these helper methods is applauded by some, others argue it separates the test setup too far from the action and makes it harder to keep the whole test in mind. You may want to watch out for this.


## Generating test data

There are a number of helper libraries available for generating data while testing. Using these can have a number of advantages. First, they usually provide a single place where model data is setup, so when model specifications change, it is easy to change the test data as well without having to go through all the testing code. Second, they can improve performance because they often manage to provide data without actually having to hit the database. And third, when a model requires a lot of attributes for setup, they help to avoid clutter in the testcode.
A popular such library is *factory-girl*, another one, and the one recommended for this course, is *Fabricator*. The following examples will all refer to and explain the Fabricator library.

The syntax for defining a new model with Fabricator is as follows:

```ruby
Fabricator(:todo) do
  name { 'cooking' }
end
```

Now in the specfile there is a simple way to instantiate a new Todo via `Fabricate(:todo)`. Of course, default parameters can all be overwritten as in `Fabricate(:todo, name: 'something else')`. When associations are needed they can be easily provided via

```ruby
Fabricator(:todo) do
  name { "cooking" }
  user
end
```

The `user`-line is actually a shortcut for `user { Fabricate(:user) }`. In order to introduce variation on the test data, it is helpful to randomize attributes. This can be done with Rails random-functions or with Fabricator's *sequences*, but the most conventient way seems to be to use the *faker*-gem. This can provide different inputs for every call and it can be included as in:

```ruby
Fabricator(:todo) do
  name { Faker::Lorem.words(2).join(' ') }
  user
end
```

## Some interesting points and helpful advice

As always, here's a bunch of helpful facts that didn't really fit anywhere in the summary. First up is the *delegation pattern* which is useful when calling methods on associated objects. This code:

```ruby
def category
  video.category
end

def video_title
  video.title
end
```

is equivalent to this:

```ruby
delegate :category, to: :video
delegate :title, to: :video, prefix: :video
```

And here are some other points:
- Be careful with testing object identity, maybe you mean object equivalence. In particular, when writing RSpec assertions, distinguish between `eq` and `be`.
- Always make sure your public interface is clean and readable, for private methods this is maybe not as important. In the same vein, it is helpful to develop 'from the outside in', first writing 'the code we wish we had'.
- When testing, write tests for 0, 1, many ('Cardinality'), and boundary conditions (like, e.g. no more than four).
- If you're using the word 'and' in your spec descriptions, that's a good indicator you're testing too many things.
- If you need authenticated users, create a context and use a before-block to set a session[:user_id].
- When you only want to run one particular test, put a line number behind the filename like so: `bin/rspec spec/controllers/videos_controller_spec.rb:23`.
- Fabricator brings a helpful method `Fabricate.attributes_for(:some_model)` which does not create the model itself.
- To check if a flash message has been set, use `expect(flash['notice']).not_to be_blank`.
- To test against an array without caring for the order, use `match_array`.
- Say we want to create a comment for a Post, so in the controller, we build a new comment and associate it with the post. But even when the comment cannot be saved, it will still show up in `@post.comments`, being an invalid object. To avoid unexpected behavior in case we need the comments in the next view, call `@post.comments.reload` before rendering.
