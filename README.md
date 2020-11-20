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

To see your current quick locations use `Show-QuickLocation` or the alias `qll`.

The command has Tab-Completion so if you have many location aliases set you can start typing and hit the tab key to cycle through the available names.

You can save your current quick locations and restore them by adding some code to your Powershell profile.

I don't want the module to be responsible for deciding how and where you store your data so I am leaving it to the user.  Here is an example of you you might implement that for yourself.

In your powershell profile you can add the following.

```powershell
Import-Module WieldingLocation

function Save-QuickLocations {
  Set-Content -Path "$($env:USERPROFILE)\.config\WieldingLocation\locations.json" (ConvertTo-Json -InputObject $QuickLocation)
}

if (Test-Path -Path "$($env:USERPROFILE)\.config\WieldingLocation\locations.json") {
  $QuickLocation = (Get-Content -Path "$($env:USERPROFILE)\.config\WieldingLocation\locations.json" | ConvertFrom-Json -AsHashtable)
}

```

This will load your saved locations when you start an new Powershell session and gives you a function `Save-QuickLocations` that you can manually call if you want to save your current quick location data.  This way you are in control and can even load different quick locations for different situations. 


Examples
========

```powershell
ql doc "$($env:USERPROFILE)\Documents" # set the name doc to point to your documents folder
ql doc # change to your documents folder
ql # change to the previous folder you were in
ql # toggle back to the documents folder.
qll # lists all of the folder definitions

