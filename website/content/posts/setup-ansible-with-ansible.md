+++
title = "Setting Up Ansible with Ansible"
date = "2017-10-31"
description = "How to use Ansible for initial Ansible configuration"
tags = [ "Ansible" ]
layout = "blog"
+++

## Background

I am responsible for a few dozen linux servers at work, and although there was an effort to install Salt a few years ago, they are all managed individually and manually. I spend more time than I should ssh'ing into boxes to add users. install applications, or restart services. I looked into Puppet a few months ago, but it seemed to complicated and clunky for my environment. Specialty, I really didn't want to install and troubleshoot the client on dozens of serveres. A few people had recommended Ansible to me, and it looked like a gerat option.
<!-- more -->
After waiting two months for the second edition to come out, I picked up a copy of Ansible Up & Running by Lorin Hochstien and Rene Moser. Realizing that I wouldn't have time to read through the text at work, it became my nighttime reading. After only one chapter, I felt confident that it was the right choice for my current environment (~40 CentOS and RHEL virtual and physical machines.) It was easy to install on my mac using Homebrew and just as easy to start using. Best of all, I didn't have to ssh into every machine on the network to install a client, but I did need to create Ansible users on the machines.

That meant, for 40+ servers, I needed to:
 - create an ansible user
 - add the user to wheel
 - enable passwordless sudo for that user
 - add a public key to the user's authorize_keys file

That would have taken me at least a few hours and I would have probably misconfigured at least one of the servers. That was before Ansible. From what I had learned in the first chapter, I was able to use my current user account (in wheel) to run the needed configuration without manually logging into each machine.

## Here's how I did it:

### Configuration:

In the configuration file (`ansible.cfg`), I set the remote user to myself, and instead of using a private key for authentication, I set the `ask_pass` flag to true. With this flag set, Ansible will prompt me for my password *once* when I run the playbook. I have also disabled host key checking (`host_key_checking = False`) to speed things up.

```ini
[defaults]
inventory = hosts
remote_user = kguay
ask_pass = True
host_key_checking = False
ansible_port = 22
```

### Playbook:
Since we don't use passwordless sudo for anything other than Ansible, that line in the sudoers file was commented out. I used that comment in the regular expression (see last section below) to select the correct line in sudoers (if you don't use that comment in your RE, it will select the wrong line, enabling passwordless ssh for all users in wheel). Instead of setting it to `%wheel ALL=(ALL) NOPASSWD: ALL`, I specified the ansible user. As much as I dread typing in my password twice, it is worth it to prevent accidental sudo's.

```yaml
- name: Add users
  hosts: all
  become: True
  tasks:
    - group:
        name: ansible
        gid: 2000
        state: present
    
    - user:
        name: ansible
        comment: "Ansible"
        uid: 2000
        group: ansible
        groups: wheel
    
    - name: Set authorized key took from file
      authorized_key:
        user: ansible
        state: present
        key: "{{ lookup('file', 'id-rsa.pub') }}"
    
    - name: Allow 'wheel' group to have passwordless sudo
      lineinfile:
        dest: /etc/sudoers
        state: present
        regexp: '^# %wheel'
        line: '%ansible ALL=(ALL) NOPASSWD: ALL'
```

### Running the playbook:

When I run the playbook, I use the `--ask-become-pass` (`-K`) option to prompt the user for the sudo password. You should be prompted twice (once for the user password and once for the sudo password). In most cases these will be the same, but you still need to enter it twice.

```
$ ansible-playbook --ask-become-pass ansible_user.yml
```

You should get some output similar to:

```
$ ansible-playbook --ask-become-pass ansible_user.yml
SSH password:
SUDO password[defaults to SSH password]:

PLAY [Add users] *****************************************

TASK [Gathering Facts] ***********************************
ok: [server1]
ok: [server2]

TASK [group] *********************************************
ok: [server1]
ok: [server2]

TASK [user] **********************************************
ok: [server1]
ok: [server2]

TASK [Set authorized key took from file] *****************
ok: [server1]
ok: [server2]

TASK [Allow 'wheel' group to have passwordless sudo] *****
changed: [server1]
changed: [server2]

PLAY RECAP ***********************************************
server1   : ok=5    changed=1    unreachable=0    failed=0
server2   : ok=5    changed=1    unreachable=0    failed=0
```

If you see a bunch of ok's, then you are done. You can log onto one of the servers to check that the ansible user has been created, is in wheel, and can sudo without a password.

To start using the new ansible user account, you will need to edit the *third* and *fourth* line in your configuration file, `ansible.cfg`. On the *fourth* line, use the private key that corresponds to the public key that you used in your playbook (here, id-rsa):

```ini
[defaults]
inventory = hosts
remote_user = ansible
private_key_file = id-rsa
host_key_checking = False
ansible_port = 22
```

## Conclusion

While I have only scratched the surface of what Ansible can do, it is clearly as powerful as it is light weight. I can't wait to dive in an spend more time programming and less time managing servers!

You can find all of the code in this post in a [ GitHub Gist](https://gist.github.com/kguay/7c3122aedb1b19eba69fc3fbe5c420de).

<!-- This code is available as a [Gist](https://gist.github.com/kguay/7c3122aedb1b19eba69fc3fbe5c420de). -->