+++
title = "Backing up data"
date = "2019-05-05"
description = ""
tags = [ "Infrastructure" ]
layout = "blog"
draft=true
+++


In the last few decades, the amount of information stored digitally has increased exponentially. There are also an increasing number of threats to this data, including natural disasters, user error, ransomware, and data breaches. Backups are a critical piece of every individual and business's IT strategy. Backup stragies scale depending on how critical the data is to your operations and where else it is already stored. For example, if you have a large database of satellite imagery downloaded from NASA, you might not need to back that up yourself since it is still available on NASA's servers. However, if that data is mission critical to your organization/work, a local backup might be necessary, since downloading it again would take too long. I will look at different types and levels of backups and when each is approperate.

## Snapshots

Snapshots of data are taken at regular intervals (e.g. hourly or daily) and are located on-premise. Snapshots are ideal for restoring deleted and corrupt files. If your storage platform supports deduplication, then snapshots should take up almost no space, since most of the files will remain unchanged from hour to hour or day to day. Snapshots are also great for virtual machine backups, since they offer easy and frequent restore points if there is a system failure.

## Mirroring

For mission critical data, having a full on-prem backup, i.e. mirror, of the data is important. If there was a total failure of the primary data server, users could access the data directly from the mirror, meaning little to no downtime. Further, once the primary data server is repaired/replaced, it can be restored from the mirror much faster than it could be from an online backup.

## Cloud backups

There are many cloud storage providers, including Amazon, Backblaze, and Wasabi. Most have storage tiers that are lower priced and ideal for backups (e.g. Amazon glacier and Backblaze B2). I am currently pushing off-site/cloud backups to Backblaze's B2 using rclone. Rclone makes backing up to these cloud storage providers easy. 

