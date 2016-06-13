---
title    : Static Files And Bitly Proxy On Single Domain
layout   : post
category : blog
tags     : [apache, static-site, bitly]

---

When having a super short domain name, you're probably using
[Bitly](http://bitly.com)'s service to run you custom-looking URL shortener with
full client support and nearly no setup costs.

But then you might ask yourself, why can't I also have my simple static website
on the same domain? Well, you can.

## Set up Apache2 to serve files and short URLs

Using the following Apache VHost configuration, Apache will answer all
requests locally, that match files within a certain directory. All other
requests will be proxied to Bitly.

    <VirtualHost *:80>

        # These rules just set up the serving of the static files
        ServerName short.com
        DocumentRoot /var/www/short.com

        <Directory /var/www/short.com/>
            Options FollowSymLinks
            AllowOverride None
            Order allow,deny
            Allow from all
        </Directory>

        # Now we're getting to the interesting parts
        RewriteEngine On

        # Make sure, that / is associated with your index.html document
        RewriteRule ^/$ /index.html [QSA]

        # Set's up a conditional rewrite
        # When a local file is not found
        RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
        # the request is proxied to http://bit.ly/
        RewriteRule ^/(.*)$ http://bit.ly/$1 [P,QSA,L]
    </VirtualHost>

There are some things to note.

* To make this work, you also need to ignore Bitly's setup instructions and
  point your domain's DNS record to your own server and not Bitly's.
* This works just because Bitly's slugs are globally uniq and not tied to a
  single domain. So `http://short.com/NArkjI` will point to the same URL as
  `http://bit.ly/NArkjI`.
* Every URL, that cannot be matched to your files, will be proxied to bitly.com,
  including `favicon.ico` and `robots.txt`. Also, this way Bitly may get a bit
  too much information, you might not want to share with them.
* 404 error pages are delivered by Bitly, what might confuse your users. This
  might be fixable with some more configuration.
* This setup is, of course, slower than the recommended setup where you change
  your DNS record. So do not use it on high traffic sites without further
  investigation.
