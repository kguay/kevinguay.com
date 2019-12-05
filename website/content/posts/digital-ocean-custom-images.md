+++
title = "Custom Images with Digital Ocean"
date = "2019-11-27"
description = "Tips for adding custom images to Digital Ocean"
tags = [ "Cloud" ]
layout = "blog"
draft = "true"
+++

## Background (not too important)

<a href="#important">Jump to the important bit</a>

Digital Ocean is my go to for cloud hosting and computing. You can spin up a Droplet (VPS) in a few seconds and the user interface is much easier to use than AWS. Aside from their sleek UI, fair prices, and robust feature set, Digital Ocean has incredible documentation. For example, their instructions for <a href="https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-centos-7" target="_blank">setting up a LAMP server</a> (Linux, Apache, MySQL/MariaDB, and PHP) on CentOS are clear, easy-to-follow, and reliable.

Until last year, Digital Ocean was missing one critical feature: the ability to upload your own image files (e.g. `.iso`). This is useful if you are migrating from an on-prem virtualized environment (e.g. KVM) to the cloud. It also makes it possible to use pre-configured images with your favorit software installed (e.g. FreePBX, OpenVPN, etc).

You can upload custom images to Digital Ocean by clicking on the Images link on the left and then Custom Images. Images can be uploaded as Raw (.img), qcow2, VHDX, VDI, or VMDK. There is even a file upload button to upload the file directly from your computer. Unfortunately, most web browsers have a file upload limit that is far below what some disk images will are. Worry not, there is an "Import via URL" option as well. Just type in the URL for your image and you're off, right? Not so fast.

I have tried uploading images via URL from multiple sources, including a public FTP server, public web server, and Google Drive. The FTP and web servers should have worked, but didn't. Since Google Drive's share link doesn't have a file extension in the URL, Digital Ocean rejects it.

<a name="important"></a>
## Tried and True

The following instructions are based on trial and error, forum and documentation perusing, and patience.

Everything here is based on CentOS 7, but the process should work on most distributions (just replace yum with your package manager). Currently Digital Ocean only works with Linux VMs.

### 1. Prepare your image file with cloud-init

Before you can use your image on Digital Ocean, you will need to install and configure `cloud-init`.

1. Install cloud-init on your on-prem VM: \
  `sudo yum install cloud-init`
1. Open /etc/cloud/cloud.cfg