---
title: Monkey-Patching User in ChiliProject
layout: post
tags : [chiliproject, plugin, ruby]
---
{% include JB/setup %}

Here is how to patch the `User` model within a ChiliProject plugin.

## What's the deal?

When ever you try to patch the `User` model you will see weird errors like
`Expected user.rb to define User` and such. Sometimes it is even more subtile.
The cause is often, that the tight dependecies between the `User`, `Principal`
and `Project` models are not loaded properly - most often caused by a plugin
which uses `require_dependency` to load one of them.

## And the fix:

I was running into this problem multiple times and I wanted to note - once and
for all - you will need the following statements to make it work:

    require_dependency 'project'
    require_dependency 'principal'
    require_dependency 'user'

Then everything should be good to go.

### See it in action

At the moment, you may see this in action
in the [Safe Password Hashes for ChiliProject
plugin](https://github.com/schmidt/chiliproject_safe_password_hashes). Have a
closer look at the
[`user_patch.rb`](https://github.com/schmidt/chiliproject_safe_password_hashes/blob/master/lib/safe_password_hashes/patches/user_patch.rb#L1-L3).
