---
layout: page
title: Just a simple blog
tagline: Don't expect rocket sciene
---
{% include JB/setup %}


This is my personal blog. It is fueled by my daily work, so expect it to be
technical, mostly ruby and web related. It also touches operations and may also
contain some links to other pages, I find interesting.

## Latest posts

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

If you are interested in my professional work, please head over to
[schm.eu](https://schm.eu/).
