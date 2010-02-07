--- 
layout: post
title: Ruby is cheating on super
---
The super call in Ruby differs in semantics from many other oo-languages. You are not simply refering to the class definition one level above, but just the method definition one level above. Additionally you may use super without arguments to tell the interpreter to use the same ones, the current method just received.

But this leaves one question open. How could you call super with no argument, while the current method received some. Besides super being a reserved word it should act as natural as possible and ideally feel like any message send. But it doesn't, unfortunately.

Please look at the following sample code.

    class BaseClass
      def method_with_default_parameter(arg0 = :default)
        arg0
      end
    end
    
    class InheritingClass < BaseClass
      def method_with_default_parameter(arg0)
        [ super,
          super(),
          super(arg0) ]
      end
    end
 
And guess what happens when this is called
   
    InheritingClass.new.method_with_default_parameter(:custom)
       # => [:custom, :default, :custom]

In some way this desired behaviour, but not what I would call least suprise. Ruby differentiates in this case between `super` and `super()`. This is only possible since the parser already knows `super` and nobody can emulate that with a custom message sends. A nasty trick that does not allow any api using `yield` to provide a similar behaviour in similar situations.

Could be corrected in 1.9. What do you think?
