Import-Module Pester
Remove-Module WieldingLocation -ErrorAction SilentlyContinue
Import-Module ./WieldingLocation.psm1

BeforeAll {
}

Describe 'Show-QuickLocation' {  

    It 'Should return no values' {
        Remove-Module WieldingLocation -ErrorAction SilentlyContinue
        Import-Module ./WieldingLocation
        (Show-QuickLocation).Length | Should -Be 0
    }

    It 'Should return a single value' {
        Set-QuickLocation -Alias "B" -Location "BB" -Force
        (Show-QuickLocation).Length | Should -Be 1
    }    

    It 'First value should be "BB"' {
        (Show-QuickLocation)[0].Value | Should -Be  'BB'
    }    

    It 'Should return two Values value' {
        Set-QuickLocation -Alias "A" -Location "AA" -Force
        (Show-QuickLocation).Length | Should -Be 2
    }        

    It 'First value should be "AA"' {
        (Show-QuickLocation)[0].Value | Should -Be  'AA'
    }    
}

Describe 'Set-QuickLocation' {

    It 'Should return no values' {
        Remove-Module WieldingLocation -ErrorAction SilentlyContinue
        Import-Module ./WieldingLocation
        (Show-QuickLocation).Length | Should -Be 0
    }

    It 'Should add a value to locations' {
        Set-QuickLocation -Alias "A" -Location "AA" -Force
        $QuickLocation.Locations.Count | Should -Be 1
    }    

    It 'Should remove a value from locations' {
        Set-QuickLocation -Alias "!A"
        $QuickLocation.Locations.Count | Should -Be 0
    }

    It 'Should fail with "Unknown alias [x]`n"' {
        Set-QuickLocation -Alias "x" | Should -Be "Unknown alias [x]`n"
    }    
}

