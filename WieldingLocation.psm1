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

 .PARAMETER Force
    Forces setting the location to provided value without validation.  Useful for storing arbitrary data for
    retrieval with 'Copy-QuickLocation"

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
        [string]$Location = "",
        [switch]$Force
    )

    $hasAlias = ($Alias -ne "")
    $hasLocation = ($Location -ne "")

    if (!$hasAlias -and !$hasLocation) {
        $newLocation = $QuickLocation.LastLocation
        $QuickLocation.LastLocation = (Get-Location).Path
        Set-Location -Path $newLocation
        return
    }

    if (!$hasLocation) {
        if ($hasAlias) {

            if ($Alias.StartsWith("!")) {
                if (!$QuickLocation.Locations.Contains($Alias.Substring(1))) {
                    Write-Output "Unknown alias [$Alias]`n"
                    return        
                }            
                
                $QuickLocation.Locations.Remove($Alias.Substring(1))
                Write-Output "Removed [$($Alias.Substring(1))]`n"
                return
            }
    
            if ($Alias.StartsWith("~")) {

                if (!$QuickLocation.Locations.Contains($Alias)) {
                    Write-Output "Unknown alias [$Alias]`n"
                    return        
                }            
    
                Invoke-Command -ScriptBlock ([scriptblock]::create($QuickLocation.Locations[$Alias]))
                return
            }   

            if (!$QuickLocation.Locations.Contains($Alias)) {
                Write-Output "Unknown alias [$Alias]`n"
                return        
            }            

   
            $item = Get-ItemProperty $QuickLocation.Locations[$Alias]

            if (Test-IsDirectory $item) {
                $QuickLocation.LastLocation = (Get-Location).Path
                Set-Location -Path $item.FullName
            }
            else {
                Invoke-Item $item.FullName
            }
        }

        return
    }

    $value = $Location

    if (-not $Force) {
        if (Test-Path $Location) {
            try {
                $item = Get-ItemProperty $Location
                $value = $item.FullName
            }
            catch {
                Write-Output "Error accessing location [$item]`n"
                return
            }
        }
        else {
            Write-Output "Unknown location [$Location]`n"
            return
        }
    }

    $QuickLocation.Locations[$Alias] = $value
}

function Show-QuickLocation {
    $QuickLocation.Locations.GetEnumerator() | Sort-Object -Property name
}

function Copy-QuickLocation {
    param (
        [string]$Alias = ""
    )

    if ($QuickLocation.Locations.Contains($Alias)) {
        Set-Clipboard -Value $QuickLocation.Locations[$Alias]
        return
    }
    else {
        Write-Output "Unknown location [$Location]`n"
        return        
    }
}

$locationCompleter = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $QuickLocation.Locations.Keys | Sort-Object | ForEach-Object -Process { if ($_.ToUpper().StartsWith($wordToComplete.ToUpper())) { $_ } }
}

Set-Alias -Name "ql" -Value Set-QuickLocation
Set-Alias -Name "qll" -Value Show-QuickLocation
Set-Alias -Name "qlc" -Value Copy-QuickLocation

Register-ArgumentCompleter -CommandName Set-QuickLocation -ParameterName Alias -ScriptBlock $locationCompleter
Register-ArgumentCompleter -CommandName Copy-QuickLocation -ParameterName Alias -ScriptBlock $locationCompleter

Export-ModuleMember -Function Out-Default, 'Set-QuickLocation'
Export-ModuleMember -Function Out-Default, 'Show-QuickLocation'
Export-ModuleMember -Function Out-Default, 'Copy-QuickLocation'
Export-ModuleMember -Variable 'QuickLocation'
Export-ModuleMember -Alias 'ql'
Export-ModuleMember -Alias 'qlc'
Export-ModuleMember -Alias 'qll'