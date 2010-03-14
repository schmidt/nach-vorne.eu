--- 
layout: post
title: "[Ann] structured_warnings 0.1.0 released"
permalink: /2008/2/21/ann-structured_warnings-0-1-0-released/index.html
---
Read [this article by Daniel Berger](http://www.oreillynet.com/ruby/blog/2008/02/structured_warnings_now.html) first.

I just implemented his suggestions and made them available via RubyGems and our [rug-b](http://www.rug-b.com/) Rubyforge account. Have a look at the [gems website](http://rug-b.rubyforge.org/structured_warnings/) and leave me a comment, if you like.

A simple `gem install structured_warnings` will bring it to your machine, another `require 'structured_warnings'` brings it to your project and tests.

The implementation relies heavily on [Christian Neukirchen](http://chneukirchen.org/)'s [dynamic.rb](http://chneukirchen.org/talks/euruko-2005/dynamic.rb).

**Disclaimer**: I cannot manipulate the `rb_warn` method, so all the "method redefined", "void context" and "parenthesis" warnings will remain active.
