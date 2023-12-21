# This file is meant to be viewed in VSCode.  It is not intended to be run directly.
# Use CTRL+K CTRL+0 collapse all outlined sections for better readability.
#
# Module: Cs1eToolkit
# Author: John.Nelson@1e.com
# Version: 202312.1823.2950.1
#
# This module contains all of the functions and classes that are used by the 1E Customer Success team

# Check if Ps1eToolkit is already loaded
if (-not (Get-Module -Name Ps1eToolkit -ListAvailable)) {
    Write-Warning "Ps1eToolkit module is not loaded. Attempting to load it."

    # Attempt to import Ps1eToolkit
    try {
        Import-Module Ps1eToolkit -ErrorAction Stop
        Write-Verbose "Ps1eToolkit module loaded successfully."
    } catch {
        Write-Error "Failed to load the required Ps1eToolkit module. Please ensure it is installed. Error: $_"
        return
    }
}

# Dot source all classes
Get-ChildItem -Path "$PSScriptRoot/Classes/*.ps1" | ForEach-Object {
    . $_.FullName
}

# Dot source all public functions
Get-ChildItem -Path "$PSScriptRoot/Public/*.ps1" | ForEach-Object {
    . $_.FullName
}

# Export all public functions
Export-ModuleMember -Function (Get-ChildItem -Path "$PSScriptRoot/Public/*.ps1" | ForEach-Object { $_.BaseName })
