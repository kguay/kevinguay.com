+++
title = "Mounting CIFS in CentOS 7"
date = "2017-11-20"
description = "Change in the way you mount CIFS shares in CentOS 7 vs CentOS 6."
tags = [ "Server" ]
layout = "blog"
+++

## The Problem

Most of my servers (virtual machines) are running CentOS 6, but the new ones run CentOS 7. This morning I setup a new CentOS 7 box and was trying to mount a CIFS storage share to it. I copied the line in `/etc/fstab` that mounts the share, created the secure credentials file, and the mount directory. However, when I ran `mount /mnt/share` it failed with the following error:

```
mount error(5): Input/output error
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
```

I checked, double checked, and rechecked every character in `/etc/fstab`. Everything was spot on. I was DuckDuckGoing the error message, cifs mounting instructions, /etc/fstab syntax, etc.. Nothing.

## The Solution

It turns out that in CentOS 7, with cifs-utils 6.2 vs 4.8 in CentOS 6), you need to specify the security mode that you are using. In this case, I needed to add `sec=ntlm` to my mount command in `/etc/fstab`. The line ended up looking like:

```
//10.2.1.2	/mnt/share	cifs	credentials=/etc/samba/credentials/private,file_mode=0777,dir_mode=0777,sec=ntlm	0 0
```

According the to cifs-utils [man page](https://www.unix.com/man-page/debian/8/mount.cifs/), the default security mode is ntlm, so you shouldn't have to specify it. But you do. If you can provide any rhyme or reason, I'd be interested.

```
sec=
	Security mode. Allowed values are:
	• none attempt to connection as a null user (no name)
	• krb5 Use Kerberos version 5 authentication
	• krb5i Use Kerberos authentication and forcibly enable packet signing
	• ntlm Use NTLM password hashing (default)
	• ntlmi Use NTLM password hashing and force packet signing
	• ntlmv2 Use NTLMv2 password hashing
	• ntlmv2i Use NTLMv2 password hashing and force packet signing
	• ntlmssp Use NTLMv2 password hashing encapsulated in Raw NTLMSSP message
	• ntlmsspi Use NTLMv2 password hashing encapsulated in Raw NTLMSSP message, and force packet signing
```