# Dot-source the function files
Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 |
    ForEach-Object { . $_.FullName }

# Export all the functions in the Public directory
Export-ModuleMember -Function (Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Name | Foreach-Object { $_ -replace '.ps1$', '' })
