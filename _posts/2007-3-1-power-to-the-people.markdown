--- 
layout: post
title: Power to the People
---
<p>On <a href="http://www.antoniocangiano.com/articles/2007/02/19/ruby-implementations-shootout-ruby-vs-yarv-vs-jruby-vs-gardens-point-ruby-net-vs-rubinius-vs-cardinal">Zen and the Art of Ruby Programming</a> Antonio Cangiano compares the speed of several Ruby implementations.</p>

<p>Interesting to see, that YARV is that much faster. On my particular problem, which mainly consists of message sends and each-loops, I expirienced only 10 % improvements over the standard ruby distribution. So I should review my implementation to gain improvements there, no chance to get it for free on other interpreters.</p>
