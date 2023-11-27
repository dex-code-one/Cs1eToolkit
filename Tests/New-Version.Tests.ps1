Describe 'New-Version Function Tests' {
    Mock Get-Date { return [DateTime]'2023-11-26T15:30:45' }

    It 'Returns a System.Version object' {
        $version = New-Version
        $version | Should -BeOfType [System.Version]
    }

    It 'Returns a version number in the correct format' {
        $version = New-Version
        $version.ToString() | Should -Match '^\d{6}\.\d{4}\.\d{4}\.1$'
    }

}
