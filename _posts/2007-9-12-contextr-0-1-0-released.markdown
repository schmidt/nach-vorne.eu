---
layout: post
title: ContextR 0.1.0 released
permalink: /2007/9/12/contextr-0-1-0-released
---
In the last weeks it was a bit silent around this page, my master's thesis and ContextR. This will change again and the start will be a new version of ContextR, that was just released.

It features a reimplementation from the scratch including more dynamicy, a totally different syntax and some more niceties, that allow easier use of it in most cases. For demo purposes although, the syntax became slightly more explicit, but this will not be much of a problem.

There were several downside of the old syntax and I would like to list the here for future reference.

- it was impossible to refactor wrapper code into layer scoped functions
- it was not easily possible to reuse code in multiple layers or for multiple functions
- it was not possible to remove behaviour definitions, since there was no way of addressing a single chunk of attached behaviour
- syntax highlighting does not work for wrapper definitions

## The shiny new API ##

From now on the layer specific behaviour is wrapped in plain old ruby modules (no more blocks). The introductory Education/Student example looks now like the following

    class Student < Struct.new(:name, :address, :university)
      def to_s
        name
      end
    end
    
    class University < Struct.new(:name, :address)
      def to_s
        name
      end
    end

This is a pretty simple class layout. But if you would like to get the address of a student under certain circumstances and the educational body in others or sometimes both, the new API comes into play.

    module AddressMethods
      def to_s
        yield(:next) + " (" + yield(:receiver).address + ")"
      end
    end

    class University
      include AddressMethods => :address
    end

    class Student
      module EducationMethods
        def to_s
          yield(:next) + "; " + yield(:receiver).university.to_s
        end
      end

      include AddressMethods => :address
      include EducationMethods => :education
    end

So what happened here? We are using plain old modules to define additional behaviour for our Student and Education classes. Just like we had done without ContextR - despite the strange `yield(:next)` instead of super and `yield(:receiver)` instead of `self`. I will try to get rid of these strangeness in one of the next iterations. Until then we have to live with them. `include` takes a Hash as argument now, which gives the layer name in which the code should be used.

## So what does this do? ##

    hpi = University.new("HPI", "Potsdam")
    me = Student.new("Gregor", "Berlin", hpi)
    
    me.to_s #=> "Gregor Schmidt"
    hpi.to_s #=> "HPI"
    
    ContextR::with_layer :address do
      me.to_s #=> "Gregor Schmidt (Berlin)"
      hpi.to_s #=> "HPI (Potsdam)"
    end
    
    ContextR::with_layer :education do
      me.to_s #=> "Gregor Schmidt; HPI"

      ContextR::with_layers :address do
        me.to_s #=> "Gregor Schmidt (Berlin); HPI (Potsdam)"
      end
    end

The main difference in the new API is the different way of defining layer specific behaviour. The actual use of the different layers remains the same. In this short example we can already make use of the new possiblity to reuse code.

Hopefully I will demostrate more useful examples in the nearer future.

## Where can I buy it? ##

    sudo gem install contextr

To use it in your project you have to add these three lines to your code

    require 'rubygems'
    gem 'contextr'
    require 'contextr'

I'm not sure, why I need three lines and not just the first and one of the others. Perhaps one of you has an idea.
