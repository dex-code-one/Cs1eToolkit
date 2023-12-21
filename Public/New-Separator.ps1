<#
.SYNOPSIS
    Generates a customizable separator string based on specified type and length.

.DESCRIPTION
    The New-Separator function creates a customizable separator string. It supports various styles, including single, double, and thick lines, as well as specialized top and bottom separators with corner decorations. The function is designed to enhance the visual layout of console output in scripts and command-line tools.

.PARAMETER Type
    Specifies the type of separator to generate. Available types include:
    - Single: A single line separator. Example: '────────────────────────────────────────────────'
    - Double: A double line separator. Example: '════════════════════════════════════════════════'
    - Thick: A thick line separator. Example: '████████████████████████████████████████████████'
    - SingleTop: A top border with single line and corners. Example: '┌──────────────────────────┐'
    - SingleBottom: A bottom border with single line and corners. Example: '└──────────────────────────┘'
    - DoubleTop: A top border with double lines and corners. Example: '╔══════════════════════════╗'
    - DoubleBottom: A bottom border with double lines and corners. Example: '╚══════════════════════════╝'
    - ThickTop: A thick top border with corners. Example: '█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█'
    - ThickBottom: A thick bottom border with corners. Example: '█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█'
    Default value: 'Double' (═══════════════════════════════════════════════════)

.PARAMETER Length
    Specifies the length of the separator in characters.
    Default value: 100.

.PARAMETER Name
    Optional. Specifies a name or label to be included in the separator for types with top or bottom borders. The name is placed at character position 2, in the separator. If the length of the separator is too short to include the name, an error is thrown.
    Default value: None.

.EXAMPLE
    PS> New-Separator -Type Single -Length 50
    Generates a single line separator 50 characters wide.

.EXAMPLE
    PS> New-Separator -Type 'SingleTop' -Length 50 -Name 'SECTION HEADER'
    Produces a single line top border with 'SECTION HEADER' , 50 characters wide.

    ┌──SECTION HEADER─────────────────────────────────┐

.EXAMPLE
    PS> New-Separator -Type 'SingleBottom' -Length 50 -Name 'SECTION HEADER'
    Produces a single line bottom border with 'SECTION HEADER' , 50 characters wide.
    
    └──SECTION HEADER─────────────────────────────────┘

.NOTES
    Author: john.nelson@1e.com
    Version: 202312.1823.2950.1
    This function is part of the XYZ PowerShell module.

.LINK
    Online Documentation: [URL to more detailed documentation or module repository]
#>
function New-Separator {
    param (
        [string] $Type = 'Double', # Default type
        [int] $Length = 100, # Default length
        [string] $Name # Optional name (for top and bottom separators)
    )

    $separatorChars = @{
        'Single' = '─'
        'Double' = '═'
        'Thick'  = '█'
        'SingleTop' = @('┌', '─', '┐')
        'SingleBottom' = @('└', '─', '┘')
        'DoubleTop' = @('╔', '═', '╗')
        'DoubleBottom' = @('╚', '═', '╝')
        'ThickTop' = @('█', '▀', '█')
        'ThickBottom' = @('█', '▄', '█')
    }

    # Function to create the separator with name
    function CreateSeparator([string] $leftChar, [string] $middleChar, [string] $rightChar, [int] $length, [string] $name) {
        $name = $name.ToUpper()
        $adjustedLength = $length - 2 - $name.Length
        if ($adjustedLength -lt 0) {
            throw "Length is too short to include the name"
        }
        $middle = $middleChar * 2 + $name + $middleChar * ($adjustedLength - 1)
        return $leftChar + $middle + $rightChar
    }

    if ($Type -in 'SingleTop', 'SingleBottom', 'DoubleTop', 'DoubleBottom', 'ThickTop', 'ThickBottom') {
        $leftChar = $separatorChars[$Type][0]
        $middleChar = $separatorChars[$Type][1]
        $rightChar = $separatorChars[$Type][2]
        if ([string]::IsNullOrEmpty($Name)) {
            $middleChar = $middleChar * ($Length - 2)
            return $leftChar + $middleChar + $rightChar
        } else {
            return CreateSeparator $leftChar $middleChar $rightChar $Length $Name
        }
    } else {
        return $separatorChars[$Type] * $Length
    }
}