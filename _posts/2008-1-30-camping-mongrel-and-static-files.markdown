---
layout: post
title: Camping, Mongrel and Static Files
permalink: /2008/1/30/camping-mongrel-and-static-files
---
After some time, I continued to work on my latest Camping project. But unfortunately, I didn't work as expected. The problem is easily spotted, static files were not delivered, the dynamics were just fine.

To cut it short: The solution is simple. There is a slight incompatibility concerning the `X-Sendfile` header between Camping and Mongrel v&nbsp;1.1.3 (ref. [1](http://code.whytheluckystiff.net/camping/wiki/ServingStaticFiles)). Until the problem is solved in v&nbsp;1.1.4 you shall simply stick to the older Mongrel. 

In order to get Camping to use it you need to change the camping executable. I recommend using the latest version of Camping from the Subversion repository. You may download it with a simple `svn co http://code.whytheluckystiff.net/svn/camping/trunk camping`. The change is in `bin/camping` around line 88:

    ...
    begin
      gem 'mongrel', "<1.1.3"
      require 'mongrel'
      require 'mongrel/camping'
      ...

A simple `rake gem` and `sudo gem install pkg/camping-1.8.gem` will install the changes to your system.

Happy Camping, again.
