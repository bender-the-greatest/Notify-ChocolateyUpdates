# Notify-ChocolateyUpdates
Powershell script which can be used with the Burnt Toast Powershell module to notify when there are Chocolatey package updates.

This has only been tested with Windows 10. This script may not run today with versions of Burnt Toast that run on Windows 8/8.1. Create an issue if you find any bugs with the latter use case.

Prerequisites
=============
You need to install the Burnt Toast Powershell module system-wide or as the user you intend to run this script as.

https://github.com/Windos/BurntToast

Suggested Usage
===============
I recommend running this via Task Scheduler on an interval or at log on. Note that when you create the scheduled task, it needs to run as the user you intend to view the notifications as. If you choose another user (such as SYSTEM, or a service account), you will not receive the notification while logged on as your user.
