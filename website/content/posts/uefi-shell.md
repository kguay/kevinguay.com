+++
title = "Red Hat 7 install and the UEFI shell"
date = "2018-12-09"
description = "Manually booting with Red Hat and UEFI shell"
layout = "blog"
tags = ["Servers"]
+++



## Routine Upgrade


<img src="/images/posts/efi.png" alt="UEFI shell" width="50%" class="pull-right" style="padding:0 0 10px 10px;">

It was anything but. I had scheduled some maintenance time for an upgrade to our main HPC, which was still running RHEL 6. Because of the version discrepency, we had to implement work arounds for using, say, the latest version of gcc. It wasn't ideal to say the least. By this time I had moved all of our user's home directories to an NFS share, moved almost all applications to environmental modules, and started using Ansible for configuration, meaning that I could finally do a clean install of the new OS with minimal configuration on the other side.

I got in early that day to make use of the window and got to work. The install went fairly smooth, save the unresponsive screen from the Live DVD (which is a known issue with SGI UV systems). What wasn't a known issue is that the Boot Loader wasn't properly configured during install and when the system reboot, it stopped at a UEFI shell.

I am not one to shy away from shells, indeed I prefer them over using a Linux GUI for most of my server admin, but this shell gave me pause. It wasn't the BASH shell that I expected, nor any varient that I had come to know (e.g. csh). It was the UEFI shell and the commands were extremely limited. I was prompted with a:

```
Shell>
```

Despite lots of Duck Duck Go-ing (is that a verb yet?), I was stuck. It turns out that I had to manually launch the grub boot loader, but I had no idea how. Slowly, through various support articles and Stack Overflow threads, I pieced together a solution that worked.

```
Shell> fs0:
fs0:\> cd EFI\redhat
fs0:\> grubx64.efi
```

This boot into RHEL and I was on my way. However, this additional step makes rebooting more difficult and when you are rebooting a 120 core and 1.5TB RAM HPC, your heartrate is  already higher than normal (if not only becuase of the heat coming off of the servers) and additional work is not ideal. I copied the /boot directory from another SGI UV machine running RHEL 7 and that seemed to work as a bandaid. I reached out to Red Hat and they gave me something to try, but I haven't had a chance, since it would require rebooting a production machine. Next time I have some dedicated downtime, I'll give it a try and update this post with the results.

For now, I have a working machine running RHEL 7 and humming (actually screaming; the fans never slow down) away in the basement. Once I got it to boot and installed the SGI-specific software, it was minimal effort to get everything running again. Most of it was done using Ansible, which saved tons of time and makes user additions and other changes reproducable for new nodes on the HPC cluster. Done for now - will update sometime in 2019.