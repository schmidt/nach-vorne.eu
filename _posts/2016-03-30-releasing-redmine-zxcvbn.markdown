---
title    : "Releasing redmine_zxcvbn 1.0.0"
layout   : post
category : blog
tags     : [redmine, security, plugin]

---

Today I stumbled upon an article named [Stop forcing your arbitrary password
rules on
me](https://ryanwinchester.ca/posts/stop-forcing-your-arbitrary-password-rules-on-me)
by Ryan Winchester. The author explains in detail, why it's a bad idea to
force arbitrary password requirements like the following:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en"
dir="ltr">&quot;Your password must be at least 8 characters including one
uppercase letter, one number, 3 Emojis &amp; the first verse of Bohemian
Rhapsody&quot;.</p>&mdash; I Am Devloper (@iamdevloper) <a
href="https://twitter.com/iamdevloper/status/532842741873803264">November 13,
2014</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Instead he proposes to force a minimum password entropy and suggests to use
[Dropbox's zxcvbn
library](https://github.com/dropbox/zxcvbn) to calculate that. In other words:
A short password using a wide range of characters should be as good as a long
one using a more limited set.


### No rules!

I say: **A regular service should never force a minimum password requirement.**
Maybe your users are creating a dummy account and want to test some features.
Forcing a minimum password strength will only lower conversions and won't
protect anything valuable. Instead we should only encourage them to use a good
password. Using a strength indicator without any enforcements -- maybe combined
with a simple minimum length requirement -- will be all you need to protect
those accounts, that need protection.


And therefore I present
[redmine\_zxcvbn](https://github.com/schmidt/redmine_zxcvbn). It's a redmine
plugin which adds a strength/quality indicator to all password fields throughout
[Redmine](https://www.redmine.org/). It does not add any server side
requirements concerning password quality. It only shows a little progress bar
below the password field which will inform the user about the quality of their
choice. It remains their responsibility to pick a password which is fit to their
security requirements.

![Screenshot](https://raw.githubusercontent.com/schmidt/redmine_zxcvbn/master/assets/doc/zxcvbn.png)


Installation
------------

Head over to [GitHub](https://github.com/schmidt/redmine_zxcvbn). You may find
all the nitty gritty details in the README. I am missing something? Please
create [a bug report here](https://github.com/schmidt/redmine_zxcvbn/issues).

The plugin is also listed in the [Redmine Plugin
directory](https://www.redmine.org/plugins/redmine_zxcvbn). So if you like it,
please go there and leave a 5 star review.
