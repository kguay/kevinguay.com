+++
title = "Hugo: HTML code in content files"
date = "2018-01-18"
description = "How to use HTML code in Hugo content files"
tags = [ "Hugo", "HTML" ]
layout = "blog"
+++

## TL;DR
You can use HTML in Hugo content files (markdown files) by including *some* (any) markdown code at the top of the page (e.g. an empty header `# `).

## Background

I recently switched this website's backend to Hugo instead of [HarpJS](http://harpjs.com/). I have been using HarpJS for two years and love it. It is a very minimal static website compiler that has support for some great languages, including Pug (formerly Jade), Sass/Less, as well as the usual suspects, including HTML (EJS) and Markdown. Furthermore, very little is required structure for the HarpJS websites. It sees a file and compiles it into the website.

Switching to Hugo required making some compromises (including dropping my beloved Pug code - it really is an excellent language). But, there are plenty of benefits, including a blog-centric structure, continuing development (Jade hasn't been updated for over a year), and a much more robust templating engine.

## A mediocre workaround: shortcodes

One major drawback to Hugo is that content files are required to be Markdown. This was a bit difficult for me to swallow. It is a great concept to simplify content files and leave the layout/styling up to the templates and stylesheets. This is still somewhat limiting.

For example, I wanted to use specific classes for my resume. Or use a bootstrap grid on my photography page. But Hugo only offers a roundabout way to specify classes. Shortcodes are custom template objects that one define in HTML code (in the layout files) and can use in the Markdown (content). To specify a div with my class, I created the following shortcode:

/layouts/div.html
```html
<div class="{{.Get "class"}}">
  {{.Inner}}
</div>
```

Then, I could use that to create a simple bootstrap grid

```
{{ % div class="row" % }}
{{ % div class="col-sm-2" % }}
<img src="/images/one.jpg">
{{ % /div %}}
{{ % div class="col-sm-2" % }}
<img src="/images/two.jpg">
{{ % /div % }}
{{ % /div % }}
```

Verdict: possible, but extremely inconvenient. There has to be a better way...

## HTML code in content files (Markdown)

I tried using html files (e.g. blog-post.html) in my content folder, but the page would not compile with the rest of the site (no styling, headers, footer, etc.). I also tried writing HTML code directly into the markdown file (e.g. blogpost.md with html code). This didn't work either.

I did find, however, that you can use HTML code within a markdown file as long as there is also markdown code present. Specifically, the file needs to *start* with markdown code.

The minimum you can do to make HTML work in Markdown (with Hugo) is to use an empty header at the top of your page. For example, the following file is completely legal. Just make sure that there is a space after the # in the first line; otherwise, it will display a "#" on the page.

```
# 

<div class="row">
  <div class="col-sm-2">
    <img src="/images/one.jpg">
  </div>
  <div class="col-sm-2">
    <img src="/images/one.jpg">
  </div>
</div>
```