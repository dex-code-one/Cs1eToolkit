<#
.SYNOPSIS
    Updates the module manifest to export functions based on filenames in a specified directory.

.DESCRIPTION
    The Update-FunctionsToExport function updates a PowerShell module manifest file to include all functions to export. It assumes that each .ps1 file in the specified Public directory of the module corresponds to a function, and the filename (without extension) is the function name. This function extracts all such filenames, treats them as function names, and updates the module manifest accordingly.

.PARAMETER ModuleFolderPath
    The path to the module folder. This folder should contain a Public subfolder with .ps1 files representing functions.

.EXAMPLE
    $moduleFolderPath = Join-Path $env:OneDriveCommercial "Code\Powershell\Cs1eToolkit"
    Update-FunctionsToExport -ModuleFolderPath $moduleFolderPath -Verbose

    Updates the module manifest in the specified folder by scanning the Public subfolder for .ps1 files and using their filenames as function names to export.

.INPUTS
    None. You cannot pipe objects to Update-FunctionsToExport.

.OUTPUTS
    None. This function does not generate any output.

.NOTES
    This function assumes that the filenames in the Public subfolder match exactly with the intended function names and are unique. It is designed to work with a specific module structure where the Public subfolder contains the .ps1 files representing the functions to be exported.

    The function does not validate whether the .ps1 files contain valid PowerShell functions. It solely relies on the naming convention.

#>
function Update-FunctionsToExport {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ModuleFolderPath
    )

    # Extract the module name from the folder path
    $moduleName = Split-Path -Path $ModuleFolderPath -Leaf

    # Define the path to the Public functions and module manifest
    $publicFunctionsFolderPath = Join-Path -Path $ModuleFolderPath -ChildPath "Public"
    $moduleManifestPath = Join-Path -Path $ModuleFolderPath -ChildPath "$moduleName.psd1"

    # Get all function names from the filenames in the Public folder
    $functionNames = Get-ChildItem -Path $publicFunctionsFolderPath -Filter *.ps1 |
        ForEach-Object {
            # Extract the base name of the file (which is the function name)
            $_.BaseName
        } | Sort-Object -Unique

    # Update the module manifest
    Update-ModuleManifest -Path $moduleManifestPath -FunctionsToExport $functionNames

    Write-Verbose "Updated module manifest $ModuleManifestName with current exported functions."
}