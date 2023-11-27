---
external help file: Cs1eToolkit-help.xml
Module Name: Cs1eToolkit
online version:
schema: 2.0.0
---

# Update-1EFunctionsToExport

## SYNOPSIS
Updates the module manifest to export functions based on filenames in a specified directory.

## SYNTAX

```
Update-1EFunctionsToExport [-ModuleFolderPath] <String> [<CommonParameters>]
```

## DESCRIPTION
The Update-FunctionsToExport function updates a PowerShell module manifest file to include all functions to export.
It assumes that each .ps1 file in the specified Public directory of the module corresponds to a function, and the filename (without extension) is the function name.
This function extracts all such filenames, treats them as function names, and updates the module manifest accordingly.

## EXAMPLES

### EXAMPLE 1
```
$moduleFolderPath = Join-Path $env:OneDriveCommercial "Code\Powershell\Cs1eToolkit"
Update-FunctionsToExport -ModuleFolderPath $moduleFolderPath -Verbose
```

Updates the module manifest in the specified folder by scanning the Public subfolder for .ps1 files and using their filenames as function names to export.

## PARAMETERS

### -ModuleFolderPath
The path to the module folder.
This folder should contain a Public subfolder with .ps1 files representing functions.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to Update-FunctionsToExport.
## OUTPUTS

### None. This function does not generate any output.
## NOTES
This function assumes that the filenames in the Public subfolder match exactly with the intended function names and are unique.
It is designed to work with a specific module structure where the Public subfolder contains the .ps1 files representing the functions to be exported.

The function does not validate whether the .ps1 files contain valid PowerShell functions.
It solely relies on the naming convention.

## RELATED LINKS

[Update-ModuleManifest]()

