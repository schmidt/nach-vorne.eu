---
layout: post
title: undef_method != remove_method
permalink: /2008/2/28/undef_method-remove_method
---
When trying to remove behavior from your classes or objects, you will quickly
stumble upon `undef_method` and `remove_method`. Even when your are just trying
to change an implementation you will need one of these. Otherwise Ruby will warn
you, that you are discarding an older code chunk.

So let's quickly examine the basic difference between the two. The RDoc of
[`undef_method`](http://ruby-doc.org/core/classes/Module.html#M001675) already
gives good starting point.

> Prevents the current class from responding to calls to the named method.
> Contrast this with remove_method, which deletes the method from the particular
> class; Ruby will still search superclasses and mixed-in modules for a possible
> receiver.

There is also some sample code, but mine will be better. (No, it will not, but
have you ever heard of NIH?) And I will use two test techniques promoted by Jay
Fields to make sure, your mind is still able to move a bit. These are
[dust](http://blog.jayfields.com/2007/08/rubygems-dust.html) and [anonymous
classes for
tests](http://blog.jayfields.com/2008/02/ruby-creating-anonymous-classes.html).
Not too much magic for the rest of us, but both make posting test code a lot
easier, quicker and more readable.

I will post it in chunks. At the end of the article you will have a complete
ruby test.

    require "rubygems"
    require "dust"

No magic. Just wait a bit more...

    unit_tests do

This is `dust`'s way to say `class FooTest < Test::Unit::TestCase`. I really
like `dust`.

      def setup
        @base_class = Class.new do
          def method
            "answered in base class"
          end
        end
        @sub_class = Class.new(@base_class) do
          def method
            "answered in sub class"
          end
        end
        @base_instance = @base_class.new
        @sub_instance = @sub_class.new
      end

The setup method is pretty basic. We are creating a fresh inheritance hierarchy
for every test method. This will simply prevent undesired side effects. Changes
to classes are so global. Okay, the `@base_class` -- actually it has no name,
but anyways -- has a single method `method`. `@sub_class` inherits from
`@base_class` -- now I get the naming schema -- and defines its own version of
the `method` method.

For each run, I also instantiate an instance for each class to play with.

      test "Basic setup works" do
        assert_equal @base_instance.method, "answered in base class"
        assert_equal @sub_instance.method, "answered in sub class"
      end

This is `dust`'s way to say `def test_basic_setup_works; ...; end`. How do you
fell?

The code itself is really basic. I'm just making sure, that the setup works and
nobody changed my tests significantly.

## `remove_method`

Let's start with the well-behaving twin: `remove_method`.

      test "remove_method let's you undo method definitions" do
        @sub_class.send(:remove_method, :method)

        assert_equal @base_instance.method, "answered in base class"
        assert_equal @sub_instance.method, "answered in base class"
      end

I'm using `send` here to circumvent the visibility restrictions. Don't do this
at home. Use `class_eval` instead. Your children (using 1.9) will be happier.

After removing a method, its definition is removed from the class itself. When
you try to access it, the correct implementation will be searched within the
ancestors. This way you can get rid of your customizations and activate a more
general definition. This is mainly the thing you would want to use, before
redefining a method, to get rid of the warning.

There is not much else to say about it. Sorry.

## `undef_method`

The less it sounds like plain english, the hackier it is (ref. awk vs. grep).
`undef_method` does not only remove the definition from the current class, but
causes Exceptions. Let's have a look at the tests first.

      test "undef_method causes NoMethodErrors" do
        @sub_class.send(:undef_method, :method)

        assert_raise(NoMethodError) { @sub_instance.method }
      end

Although, there is a definition in the base class, it is not used. Instead, we
get an error. Okay, but this might make you think, that now, the method `method`
is totally gone ...

      test "undef_method does not affect superclasses" do
        @sub_class.send(:undef_method, :method)

        assert_equal @base_instance.method, "answered in base class"
      end

... no it is not. It is still there -- in the base class. `undef_method`
actually hides all implementations in superclasses. This somehow breaks the
inheritance relation. Although sub inherits from base and although base has an
implementation and sub does not, the happy programmer caused a NoMethodError.
The following test shall stress this reasoning.

      test "undef_method breaks inheritance" do
        @sub_class.send(:undef_method, :method)

        assert @base_class.instance_methods.include?("method")
        assert @sub_instance.kind_of?(@base_class)

        # This is the point where you should say: No!
        assert !@sub_instance.respond_to?(:method)
      end

We are still missing an

    end

here. The test is done, it will work on all 1.8 compatible machines.

## Strange summary

More or less -- without the hooks to update the functionality of `respond_to`,
`instance_methods` and their friends -- `remove_method` and `undef_method` could
be implemented like the following

    class Module
      def remove_method(name)
        define_method(name) do
          super
        end
      end

      def undef_method(name)
        define_method(name) do
          raise NoMethodError,
                "undefined method `#{name}' for #{self}",
                caller(1)
        end
      end
    end

The one passes control flow to an implementation somewhere else, the other
raises Exceptions. Try it, think about it, and tell me, why one needs
`undef_method`.
