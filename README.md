# WieldingLocation

Powershell Quick Locations.

This module adds functions to assist with navigating to common directories and files quickly with autocompletion.

This is a work in progress so it may have breaking changes in each update until it is stable.

There will be better documentation in the future when this module hits a stable release.

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

4. Set a frequently used file to an alias

```powershell
Set-QuickLocation -Alias pro -Location $profile
```

Now when you type
```powershell
ql pro
```

If you want to remove a location prefix the name with a "!"
```powershell
Set-QuickLocation -Alias !pro
```

or with the alias
```powershell
ql !pro
```
This will cause Set-QuickLocation to attempt opening your Powershell profile by using the Windows file extension association (in this case ".ps1"). If there is no association it will ask you which application you want to use to open it.

5. Copy location to clipboard
  
You can also have your quick location entries copied to the clipboard.

```powershell
Copy-QuickLocation pro
```

or with the alias 
```powershell
qlc pro
```

This will put the contents of the 'pro' alias to the clipboard.

You can store arbitrary data in the location list by using the `-Force` option.

```powershell
qlc name "Joe User" -Force
```

This will add "Joe User" to the quick location list which can then be place on the clipboard with
```powershell
qlc name
```


To see your current quick locations use `Show-QuickLocation` or the alias `qll`.

The command has Tab-Completion so if you have many location aliases set you can start typing and hit the tab key to cycle through the available names.

You can save your current quick locations and restore them by adding some code to your Powershell profile.

I don't want the module to be responsible for deciding how and where you store your data so I am leaving it to the user.  Here is an example of how you might implement that for yourself.

In your powershell profile you can add the following.

```powershell
Import-Module WieldingLocation

$quickConfigLocation = "$($env:USERPROFILE)\.config\WieldingLocation\locations.json"

function Save-QuickLocations {
  Set-Content -Path $quickConfigLocation (ConvertTo-Json -InputObject $QuickLocation -Depth 10)
}

if (Test-Path -Path $quickConfigLocation) {
  $QuickLocation = (Get-Content -Path $quickConfigLocation | ConvertFrom-Json -AsHashtable)
}

```

This will load your saved locations when you start a new Powershell session and gives you a function `Save-QuickLocations` that you can manually call if you want to save your current quick location data.  This way you are in control and can even load different quick locations for different situations. 


Examples
========

```powershell
ql doc "$($env:USERPROFILE)\Documents" # set the name doc to point to your documents folder
ql doc # change to your documents folder
ql # change to the previous folder you were in
ql # toggle back to the documents folder.
qll # lists all of the folder definitions
qlc doc #copy the location referenced by 'doc' to the clipboard
