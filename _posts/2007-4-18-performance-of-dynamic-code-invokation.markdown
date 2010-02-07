--- 
layout: post
title: Performance of Dynamic Code Invokation
---
In my new project I need to surround basic method with some wrapping code, which should be called dynamically, e.g. not each time, but under certain circumstances. In a first implementation by [Christian Neukirchen](http://chneukirchen.org/talks/euruko-2005/) this was done by adding the code in private methods and substituting the core method with code, that calls the other ones. Simple and charming.

But I will try a different approach. More details will follow later. For now I need to now, how to inject new code into a class or better a single object as fast as possible. To get the right feeling, a simple message send to the object will act as basic measuring unit.

### Implementations

I came up with these options:

- wrap your code into a block and call `instance_eval` on the object
- wrap your code into a string and call `instance_eval` on the object
- wrap your code into a method within that class and fetch the corresponding `UnboundMethod`.
  Bind that `UnboundMethod` to the object and execute it
- a variation of the former, just include the binding into the bechmark

These result in the following code:

<pre><code>
  require 'benchmark'
  
  class A
    def a
      true
    end
  end
  
  n = 1_000_000
  Benchmark.bm(30) do | b |
    instance = A.new
    b.report( "simple call" ) do
      n.times { instance.a }
    end
  
    instance = A.new
    block = lambda { true }
    b.report( "instance_eval with block" ) do
      n.times { instance.instance_eval( &block ) }
    end
  
    instance = A.new
    string = "true"
    b.report( "instance_eval with string" ) do
      n.times { instance.instance_eval( string ) }
    end
  
    method = A.instance_method( :a )
    instance = A.new
    bound_method = method.bind( instance )
    b.report( "bound method" ) do 
      n.times { bound_method.call }
    end                        
  
    method = A.instance_method( :a )
    instance = A.new
    b.report( "bind method each time" ) do
      n.times { method.bind( instance ).call }
    end
  end
</code></pre>

That was easy...

### And now the results

I tested it on Ruby 1.8.6 and Ruby's YARV trunk (2007-04-12) and JRuby trunk (2007-03-31) on my MacBook. First of all the numbers:

<table>
<thead>
  <tr>
    <th></th>
    <th>Ruby 1.8.6 (MRI)</th>
    <th>Ruby 1.9 (YARV)</th>
    <th>JRuby</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>simple call</td>
    <td><strong>1.0</strong> (0.42)*</td>
    <td><strong>1.0</strong> (0.25)</td>
    <td><strong>1.0</strong> (1.40)</td>
  </tr>
  <tr>
    <td>eval with block</td>
    <td><strong>2.5</strong> (1.08)</td>
    <td><strong>6.3</strong> (1.57)</td>
    <td><strong>1.6</strong> (2.28)</td>
  </tr>
  <tr>
    <td>eval with string</td>
    <td><strong>7.3</strong> (3.06)</td>
    <td><strong>48</strong> (12.10)</td>
    <td><strong>26.5</strong> (37.15)</td>
  </tr>
  <tr>
    <td>bound method</td>
    <td><strong>1.2</strong> (0.49)</td>
    <td><strong>1.8</strong> (0.45)</td>
    <td><strong>1.2</strong> (1.73)</td>
  </tr>
  <tr>
    <td>bind method each time</td>
    <td><strong>2.7</strong> (1.15)</td>
    <td><strong>4.3</strong> (1.08)</td>
    <td><strong>3.1</strong> (4.35)</td>
  </tr>
</tbody>
</table>

![All results in a nice graph](http://www.nach-vorne.de/assets/2007/4/18/instance_eval_graph.png)

To make it clear, I did not compare the performance of MRI with YARV or JRuby - this is done elsewhere. I also did not optimize JRuby's perfomance with some environment variables (see [this article](http://headius.blogspot.com/2007/04/paving-road-to-jruby-10-performance.html) to see what should be done). First of all, I wouldn't know which and then it wouldn't change much, because I only compare JRuby with itself. I was only interested in the fastest implementation strategie. 

And the winner is **bound method**. When I am able to cache the bound methods for all objects, then I have nearly no performance impact related to the inclusion of the "foreign code".

### Lessons learned

Do not call `instance_eval` in YARV or JRuby with a String regularly. No, no, no. It looks evil and it is really slow. The only advantage is that no closure has to be stored so it may be useful for light dynamic method definitions.


)* The numbers in brackets are seconds, the absolute results printed to stdout.
