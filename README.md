# WieldingLocation

Powershell Quick Locations.

This module adds functions to assist with navigating to common directories quickly with autocompletion.

This is a work in progress so it may have breaking changes in each update until it is stable.

Quick Start
-----------

1. Install Module
```powershell
Install-Module -Name WieldingLocation
```

2. Set a frequently used location

```powershell
Set-QuickLocation -Alias "doc" -Location "$($env:USERPROFILE)\Documents"
```

or using the short form with the exported alias `ql`

```powershell
ql doc "$($env:USERPROFILE)\Documents"
```

3. Now that you have added a location you can jump to your documents folder from wherever you are in your filesystem by simply typing:

```powershell
ql doc
```

The command has Tab-Completion so if you have many location aliases set you can start typing and hit the tab key to cycle through the available names.

Examples
========

```powershell
ql doc "$($env:USERPROFILE)\Documents" # set the name doc to point to your documents folder
ql doc # change to your documents folder
ql # change to the previous folder you were in
ql # toggle back to the documents folder.
qll # lists all of the folder definitions

