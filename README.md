# HEX Editor Magisk Module

## Descriptions
- Bypasses security restrictions of HEX Editor app, so we don't need to turn our device to Permissive state to access all of directories.
- What app is this? Tap here: https://play.google.com/store/apps/details?id=com.myprog.hexedit. Tap the "About this app" there.

## Requirements
- Android 4.3 (SDK 18) and up
- Magisk or Kitsune Mask or KernelSU or Apatch installed

## Changelog

v1.15
- Update libmagiskpolicy.so from Magisk (stable) 30.7 (30700)
- Fix sepolicy denials

v1.14
- Add Action button to clear app caches
- Fix extract libs
- Fix bug in uninstall.sh

v1.13
- Fix conflict with modules_update while installing via recovery if Magisk installed
- Fix MagiskHide & SUList
- Fix selinux denials
- Disables ad component com.smaato.soma.interstitial.InterstitialActivity

v1.12
- Redirect /sdcard to /data/media/"$UID"
- Fix MagiskHide & SUList

v1.11
- Specify UID at script
- Add optional debug.log=1 for more detailed install log

v1.10
- KernelSU support
- Magisk v26.1 support
- Fix optional permissive mode
- Set blacklist/whitelist
- Save uninstall log in /data/adb/modules/..._uninstall.log

v1.9
- Fix permissions
- Fix sepolicy denials
- Using sys.boot_completed=1 detection

v1.8
- package_cache deletion
- Script enhancements
- Move dalvik cache cleaning to cleaner.sh
- Enable debug log
- Fix sepolicy denials
- Using /sdcard/optionals.prop instead of terminal commands for any optional installation

v1.7
- Fix uninstall.sh bug
- Mount /persist and /metadata on recovery to fix sepolicy.rule installation on recovery

## Installation Guide & Download Link
- If you are using KernelSU, you need to disable Unmount Modules by Default in KernelSU app settings and install https://github.com/KernelSU-Modules-Repo/meta-overlayfs or https://github.com/KernelSU-Modules-Repo/magic_mount_rs or https://github.com/KernelSU-Modules-Repo/hybrid_mount first depending on ROM compatibility
- Install this module https://devuploads.com/ojqwez4xx5c5 via Magisk app or KernelSU app only
- Reboot
- If you are using KernelSU, you need to allow superuser list manually all package name listed in package.txt (and your home launcher app also) (enable show system apps) and reboot afterwards
- If you are using SUList, you need to allow list manually your home launcher app (enable show system apps) and reboot afterwards

## Optionals
Global: https://t.me/ryukinotes/35

## Troubleshootings
Global: https://t.me/ryukinotes/34

## Support & Bug Report
- https://t.me/ryukinotes/54
- If you don't do above, issues will be closed immediately.

## Credits and Contributors
- https://t.me/androidryukimodsdiscussions
- You can contribute ideas about this Magisk Module here: https://t.me/androidappsportdevelopment

## Sponsors
https://t.me/ryukinotes/25


