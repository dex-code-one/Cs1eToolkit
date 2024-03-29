
#region HELP INTELLISENSE
#Uncomment this region to enable intellisense for the eClasses module, otherwise, leave it commented out before releasing

class eHelpAttribute {
    [string]$Content

    eHelpAttribute([string]$content) {
        $this.Content = $content
    }

    [string] ToString() {
        return $this.Content
    }
}

# }

#endregion

#region Preload eHelpAttribute class
Add-Type -TypeDefinition @'
using System;

// This class is the base class for all single-attribute eHelp attributes
public class eHelpAttribute : Attribute
{
    public string Content { get; set; }

    public eHelpAttribute(string content)
    {
        this.Content = content;
    }
}

'@ -Language CSharp
#endregion

#╔═══BASE═════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region
    # This region contains the other base classes that are used by the eClasses module

    #--------------------------------------------
    #region enum eNewlineAdd
    #--------------------------------------------
    [flags()] enum eNewlineAdd {
        # Used to determine where a newline character should be added
        None = 0
        Before = 1
        After = 2
        Both = 3
    }
    #endregion

    #--------------------------------------------
    #region eEncoding
    #--------------------------------------------
    class eEncoding {
        static [System.Text.Encoding] $Encoding = [System.Text.Encoding]::Unicode
    }
    #endregion

    #--------------------------------------------
    #region eString
    #--------------------------------------------
    class eString {
        #============================================
        #region Properties
        #============================================
        [string] $Value
        #endregion


        #============================================
        #region Static/Hidden Properties
        #============================================
        static hidden [int] $IndentSize = 4
        #endregion


        #============================================
        #region Constructors
        #============================================

        #region Empty
        eString() {
            $this.Value = ''
        }
        #endregion

        #region [string] Value
        eString([string] $Value) {
            $this.Value = $Value
        }
        #endregion

        #region [eString] Value
        eString([eString] $Value) {
            $this.Value = $Value.Value
        }
        #endregion

        #endregion

        #============================================
        #region Methods
        #============================================

        #--------------------------------------------
        #region AddIndent
        #--------------------------------------------
        # Adds indentation to the current string
        [eString] AddIndent() {
            return [eString]::AddIndent($this.Value, [eString]::IndentSize)
        }


        [eString] AddIndent([int] $IndentSize) {
            return [eString]::AddIndent($this.Value, $IndentSize)
        }

        static [eString] AddIndent([string] $Value) {
            return [eString]::AddIndent($Value, [eString]::IndentSize)
        }

        static [eString] AddIndent([string] $Value, [int] $IndentSize) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            return [eString]::new(($Value -split "`n" | ForEach-Object { "${indentation}$_" }) -join "`n")
        }

        static [eString] AddIndent([eString] $Value) {
            return [eString]::AddIndent($Value.Value, [eString]::IndentSize)
        }

        static [eString] AddIndent([eString] $Value, [int] $IndentSize) {
            return [eString]::AddIndent($Value.Value, $IndentSize)
        }
        #endregion

        #--------------------------------------------
        #region AddNewLine
        #--------------------------------------------
        # Adds a new line to the current string
        [eString] AddNewLine() {
            return [eString]::AddNewLine($this.Value, [eNewlineAdd]::After)
        }

        [eString] AddNewLine([eNewlineAdd] $NewlineAdd) {
            return [eString]::AddNewLine($this.Value, $NewlineAdd)
        }

        static [eString] AddNewLine([string] $Value) {
            return [eString]::AddNewLine($Value, [eNewlineAdd]::After)
        }

        static [eString] AddNewLine([eString] $Value) {
            return [eString]::AddNewLine($Value.Value, [eNewlineAdd]::After)
        }

        static [eString] AddNewLine([eString] $Value, [eNewlineAdd] $NewlineAdd) {
            return [eString]::AddNewLine($Value.Value, $NewlineAdd)
        }

        static [eString] AddNewLine([string] $Value, [eNewlineAdd] $NewlineAdd) {
            $newValue = $Value
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$newValue = "`n$newValue"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$newValue = "$newValue`n"}
            return [eString]::new($newValue)
        }
        #endregion

        #--------------------------------------------
        #region Chars
        #--------------------------------------------
        [char] Chars([int] $Index) {
            if ($Index -lt 0 -or $Index -ge $this.Value.Length) {
                throw [System.ArgumentOutOfRangeException]::new("index", "Index must be within the bounds of the string.")
            }
            return $this.Value[$Index]
        }

        static [char] Chars([string] $Value, [int] $Index) {
            if ($Index -lt 0 -or $Index -ge $Value.Length) {
                throw [System.ArgumentOutOfRangeException]::new("index", "Index must be within the bounds of the string.")
            }
            return $Value[$Index]
        }

        static [char] Chars([eString] $Value, [int] $Index) {
            if ($Index -lt 0 -or $Index -ge $Value.Value.Length) {
                throw [System.ArgumentOutOfRangeException]::new("index", "Index must be within the bounds of the string.")
            }
            return $Value.Value[$Index]
        }
        #endregion

        #--------------------------------------------
        #region Contains
        #--------------------------------------------
        [bool] Contains([string] $Value) {
            return $this.Value.Contains($Value)
        }

        static [bool] Contains([string] $Value, [string] $SearchValue) {
            return $Value.Contains($SearchValue)
        }

        static [bool] Contains([eString] $Value, [string] $SearchValue) {
            return $Value.Value.Contains($SearchValue)
        }
        #endregion

        #--------------------------------------------
        #region ConvertToComment
        #--------------------------------------------
        [eString] ConvertToComment() {
            return [eString]::ConvertToComment($this.Value)
        }

        static [eString] ConvertToComment([string] $Value) {
            return [eString]::new(($Value -split "`n" | ForEach-Object {"#$_"}) -join "`n")
        }

        static [eString] ConvertToComment([eString] $Value) {
            return [eString]::ConvertToComment($Value.Value)
        }
        #endregion

        #--------------------------------------------
        #region EndsWith
        #--------------------------------------------
        [bool] EndsWith([string] $Value) {
            return $this.Value.EndsWith($Value)
        }

        static [bool] EndsWith([string] $Value, [string] $SearchValue) {
            return $Value.EndsWith($SearchValue)
        }

        static [bool] EndsWith([eString] $Value, [string] $SearchValue) {
            return $Value.Value.EndsWith($SearchValue)
        }
        #endregion

        #--------------------------------------------
        #region Equals
        #--------------------------------------------
        [bool] Equals([string] $Value) {
            return $this.Value.Equals($Value)
        }

        static [bool] Equals([string] $Value, [string] $SearchValue) {
            return $Value.Equals($SearchValue)
        }

        static [bool] Equals([eString] $Value, [string] $SearchValue) {
            return $Value.Value.Equals($SearchValue)
        }

        static [bool] Equals([eString] $Value, [eString] $SearchValue) {
            return $Value.Value.Equals($SearchValue.Value)
        }
        #endregion

        #--------------------------------------------
        #region Length
        #--------------------------------------------
        [int] Length() {
            return $this.Value.Length            
        }

        static [int] Length([string] $Value) {
            return $Value.Length
        }

        static [int] Length([eString] $Value) {
            return $Value.Value.Length
        }
        #endregion

        #--------------------------------------------
        #region PadLeft
        #--------------------------------------------
        [eString] PadLeft([int] $TotalWidth) {
            return [eString]::PadLeft($this.Value, $TotalWidth, ' ')
        }

        [eString] PadLeft([int] $TotalWidth, [char] $PaddingChar) {
            return [eString]::PadLeft($this.Value, $TotalWidth, $PaddingChar)
        }

        static [eString] PadLeft([string] $Value, [int] $TotalWidth) {
            return [eString]::PadLeft($Value, $TotalWidth, ' ')
        }

        static [eString] PadLeft([string] $Value, [int] $TotalWidth, [char] $PaddingChar) {
            return [eString]::new($Value.PadLeft($TotalWidth, $PaddingChar))
        }

        static [eString] PadLeft([eString] $Value, [int] $TotalWidth) {
            return [eString]::PadLeft($Value.Value, $TotalWidth, ' ')
        }

        static [eString] PadLeft([eString] $Value, [int] $TotalWidth, [char] $PaddingChar) {
            return [eString]::PadLeft($Value.Value, $TotalWidth, $PaddingChar)
        }
        #endregion

        #--------------------------------------------
        #region PadRight
        #--------------------------------------------
        [eString] PadRight([int] $TotalWidth) {
            return [eString]::PadRight($this.Value, $TotalWidth, ' ')
        }

        [eString] PadRight([int] $TotalWidth, [char] $PaddingChar) {
            return [eString]::PadRight($this.Value, $TotalWidth, $PaddingChar)
        }

        static [eString] PadRight([string] $Value, [int] $TotalWidth) {
            return [eString]::PadRight($Value, $TotalWidth, ' ')
        }

        static [eString] PadRight([string] $Value, [int] $TotalWidth, [char] $PaddingChar) {
            return [eString]::new($Value.PadRight($TotalWidth, $PaddingChar))
        }

        static [eString] PadRight([eString] $Value, [int] $TotalWidth) {
            return [eString]::PadRight($Value.Value, $TotalWidth, ' ')
        }

        static [eString] PadRight([eString] $Value, [int] $TotalWidth, [char] $PaddingChar) {
            return [eString]::PadRight($Value.Value, $TotalWidth, $PaddingChar)
        }
        #endregion

        #--------------------------------------------
        #region Remove
        #--------------------------------------------
        [eString] Remove([int] $StartIndex) {
            return [eString]::Remove($this.Value, $StartIndex)
        }

        [eString] Remove([int] $StartIndex, [int] $Count) {
            return [eString]::Remove($this.Value, $StartIndex, $Count)
        }

        static [eString] Remove([string] $Value, [int] $StartIndex) {
            return [eString]::new($Value.Remove($StartIndex))
        }

        static [eString] Remove([string] $Value, [int] $StartIndex, [int] $Count) {
            return [eString]::new($Value.Remove($StartIndex, $Count))
        }

        static [eString] Remove([eString] $Value, [int] $StartIndex) {
            return [eString]::Remove($Value.Value, $StartIndex)
        }

        static [eString] Remove([eString] $Value, [int] $StartIndex, [int] $Count) {
            return [eString]::Remove($Value.Value, $StartIndex, $Count)
        }
        #endregion

        #--------------------------------------------
        #region Replace
        #--------------------------------------------
        [eString] Replace([string] $OldValue, [string] $NewValue) {
            return [eString]::Replace($this.Value, $OldValue, $NewValue)
        }

        static [eString] Replace([string] $Value, [string] $OldValue, [string] $NewValue) {
            return [eString]::new($Value.Replace($OldValue, $NewValue))
        }

        static [eString] Replace([eString] $Value, [string] $OldValue, [string] $NewValue) {
            return [eString]::Replace($Value.Value, $OldValue, $NewValue)
        }
        #endregion

        #--------------------------------------------
        #region ReplaceLineEndings
        #--------------------------------------------
        # Replaces line endings in the current string
        [eString] ReplaceLineEndings() {
            return [eString]::ReplaceLineEndings($this.Value)
        }

        static [eString] ReplaceLineEndings([string] $Value) {
            return [eString]::new($Value.ReplaceLineEndings())
        }

        static [eString] ReplaceLineEndings([eString] $Value) {
            return [eString]::ReplaceLineEndings($Value.Value)
        }
        #endregion

        #--------------------------------------------
        #region SetClipboard
        #--------------------------------------------
        # Sets the current string to the clipboard
        [void] SetClipboard() {
            $this.Value | Set-Clipboard
        }

        # Overload to passthru the value as eString
        [eString] SetClipboard([bool] $Passthru) {
            $this.Value | Set-Clipboard
            if ($Passthru) {
                return $this
            } else {
                return $null
            }
        }

        # Static overload for setting a string to the clipboard
        static [void] SetClipboard([eString]$Value) {
            Set-Clipboard -Value $Value.Value
        }

        # Static overload for setting an eString to the clipboard and passing the value through
        static [eString] SetClipboard([eString]$Value, [bool] $Passthru) {
            Set-Clipboard -Value $Value.Value
            if ($Passthru) {
                return $Value
            } else {
                return $null
            }
        }

        # Static overload for setting a string to the clipboard and passing the value through
        static [eString] SetClipboard([string]$Value, [bool] $Passthru) {
            Set-Clipboard -Value $Value
            if ($Passthru) {
                return [eString]::new($Value)
            } else {
                return $null
            }
        }
        #endregion

        #--------------------------------------------
        #region Split
        #--------------------------------------------
        # Splits the current string
        [eString[]] Split([char[]] $Separator) {
            return [eString]::Split($this.Value, $Separator)
        }

        static [eString[]] Split([string] $Value, [char[]] $Separator) {
            return $Value.Split($Separator) | ForEach-Object { [eString]::new($_) }
        }

        static [eString[]] Split([eString] $Value, [char[]] $Separator) {
            return [eString]::Split($Value.Value, $Separator)
        }
        #endregion

        #--------------------------------------------
        #region StartsWith
        #--------------------------------------------
        # Determines if the current string starts with a value
        [bool] StartsWith([string] $Value) {
            return $this.Value.StartsWith($Value)
        }

        static [bool] StartsWith([string] $Value, [string] $SearchValue) {
            return $Value.StartsWith($SearchValue)
        }

        static [bool] StartsWith([eString] $Value, [string] $SearchValue) {
            return $Value.Value.StartsWith($SearchValue)
        }
        #endregion

        #--------------------------------------------
        #region Substring
        #--------------------------------------------
        # Returns a substring from the current string
        [eString] Substring([int] $StartIndex) {
            return [eString]::Substring($this.Value, $StartIndex)
        }

        [eString] Substring([int] $StartIndex, [int] $Length) {
            return [eString]::Substring($this.Value, $StartIndex, $Length)
        }

        static [eString] Substring([string] $Value, [int] $StartIndex) {
            return [eString]::new($Value.Substring($StartIndex))
        }

        static [eString] Substring([string] $Value, [int] $StartIndex, [int] $Length) {
            return [eString]::new($Value.Substring($StartIndex, $Length))
        }

        static [eString] Substring([eString] $Value, [int] $StartIndex) {
            return [eString]::Substring($Value.Value, $StartIndex)
        }

        static [eString] Substring([eString] $Value, [int] $StartIndex, [int] $Length) {
            return [eString]::Substring($Value.Value, $StartIndex, $Length)
        }
        #endregion

        #--------------------------------------------
        #region ToCharArray
        #--------------------------------------------
        # Converts the current string to a character array
        [char[]] ToCharArray() {
            return $this.Value.ToCharArray()
        }

        static [char[]] ToCharArray([string] $Value) {
            return $Value.ToCharArray()
        }

        static [char[]] ToCharArray([eString] $Value) {
            return $Value.Value.ToCharArray()
        }
        #endregion

        #--------------------------------------------
        #region ToEVersion
        #--------------------------------------------
        # Converts the current string to an eVersion object
        [eVersion] ToEVersion() {
            return [eVersion]::new($this.Value)
        }
        #endregion

        #--------------------------------------------
        #region ToLower
        #--------------------------------------------
        # Converts the current string to lowercase
        [eString] ToLower() {
            return [eString]::new($this.Value.ToLower())
        }

        static [eString] ToLower([string] $Value) {
            return [eString]::new($Value.ToLower())
        }

        static [eString] ToLower([eString] $Value) {
            return [eString]::new($Value.Value.ToLower())
        }
        #endregion

        #--------------------------------------------
        #region ToLowerInvariant
        #--------------------------------------------
        # Converts the current string to lowercase using the invariant culture
        [eString] ToLowerInvariant() {
            return [eString]::new($this.Value.ToLowerInvariant())
        }

        static [eString] ToLowerInvariant([string] $Value) {
            return [eString]::new($Value.ToLowerInvariant())
        }

        static [eString] ToLowerInvariant([eString] $Value) {
            return [eString]::new($Value.Value.ToLowerInvariant())
        }
        #endregion

        #--------------------------------------------
        #region ToString
        #--------------------------------------------
        [string] ToString() {
            return $this.Value
        }

        static [string] ToString([string] $Value) {
            return $Value
        }

        static [string] ToString([eString] $Value) {
            return $Value.Value
        }
        #endregion

        #--------------------------------------------
        #region ToUpper
        #--------------------------------------------
        # Converts the current string to uppercase
        [eString] ToUpper() {
            return [eString]::new($this.Value.ToUpper())
        }

        static [eString] ToUpper([string] $Value) {
            return [eString]::new($Value.ToUpper())
        }

        static [eString] ToUpper([eString] $Value) {
            return [eString]::new($Value.Value.ToUpper())
        }
        #endregion

        #--------------------------------------------
        #region ToUpperInvariant
        #--------------------------------------------
        # Converts the current string to uppercase using the invariant culture
        [eString] ToUpperInvariant() {
            return [eString]::new($this.Value.ToUpperInvariant())
        }

        static [eString] ToUpperInvariant([string] $Value) {
            return [eString]::new($Value.ToUpperInvariant())
        }

        static [eString] ToUpperInvariant([eString] $Value) {
            return [eString]::new($Value.Value.ToUpperInvariant())
        }
        #endregion

        #--------------------------------------------
        #region Trim
        #--------------------------------------------
        # Trims the current string
        [eString] Trim() {
            return [eString]::new($this.Value.Trim())
        }

        static [eString] Trim([string] $Value) {
            return [eString]::new($Value.Trim())
        }

        static [eString] Trim([eString] $Value) {
            return [eString]::new($Value.Value.Trim())
        }
        #endregion

        #--------------------------------------------
        #region TrimEnd
        #--------------------------------------------
        # Trims the current string on the right
        [eString] TrimEnd() {
            return [eString]::new($this.Value.TrimEnd())
        }

        static [eString] TrimEnd([string] $Value) {
            return [eString]::new($Value.TrimEnd())
        }

        static [eString] TrimEnd([eString] $Value) {
            return [eString]::new($Value.Value.TrimEnd())
        }
        #endregion

        #--------------------------------------------
        #region TrimStart
        #--------------------------------------------
        # Trims the current string on the left
        [eString] TrimStart() {
            return [eString]::new($this.Value.TrimStart())
        }

        static [eString] TrimStart([string] $Value) {
            return [eString]::new($Value.TrimStart())
        }

        static [eString] TrimStart([eString] $Value) {
            return [eString]::new($Value.Value.TrimStart())
        }
        #endregion

        #endregion
        #============================================

    }
    #endregion 

    #--------------------------------------------
    #region eLineBuilder
    #--------------------------------------------
    # Utility class to generate lines of various types like separators, dividers, etc.
    class eLineBuilder {
        # Utility class to generate lines of various types like separators, dividers, etc.

        #--------------------------------------------
        #region Properties
        #--------------------------------------------
        static [int] $DefaultLength = 80
        static [int] $IndentSize = 0
        static [int] $Level1Length = 120
        static [int] $Level2Length = 100
        static [int] $Level3Length = 80
        static [int] $Level4Length = 60
        #endregion

        #--------------------------------------------
        #region Custom
        #--------------------------------------------
        # Generates a custom line

        # [eLineBuilder]::Custom('X')
        # XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        static [string] Custom([string]$char) {
            return [eLineBuilder]::Custom($char, [eLineBuilder]::DefaultLength, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Custom([string] $char, [int] $length) {
            return [eLineBuilder]::Custom($char, $length, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Custom([string] $char, [int] $length, [int] $IndentSize) {
            return [eLineBuilder]::Custom($char, $length, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] Custom ([string]$char, [int]$length, [int]$IndentSize, [eNewlineAdd]$NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $line = "${indentation}$($char * $length)"
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region Dashed
        #--------------------------------------------
        # Generates a dashed line

        # [eLineBuilder]::Dashed()
        # --------------------------------------------------------------------------------
        static [string] Dashed() {
            return [eLineBuilder]::Dashed([eLineBuilder]::DefaultLength, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Dashed([int] $length) {
            return [eLineBuilder]::Dashed($length, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Dashed([int] $length, [int] $IndentSize) {
            return [eLineBuilder]::Dashed($length, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] Dashed([int] $length, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $line = "${indentation}$('-' * $length)"
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region Dotted
        #--------------------------------------------
        # Generates a dotted line
        # [eLineBuilder]::Dotted()
        # ················································································
        static [string] Dotted() {
            return [eLineBuilder]::Dotted([eLineBuilder]::DefaultLength, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Dotted([int] $length) {
            return [eLineBuilder]::Dotted($length, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Dotted([int] $length, [int] $IndentSize) {
            return [eLineBuilder]::Dotted($length, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] Dotted([int] $length, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $line = "${indentation}$('·' * $length)"
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region Double
        #--------------------------------------------
        # Generates a double line
        # [eLineBuilder]::Double()
        # ════════════════════════════════════════════════════════════════════════════════
        static [string] Double() {
            return [eLineBuilder]::Double([eLineBuilder]::DefaultLength, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Double([int] $length) {
            return [eLineBuilder]::Double($length, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Double([int] $length, [int] $IndentSize) {
            return [eLineBuilder]::Double($length, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] Double([int] $length, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $line = "${indentation}$('═' * $length)"
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region DoubleBottom
        #--------------------------------------------
        # Generates a double line with a bottom cap
        # [eLineBuilder]::DoubleBottom()
        # ╚══════════════════════════════════════════════════════════════════════════════╝
        # [eLineBuilder]::DoubleBottom('END BLOCK')
        # ╚═══END BLOCK══════════════════════════════════════════════════════════════════╝
        static [string] DoubleBottom() {
            return [eLineBuilder]::DoubleBottom([eLineBuilder]::DefaultLength, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleBottom([string] $label) {
            return [eLineBuilder]::DoubleBottom([eLineBuilder]::DefaultLength, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleBottom([string] $label, [int] $IndentSize) {
            return [eLineBuilder]::DoubleBottom([eLineBuilder]::DefaultLength, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleBottom([string] $label, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            return [eLineBuilder]::DoubleBottom([eLineBuilder]::DefaultLength, $label, $IndentSize, $NewLineAdd)
        }

        static [string] DoubleBottom([int] $length) {
            return [eLineBuilder]::DoubleBottom($length, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleBottom([int] $length, [string] $label) {
            return [eLineBuilder]::DoubleBottom($length, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleBottom([int] $length, [string] $label, [int] $IndentSize) {
            return [eLineBuilder]::DoubleBottom($length, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleBottom([int] $length, [string] $label, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $text = $label.PadRight($length - 5,'═')
            $line = "${indentation}╚═══" + $text + '╝'
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region DoubleTop
        #--------------------------------------------
        # Generates a double line with a top cap
        # [eLineBuilder]::DoubleTop()
        # ╔══════════════════════════════════════════════════════════════════════════════╗
        # [eLineBuilder]::DoubleTop('START BLOCK')
        # ╔═══START BLOCK════════════════════════════════════════════════════════════════╗
        static [string] DoubleTop() {
            return [eLineBuilder]::DoubleTop([eLineBuilder]::DefaultLength, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleTop([string] $label) {
            return [eLineBuilder]::DoubleTop([eLineBuilder]::DefaultLength, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleTop([string] $label, [int] $IndentSize) {
            return [eLineBuilder]::DoubleTop([eLineBuilder]::DefaultLength, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleTop([string] $label, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            return [eLineBuilder]::DoubleTop([eLineBuilder]::DefaultLength, $label, $IndentSize, $NewLineAdd)
        }

        static [string] DoubleTop([int] $length) {
            return [eLineBuilder]::DoubleTop($length, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleTop([int] $length, [string] $label) {
            return [eLineBuilder]::DoubleTop($length, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleTop([int] $length, [string] $label, [int] $IndentSize) {
            return [eLineBuilder]::DoubleTop($length, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleTop([int] $length, [string] $label, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $text = $label.PadRight($length - 5, '═')
            $line = "${indentation}╔═══" + $text + '╗'
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region DoubleWave
        #--------------------------------------------
        # Generates a double wave line
        # [eLineBuilder]::DoubleWave()
        # ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ ═ 
        static [string] DoubleWave() {
            return [eLineBuilder]::DoubleWave([eLineBuilder]::DefaultLength, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleWave([int] $length) {
            return [eLineBuilder]::DoubleWave($length, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleWave([int] $length, [int] $IndentSize) {
            return [eLineBuilder]::DoubleWave($length, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] DoubleWave([int] $length, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $line = $indentation
            for ($i = 0; $i -lt $length; $i++) {
                $line += if ($i % 2 -eq 0) { '═' } else { ' ' }
            }
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region Heavy
        #--------------------------------------------
        # Generates a single heavy line
        # [eLineBuilder]::Heavy()
        # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        static [string] Heavy() {
            return [eLineBuilder]::Heavy([eLineBuilder]::DefaultLength, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Heavy([int] $length) {
            return [eLineBuilder]::Heavy($length, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Heavy([int] $length, [int] $IndentSize) {
            return [eLineBuilder]::Heavy($length, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] Heavy([int] $length, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $line = "${indentation}$('━' * $length)"
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region HeavyTop
        #--------------------------------------------
        # Generates a single heavy line with a top cap
        # [eLineBuilder]::HeavyTop()
        static [string] HeavyTop() {
            return [eLineBuilder]::HeavyTop([eLineBuilder]::DefaultLength, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] HeavyTop([string] $label) {
            return [eLineBuilder]::HeavyTop([eLineBuilder]::DefaultLength, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] HeavyTop([string] $label, [int] $IndentSize) {
            return [eLineBuilder]::HeavyTop([eLineBuilder]::DefaultLength, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] HeavyTop([int] $length) {
            return [eLineBuilder]::HeavyTop($length, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] HeavyTop([int] $length, [string] $label) {
            return [eLineBuilder]::HeavyTop($length, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] HeavyTop([int] $length, [string] $label, [int] $IndentSize) {
            return [eLineBuilder]::HeavyTop($length, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] HeavyTop([int] $length, [string] $label, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $text = $label.PadRight($length - 5,'━')
            $line = "${indentation}┏━━━" + $text + '┓'
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region HeavyBottom
        #--------------------------------------------
        # Generates a single heavy line with a bottom cap
        # [eLineBuilder]::HeavyBottom()
        static [string] HeavyBottom() {
            return [eLineBuilder]::HeavyBottom([eLineBuilder]::DefaultLength, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] HeavyBottom([int] $length) {
            return [eLineBuilder]::HeavyBottom($length, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] HeavyBottom([int] $length, [string] $label) {
            return [eLineBuilder]::HeavyBottom($length, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] HeavyBottom([int] $length, [string] $label, [int] $IndentSize) {
            return [eLineBuilder]::HeavyBottom($length, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] HeavyBottom([int] $length, [string] $label, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $text = $label.PadRight($length - 5,'━')
            $line = "${indentation}┗━━━" + $text + '┛'
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region Mixed
        #--------------------------------------------
        # Generates a mixed line
        # [eLineBuilder]::Mixed()
        # -·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·-·
        static [string] Mixed() {
            return [eLineBuilder]::Mixed([eLineBuilder]::DefaultLength, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Mixed([int] $length) {
            return [eLineBuilder]::Mixed($length, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Mixed([int] $length, [int] $IndentSize) {
            return [eLineBuilder]::Mixed($length, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] Mixed([int] $length, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $line = $indentation
            for ($i = 0; $i -lt $length; $i++) {
                $line += if ($i % 2 -eq 0) { '-' } else { '·' }
            }
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion
        
        #--------------------------------------------
        #region Single
        #--------------------------------------------
        # Generates a single line
        # [eLineBuilder]::Single()
        # ────────────────────────────────────────────────────────────────────────────────
        static [string] Single() {
            return [eLineBuilder]::Single([eLineBuilder]::DefaultLength, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Single([int] $length) {
            return [eLineBuilder]::Single($length, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Single([int] $length, [int] $IndentSize) {
            return [eLineBuilder]::Single($length, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] Single([int] $length, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $line = "${indentation}$('─' * $length)"
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region SingleTop
        #--------------------------------------------
        # Generates a single line with a top cap
        # [eLineBuilder]::SingleTop()
        # ┌───────────────────────────────────────────────────────────────────────────────┐
        # [eLineBuilder]::SingleTop('START BLOCK')
        # ┌───START BLOCK─────────────────────────────────────────────────────────────────┐
        static [string] SingleTop() {
            return [eLineBuilder]::SingleTop([eLineBuilder]::DefaultLength, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] SingleTop([int] $length) {
            return [eLineBuilder]::SingleTop($length, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] SingleTop([int] $length, [string] $label) {
            return [eLineBuilder]::SingleTop($length, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] SingleTop([int] $length, [string] $label, [int] $IndentSize) {
            return [eLineBuilder]::SingleTop($length, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] SingleTop([int] $length, [string] $label, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $text = $label.PadRight($length - 5,'─')
            $line = "${indentation}┌───" + $text + '┐'
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region SingleBottom
        #--------------------------------------------
        # Generates a single line with a bottom cap
        # [eLineBuilder]::SingleBottom()
        # └───────────────────────────────────────────────────────────────────────────────┘
        # [eLineBuilder]::SingleBottom('END BLOCK')
        # └───END BLOCK───────────────────────────────────────────────────────────────────┘
        static [string] SingleBottom() {
            return [eLineBuilder]::SingleBottom([eLineBuilder]::DefaultLength, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] SingleBottom([int] $length) {
            return [eLineBuilder]::SingleBottom($length, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] SingleBottom([int] $length, [string] $label) {
            return [eLineBuilder]::SingleBottom($length, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] SingleBottom([int] $length, [string] $label, [int] $IndentSize) {
            return [eLineBuilder]::SingleBottom($length, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] SingleBottom([int] $length, [string] $label, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $text = $label.PadRight($length - 5,'─')
            $line = "${indentation}└───" + $text + '┘'
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion
    
        #--------------------------------------------
        #region Thick
        #--------------------------------------------
        # Generates a thick line
        # [eLineBuilder]::Thick()
        # ████████████████████████████████████████████████████████████████████████████████
        static [string] Thick() {
            return [eLineBuilder]::Thick([eLineBuilder]::DefaultLength, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Thick([int] $length) {
            return [eLineBuilder]::Thick($length, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Thick([int] $length, [int] $IndentSize) {
            return [eLineBuilder]::Thick($length, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] Thick([int] $length, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $line = "${indentation}$('█' * $length)"
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

        #--------------------------------------------
        #region ThickBottom
        #--------------------------------------------
        # Generates a thick line with a bottom cap
        # [eLineBuilder]::ThickBottom()
        # ██                                                                            ██
        # ████████████████████████████████████████████████████████████████████████████████

        # [eLineBuilder]::ThickBottom('END BLOCK')
        # ██ END BLOCK                                                                  ██
        # ████████████████████████████████████████████████████████████████████████████████

        static [string] ThickBottom() {
            return [eLineBuilder]::ThickBottom([eLineBuilder]::DefaultLength, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] ThickBottom([string] $label) {
            return [eLineBuilder]::ThickBottom([eLineBuilder]::DefaultLength, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] ThickBottom([string] $label, [int] $IndentSize) {
            return [eLineBuilder]::ThickBottom([eLineBuilder]::DefaultLength, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] ThickBottom([string] $label, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            return [eLineBuilder]::ThickBottom([eLineBuilder]::DefaultLength, $label, $IndentSize, $NewLineAdd)
        }

        static [string] ThickBottom([int] $length) {
            return [eLineBuilder]::ThickBottom($length, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] ThickBottom([int] $length, [string] $label) {
            return [eLineBuilder]::ThickBottom($length, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] ThickBottom([int] $length, [string] $label, [int] $IndentSize) {
            return [eLineBuilder]::ThickBottom($length, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] ThickBottom([int] $length, [string] $label, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $text = $label.PadRight($length - 8)
            $lines = "${indentation}██ " + $text + (' ' * ($length - 5 - $text.Length)) + "██`n${indentation}" + ('█' * $length)
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$lines = "`n$lines"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$lines = "$lines`n"}
            return [eString]::new($lines)
        }
        #endregion

        #--------------------------------------------
        #region ThickTop
        #--------------------------------------------
        # Generates a thick line with a top cap
        # [eLineBuilder]::ThickTop()
        # ████████████████████████████████████████████████████████████████████████████████
        # ██                                                                            ██
        # [eLineBuilder]::ThickTop('START BLOCK')
        # ████████████████████████████████████████████████████████████████████████████████
        # ██ START BLOCK                                                                ██        
        static [string] ThickTop() {
            return [eLineBuilder]::ThickTop([eLineBuilder]::DefaultLength, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] ThickTop([string] $label) {
            return [eLineBuilder]::ThickTop([eLineBuilder]::DefaultLength, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] ThickTop([string] $label, [int] $IndentSize) {
            return [eLineBuilder]::ThickTop([eLineBuilder]::DefaultLength, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] ThickTop([string] $label, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            return [eLineBuilder]::ThickTop([eLineBuilder]::DefaultLength, $label, $IndentSize, $NewLineAdd)
        }

        static [string] ThickTop([int] $length) {
            return [eLineBuilder]::ThickTop($length, '', [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] ThickTop([int] $length, [string] $label) {
            return [eLineBuilder]::ThickTop($length, $label, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] ThickTop([int] $length, [string] $label, [int] $IndentSize) {
            return [eLineBuilder]::ThickTop($length, $label, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] ThickTop([int] $length, [string] $label, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $text = $label.PadRight($length - 8)
            $lines = ${indentation} + '█' * $length + "`n${indentation}" + '██ ' + $text + (' ' * ($length - 5 - $text.Length)) + "██"
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$lines = "`n$lines"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$lines = "$lines`n"}
            return [eString]::new($lines)
        }
        #endregion

        #--------------------------------------------
        #region Wave
        #--------------------------------------------
        # Generates a wave line
        # [eLineBuilder]::Wave()
        # ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ 
        static [string] Wave() {
            return [eLineBuilder]::Wave([eLineBuilder]::DefaultLength, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Wave([int] $length) {
            return [eLineBuilder]::Wave($length, [eLineBuilder]::IndentSize, [eNewlineAdd]::None)
        }

        static [string] Wave([int] $length, [int] $IndentSize) {
            return [eLineBuilder]::Wave($length, $IndentSize, [eNewlineAdd]::None)
        }

        static [string] Wave([int] $length, [int] $IndentSize, [eNewlineAdd] $NewlineAdd) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            $line = $indentation
            for ($i = 0; $i -lt $length; $i++) {
                $line += if ($i % 2 -eq 0) { '─' } else { ' ' }
            }
            if ($NewlineAdd -band [eNewlineAdd]::Before) {$line = "`n$line"}
            if ($NewlineAdd -band [eNewlineAdd]::After) {$line = "$line`n"}
            return [eString]::new($line)
        }
        #endregion

    }
    #endregion

    #--------------------------------------------
    #region eBlock
    #--------------------------------------------
    # Class to generate nested block lines for formatting/separation, etc.
    #
#    PS D:\OneDrive - 1E\Documents\PowerShell\Modules> $blk = [eBlock]::new()
#    PS D:\OneDrive - 1E\Documents\PowerShell\Modules> $blk.GetBlockLine(1,'Top','CLASS DEFINITION')
#    
#    ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
#    ██ CLASS DEFINITION                                                                                                   ██
#    PS D:\OneDrive - 1E\Documents\PowerShell\Modules> $blk.GetBlockLine(2,'Top','PROPERTIES')      
#    
#        ╔═══PROPERTIES═══════════════════════════════════════════════════════════════════════════════════════════════════╗
#    PS D:\OneDrive - 1E\Documents\PowerShell\Modules> $blk.GetBlockLine(3,'Top','Value')      
#    
#            ┏━━━Value━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#    PS D:\OneDrive - 1E\Documents\PowerShell\Modules> $blk.GetBlockLine(3,'Bottom','Value')
#    
#            ┗━━━Value━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
#    PS D:\OneDrive - 1E\Documents\PowerShell\Modules> $blk.GetBlockLine(2,'Bottom','PROPERTIES')
#    
#        ╚═══PROPERTIES═══════════════════════════════════════════════════════════════════════════════════════════════════╝
#    PS D:\OneDrive - 1E\Documents\PowerShell\Modules> $blk.GetBlockLine(1,'Bottom','CLASS DEFINITION')
#    
#    ██ CLASS DEFINITION                                                                                                   ██
#    ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████    
    class eBlock {
        #region Properties
        [int] $BlockWidth
        [int] $IndentSize
        [eNewlineAdd] $NewlineAdd

        hidden [int] $DefaultBlockWidth = 120
        hidden [int] $DefaultIndentSize = 4
        hidden [eNewlineAdd] $DefaultNewlineAdd = [eNewlineAdd]::Before
        #endregion

        #region Constructors
        eBlock() {
            $this.BlockWidth = $this.DefaultBlockWidth
            $this.IndentSize = $this.DefaultIndentSize
            $this.NewlineAdd = $this.DefaultNewlineAdd
        }        

        eBlock([int]$BlockWidth) {
            $this.BlockWidth = $BlockWidth
            $this.IndentSize = $this.DefaultIndentSize
            $this.NewlineAdd = $this.DefaultNewlineAdd
        }

        eBlock([int]$BlockWidth, [int]$IndentSize) {
            $this.BlockWidth = $BlockWidth
            $this.IndentSize = $IndentSize
            $this.NewlineAdd = $this.DefaultNewlineAdd
        }

        eBlock([int]$BlockWidth, [int]$IndentSize, [eNewlineAdd]$NewlineAdd) {
            $this.BlockWidth = $BlockWidth
            $this.IndentSize = $IndentSize
            $this.NewlineAdd = $NewlineAdd
        }
        #endregion

        #region Methods

        # Get a block line based on the block level.  With no location or label, we'll just return a line
        [string] GetBlockLine([int]$BlockLevel) {
            switch ($BlockLevel) {
                1 {
                    $currLen = $this.BlockWidth
                    $currIndent = 0
                    return [eLineBuilder]::Thick($currLen, $currIndent, $this.NewlineAdd)
                }
                2 {
                    $currLen = $this.BlockWidth - ($this.IndentSize + 2)
                    $currIndent = $this.IndentSize 
                    return [eLineBuilder]::Double($currLen, $currIndent, $this.NewlineAdd)
                }
                3 {
                    $currLen = $this.BlockWidth - (($this.IndentSize + 2) * 2)
                    $currIndent = $this.IndentSize + 2
                    return [eLineBuilder]::Heavy($currLen, $currIndent, $this.NewlineAdd)
                }
                4 {
                    $currLen = $this.BlockWidth - (($this.IndentSize + 2) * 3)
                    $currIndent = $this.IndentSize * 3
                    return [eLineBuilder]::Single($currLen, $currIndent, $this.NewlineAdd)
                }
            }
            return ''
        }

        [string] GetBlockLine([int]$BlockLevel, [string]$BlockLocation) {
            return $this.GetBlockLine($BlockLevel, $BlockLocation, '')
        }

        [string] GetBlockLine([int]$BlockLevel, [string]$BlockLocation, [string]$Label) {
            switch ($BlockLevel) {
                1 {
                    $currLen = $this.BlockWidth
                    $currIndent = 0
                    switch ($BlockLocation) {
                        'Top' {
                            return [eLineBuilder]::ThickTop($currLen, $Label, $currIndent, $this.NewlineAdd)
                        }
                        'Bottom' {
                            return [eLineBuilder]::ThickBottom($currLen, $Label, $currIndent, $this.NewlineAdd)
                        }
                    }
                }
                2 {
                    $currLen = $this.BlockWidth - ($this.IndentSize + 2)
                    $currIndent = $this.IndentSize
                    switch ($BlockLocation) {
                        'Top' {
                            return [eLineBuilder]::DoubleTop($currLen, $Label, $currIndent, $this.NewlineAdd)
                        }
                        'Bottom' {
                            return [eLineBuilder]::DoubleBottom($currLen, $Label, $currIndent, $this.NewlineAdd)
                        }
                    }
                }
                3 {
                    $currLen = $this.BlockWidth - (($this.IndentSize + 2) * 2)
                    $currIndent = $this.IndentSize * 2
                    switch ($BlockLocation) {
                        'Top' {
                            return [eLineBuilder]::HeavyTop($currLen, $Label, $currIndent, $this.NewlineAdd)
                        }
                        'Bottom' {
                            return [eLineBuilder]::HeavyBottom($currLen, $Label, $currIndent, $this.NewlineAdd)
                        }
                    }
                }
                4 {
                    $currLen = $this.BlockWidth - (($this.IndentSize + 2) * 3)
                    $currIndent = $this.IndentSize * 3
                    switch ($BlockLocation) {
                        'Top' {
                            return [eLineBuilder]::SingleTop($currLen, $Label, $currIndent, $this.NewlineAdd)
                        }
                        'Bottom' {
                            return [eLineBuilder]::SingleBottom($currLen, $Label, $currIndent, $this.NewlineAdd)
                        }
                    }
                }
            }
            return ''
        }

        #endregion
    }
    #endregion

    #--------------------------------------------
    #region eVersion
    #--------------------------------------------
    # Class to generate version strings
    class eVersion {
        [System.Version] $Version

        # DEFAULT CONSTRUCTOR
        eVersion() {
            $currentTime = Get-Date -AsUTC
            
            # format: A.B.C.D where:
            # A = YYYYMM
            # B = DDHH
            # C = MMSS
            # D = 1
    
            # A - Year and Month (6 digits)
            $yearMonthSegment = ($currentTime.Year.ToString() + $currentTime.Month.ToString("00"))
    
            # B - Day and Hour (4 digits)
            $dayHourSegment = ($currentTime.Day.ToString("00") + $currentTime.Hour.ToString("00"))
    
            # C - Minute and Second (4 digits)
            $minuteSecondSegment = ($currentTime.Minute.ToString("00") + $currentTime.Second.ToString("00"))
    
            # D - Default to 1
            $incrementingSegment = 1
    
            $this.Version = [System.Version]"$yearMonthSegment.$dayHourSegment.$minuteSecondSegment.$incrementingSegment"          
        }

        # DATETIME CONSTRUCTOR
        eVersion([datetime] $dateTime) {
            $currentTime = $dateTime
            
            # format: A.B.C.D where:
            # A = YYYYMM
            # B = DDHH
            # C = MMSS
            # D = 1
    
            # A - Year and Month (6 digits)
            $yearMonthSegment = ($currentTime.Year.ToString() + $currentTime.Month.ToString("00"))
    
            # B - Day and Hour (4 digits)
            $dayHourSegment = ($currentTime.Day.ToString("00") + $currentTime.Hour.ToString("00"))
    
            # C - Minute and Second (4 digits)
            $minuteSecondSegment = ($currentTime.Minute.ToString("00") + $currentTime.Second.ToString("00"))
    
            # D - Default to 1
            $incrementingSegment = 1
    
            $this.Version = [System.Version]"$yearMonthSegment.$dayHourSegment.$minuteSecondSegment.$incrementingSegment"          
        }

        # DATETIMEOFFSET CONSTRUCTOR
        eVersion([datetimeoffset] $dateTimeOffset) {
            $currentTime = $dateTimeOffset.UtcDateTime
            
            # format: A.B.C.D where:
            # A = YYYYMM
            # B = DDHH
            # C = MMSS
            # D = 1
    
            # A - Year and Month (6 digits)
            $yearMonthSegment = ($currentTime.Year.ToString() + $currentTime.Month.ToString("00"))
    
            # B - Day and Hour (4 digits)
            $dayHourSegment = ($currentTime.Day.ToString("00") + $currentTime.Hour.ToString("00"))
    
            # C - Minute and Second (4 digits)
            $minuteSecondSegment = ($currentTime.Minute.ToString("00") + $currentTime.Second.ToString("00"))
    
            # D - Default to 1
            $incrementingSegment = 1
    
            $this.Version = [System.Version]"$yearMonthSegment.$dayHourSegment.$minuteSecondSegment.$incrementingSegment"          
        }

        # VERSION CONSTRUCTOR
        eVersion([System.Version] $version) {
            $this.Version = $version
        }

        # STRING CONSTRUCTOR
        eVersion([string] $version) {
            $this.Version = [System.Version]$version
        }

        # MAJOR, MINOR, BUILD, REVISION CONSTRUCTOR
        eVersion([int] $major, [int] $minor, [int] $build, [int] $revision) {
            $this.Version = [System.Version]::new($major,$minor,$build,$revision)
        }

        # MAJOR, MINOR, BUILD CONSTRUCTOR
        eVersion([int] $major, [int] $minor, [int] $build) {
            $this.Version = [System.Version]$major,$minor,$build
        }

        # MAJOR, MINOR CONSTRUCTOR
        eVersion([int] $major, [int] $minor) {
            $this.Version = [System.Version]$major,$minor
        }

        # MAJOR CONSTRUCTOR
        eVersion([int] $major) {
            $this.Version = [System.Version]$major
        }

        # ToDateTime
        [datetime] ToDateTime() {
            $year = [int]($this.Version.Major / 100)
            $month = [int]($this.Version.Major % 100)
            $day = [int]($this.Version.Minor / 100)
            $hour = [int]($this.Version.Minor % 100)
            $minute = [int]($this.Version.Build / 100)
            $second = [int]($this.Version.Build % 100)
            return [datetime]::new($year, $month, $day, $hour, $minute, $second)
        }

        # ToString
        [string] ToString() {
            return $this.Version.ToString()
        }

        # Increment
        [eVersion] Increment() {
            return [eVersion]::new($this.Version.Major, $this.Version.Minor, $this.Version.Build, $this.Version.Revision + 1)
        }
    }
    #endregion

    #--------------------------------------------
    #region eHelp
    #--------------------------------------------
    # Class to generate help documentation for a class using reflection and eHelpAttribute attributes
    class eHelp {
        static [System.Reflection.BindingFlags] $BindingFlags = `
            [System.Reflection.BindingFlags]::Public -bor `
            [System.Reflection.BindingFlags]::NonPublic -bor `
            [System.Reflection.BindingFlags]::Instance -bor `
            [System.Reflection.BindingFlags]::Static -bor `
            [System.Reflection.BindingFlags]::DeclaredOnly

        # This class is used to get help documentation for a class
        static [eString] GetHelp([object] $target) {
            if ($target -is [type]) {
                return [eHelp]::ProcessType($target, [eHelp]::BindingFlags)
            }
            else {
                return [eHelp]::ProcessType($target.GetType(), [eHelp]::BindingFlags)
            }
        }

        static [eString] GetHelp([object] $target, [System.Reflection.BindingFlags] $bindingFlags) {
            return [eHelp]::ProcessType($target, $bindingFlags)
        }

        hidden static [string] ProcessType ([type] $type, [System.Reflection.BindingFlags] $bindingFlags = [eHelp]::BindingFlags) {
            $sb = [System.Text.StringBuilder]::new()
            $blk = [eBlock]::new(120, 2, [eNewlineAdd]::Before)

            [void]$sb.AppendLine($blk.GetBlockLine(1,'Top', $type.Name))
            [void]$sb.AppendLine($blk.GetBlockLine(2,'Top','CLASS DOCUMENTATION'))
            $Attributes = $type.GetCustomAttributes($true)
            foreach ($Attribute in $Attributes) {
                [void]$sb.AppendLine([eString]::new($Attribute.ToString()).AddIndent(4).AddNewLine([eNewlineAdd]::Before))
            }
            [void]$sb.AppendLine($blk.GetBlockLine(2,'Bottom','CLASS DOCUMENTATION'))

            [void]$sb.AppendLine($blk.GetBlockLine(2,'Top','CLASS PROPERTIES'))
            $Properties = $type.GetProperties()
            $getSetList = $Properties | ForEach-Object{"get_$($_.Name)";"set_$($_.Name)"}
            foreach ($Property in $Properties) {
                [void]$sb.AppendLine($blk.GetBlockLine(3,'Top',$Property.Name))
                $Attributes = $Property.GetCustomAttributes($true)
                if ([string]::IsNullOrEmpty($Attributes)) {
                    [void]$sb.AppendLine([eString]::new(".PROPERTY " + $Property.Name + '[' + $Property.PropertyType + ']').AddIndent(6).AddNewLine([eNewlineAdd]::Before)) # Append property type
                }
                foreach ($Attribute in $Attributes) {
                    [void]$sb.AppendLine([eString]::new($Attribute.ToString()).AddIndent(6).AddNewLine([eNewlineAdd]::Before))
                }
                [void]$sb.AppendLine($blk.GetBlockLine(3,'Bottom',$Property.Name))
            }
            [void]$sb.AppendLine($blk.GetBlockLine(2,'Bottom','CLASS PROPERTIES'))
    

            [void]$sb.AppendLine($blk.GetBlockLine(2,'Top','CLASS METHODS'))
            $Methods = $type.GetMethods($bindingFlags) | Where-Object { $getSetList -notcontains $_.Name }
            foreach ($Method in $Methods) {
                [void]$sb.AppendLine($blk.GetBlockLine(3,'Top',$Method.Name))
                $Attributes = $Method.GetCustomAttributes($true)
                foreach ($Attribute in $Attributes) {
                    [void]$sb.AppendLine([eString]::new($Attribute.ToString()).AddIndent(6).AddNewLine([eNewlineAdd]::Before))
                }        
                [void]$sb.AppendLine($blk.GetBlockLine(3,'Bottom',$Method.Name))
            }
            [void]$sb.AppendLine($blk.GetBlockLine(2,'Bottom','CLASS METHODS'))
            [void]$sb.AppendLine($blk.GetBlockLine(1,'Bottom', $type.Name))

            return $sb.ToString()
        }
    }
    #endregion

    #endregion
#╚═══BASE═════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

#╔═══LOG══════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    #--------------------------------------------
    #region eLogContext
    #--------------------------------------------
    # Class to represent a log context
    class [eLogContext] {
        # Properties
        [eLog] $Log
        
    }

    #endregion
#╚═══LOG══════════════════════════════════════════════════════════════════════════════════════════════════════════════╝




#╔═══BASE═════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region
    # This region contains the base classes that are used throughout the eClasses module


    class eEncryption {
        # Class to handle hashing/encryption of strings

        static [string] AES([byte[]] $Key, [byte[]] $IV, [string] $String) {
            $aes = [System.Security.Cryptography.Aes]::Create()
            try {
                # Directly use the Key and IV byte arrays without conversion.
                $aes.Key = $Key
                $aes.IV = $IV
        
                if ($aes.Key.Length -notin @(16, 24, 32)) {
                    throw "Key size is not valid. Key must be 128, 192, or 256 bits (16, 24, 32 bytes)"
                }
        
                if ($aes.IV.Length -ne 16) {
                    throw "IV size is not valid. IV must be 128 bits (16 bytes)"
                }
        
                $encryptor = $aes.CreateEncryptor($aes.Key, $aes.IV)
                $ms = [System.IO.MemoryStream]::new()
                $cs = [System.Security.Cryptography.CryptoStream]::new($ms, $encryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)
                $sw = [System.IO.StreamWriter]::new($cs)
        
                $sw.Write($String)
                $sw.Dispose()
                $cs.Dispose()
                $ms.Close()
        
                return [Convert]::ToBase64String($ms.ToArray())
            } finally {
                # Properly dispose of AES to free resources.
                if ($null -ne $aes) {
                    $aes.Dispose()
                }
            }
        }

        static [string] AESDecrypt([byte[]] $Key, [byte[]] $IV, [string] $String) {
            $aes = [System.Security.Cryptography.Aes]::Create()
            $aes.Key = $Key
            $aes.IV = $IV
            $decryptor = $aes.CreateDecryptor($aes.Key, $aes.IV)
            $ms = [System.IO.MemoryStream]::new([Convert]::FromBase64String($String))
            $cs = [System.Security.Cryptography.CryptoStream]::new($ms, $decryptor, [System.Security.Cryptography.CryptoStreamMode]::Read)
            $sr = [System.IO.StreamReader]::new($cs)
            $result = $sr.ReadToEnd()
            $sr.Close()
            $cs.Close()
            $ms.Close()
            return $result
        }

        static [string] MD5([string] $String) {
            $md5 = [System.Security.Cryptography.MD5]::Create()
            try {
                $hash = [System.BitConverter]::ToString($md5.ComputeHash([eEncoding]::Encoding.GetBytes($String ?? ''))).Replace('-','')
            }
            catch {
                $hash = 'D41D8CD98F00B204E9800998ECF8427E'
            }
            finally {
                $md5.Dispose()
            }
            return $hash
        }

        static [byte[]] RandomBytes([int]$Length) {
            $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
            try {
                $randomBytes = New-Object byte[] $Length
                $rng.GetBytes($randomBytes)
                return $randomBytes
            } finally {
                if ($null -ne $rng) {
                    $rng.Dispose()
                }
            }
        }

        static [string] RandomString([int] $Length) {        
            $randomBytes = New-Object byte[] $Length
            $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
            $rng.GetBytes($randomBytes)
            $randomString = [System.BitConverter]::ToString($randomBytes).Replace("-", "").Substring(0, $Length)
            return $randomString
        }
        
        static [string] SHA1([string] $String) {
            $sha1 = [System.Security.Cryptography.SHA1]::Create()
            try {
                $hash = [System.BitConverter]::ToString($sha1.ComputeHash([eEncoding]::Encoding.GetBytes($String ?? ''))).Replace('-','')
            }
            catch {
                $hash = 'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709'
            }
            finally {
                $sha1.Dispose()
            }
            return $hash
        }

        static [string] SHA256([string] $String) {
            $sha256 = [System.Security.Cryptography.SHA256]::Create()
            try {
                $hash = [System.BitConverter]::ToString($sha256.ComputeHash([eEncoding]::Encoding.GetBytes($String ?? ''))).Replace('-','')
            }
            catch {
                $hash = 'E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855'
            }
            finally {
                $sha256.Dispose()
            }
            return $hash
        }

        static [string] SHA384([string] $String) {
            $sha384 = [System.Security.Cryptography.SHA384]::Create()
            try {
                $hash = [System.BitConverter]::ToString($sha384.ComputeHash([eEncoding]::Encoding.GetBytes($String ?? ''))).Replace('-','')
            }
            catch {
                $hash = '38B060A751AC96384CD9327EB1B1E36A21FDB71114BE07434C0CC7BF63F6E1DA274EDEBFE76F65FBD51AD2F14898B95B'
            }
            finally {
                $sha384.Dispose()
            }
            return $hash
        }

        static [string] SHA512([string] $String) {
            $sha512 = [System.Security.Cryptography.SHA512]::Create()
            try {
                $hash = [System.BitConverter]::ToString($sha512.ComputeHash([eEncoding]::Encoding.GetBytes($String ?? ''))).Replace('-','')
            }
            catch {
                $hash = 'CF83E1357EEFB8BDF1542850D66D8007D620E4050B5715DC83F4A921D36CE9CE47D0D13C5D85F2B0FF8318D2877EEC2F63B931BD47417A81A538327AF927DA3E'
            }
            finally {
                $sha512.Dispose()
            }
            return $hash
        }
    }    

    #endregion
#╚═══BASE═════════════════════════════════════════════════════════════════════════════════════════════════════════════╝
