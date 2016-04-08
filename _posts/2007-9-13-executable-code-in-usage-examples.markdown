---
layout: post
title: Executable code in usage examples
permalink: /2007/9/13/executable-code-in-usage-examples
---
Today I wrote a basic usage document for ContextR. It will be part of the next
gem release and therefor right at the hand of the user. What hit me was, that I
wanted it to be executable. It is okay to write a bit of code and surround it
with comments to explain it, but what bothered me, was that I had to use puts
all over to demostrate example output.

But the reader cannot see the output of a line of code and the line itself at
once. So you will start writing something like this.

    puts "bla" * 3 # => "blablabla"

I think everybody has seen code like this somewhere. Probably in this blog. It
works okay, the code stays executable and readable, but it is not easy to
garantee, that the code and the comment are in sync. If you change your libary
code (in this case the `*` method for String) and the code and comment act
differently, the only person who is able to spot the error is the user, that
tried the piece of code in his own project.

### Make it a test case

And, by the way, executing a file with 20 to 30 puts lines in it does not give a
good looking output. So what you want it to have the actual code and the
expected output side by side. Sound like a test case to me. So you would change
the above example to the following

    class TestString < Test::Unit::TestCase
      def test_multiply
        assert_equal "blablabla", ("bla" * 3).to_s
      end
    end

This is a lot of noise, that nobody wants to see. But we've got the advantage,
that our manual can become part of our test suite and it will fail in the
second, we change our libary - immediate feedback. Nothing is worse than having
outdated documentation.

### Get rid of the noise

So I tried to make it less noisy, but keep the test case approach. What I did
was a bit of metaprogramming and dsl-ing. The result:

    test_class(:TestString)

    # introduction

    example do
      output_of("bla" + "blub") == "blablub"
    end

    # some comment

    example do
      output_of("bla" * 2) == "blabla"
      output_of("bla" * 3) == "blablabla"
    end


The definition of the `test_class` is done only once, I group all examples of a
file into one test class for example. All examples following a `test_class`
definition are made to `test_*` methods within this class.

In the above example generates the following code, or to correct it generates an
object structure, that acts like the following code:

    class TestString < Test::Unit::TestCase
      def test_001
        assert_equal "blablub", ("bla" + "blub").to_s
      end

      def test_002
        assert_equal "blabla",    ("bla" * 2).to_s
        assert_equal "blablabla", ("bla" * 3).to_s
      end
    end

At the end there is a fully functional TestClass that is executed automatically
with all the others. And the execution of your document gives you the
information whether it is still correct or not. Everything we wanted.

But there is one downside I could not solve elegantly yet. If you want to share
variables from one example to the other, you have to use instance variables or
global variables. And if you embed code, that is not part of an example, that
should use the variables as well, there is no other option than globals. But I
guess that this could be solved somehow. In my case it is sufficient.

### The implementation

I simply added the following lines to my test_helper.rb

    module ExampleTest
      module ObjectExtension
        def test_class(name)
          $last_test_class = Class.new(Test::Unit::TestCase)
          $last_test_case  = 0
          Object.const_set(name, $last_test_class)
        end

        def example(&block)
          $last_test_class.class_eval do
            define_method("test_%03d" % ($last_test_case += 1), &block)
          end
        end
      end

      module TestExtension
        def assert_to_s(expected, actual)
          assert_equal(expected, actual.to_s)
        end

        def output_of(object)
          Output.new(object, self)
        end

        class Output
          attr_accessor :object, :test_class
          def initialize(object, test_class)
            self.object = object
            self.test_class = test_class
          end
          def ==(string)
            test_class.assert_equal(string, object.to_s)
          end
        end
      end
    end

    class Test::Unit::TestCase
      include ExampleTest::TestExtension
    end
    class Object
      include ExampleTest::ObjectExtension
    end

Feel free to use it in your projects and give me feedback if you do. If this
makes sense to more than three people, I will most likely compile a gem and
release it to the public.

### An example (I love recursion)

If you would like to see the above in action, have a look at the [ContextR
introduction
test](http://contextr.rubyforge.org/svn/trunk/test/test_introduction.rb). Lots
of comment and some code examples in between. It is a lot more readable with
syntax highlighting. And what happens when the file is executed?

    $ ruby test/test_introduction.rb
    Loaded suite test/test_introduction
    Started
    ...........
    Finished in 0.003204 seconds.

    11 tests, 18 assertions, 0 failures, 0 errors

### Addendum

This causes some warning when your test are executed using the `-w` option, what
they should, by the way. I am not sure, whether it is possible to avoid these or
not. As far as I can see, RSpec, where I stole the `==` syntax has the same
problems. Propably we should switch to a single `=` but this would not look
right. I'm not sure.

Anyway, if I release it as a gem, it needs to have a name.
