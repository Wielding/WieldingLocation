class QLocationData {
    $Locations = @{}
    [string]$LastLocation
}

$QuickLocation = New-Object -TypeName QLocationData

function Test-IsDirectory {
    param (
        $item
    )

    foreach ($attribute in $item.Attributes) {
        $isReparsePoint = ($attribute -band [System.IO.FileAttributes]::ReparsePoint) -eq [System.IO.FileAttributes]::ReparsePoint
        $isDirectory = ($attribute -band [System.IO.FileAttributes]::Directory) -eq [System.IO.FileAttributes]::Directory

        if ($isReparsePoint -or $isDirectory) {
            return $True
        }
    }

    return $False
}

function Set-QuickLocation {
    <#
 .SYNOPSIS
    Sets or changes to a stored directory location.

 .DESCRIPTION
    Sets or changes to a stored directory location.

 .PARAMETER Alias
    The short name to use to reference the directory

 .PARAMETER Location
    The folder that will be referenced by the Alias value

  .EXAMPLE   
    Set-QuickLocation -Alias doc -Location "$($env:USERPROFILE)\Documents"
    Sets a quick location named "doc" to the users Documents folder

 .EXAMPLE  
    Set-QuickLocation -Alias doc
    Changes to the directory that has an alias of "doc"

 .EXAMPLE  
    Set-QuickLocation
    Switches to the last directory that was changed to using Set-QuickLocation.

 .NOTES
    Author: Andrew Kunkel 
    

 .LINK
    https://github.com/Wielding/WieldingLocation
    
#>        
    [CmdletBinding()]
    param (
        [string]$Alias = "",
        [string]$Location = ""
    )

    $hasAlias = ($Alias -ne "")
    $hasLocation = ($Location -ne "")


    if (!$hasAlias -and !$hasLocation) {
        $newLocation = $QuickLocation.LastLocation
        $QuickLocation.LastLocation = $PWD
        Set-Location -Path $newLocation
        return
    }

    if ($hasAlias) {
        if (!$hasLocation) {
            if ($QuickLocation.Locations.Contains($Alias)) {
                $QuickLocation.LastLocation = $PWD
                $resolvedLocation = (Split-Path -Resolve $QuickLocation.Locations[$Alias]) + "/" + (Split-Path -Leaf $QuickLocation.Locations[$Alias])
                $item = Get-ItemProperty $resolvedLocation

                if (Test-IsDirectory $item) {
                    Set-Location -Path $QuickLocation.Locations[$Alias]
                } else {
                    Invoke-Item $QuickLocation.Locations[$Alias]
                }
                return
            } else {
                Write-Host "Location name [$Alias] does not exist"
                return
            }
        } else {
            $resolvedLocation = (Split-Path -Resolve $Location) + "/" + (Split-Path -Leaf $Location)
            $QuickLocation.Locations[$Alias] = $resolvedLocation
        }
    }
}

function Show-QuickLocation {
    $QuickLocation.Locations
}

$locationCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $QuickLocation.Locations.Keys | Sort-Object | ForEach-Object -Process {if ($_.StartsWith($wordToComplete)) {$_}}
}

Set-Alias -Name "ql" -Value Set-QuickLocation
Set-Alias -Name "qll" -Value Show-QuickLocation

Register-ArgumentCompleter -CommandName Set-QuickLocation -ParameterName Alias -ScriptBlock $locationCompleter

Export-ModuleMember -Function Out-Default, 'Set-QuickLocation'
Export-ModuleMember -Function Out-Default, 'Show-QuickLocation'
Export-ModuleMember -Variable 'QuickLocation'
Export-ModuleMember -Alias 'ql'
Export-ModuleMember -Alias 'qll'