--- 
layout: post
title: cache_annotations release to the wild
permalink: /2007/5/28/cache_annotations-release-to-the-wild/index.html
---
Ruby is all about keeping things simple, letting others do the simple work and being creative and not occupied. Have you ever thought about how often you are writing down the same idioms. Although they may look cleaner than in other languages it is cumbersome to write the same patterns over and over.

`cache_annotations` tries to eliminate one of these. And I encourage everybody to spot others and ged rid of these to. This is Ruby and it should look as lean and mean as possible. `cache_annotations` is a simple annotation-like, aop-inspired api that allows you to mark methods as functional. These will always return the same values, given the same parameters and do not produce any side effects. Examples would be any mathematical computation, database `select`s on a read-only db or between to `update`s.

### Fibonacci example

I have a pretty easy and striking example to show the use and beauty of `cache_annotations`. The Fibonacci sequence. The following code will compute every fibonacci value corresponding to the recursive defintion on [Wikipedia](http://en.wikipedia.org/wiki/Fibonacci_number).

    class Fibonacci
      module ClassMethods
        def compute(number)
          if number < 0
            raise ArgumentError.new(
                "Fibonacci is not defined for numbers < 0")
          elsif number < 2
            number
          else
            Fibonacci.compute(number - 2) + 
                 Fibonacci.compute(number - 1)
          end
        end
      end
      self.extend(ClassMethods)
    end
    
    Fibonacci.compute(10) # => 55

But after looking closely to the code you may see, that esp. for larger numbers, this defintion is a killer. For each call it executes two recursive other calls and this eats stack levels. Besides that `Fibonacci.compute(number - 2)` is computed twice, one time in each recursive call. Finally computing `Fibonacci.compute(100)` takes ages - or at least longer than 10 seconds.

We have got two options here. Switch to a non-recursive function definition or avoid the double computation by caching results.

### Enter cache_annotations

    require 'rubygems'
    require 'cache_annotations'
    
    class Fibonacci
      module ClassMethods
        include CacheAnnotation
        
        cached :in => :@fibonacci_cache
        def compute(number)
          if number < 0
            raise ArgumentError.new(
                "Fibonacci is not defined for numbers < 0")
          elsif number < 2
            number
          else
            Fibonacci.compute(number - 2) + 
                 Fibonacci.compute(number - 1)
          end
        end
      end
      self.extend(ClassMethods)
    end

That's it. No need to rewrite, not much more code. The `compute` function is automagically cached into an instance variable `Hash` named `@fibonacci_cache`. The performance inprovements are tremendous with two additional lines of code and no additional brain work.

### The gem

Want to use it on your own? All you need to do is

    sudo gem install cache_annotations

I just released it, so it may take a day to reach all rubyforge mirrors. Detailed information and other examples may be found in the [API doc](http://contextr.rubyforge.org/cache_annotations/rdoc/). If you have any problems, ideas or comments, feel free to leave a comment or drop me a line via mail.
