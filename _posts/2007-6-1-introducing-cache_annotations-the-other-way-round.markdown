---
layout: post
title: Introducing cache_annotations the other way round
permalink: /2007/6/1/introducing-cache_annotations-the-other-way-round/

---

In [one of my last articles](/2007/5/28/cache_annotations-release-to-the-wild) I
introduced my [lasted gem
`cache_annotations`](http://contextr.rubyforge.org/cache_annotations/rdoc/).
Today I think it was explained as black vodoo, which might be uncomfortable to
most readers. Therefore, I'll start again, but the otherway round and everybody
will love its simplicity.

## cache_annotations

With CacheAnnotation you may easily provide your methods with an often needed
caching. Suppose you are using the following piece of code:

    class A
      def a
        @a ||= "some heavy computing that should be" +
            " done only once"
      end
    end

This could look so much better:

    class A
      include CacheAnnotation

      cached
      def a
        "some heavy computing that should be done only once"
      end
    end

Or even better for single argumented methods:

    class A
      def b(arg0)
        @b ||= {}
        @b[arg0] ||= "some heavy computing in " +
                     "respect to #{arg0} " +
                     "that should be done only once"
      end
    end

vs.

    class A
      include CacheAnnotation

      cached
      def b(arg0)
        "some heavy computing in respect to #{arg0} " +
        "that should be done only once"
      end
    end


Behind the scenes, CacheAnnotation replaces the method body with the caching
code. So the two versions are equal concerning behaviour and speed. If you don't
want CacheAnnotation to derive the instance variable's name from the method
name, you may supply a custom one:

    class A
      include CacheAnnotation

      cached :in => :@b_cache
      def b(arg0)
        "some heavy computing in respect to #{arg0} " +
        "that should be done only once"
      end
    end

If you want to use CacheAnnotation on the class side, you have to use a
special technique to add these methods. It is described pretty good on
http://www.dcmanges.com/blog/27

    class A
      module ClassMethods
        include CacheAnnotation

        cached
        def c
          "some heavy computing that should " +
                "be done only once"
        end
      end
      self.extend(ClassMethods)
    end

## Final Remarks

That's all the voodoo. Generating a simple method for you, basically the same
thing `attr_*` does.

You will find other chunks of repeated code and you should think, if this could
be stripped of and be used in a declarative way.
