---
layout: post
title: Written in Ruby
permalink: /2007/3/1/written-in-ruby/

---

In this article I'ld like to point out, why "written in Ruby" is a pro and never
a con for each Ruby related software, e.g. interpreter, libraries and IDE.

In her daily life a ruby programmer probably prefers c-libraries over native
ruby ones, because of their tremendous speed advatages. Nobody likes to
compare Rexml with libxml on that battle ground. But the usage of non-native
tools hampers Ruby's general development. The need to improve the interpreters
speed decreases. The quality of libraries may not be reviewed, like it could
when written in a language every user of it understand.

I'd like to cite popular examples here: Lisp and Smalltalk. Both based on a
really really really small core written in whatever language and afterwards
bootstrapped to be implemented in itself, running on byte code (I have no
problem with a speedy AST interpreter, but I haven't seen one yet). Each and
every Smalltalk user is able to change the inner windings of its standard
library without speed loss usage of RubyInline (which is really great by the
way, although I would feel better, if we wouldn't need it). This is where I
would love to se Ruby in 2 to 5 years. And that is why I would prefer the <a
href="http://blog.fallingsnow.net/rubinius/" title="by Evan
Phoenix">Rubinius</a> approach over YARV. Even porting the AST to Smalltalk byte
code, as <a href="http://smallthought.com/avi/?p=19" title="A well known Seaside
hacker">Avi Bryant</a> proposes it, could work well. Just get rid of this old
school c code, please.

But I will have a look on that in the future and comment on it, as something
happens.

<strong>post:</strong> Did I mention, that the above statements are the reason,
why this blog uses <a href="http://www.mephistoblog.com/">mephisto</a> and not
wordpress, although its feature set is more promising and the performance
outstanding in comparison. Apache is c but <a
href="http://mongrel.rubyforge.org/">mongrel</a> is said to be Ruby in large
parts although I didn't check.
