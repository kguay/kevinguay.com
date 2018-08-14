+++
title = "Find the Next Available UID/GID"
date = "2018-06-01"
description = "Find the next available uid/gid on a UNIX system"
tags = [ "Linux", "Admin" ]
layout = "blog"
+++

## New User Accounts
If you manage multiple linux servers, you know that creating users can be quite a process, especially when mounting/unmounting home directories and setting up permissions is involved. I am in the process of automating user creation with Ansible, but there is a road block that has been holding me back. Because we share home directories across systems, the user's uid and gid need to be the same on all of the servers in our environment (especially our hpc environment).

In order to automatically creat accounts, I need to be able to quickly find the next available uid/gid in a particular range (in this case the 3000's; 3000-3999).

## Finding the next available UID and/or GID
To get started, I dump the user and group files to stdout. This provides all of the uid's (/etc/passwd) and gid's(/etc/group):
```
cat /etc/group /etc/passwd
```

Next, I pipe that output to the cut command which strips off everything except the uid (for /etc/passwd) and gid (for /etc/group):
```
cat /etc/group /etc/passwd | cut -d ":" -f 3
```

I then search for all numbers that are in the range 3000-3999 using a regular expression, ```^3...$```. The ```^``` marks the start of the number so that it doesn't include (123000). The ```.```'s are wildcards and the ```$``` marks the end of the term.
```
cat /etc/group /etc/passwd | cut -d ":" -f 3 | grep "^3...$"
```

Now that we have all the numbers in our range, we need to find the highest value. To do that, I sort the list from low to high using ```sort``` and use tail -n 1 to get the last element (highest number).
```
cat /etc/group /etc/passwd | cut -d ":" -f 3 | grep "^3...$" | sort -n | tail -n 1
```

So we now have the largest uid and/or gid in our range. Since I like the uid to be the same as the gid, I don't care if I skip a gid or uid in this process, as long as it is not going to conflict with any existing id's.

Lastely we need to increment the number by one. Like other things in linux, this is more difficult than it seems, but nonetheless we have the next uid and gid ready for user creation:
```
cat /etc/group /etc/passwd | cut -d ":" -f 3 | grep "^3...$" | sort -n | tail -n 1 | awk '{ print $1+1 }'
```