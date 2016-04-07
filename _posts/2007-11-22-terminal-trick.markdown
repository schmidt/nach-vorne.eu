---
layout: post
title: Terminal Trick
permalink: /2007/11/22/terminal-trick
---
Mostly off topic, but I wanted to share it anyway.

We terminal cowboys often have the same problem. I'm in my current workspace,
represented by a certain directory. But I would like to open a new Terminal
window pointing to exactly the same directory. Hitting
\[Apple\]+\[n\](1) will open a new window, but is points to `$HOME`.
(Sidenote: `gnome-terminal` knows its customers better. It opens at the same
location. When I wanted to be at `$HOME`, I could easily enter `cd` and be
there.)

But I'm working on Mac OS and nearly every application made by Apple is
scriptable with AppleScript, so is Terminal. I fetched one of the "Open
Terminal Here" scripts to open a terminal from Finder. But I could not get
behind the syntax. It looks great and is got to get, but difficult to write,
when unfamiliar with it. But I could extract the right portions to open a
Terminal at a given directory. But how do I fetch this one. Hmm.

The solution is pretty simple. Use a language, where I know how to fetch the
current directory: Ruby. There is a great gem called
[rb-appscript](http://rb-appscript.rubyforge.org/). It's a Ruby-AppleScript
bridge and does what I want. It's not easy to fetch the syntax here as well,
but I just wanted to translate two lines, trial and error did the job.

### The Result

... is a litte ruby script placed in '/usr/local/bin' called ot (Open Terminal)
and it is not more but the following:

<pre><code>#!/usr/bin/env ruby -rubygems

require 'appscript'
include Appscript

term = app("Terminal")
term.activate
term.do_script(:with_command => "cd #{Dir.pwd}")
</code></pre>

Now I can easily do what I want. If you are always using Terminal and calling
the script only from one, you can even boil it down to three lines:

<pre><code>#!/usr/bin/env ruby -rubygems

require 'appscript'
Appscript::app("Terminal").do_script(:with_command => "cd #{Dir.pwd}")
</code></pre>

The nicities of open source and open architectures. It was a pleasure.

(1): Yes I call the "command key" "apple key", because everybody will
instantly know what I mean. I'm not a fan of removing this icon from the
keyboard.
