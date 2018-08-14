+++
title = "Favorite Open Source Projects"
date = "2017-10-30"
description = "A current list of my favorite open source projects"
tags = [ "Open Source" ]
layout = "blog"
+++

## Overview 

Open source projects are great in every way. Aside from being free, they offer programmers of all levels a chance to get some real world experience and contribute to the public domain. I am certainly guilty of using open source software and not contributing to it, but that is about to change.

Below is an annotated list of my favorite open source projects. I will make an effort to update this list regularly.

**Favorite Open Source Projects**
- <a href="#tldrpages">TLDR Pages</a>  
- <a href="#devdocs">DevDocs</a>

<a name="tldrpages">
## TLDR Pages
<a href="http://tldr.sh/" target="_blank">tldr.sh</a>  
<a href="https://github.com/tldr-pages/tldr" target="_blank">GitHub</a>

If you have ever been overwhelmed be a man page, TLDR pages is for you. It condenses the documentation for a program into a few simple examples. I have included a comparison below of the TLDR page for `cat`. TLDR pages has almost every command that I can think of for several linux distros, MacOS, and PowerShell. The TLDR pages output is short enough that it doesn't require a `less` window and outputs to STDOUT, allowing you to keep working without interruption.

```
$ tldr cat

  cat

  Print and concatenate files.

  - Print the contents of a file to the standard output:
    cat file

  - Concatenate several files into the target file:
    cat file1 file2 > target_file

  - Append several files into the target file:
    cat file1 file2 >> target_file

  - Number all output lines:
    cat -n file
```

<a name="devdocs">
## Dev Docs Pages
<a href="http://devdocs.io/" target="_blank">devdocs.io</a>  
<a href="https://github.com/Thibaut/devdocs" target="_blank">GitHub</a>

DevDocs is like an excellent reference book for web programming. From CSS, HTML, and JavaScript to Bootstrap, CoffeeScript, and JQuery, DevDocs has a thorough and extremely well-organized collection of web programming documentation. It includes examples, parameters/options, and explanations. I would highly recommend heading over next time you're knee deep in a web-app or website.

https://github.com/junegunn/fzf#using-homebrew-or-linuxbrew