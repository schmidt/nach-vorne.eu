--- 
layout: post
title: The difference between alias_method_chain and plain old super
---
Today a simple question arose. How to use `alias_method_chain` for class methods a.k.a. singleton methods a.k.a. instance specific methods for class. I just tried to answer the question, but finally I recognized, that it was't actually necessary to use `alias_method_chain` at all. The aim was to add behavior to `validates_presence_of`, an ActiveRecord method, that installs a check to ensure, that a certain value is set, before data is send to the database.

So let's have a look at the prerequisites first. I'll translate the actual implementation into an easier example. ActiveRecord will most likely implement class methods in a module, that is mixed into the singleton class of all subclasses. This looks a lot like the following code, where `ActiveRecord::Base` becomes `Base` and `validates_presence_of` becomes `class_method`.

    class Base
      module ClassMethods
        def class_method
          "base implementation used"
        end
      end

      def self.inherited(sub)
        sub.extend ClassMethods
      end
    end

Whenever this class is subclassed, the inherited method will be called an the class methods added as described. If you want to add more specific behavior to the `class_method` you got multiple options. But there is no need to use method aliasing with ActiveSupport's `alias_method_chain`. Modules, even the ones extending Objects have an inheritance relation. So let's use `super` powers.

### First option: Reusability

Define your own `ExtendedBase` that you may mix in to your classes, that need the additional behavior.

    module ExtendedBase
      module ClassMethods
        def class_method
          "extended and " + super
        end
      end
      def self.included(sub)
        sub.extend ClassMethods
      end
    end

This code uses the same `ClassMethods` technique as the class above, but the call back is called `inherited` this time. It provides a special implementation for `class_method` and delegates to the next one in the inheritance chain for the more general stuff.

It is used like the following:

    class A < Base
      include ExtendedBase
    end

### Second option: Ad hoc usage

If no reuse is necessary, you may savely add the behavior to the single class, where you need it. Just open up the metaclass a.k.a. eigenclass a.k.a. singleton class and define your methods. Again, you 
may simply delegate to the base implementation using super.

    class A < Base
      def self.class_method
        "custom and " + super
      end
    end

Hehe. The description was more verbose than the code, but trust me it was still correct.

### Never trust your code without tests

To make clear, that everything works as expected, I will add a test. I assume, that all the above definitions are loaded.

    require "rubygems"
    require "dust"

    unit_tests do
      test "should call all three implementations" do
        assert_equal("custom and extended and base implementation used",
                     A.class_method)
      end
    end

### Conclusion: Know your inheritance chain

You should always have a look at your tools and know how your inheritance hierarchy looks like. It can things so much easier. Ruby's method lookup follows a simple rule.

1. Definitions in the class itself
2. Definitions in included modules, modules included later are used first
3. Definitions in super classes

It is always possible to jump from one implementation to the other with the use of super. And if you are not sure, which implementation will be used first, ask your [`ancestors`](http://ruby-doc.org/core/classes/Module.html#M001700).

In this case a super call is much more expressive than the use of method aliasing. It does not pollute your objects instance methods list and it will never produce name clashes.
