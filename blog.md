---
layout: page
title: Blog
heading: Just a simple blog
---


These is my personal blog convering technical findings of my everyday work. So
expect the post to cover technical, mostly ruby and web related topics.

Some of the content below was originally published on other sites.

## Latest posts

<ul class="posts">
{% for post in site.posts limit: 5 %}
  <li>
    <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ul>

<div class="smallprint" markdown="1">

## Archive

{% for post in site.posts  %}

  {% capture this_year %}{{ post.date | date: "%Y" }}{% endcapture %}
  {% capture next_year %}{{ post.previous.date | date: "%Y" }}{% endcapture %}

  {% if forloop.first %}

<h2>{{this_year}}</h2>
<ul>

  {% endif %}

  <li>
  <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
  -
  <span>{{ post.date | date: "%B %e" }}</span>
  </li>

  {% if forloop.last %}

</ul>

  {% else %}
    {% if this_year != next_year %}

</ul>

<h2>{{next_year}}</h2>

<ul>
  {% endif %}
{% endif %}

{% endfor %}

</div>
