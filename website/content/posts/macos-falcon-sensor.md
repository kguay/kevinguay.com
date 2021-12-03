+++
title = "MacOS Falcon Sensor Deployment"
date = "2019-02-12"
description = "Configuring CrowdStrike Falcon advanced endpoint protection installer for MacOS"
tags = [ "Guide", "Security" ]
layout = "blog"
+++

***TL;DR*** *I hacked the Falcon sensor installer for MacOS to include the licensing information.*


#### What is falcond?

A lot of searches for "what is falcond" are landing on this page. *falcond* is the MacOS sensor for CrowdStrike antivirus software. The *d* is for daemon, a process that runs in the background, and *falcon* is the name of the antivirus software.

---

#### Update (December 2021)

A good semaritan has <a href="https://github.com/kguay/falcon-license/pull/1" target="_blank">updated my script</a> to work with the new macOS Falcon Sensor version (6.32 as of writing). I updated this article to reflect the changes.

---

## Overview

CrowdStrike Falcon is a leading endpoint protection platform. The CrowdStrike platform offers increased control, visibility, and protection as well as humans on the back end to make sure that nothing slips through the cracks. In a large environment, it is advantageous to automate the installation process as much as possible. The Windows sensor installer has the Customer ID built-in, but the macOS installer does not.

The Falcon installer is straightforward enough for employees to use, but licensing it requires running a command in Terminal (shell). Easy for some, but Terminal can be a scary place for others. Had I sent the Falcon install instructions (including the licensing command) to the masses, there would have been a lot of partial installs. I knew that there had to be a better, easier, way to deploy Falcon on the Macs, so I started hacking.

## Hack the pkg

I've never snooped around package (.pkg) installers before, but it was easier than I thought to hack. You will need XCode installed to use the pkgutil command.

#### 1 - Expand package
In order to edit the scripts within the package, you need to expand it using the pkgutil command:

```bash
pkgutil --expand FalconSensorMacOS.pkg /tmp/FalconSensorMacOS.unpkg
```
#### 2 - Edit postinstall scripts
Next, you will need to edit two files (the same script in two locations):
  1. /tmp/FalconSensorMacOS.unpkg/sensor-kext.pkg/Scripts/postinstall
  1. /tmp/FalconSensorMacOS.unpkg/sensor-sysx.pkg/Scripts/postinstall

**Note**: if you are navigating to the files in Finder, you will need to right click on the sensor-kext.pkg and click "Show Package Contents".

The `postinstall` script gets run towards the end of the installation process. We need to edit the file in two places:

#### 2.1 - Assign license key to VALUE variable
First, locate the readManagedProfileKey function towards the top of the file (line number 15 as of writing). Add your license key to line 4 (keep the quotation marks):

```bash {linenos=table,hl_lines=[4],linenostart=12}
function readManagedProfileKey()
{
    if ! VALUE=$(/usr/libexec/PlistBuddy -c "print :$1" "$MANAGED_FALCON_PLIST" 2>/dev/null) ; then
        VALUE="0123456789ABCDEFGHIJKLMNOPQRSTUV-WX"
    fi

    echo "$VALUE"
}
```

#### 2.2 - Add licenseSensor function
Second, add the licenseSensor function (including the function call) above "loadSensor" (lines 107-112 below):
```bash {linenos=table,linenostart=107}
function licenseSensor()
{
    "$CS_BIN_PATH/falconctl" license 0123456789ABCDEFGHIJKLMNOPQRSTUV-WX
}

licenseSensor
loadSensor
```

*Be sure to replace the example license key with your own.*

#### 3 - Re-package files

Back in Terminal, flatten (i.e. re-package) the files:

```bash
pkgutil --flatten /tmp/FalconSensorMacOS.unpkg FalconSensorMacOSWithID.pkg
```

That's it! The user will still need to allow the computer to enable the system extension, but they will not need to run the licensing command in terminal.

## Automating the hack

I wrote a script to automatically:
 - Expand the package
 - Edit the postinstall scripts
 - Re-package the files

You can find the script on <a href="https://github.com/kguay/falcon-license" target="_blank">https://github.com/kguay/falcon-license</a>. The script needs to be run on a computer running MacOS with XCode installed, since it requires the `pkgutil` utility.

1. Download the MacOS Falcon installer from the Falcon management web portal.
2. Download the license-falcon script from <a href="https://github.com/kguay/falcon-license" target="_blank">https://github.com/kguay/falcon-license</a>
3. Run the license-falcon script the path to FalconSensorMacOS.pkg and your Customer ID

For example:
 
```bash
sh license-falcon.sh FalconSensorMacOS.pkg <customer_id>
```