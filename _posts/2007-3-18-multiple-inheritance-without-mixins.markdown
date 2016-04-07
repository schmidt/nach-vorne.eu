---
layout: post
title: Multiple Inheritance without MixIns
permalink: /2007/3/18/multiple-inheritance-without-mixins
---
<p>This work is based on <a href="http://blog.mauricecodik.com/2006/01/ruby-multiple-inheritance.html">Maurice Codik's</a> start from last year. I spent some hours on it today and I am willing to release it to the public. The basic implementation idea didn't change, but I had to change some strategies in order to implement a reasonable method resolution order. This may also mean, that the performance of message sends suffers from these changes. So this library is not meant to work in public software, but it may be used to fool around and see what is possible.</p>

<p>My main targets where a reasonable method resolution order (namely Python-2.3's) and the functionality of the main meta object and reflection protocol of ruby (see <a href="/2007/3/18/list-of-callback-methods">this post</a> for some examples).</p>

<h2>Download</h2>

<p>You may download the library in its very first version (0.1) here. The RSpec file is available separately.</p>
<ul>
<li><a href="/mi/multipleinheritance.rb"><code>multipleinheritance.rb</code></a></li>
<li><a href="/mi/multipleinheritance_spec.rb"><code>multipleinheritance_spec.rb</code></a></li>
</ul>

<p><strong>Update:</strong> The code is now available on
<a href="http://github.com/schmidt/multiple_inheritance">GitHub</a></p>

<h2>Specification</h2>

<p>I have used Rspec to state my wishes.<br />Assuming, that <code>A</code> and <code>B</code> are direct subclasses of <code>Object</code></p>

A subclass of `A` and `B`
- should answer with `[A, B]` when sended `superclasses`
- should not list constants defined in its superclasses, when sent `constants`
- should not answer `true` to `const_defined?` for constants defined in `A` or `B`
- should answer `true` to `const_defined?` for constants defined in it
- should list methods of its superclasses in `instance_methods( true )`

The Ancestors of a subclass of `A` and `B`
- should contain `A`, `B` and `Object`
- should have `A` as first element
- should not include double entries
- should contain `A` before `B`
- should contain `B` before `Object`

An instance of a subclass of `A` and `B`
- should be kind of its class
- should be kind of its super classes
- should be kind of its super super classes
- should prefer its own methods over inherited ones
- should be able to call inherited methods
- should be able to combine inherited calls
- should prefer methods defined in `A` over `Object`'s
- should prefer methods defined in `B` over `Object`'s
- should prefer methods defined in `A` over `B`'s (left first)
- should be able to use `method_missing`
- should be able to use `method_missing` in one of its parents
- should answer `respond_to?( 'some method in A' )` with `true`
- should answer `respond_to?( 'some method in B' )` with `true`
- should answer `respond_to?( 'some method in Object' )` with `true`
- should be able to access constants defined in superclasses directly
- should be able to use `const_missing`
- should list methods of its superclasses in `methods`
- should be able to use methods from `A` and `B` using own instance variables
- should be able to use blocks for methods in superclasses

When `A` and `B` are subclassed by a class, they
- should be informed via `self.inherited( subclass )`

<p>I did not yet work on instance or class variables, as well as the behaviour of private or protected methods (who uses them anyway?). Please send me your ideas or bug reports. I am sure, that this is far from perfect.</p>
