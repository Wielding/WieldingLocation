# WieldingLocation

Powershell Quick Locations.

This module adds functions to assist with navigating to common directories and files quickly with autocompletion.

It is growing beyond its original purpose and now supports executing frequent commands and copying stored locations and commands to the clipboard.

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

3. Now that you have added a location you can jump to your documents folder from wherever you are in your filesystem by simply typing the name of the alias after the `ql` alias.  The command will use tab completion with the names from your saved locations 

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

The system should open the Powershell profile using the default application for the file extension.  So far this only seems to work under Windows.  Maybe some Linux Distributions or MacOs has the capability to open files from the command line but I can't test them all.  It does not work under my WSL distributions.


If you want to remove a location prefix the name with a "!"
```powershell
Set-QuickLocation -Alias !pro
```

or with the alias
```powershell
ql !pro
```
This will remove the alias "pro" from your location list.

5. Copy location to clipboard
  
You can also have your quick location entries copied to the clipboard.

```powershell
Copy-QuickLocation pro
```

or with the alias 
```powershell
qlc pro
```

This will put the contents of the 'pro' alias to the clipboard on Windows.  It does not work under WSL.  I will investigate checking for linux and maybe using `xclip` to implement this functionality under an X11 environment.

You can store arbitrary data in the location list by using the `-Force` option.  This will prevent validating that the data is a location on your file system.

```powershell
qlc name "Joe User" -Force
```

This will add "Joe User" to the quick location list which can then be place on the clipboard with
```powershell
qlc name
```

6. You can store shortcuts to frequently used powershell commands by adding a '*' prefix to your alias.  You can put anything that Powershell understands when using the Invoke-Command script block.

For example

```powershell
ql *wh "Write-Host 'test'" -Force
```

This will store an alias named "*wh" with the value `"Write-Host 'test'" `.

You can now execute that command with 
```powershell
ql *wh
```

To see your current quick locations use `Show-QuickLocation` or the alias `qll`.

If you have tried the above examples the `qll` command should output something like

```powershell
Name                           Value
----                           -----
doc                            C:\Users\<user name>\Documents
name                           Joe User
*wh                            Write-Host 'test'
```

The command has Tab-Completion so if you have many location aliases set you can start typing and hit the tab key to cycle through the available names.

You can save your current quick locations and restore them by adding some code to your Powershell profile.

I don't want the module to be responsible for deciding how and where you store your data so I am leaving it to the user.  Here is an example of how you might implement that for yourself under Windows.  For other systems you probably want change the `$env:USERPROFILE` to `~` or something else.

In your powershell profile you can add the following.

```powershell
Import-Module WieldingLocation

$quickConfigLocation = "$($env:USERPROFILE)\.config\WieldingLocation\locations.json"

function Save-QuickLocations {
  Set-Content -Path $quickConfigLocation (ConvertTo-Json -InputObject $QuickLocation)
}

if (Test-Path -Path $quickConfigLocation) {
  $QuickLocation = (Get-Content -Path $quickConfigLocation | ConvertFrom-Json -AsHashtable)
}

```

This will load your saved locations when you start a new Powershell session and gives you a function `Save-QuickLocations` that you can manually call if you want to save your current quick location data so that it will be reloaded on the next start of your Powershell console.  This way you are in control and can even load different quick locations for different situations. 


Examples
========

```powershell
ql doc "$($env:USERPROFILE)\Documents" # set the name doc to point to your documents folder (Windows)
ql doc # change to your documents folder
ql # change to the previous folder you were in
ql # toggle back to the documents folder.
ql # toggle again
qll # lists all of the folder definitions
qlc doc # copy the location referenced by 'doc' to the clipboard
ql !doc # remove the doc alias from your locations
ql *env "Get-ChildItem env:" -Force # create a quick command
ql *env # executes the '*env' alias which will show your environment variables

