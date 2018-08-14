+++
title = "Using a Mac as a server"
date = "2018-02-21"
description = "How to configure a Mac for a Zoom Room"
tags = [ "Apple" ]
layout = "blog"
draft = "true"
+++

## Background
I was recently setting up a Mac Mini as a "Zoom Room" computer. Zoom is a video conferencing software and a Zoom Room is setup with a camera, microphone, speaker, etc. so that video conferences can happen easily and without setup. The computer is basically going to act like a server. It will be kept in an inaccessable location (likely above the drop ceiling) and not connected to a mouse or keyboard. This is not how Macs are intended to be used. In face, by defauly MacOS requires a keyboard or mouse to be plugged into the computer in order to boot. This doesn't effect laptops with builting input devices, but for desktop computers like the Mac Mini, it wouldn't boot without seeing the input devices.

Also of concern was the power button. In order to turn on the computer, the power button has to be pushed. This becomes difficult if the computer is above a high ceiling. Fortunately, there are solutions to these problems and more. I will outline them below for anyone looking to use a Mac as a server.

## Input devices

The first problem that I encountered with the Mac setup was that the computer would not boot. I had previously configured it with a keyboard, mouse, and display. Accounts had been setup, software installed, but when I plugged it into a projector without any input devies, it wouldn't boot. I tried a power cycle and it presented a screen to recover my lost password. Lost password? I couldn't figure out where I had gone wrong. A little research revealed that Apple hadn't considered this application for their hardware. After all, who would want to put a beautiful piece of pression machined aluminum above a ceiling? I did.

## Power button

The physical power button on the Mac Mini made remote startup a tricky proposition. Here in Maine, it is not uncommon to loose power. We have a generator for our servers and networking equipment, but not where the Mac was going to be plugged in. I considered a small battery backup, but it seemed overkill for a non-critical machine.

As with the input devices, the Mac Mini has a speical setting for power that Laptops do not. In Energy Saver System Preferences, you can set the computer to boot automatically when plugged in ("Start up automatically after a power failure"). This way, if the power goes out and comes back on, the computer will automatically boot and be ready to use.

## The rest

The rest wasn't difficult. I used a local user account (vs a domain account) and set it up without a password so that it would boot to that user's desktop.