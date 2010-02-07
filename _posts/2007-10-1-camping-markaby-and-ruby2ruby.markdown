--- 
layout: post
title: Camping, Markaby and ruby2ruby
---
I wanted to use [camping][camping] to a [literate programming][lit_prog] style wiki with [markaby][markaby] syntax. Literally I wanted to make the followin possible:

### The Goal

Have a wiki page with the following content:

    p "This page demonstrates Literate Markaby"
    
    ruby_code do
      a = 1 + 1
      p "Output of a: #{a}"
    end

And have the following output:

    <p>This page demonstrates Literate Markaby</p>
    <pre><code>a = 1 + 1
    p "Output of a: #{a}"</code></pre>
    <p>Output of a: 2</p>

Or it should look like this:

<p>This page demonstrates Literate Markaby</p>
<pre><code>a = 1 + 1
p "Output of a: #{a}"</code></pre>
<p>Output of a: 2</p>

### The Tool

Markaby is Markup in Ruby. So the code entered as wiki markup will be eval'ed to get the output right. So when I would like to get the contents of the block passed to `ruby_code` I have to inspect live code. And there is one nice tool, that fits this task - *ruby2ruby*.

### The Implementation

So all there is to do is to write a little camping helper, that implements the `ruby_code` method and generates the output.

    STRIP_PROC = /^proc \{\n(.*)\n\}$/m

    def ruby_code(&block)
      self.pre do
        self.code(block.to_ruby.gsub(STRIP_PROC, '\1'))
      end
      block.call
    end

It is pretty easy, when you start in the middle. `block.to_ruby` gives you a string representation of the given block. Since it is a proc, ruby2ruby surrounds it accordingly. In this example the actual value would be

    proc {
      a = (1 + 1)
      p("Output of a: #{a}")
    }

The `proc` is okay, if we would like to execute the code once again, but in this case it is too much information. Therefore, the regular expression and `gsub` remove these characters. This string is then surrounded with html code and pre blocks, so it is marked up semantically.

I tested this code in a separte script with marbaky and ruby2ruby.

### The stumbling block

But then, a simple `require 'ruby2ruby'` in the targeted camping app, breaks it. Strange `Markaby::InvalidXhtmlError`s are raised, where no exception was raised before. In fact, the occurred at the first call of `tag!` with attribute arguments. Since I was not able to track this down, I send my question to the [camping-list][list] and got the right hint.

`ruby2ruby` defines `NilClass#method_missing` to always return nil, instead of raising an exception. A nearby comment calls it an Object-C hack. I call it a bad idea. Other applications may rely on this basic behaviour, Camping does. Undefining it again, after the requiring `ruby2ruby` solved the strange errors. But on the other hand, ruby2ruby may rely on the changed behaviour. So this could not be it.

### A solution

By accident I came up with a working solution. Unfortunately I don't know why I helped, but I guess a certain degree of meta-programming leads to this behaviour. Add a definition of `tag!` to your application and everthing is fine. This will look loke the following:

    class MyApp::Mab
      def tag!(*g,&b)
        super
      end
    end

### Get it for free

If you now think, why should I solve that again, You already did, you are right. You can get all the fixes and methods for free, now. To use the code, simply add an `include LiterateMarkaby` to your application's module. That's it.

Ahh, of course you need to copy the following lines as well..

    require "ruby2ruby"

    module LiterateMarkaby
      STRIP_PROC = /^proc \{\n(.*)\n\}$/m
      def self.included(base)
        base.const_get(:Mab).class_eval do
          def tag!(*g,&b)
            super
          end
        end
        base.const_get(:Helpers).class_eval do
          def ruby_code(&block)
            self.pre do
              self.code(block.to_ruby.gsub(STRIP_PROC, '\1'))
            end
            block.call
          end
        end
      end
    end

As you can see: even more meta programming. The first reason: Helpers need to be defined directly within the applications helper module. Otherwise Markaby does not find them. And the other reason was already discussed, we need a `Mab#tag!` in our module.

There is only one thing better than meta-magic, even more meta-magic.


[camping]: http://code.whytheluckystiff.net/markaby
[lit_prog]: http://en.wikipedia.org/wiki/Literate_Programming
[markaby]: http://code.whytheluckystiff.net/markaby
[list]: http://rubyforge.org/pipermail/camping-list/2007-September/000467.html
