---
layout: post
title: Mechanize Use Case
permalink: /2008/3/16/mechanize-use-case
---
I'm using [www.bibsonomy.org](http://www.bibsonomy.org) to manage my bibtex entries. This is a must have, when writing any scientific paper. Bibsonomy is like del.icio.us just for bibtex. Among the social and webscraping features to collect bibliography entries it has a bibtex export to create `.bib`-files for your local latex project.

The problem, we will solve today: Fetch the bibtex export from bibsonomy.

### The older solution:

    wget http://www.bibsonomy.org/bib/user/schmidtwisser?items=1000 -O literatur.bib

This solution is simple and was useful for a long time. Unfortunately I recently added private bib-entries. Since this solution doesn't use any authentication, it only delivers my public entries. 

### Mechanize

So I needed to either use bibsonomy's API, which would need registration, or I need to authenticate, keep the cookie and then fetch my bibliography. Enter [mechanize](http://mechanize.rubyforge.org/):

    require "rubygems"
    require "active_support"
    require "mechanize"

    config = YAML::load_file(File.join(ENV['HOME'], 
                                       ".bibsonomy.yml")).symbolize_keys

    agent = WWW::Mechanize.new
    page = agent.get('http://www.bibsonomy.org/')

    form = page.forms.action('/login_process').first
    form.userName = config[:username]
    form.loginPassword = config[:password] 
    page = agent.submit(form)

    page = agent.get("/bib/user/#{config[:username]}?items=1000")

    File.open("literatur.bib", "w") do |f|
      f.puts page.body 
    end

It is so easy, I won't even explain the code. 

Just one bit: Don't embed your password in any public code, so do I. My credentials are therefore stored in my Home-directory.
