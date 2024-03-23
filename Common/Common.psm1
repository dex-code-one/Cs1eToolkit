
function Add-Indentation {
    <#
    .SYNOPSIS
    Adds indentation to each line of input text.

    .DESCRIPTION
    The Add-Indentation function adds a specified number of spaces to the beginning of each line in a given string. This function is useful for formatting text output or preparing strings for display in a nested or hierarchical format.

    .PARAMETER Text
    The input text to be indented. This parameter is mandatory and accepts input from the pipeline.

    .PARAMETER IndentSize
    The number of spaces to add as indentation to each line of the input text. If not specified, the default indentation is 2 spaces. This parameter is optional.

    .EXAMPLE
    Add-Indentation -Text "This is line one.`nThis is line two."

    This example adds the default indentation (2 spaces) to each line of the input text.

    .EXAMPLE
    "Some text`nwith multiple lines" | Add-Indentation -IndentSize 4

    This example demonstrates using the function in a pipeline to indent each line of the input text with 4 spaces.

    .INPUTS
    System.String
    You can pipe a string to Add-Indentation.

    .OUTPUTS
    System.String
    Add-Indentation returns the indented text as a string.

    .NOTES
    Version:        1.0
    Author:         john.nelson@1e.com
    Creation Date:  2024-03-22
    Purpose/Change: Initial function development

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Text,
        
        [Parameter(Mandatory = $false)]
        [int]$IndentSize = 2
    )

    process {
        $indentation = ' ' * $IndentSize
        ($Text -split "`n" | ForEach-Object {
            "${indentation}$_"
        }) -join "`n"
    }
}

function New-Separator {
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

    .PARAMETER NewLineBefore
        When set, this switch adds a newline character (`n) before the separator output. This is useful for creating space before the separator when outputting to the console or a file.

    .PARAMETER NewLineAfter
        When set, this switch adds a newline character (`n) after the separator output. This allows for separating subsequent output or creating space after the separator.

    .PARAMETER IndentSize
        The number of spaces to indent the separator. Indentation is applied after any prepended newline and before the separator. This parameter is useful for aligning the separator with other output or text.

    .EXAMPLE
        PS > New-Separator -Type 'Single' -Length 50
        Generates a single line separator of 50 characters in length.

    .EXAMPLE
        PS > New-Separator -Type 'Double' -Length 100 -NewLineBefore -NewLineAfter
        Generates a double line separator of 100 characters in length with a newline character both before and after the separator.

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
        This function is part of the Cs1eToolkit PowerShell module.

    .LINK
        Online Documentation: [URL to more detailed documentation or module repository]
    #>
        param (
            [string] $Type = 'Double', # Default type
            [int] $Length = 100, # Default length
            [string] $Name, # Optional name (for top and bottom separators)
            [switch] $NewLineBefore, # Add a newline character before the output
            [switch] $NewLineAfter, # Add a newline character after the output
            [int] $IndentSize = 0 # Default indentation size (default is no indentation)
        )
    
        $separatorChars = @{
            'Single' = '─'
            'Double' = '═'
            'Thick'  = '█'
            'SingleTop' = @('┌', '─', '┐')
            'SingleBottom' = @('└', '─', '┘')
            'DoubleTop' = @('╔', '═', '╗')
            'DoubleBottom' = @('╚', '═', '╝')
            'ThickTop' = @('█', '█', '█')
            'ThickBottom' = @('█', '█', '█')
        }
    
        # Function to create the separator with name
        function CreateSeparator([string] $leftChar, [string] $middleChar, [string] $rightChar, [int] $length, [string] $name) {
            $name = $name.ToUpper()
            $adjustedLength = $length - 2 - $name.Length
            if ($adjustedLength -lt 0) {
                throw "Length is too short to include the name"
            }
            $middle = $middleChar * 2 + $name + $middleChar * ($adjustedLength - 2)
            return $leftChar + $middle + $rightChar
        }
    
        $separator = if ($Type -in 'SingleTop', 'SingleBottom', 'DoubleTop', 'DoubleBottom', 'ThickTop', 'ThickBottom') {
            $leftChar = $separatorChars[$Type][0]
            $middleChar = $separatorChars[$Type][1]
            $rightChar = $separatorChars[$Type][2]
            if ([string]::IsNullOrEmpty($Name)) {
                $middleChar = $middleChar * ($Length - 2)
                $leftChar + $middleChar + $rightChar
            } else {
                CreateSeparator $leftChar $middleChar $rightChar $Length $Name
            }
        } else {
            $separatorChars[$Type] * $Length
        }
    
        # Applying newline switches and indentation
        $output = ''
        if ($NewLineBefore) {
            $output += "`n"
        }
        if ($IndentSize -gt 0) {
            $indentation = ' ' * $IndentSize
            $output += $indentation
        }        
        $output += $separator
        if ($NewLineAfter) {
            $output += "`n"
        }
    
        return $output
}
    