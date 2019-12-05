+++
title = "MacOS Falcon Sensor Deployment"
date = "2019-02-12"
description = "Configuring CrowdStrike Falcon advanced endpoint protection installer for MacOS"
tags = [ "Security" ]
layout = "blog"
+++

***TL;DR*** *I hacked the Falcon sensor installer for MacOS to include the licensing information.*


{{% box %}}
<b>What is falcond?</b>

A lot of searches for "what is falcond" are landing on this page. <i>falcond</i> is the MacOS sensor for CrowdStrike antivirus software. The <i>d</i> is for daemon, a process that runs in the background, and <i>falcon</i> is the name of the antivirus software.
{{% /box %}}

{{% box %}}
<b>Update (December 2019)</b>

Since this post has gotten so much attention, I have created a script for it on GitHub. See the section titled "Automating the hack" at the end for a link and instructions to run.
{{% /box %}}

After much research and deliberation, I decided to move from Avast to CrowdStrike Falcon for endpoint antivirus protection. The CrowdStrike platform offers increased control, visibility, and protection as well as humans on the back end to make sure that nothing slips through the cracks. I am in the process of deployment, and while it's relatively easy to install the sensor on Windows workstations using group policies, Macs are not so easy. Of course, I could use a Mac management platform such as Jamf, but the subscription cost is prohibitive for me.

The Falcon installer is straightforward enough for employees to use, but licensing it requires running a command in Terminal (shell). Easy for us programmers, but Terminal can be a scary place for everyone else. Had I sent the Falcon install instructions (including the licensing command) to the masses, there would have been panic, or at least a lot of partial installs. I knew that there had to be a better, easier, way to deploy Falcon on the Macs, so I started playing.

## AppleScript?

CrowdStrike offers a command line method of installing the sensor, which could easily be written into a script. The script could then be bundled as an app and presto, a user-friendly installer. This is certainly an easy option, but it provides ample room for something to go wrong during installation without notifying the user.

A script is advantagous because it can be installed remotely, however, the user still needs to click "Allow" in System Preferences > Security & Privacy (General) to allow the system extension to be used. I tried a number of ways to bypass this, including an AppleScript that clicks the Allow button for you. Unfortunately, in order for the AppleScript to do this you need to manually give it access, which defeats the purpose of automation.

## Hack the pkg

I've never snooped around package (.pkg) installers before, but it was easier than I thought to hack. You will need XCode installed to use the pkgutil command.

You can't edit a package file directly since it has been "flattened". You will need to expand (unflatten) it first: 

```
pkgutil --expand ~/Desktop/FalconSensor.pkg /tmp/FalconSensor.unpkg
```

Next, open the FalconSensorMacOS.unpkg folder in /tmp (or wherever you expanded it to), right click on sensor.pkg, and "Show Package Contents". There is a Scripts folder. Expand it and open the postinstall script in a text editor.

You should see something like:

```
#!/bin/bash

CS_PATH="/Library/CS"

function loadComponents()
{
    /bin/launchctl load /Library/LaunchDaemons/com.crowdstrike.userdaemon.plist
    /bin/launchctl load /Library/LaunchDaemons/com.crowdstrike.falcond.plist
}

function loadSensor()
{
    # Only load sensor if licensed
    if [[ -e "${CS_PATH}/license.bin" ]]; then
        loadComponents
    fi
}

loadSensor
```

As the filename suggests, this script is executed after the Falcon sensor is installed, which is right when we want to license it. The last line calls the loadSensor function, which checks if the sensor is licensed and then runs loadComponents. We want to slide in before loadSensor and run the licensing command. You should add the licenseSensor() function and call it *before* calling loadSensor:

```
#!/bin/bash

CS_PATH="/Library/CS"

function loadComponents()
{
    /bin/launchctl load /Library/LaunchDaemons/com.crowdstrike.userdaemon.plist
    /bin/launchctl load /Library/LaunchDaemons/com.crowdstrike.falcond.plist
}

function loadSensor()
{
    # Only load sensor if licensed
    if [[ -e "${CS_PATH}/license.bin" ]]; then
        loadComponents
    fi
}

function licenseSensor()
{
    /Library/CS/falconctl license 0123456789ABCDEFGHIJKLMNOPQRSTUV-WX
}

licenseSensor
loadSensor

```

*Be sure to replace the example license key with your own.*

Back in Terminal, we will flatten, or re-package, the files:

```
pkgutil --flatten /tmp/FalconSensor.unpkg ~/Desktop/FalconSensorLicensed.pkg
```

That's it! The user will still need to allow the computer to enable the system extension, but they will not need to run the licensing command in terminal.

## Automating the hack

This post has gotten so much attention that I circled back and wrote a bash script to automate the pkg hacking process. You can find the script on <a href="https://github.com/kguay/falcon-inject" target="blank">GitHub</a>. The script needs to be run on a computer running MacOS, since it requires the `pkgutil` utility.

1. Download the MacOS Falcon installer from the Falcon management web portal.
2. Download the license-falcon script
3. run the license-falcon script with two parameters.
  - First, the path to the `FalconSensorMacOS.pkg` that you downloaded in step 2.
  - And second, your customer ID for falcon e.g. 1234567890ABCDEFGHIJKLMNOPQRSTUV-WX

For example:
 
```
sh license-falcon.sh /path/to/FalconSensorMacOS.pkg customer_id
```