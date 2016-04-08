---
layout: post
title: structured_warnings Highlights
permalink: /2008/2/22/structured_warnings-highlights
---
After my short Announcement yesterday, I'd like to go on an name some of the
highlights.

Besides the basic functionality proposed in [the original
article](http://www.oreillynet.com/ruby/blog/2008/02/structured_warnings_now.html),
it has some more neat features, that make the life of its users enjoyable and
fun.

So you better start using structured_warnings now.

### Dynamic scoping

Using the block syntax to disable warnings provides a dynamic scope of
deactivation. Not only everything within the block will raise no warning, but
every piece of code, that is accessed from there on. This can become very
powerful for certain uses.

### Last one wins

You never know exactly, so deactivating a warning for a dynamic scope may be
overridden by enabling it again in a deeper scope and the other way round.

### Warner architecture

Each warning is passed to a warner instance, which it there to format the
information, which is put to stdout. This warner may be changed for --again -- a
dynamic scope. This way you may instruct your favourite web framework to use a
specific warner, that fetches all the information and writes it to a database
instead of stdout.

Perhaps you want to have warnings in your merchant library to be to you via
twitter message. Who knows? It will be pretty easy. Just have a look at the
warner that is used for the test assertions. It will give you a good start.

### Inheritance done right

Instead of redefining the `Kernel#warn` method directly, structured_warnings
simply defines its own `warn`. The module is mixed into Object, so that every
warn will go to this implementation first. After collecting all the necessary
information, checking if the current warning is not disabled and formatting the
output, the resulting message is passed on to the base implementation.

This way it is possible to add other extensions to you warning mechanism, you
may freely redirect stderr to whatever you want. structured_warnings `warn` will
just do, what it is supposed to.

### Fully documented sources

Today I finished the documentation part. Now each and every method, public or
not is documented. Just have a look at the [RDoc generated API
site](http://rug-b.rubyforge.org/structured_warnings/rdoc).

### Performance

Come on. The main goal is to avoid the use of code, that raises warnings. With
the help of this library it is as easy as it gets to do that. A warning should
always be an exception (not in the sense of the Ruby class, but in the sense of
"not common"), so who will be concerned about performance.

The only thing I can tell you is, that structured_warnings will slow down calls
to `warn` but it will not slow down your whole code and that is what counts.
