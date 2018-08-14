+++
title = "Ansible OS Distribution and Version"
date = "2017-12-26"
description = "Print out the distro and version for Fedora, CentOS, and Red Hat hosts"
tags = [ "Ansible", "HTML" ]
layout = "blog"
+++

## The Gist

Ansible has built-in "facts" about your hosts that make it easy to find basic information such as hostname, operating system, IP address. This is great for debugging or inventorying systems, however OS version is not included and it was surprisingly difficult to find a way to print this information out. I understand that Ansible is OS-independant (and hence OS-version-independant), however, it can be useful to know which servers are running CentOS/RH 6 vs 7.

The following playbook prints out the OS name and version using the contents of /etc/system-release. This file works for all Fedora deriviatives (e.g. CentOS and Red Hat), but you might run into trouble if you run it on another distro.

```
- name: Print linux distribution and version
  hosts: all
  tasks:
    - name: capture output of id command
      command: cat /etc/system-release
      register: login
    - debug: msg="{{ login.stdout }}"
```