---
layout: post
title: attr_accessor on Steroids
permalink: /2007/4/24/attr_accessor-on-steroids/

---

Every Ruby programmer knows the nice metaprogramming feature of `att_reader`,
`attr_writer`, and `attr_accessor`. You use them, I use them, everybody does.
There is nothing wrong with them. But how often do you write things like this:

<pre><code>  class Foo
    attr_accessor :bar

    def initialize
      self.bar = Hash.new
    end
  end
</code></pre>

Or as well something like this:

<pre><code>  class Foo
    attr_writer :foo
    def foo
      @foo ||= Hash.new
    end
  end
</code></pre>

I do. And this is simply annoying. It's not nice and slow in certain occasions.
I will support this with some easy benchmarks in MRI (Ruby 1.8.6)

## Benching ##

I tested different scenarios. How long takes the initialization of a new
Object. What about the first access and what about consequtive accesses. I
benched them for each implementation strategy and tried to set the number of
iterations to a maximum runtime of 2 seconds. As you would guess, testing the
setting of a new value does not make much sense. It tried anyway and they are
equal - so forget about it.

<table>
<thead><tr>
<th>Strategy</th>
<th>Initialization (1,000,000)</th>
<th>First Access (100,000)</th>
<th>Consequtive Access (4,000,000)</th>
</tr></thead>
<tbody>
<tr><td>Initializer</td><td>2.0</td><td>0.05</td><td>1.3</td></tr>
<tr><td>Custom Setter</td><td>0.7</td><td>0.1</td><td>2.0</td></tr>
</tbody>
</table>

What we see is, that ( 0.1 is not close to a maximum value of 2.0 seconds, but
just wait some lines and ) everything behaves as expected. The first
implementation is expensive on initialization, the other is more expensive when
it comes to reading.

I wonder if there is something, that could combine the pros of both concepts.
As you already see, this one would be a lot more expensive on the first read,
but there is no such thing as free lunch.

## Meta Magic ##

Let's look, what is already there. There is for example ActiveSupport's Module
extension called `attr_accessor_with_default` - currently only in [the
trunk](http://svn.rubyonrails.org/rails/trunk/activesupport/lib/active_support/core_ext/module/attr_accessor_with_default.rb).
But it has two downsides.

- It does not set the actual default value, it just returns on, if there is
  none. This may be right for certain cases, but not for me.
- It uses `module_eval` with a string, and we have [just
  learned](/2007/4/18/performance-of-dynamic-code-invokation), that this will
  not be good in the future

But I used that approach to implement my own idea. Its name is
`attr_accessor_with_default_setter`. This is neither cool nor short, but it

- does not clash with ActiveSupport's naming and since it provides different
  semantics this would hurt
- stresses the fact, that it actually sets the default value whenever it was
  accessed

### `attr_accessor_with_default_setter` ###

<pre><code>  class Module
    def attr_accessor_with_default_setter( *syms, &amp;block )
      raise 'Default value in block required' unless block
      syms.each do | sym |
        module_eval do
          attr_writer( sym )
          define_method( sym ) do | |
            class &lt;&lt; self; self; end.class_eval do
              attr_reader( sym )
            end
            if instance_variables.include? "@#{sym}"
              instance_variable_get( "@#{sym}" )
            else
              instance_variable_set( "@#{sym}", block.call )
            end
          end
        end
      end
      nil
    end
  end
</code></pre>

The implementation is pretty basic. It mixes the two approaches above. First of
all it adds an `attr_writer` since it cannot hurt and it places a method as
getter that sets the instance variable to the default value and afterwards
replaces itself with the general `attr_writer`. Of course, somebody could have
set the instance variable without using the default reader first - therefore
whe have to check, whether it was already used, before applying the default
value and that's it.

### The Usage ###

<pre><code>  class Foo
    attr_accessor_with_default_setter :bar do
      Hash.new
    end
  end
</code></pre>

Pretty nice, despite the long name. But it was not my main goal to nice things
up. Although there is one occasion, where it is actually a lot more DRY. Just
imagine multiple instance variables that all have the same default value. This
would become talkative with the other approaches.

<pre><code>  class Solution
    attr_accessor_with_default_setter :pros, :cons do
      Array.new
    end
  end
</code></pre>

### What else ###

Okay, now it has to run next to the other implementations in my tiny benchmark.
I will repeat the other values for better comparison:

<table>
<thead><tr>
<th>Strategy</th>
<th>Initialization (1,000,000)</th>
<th>First Access (100,000)</th>
<th>Consequtive Access (4,000,000)</th>
</tr></thead>
<tbody>
<tr><td>Initializer</td><td>2.0</td><td>0.05</td><td>1.3</td></tr>
<tr><td>Custom Setter</td><td>0.7</td><td>0.1</td><td>2.0</td></tr>
<tr><td>Meta Magic</td><td>0.7</td><td>2.0</td><td>1.3</td></tr>
</tbody>
</table>

![Perfomance of Different Default Value Implementations on
MRI](/assets/2007/4/24/graph.png)

It performs as expected. It is as fast on initialization and consequtive
accessing as the best in these disciplines. Only one big downside: the first
access is really slow. It has to `module_eval`, reflect on instance variables,
and define a method. This takes a lot more time.



## What we have learned ##

There is not single solution to this problem. If you want it fast, you have to
evaluate the options. But I hope everybody is equipped with the needed
knowledge now.

**Annotation**: The actual results may differ from interpreter to interpreter,
but the overall / relative values will remain the same.
