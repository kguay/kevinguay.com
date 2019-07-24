+++
title = "Microsoft's reversal on password expiration"
date = "2019-06-09"
description = "Microsoft recently reversed their recommendation on password expiration"
tags = [ "Security" ]
layout = "blog"
+++

Last weekend, <a href="https://blogs.technet.microsoft.com/secguide/2019/05/23/security-baseline-final-for-windows-10-v1903-and-windows-server-v1903/" target="_blank">Microsoft reversed</a> its long-time recommendation that passwords should expire every few months. If your company has this policy, you know that people don't really change their passwords. They use derivatives of the same password that are only different enough to fool Microsoft's password history rules.

ThisIsMyPassw0rd  
This1sMyPassw0rd1  
Th1s1sMyPassw0rd3%  
Th1s1sMyP@ssw0rd72  

The reversal speaks to a new school of thought regarding security. Instead of short and complicated passwords that are impossible for most people to remember, long passwords are preferred. There is also a huge push towards two factor authentication. Not relying on one piece of information to protect your financial accounts seems like common sense now.

It is important to educate users on the importance of good passwords so that they don't succumb to bad practices like changing one character in a password or adding a numeral to the end. Tools like <a href="https://haveibeenpwned.com" target="_blank">Have I Been Pwned</a> can be sobering and hopefully help on the road to understanding why we need good passwords.

While I agree that, combined with two factor authentication, regular passwords changes are unnecessary, it is still important to educate users on best practices and require changes if passwords have been leaked or stolen. Some password managers, such as <a href="https://1password.com/" target="_blank"> 1Password</a>, already alert users when their passwords have been compromised. Perhaps Microsoft can implement a similar feature, requiring password changes when the password has been compromised.