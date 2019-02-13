+++
title = "MacOS Falcon Sensor Deployment"
date = "2019-02-12"
description = "Configuring CrowdStrike Falcon advanced endpoint protection installer for MacOS"
tags = [ "Security" ]
layout = "blog"
+++

After much research and deliberation, I decided to move from Avast to CrowdStrike Falcon for endpoint antivirus protection. The CrowdStrike platform offers increased control, visibility, and protection as well as humans on the back end to make sure that nothing slips through the cracks. I'm in the middle of deployment and have run into a few problems. We have both Mac and Windows workstations in our environment, and while it's relatively easy to install software on Windows workstations using group policies, Macs are not so easy. Of course, I could use a Mac management platform such as Jamf, but the subscription cost is prohibitive for me.

The Falcon installer is easy enough for employees to install, but licensing it requires running a command in Terminal (shell). Easy enough for us programmers, but Terminal can be a scary place for everyone else.

So, to recap, we just need to run one line of code after the installer is done. Should be easy enough, right?

## One script to rule them all

CrowdStrike offers a command line-only way to install the sensor, which could easily be written into a script. The script could then be bundled as an app and presto, a user-friendly installer. This is certainly an easy option, but it provides ample room for something to go wrong during installation without notifying the user. The script would look like this:

```
#!/bin/bash
# Download
curl -o /tmp/FalconSensor.pkg https://sub.domain.com/FalconSensor.pkg
# Install
sudo installer -verboseR -package /tmp/FalconSensor.pkg -target /
# License
sudo /Library/CS/falconctl license 0123456789ABCDEFGHIJKLMNOPQRSTUV-WX
```

Of course, you would need a web server where you could host the installer. The advantage to a script is that it can be installed remotely, however, the user still needs to click "Allow" in System Preferences > Security & Privacy (General) to allow the system extension to be used. I tried a number of ways to bypass this, including an AppleScript that clicks the Allow button for you. Unfortunately, in order for the AppleScript to do this, you need to give it access in... you guessed it... System Preferences > Security and Privacy (Privacy). That defeats the purpose.

## Hack the pkg

I've never snooped around package (.pkg) installers before, but it was easier than I thought to hack. You will need XCode installed to use the pkgutil.

You can't edit a package file directly since it has been "flattened". You will need to expand (unflatten) it: 

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

The last line calls the loadSensor function, which checks if the sensor is licensed and then runs loadComponents. We want to slide in before loadSensor and run the licensing command. You should add the licenseSensor() function and call it *before* calling loadSensor:

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

That's it! The user will still need to allow the computer to enable the system extension, but they will not need to run the licensing command.