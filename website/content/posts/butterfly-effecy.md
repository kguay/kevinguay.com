+++
date = "2018-11-12T04:00:00+00:00"
description = "How a full disk took down an entire network"
layout = "blog"
tags = ["IT"]
title = "The Butterfly Effect"
draft = "true"
+++

Let me set it up:
We have two physical servers that host our Windows virtual machines.
The virtual machine files are stored on the NetApp storage system.
We have redundant active directory (user permissions) and DNS (IP address phone book) servers, one on each physical server.
Somehow (that's the why that I'm looking into) all of the virtual machines running on those two servers went offline at the same time yesterday. Okay, so just start them back up, right? Not so fast, the NetApp shares that the virtual machine files are stored on (2 above) are accessed using permissions from active directory. Since active directory was offline, I couldn't access the shares with the VM files. Catch 22. After a few good ideas that decided to have slow and/or lousy results, I booted up an old copy of the active directory server on a different virtualization system that used NFS, not windows permissions (thereby bypassing active directory for authentication). That enabled the physical servers to auth and mount the storage shares.