---
layout: page
title: About
permalink: /about/
---
<ul class="arc-list">
{% for project in site.data.project %}
    <li><a href="{{ project.github }}">{{ project.name }}</a></li>
{% endfor %}
</ul>
