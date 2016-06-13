---
layout: post
title: Quick Rake Goodies
permalink: /2008/2/27/rake-quickies/

---

Since we are all social guys, telling everybody what we are doing right now, as
often and as detailed as possible, it is just right, to do this automatically.
So for everybody living on the command line and in Ruby the following quick
snippets might be useful.

As you might know, I'm currently writing my master's thesis -- in LaTeX. And
there is a quick command to calculate the current word count.

    detex mainfile.tex | wc -w

`detex` strips all the LaTeX commands out of your document, but it follows
includes, so all you got in the end is a plain text version on STDOUT. `wc` is
one of this great old unix tools, it simply counts lines, words and characters.
The `-w` options limits the output to a single number -- the number of words.

This will be the first building block.

### Skype

The first target of social striptease will be Skype. At least in my contact
list, it is usual to let everybody know what you are listening to, where you are
and what you are doing, with the help of mood messages. Sometimes they are even
used for chatting. To set a mood message from the command line is pretty easy. I
will be using the `rb-appscript` gem which allows to execute AppleScript from
Ruby. Consequently this works only on a Mac.

    require 'rubygems'
    require 'appscript'
    include Appscript

    app("Skype").send_ :script_name => "Raketask",
                       :command => "SET PROFILE MOOD_TEXT I'm in Ruby mood"

The necessary information for this snippet were taken from the [`rb-skypemac`
gem](http://rb-skypemac.rubyforge.org/) (the way to talk to Skype via
`rb-appscript`) and from this [blog post
(german)](http://blog.grundprinzip.de/articles/2008/02/25/mac-skype-status-von-der-kommandozeile-setzen/)
of a friend of mine (the way to set a mood message via AppleScript).

### Twitter

Wouldn't it be great if all my friends get an SMS, when I wrote five words, yes
it would. So let's build a simple Twitter integration. There is the great
`twitter` gem which let's you forget all the API nastiness and gives you really
simple access from Ruby and your plain old command line. If you set up your
Twitter credentials in `~/.twitter` the command line tool automatically picks
them to authenticate. I will use them to minimize the setup costs.
Unfortunately, the Ruby API has no official way to access the config file in
your home directory. But this is not a reason to stop. I'm using the send method
here to circumvent visibility restrictions.

    require "rubygems"
    require "twitter"
    require "twitter/command"

    config = Twitter::Command.send(:create_or_find_config)

    Twitter::Base.new(config['email'], config['password']).post("Ruby? Anybody?")

### All together now

I have a Rakefile to compile my thesis using latex. In there are options to do a
quick compile for preview and a longer compile including images for a final
version. I have a task to open the generated PDF in Preview (using AppleScript
again) or to fetch my bibtex file from
[bibsonomy.org](http://www.bibsonomy.org). So why not add tasks to count words
and to post the current status to Skype and Twitter. Now we have everything in
place. So without and further ado, here is a snippet from my Rakefile:

    desc "Counts words of main document"
    task :count do
      puts "#{`detex #{PROJECT_NAME} | wc -w`.strip} words in thesis"
      if (file = ENV["file"])
        puts "#{`detex #{file} | wc -w`.strip} words in #{file}"
      end
    end

This is the main `count` task. It simply prints the current word count to the
command line. Additionally it is possible to count the words in a single file by
passing in a file parameter (`rake count file=chapter_1.tex`).

    namespace :count do
      def count
        count = `detex #{PROJECT_NAME} | wc -w`.strip
        "Current word count in master's thesis: #{count}"
      end

      desc "Post word count to Twitter"
      task :twitter do
        require "rubygems"
        require "twitter"
        require "twitter/command"

        config = Twitter::Command.send(:create_or_find_config)

        Twitter::Base.new(config['email'], config['password']).post(count)
      end

      desc "Post word count to Skype"
      task :skype do
        require 'rubygems'
        require 'appscript'
        include Appscript

        app("Skype").send_ :script_name => "Raketask",
                           :command => "SET PROFILE MOOD_TEXT #{count}"
      end
    end

This code may look familiar. It is the Skype and Twitter integration. The task
use a common method `count` to get the numbers from the command line.

This were the not so quick Rake goodies. Thanks for your attention.
