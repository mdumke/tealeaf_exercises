# Lesson 3.1 - Introduction to Testing Rails with RSpec

This first week of the third course provided an introduction to application planning, workflow and testing. First tests were written in RSpec and some new technology for the rest of the course was introduced, including jQuery, Sass, HAML, and formbuilders.


## Application Planning and Development Workflow

A prototypical process for planning an application from idea to sofware might be devided into five steps, listed below. It is a good idea to keep those steps separated from one another because this is a good strategy for generating multiple different ideas on each step.

1. *Formulating the idea* This can be a whole process of its own including market research, coming up with personas, writing scenarios and user stories and formulating a business plan.
2. *Building wireframes* Let it be clear that building wireframes is not about design! It is about finding out which interactions an application should support. Popular mockup-software like *balsamiq* or *moqups* is purposefully constructed to look clunky and ugly. The goal of wireframing is to quickly test out a number of different approaches to how interaction might look like.
3. *Design* This part is about layout, choosing colors, fonts, images and related questions. At the end of a design process there is usually a .psd-file that covers all relevant aspects of the application.
4. *Slicing* Taking a design and converting it to HTML, preferrably true to the pixel, is called slicing. There are actually services specialized for doing just that, and they will provide you with a set of static pages that developers can work off of.
5. *Development* Well, this is what we're here for...

When starting with a sliced version of a website, it is a good idea to make the static pages easily available in development. Hashrocket has introduced a helpful UI-controller / index view that automatically creates routes for every relevant view under app/views/ui. The controller just presents the index view and redirects unless the environment is development. The index view looks like this:

```ruby
%ul
  - Dir.glob('app/views/ui/*.html.haml').sort.each do |file|
    - wireframe = File.basename(file, '.html.haml')
    - unless wireframe == 'index' || wireframe.match(/^_/)
      %li= link_to wireframe.titleize, action: wireframe unless wireframe == 'index'
```

There are a number of possible git-based workflows when working in teams, but a simple yet effective one seems to be the **github flow** (read about it at `http://scottchacon.com/2011/08/31/github-flow.html`). The main ideas are that everything on the master branch has to be deployable at any time and that work is done on extra branches, so pull requests can be used for discussion, code reviews and final merging. This way, a simple `git fetch` will also provide you with a quick overview over the things others have recently been working on.


## Testing Software

Automated testing of software is the critically important in reducing technical debt (the accumulation of uncertainties that make it hard for projects to grow beyond a certain size). Alternatives to automated testing would be first of all 'no testing'. But this in effect would mean that customers do the testing, a huge inconvenience for everyone involved. Another option would be to have a dedicated QA-department doing the testing, but this in turn brings a lot of organizational difficulties ('nobody likes the QA team', which is often composed of junior developers with little experience). So there is really no good way around automated testing, even though it might look tedious in the beginning.

There are different kinds of tests and approaches to testing. We usually distinguish between unit-, functional-, and integration-tests. *Unit tests* test models, controllers, routing, etc. in isolation, just the components themselves and is threfore usually fast and has high test coverage. *Functional tests* check the interplay of multiple components, in Rails they are typically controller tests. And finally, the goal of *integration tests* is to test the workings of the application as a whole, with (simulated) users clicking buttons and getting feedback. This course will focus primarily on unit and functional tests.

There are different appraoches as to when to write tests ranging all the way to writing tests for a finished product (which guards against regressions), to 'code a little, test a little', to 'write tests first', all the way to test driven development and test driven design. Those latter approaches put tests not just before some piece of code, but drive the whole process of developing new features and expanding applications guided by tests. Which strategy is the right one depends, of course, on the respective context.


## Testing Rails with RSpec

RSpec is intended to be used as a tool that supplements a Behavior Driven Design process. For this reason, what you formulate with RSpec are not just tests, but *specs* (hence the name). Running `rspec` will search through the spec-directory, look for files that end in '_spec.rb' and run them. Here's what a basic specfile could look like:

    # make sure the Rails environment and the relevant class are loaded
    require 'spec_helper'

    describe Todo do
      it 'saves itself' do
        # 1. setup step
        todo = Todo.new(name: 'cook dinner')

        # 2. perform some action
        todo.save

        # 3. verify the result is as expected
        Todo.first.name.should == 'cook dinner'
      end
    end

This code exemplifies a prototypical approach for writing tests in multiple steps: first a setup, the some action we would like to perform, then check whether the results meet our expectations, and finally some cleanup (not necessary in this case). Now this particular spec is not recommended because it tests Rails and ActiveRecord, which is not really necessary. Only test the code you own.

Tests that are basic but still considered relevant might be validation-tests and associations-tests for models. Because they are basic, there is a nice tool that can save some typing and help with edge-cases, a gem called *shoulda-matchers*. With soulda-matchers, we can write those test as, e.g.

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should belong_to(:user) }
    it { should have_many(:videos) }

When writing tests, considers using a technique called *triangulation*. This means to start off by writing the simplest code possible to make the first test pass (even if the code is entirely trivial) and extend it only when another test makes this necessary.


## Custom Form Builders

Sometimes, especially when dealing with a form-heavy application, it can be convenient to customize the rails form helpers, e.g. in order to render error messages automatically or display error with each label field. For instance, we could write a new form builder in `app/helpers/my_form_builder.rb` that extends the label-method:

    class MyFormBuilder < ActionView::Helpers::FormBuilder
      def label(method, text = nil, options = {}, &block)
        errors = object.errors[method.to_sym]

        if errors
          text += " <span class=\"error\">#{ errors.first }</span>
        end

        super(method, text.html_safe, options, &block)
      end
    end

This just adds an error-span for every input that has an associated error. To use the new builder, the form_for helper takes an additional options-argument: `form_for @post, builder: MyFormBuilder do |f| ... end`. Now instead of having to add this to every form it is much more convenient to write a new form-helper function in the application_helper.rb like, e.g.

    module ApplicationHelper
      def my_form_for(record, options = {}, &proc)
        form_for(
          record,
          options.merge!({builder: MyFormBuilder}),
          &proc
        )
      end
    end

Apart from writing custom form buiders for specialized needs there are also a number of libraries available, some bringing a rather heavy-weight DSL (like *formtastic* and *simple_form*) and others just providing some boilerplate code but staying closer to the rails helper syntax (like *bootstrap_form*).


## Fun Facts and Best Practices

- When thinking about a new application, don't start from an empty nav and think 'where could we go from here'; start in the middle of things, the nav will come together later anyways
- Specify a Ruby version in a file named `.ruby-version` and rvm will automatically switch to the correct version (simply put e.g. `2.1.2` inside the file)
- Similarly for associating a particular gemset with a project, create a `.ruby-gemset` file and just put the name in there, like `this_special_project`
- It is a good practice for has-many associations to specify a default order via, e.g. `has_many :videos -> { order('title') }`, note that this replaces the older syntax which was `has_many :videos, order: :name`
- Prior to Rails 4.1. it was necessary to run `rake db:migrate db:test:prepare` to setup the testing environment, this is not required anymore
- To see an exhaustive list of rake tasks, run `rake -T -A`
- It is common to have a pages controller for static pages like the front page
