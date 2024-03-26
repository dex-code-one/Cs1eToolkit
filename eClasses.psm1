#region HELP INTELLISENSE
#Uncomment this region to enable intellisense for the eClasses module, otherwise, leave it commented out before releasing

# class eHelpAttribute {
#     [string]$Content

#     eHelpAttribute([string]$content) {
#         $this.Content = $content
#     }

#     [string] ToString() {
#         return $this.Content
#     }
# }

# class eHelpNamedAttribute : eHelpAttribute {
#     [string]$Name

#     eHelpNamedAttribute([string]$name, [string]$content) : base($content) {
#         $this.Name = $name
#     }

#     [string] ToString() {
#         return $this.Name + "`n" + $this.Content
#     }
# }

# class eHelpSynopsis : eHelpAttribute {
#     eHelpSynopsis() : base("") { }
#     eHelpSynopsis([string]$content) : base($content) { }

#     [string] ToString() {
#         return ".SYNOPSIS`n" + $this.Content
#     }
# }

# class eHelpDescription : eHelpAttribute {
#     eHelpDescription() : base("") { }
#     eHelpDescription([string]$content) : base($content) { }

#     [string] ToString() {
#         return ".DESCRIPTION`n" + $this.Content
#     }
# }

# class eHelpNotes : eHelpAttribute {
#     eHelpNotes() : base("") { }
#     eHelpNotes([string]$content) : base($content) { }

#     [string] ToString() {
#         return ".NOTES`n" + $this.Content
#     }
# }

# class eHelpLink : eHelpAttribute {
#     eHelpLink() : base("") { }
#     eHelpLink([string]$content) : base($content) { }

#     [string] ToString() {
#         return ".LINK`n" + $this.Content
#     }
# }

# class eHelpParameter : eHelpNamedAttribute {
#     eHelpParameter() : base("", "") { }
#     eHelpParameter([string]$name, [string]$content) : base($name, $content) { }

#     [string] ToString() {
#         return ".PARAMETER " + $this.Name + "`n" + $this.Content
#     }
# }

# class eHelpExample : eHelpAttribute {
#     eHelpExample() : base("") { }
#     eHelpExample([string]$content) : base($content) { }

#     [string] ToString() {
#         return ".EXAMPLE`n" + $this.Content
#     }
# }

# class eHelpProperty : eHelpNamedAttribute {
#     eHelpProperty() : base("", "") { }
#     eHelpProperty([string]$name, [string]$content) : base($name, $content) { }

#     [string] ToString() {
#         return ".PROPERTY " + $this.Name + "`n" + $this.Content
#     }
# }

# class eHelpOutputs : eHelpAttribute {
#     eHelpOutputs() : base("") { }
#     eHelpOutputs([string]$content) : base($content) { }

#     [string] ToString() {
#         return ".RETURN`n" + $this.Content
#     }
# }

#endregion

#╔═══BASE═════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region
    # This region contains the other base classes that are needed to use the eHelp above

    #--------------------------------------------
    #region class eEncoding
    #--------------------------------------------
    [eHelpSynopsis('This class is used to provide global encoding options for the eClasses module')]
    [eHelpDescription('This class is used to provide global encoding options for the eClasses module')]
    [eHelpExample(@'
eEncoding.Encoding = [System.Text.Encoding]::UTF8
$encodedString = [eEncoding]::Encoding.GetBytes('Hello, World!')
'@)]
    [eHelpNotes('')]
    [eHelpLink('')]
    class eEncoding {
        [eHelpProperty('Encoding', 'The encoding to use for the eClasses module`nThis is set to Unicode by default, but can be changed with`n[eEncoding]::Encoding = [System.Text.Encoding]::UTF8')]
        static [System.Text.Encoding] $Encoding = [System.Text.Encoding]::Unicode
    }
    #endregion

    #--------------------------------------------
    #region enum eNewlineAdd
    #--------------------------------------------
    [eHelpSynopsis('This enum is used to determine where a newline character should be added')]
    [eHelpDescription('This enum is used to determine where a newline character should be added')]
    [eHelpExample(@'
$Value = 'Hello, World!'
$NewlineAdd = [eNewlineAdd]::Before
$Value = [eString]::AddNewLine($Value, $NewlineAdd)
'@)]
    [eHelpNotes('')]
    [eHelpLink('')]
    [flags()] enum eNewlineAdd {
        # Used to determine where a newline character should be added
        None = 0
        Before = 1
        After = 2
        Both = 3
    }
    #endregion

    #--------------------------------------------
    #region class eString
    #--------------------------------------------
    [eHelpSynopsis('This class is used to provide additional common string manipulation methods')]
    [eHelpDescription('This class is used to provide additional common string manipulation methods')]
    [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.AddIndent().ConvertToComment()

Value
-----
#    Hello, World!
'@)]
    [eHelpNotes('')]
    [eHelpLink('')]
    class eString {
        # eString class
        # This class is used to provide additional common string manipulation methods

        #============================================
        #region Properties
        #============================================
        [eHelpProperty('Value', 'The string value')]
        [string] $Value
        #endregion


        #============================================
        #region Static/Hidden Properties
        #============================================
        [eHelpProperty('IndentSize', 'The default size of the indentation. This is set to 4 by default')]
        static hidden [int] $IndentSize = 4
        #endregion


        #============================================
        #region Constructors
        #============================================

        #region Empty
        [eHelpSynopsis('Creates a new eString object with an empty string')]
        [eHelpDescription('Empty constructor for the eString class. Creates a new eString object with an empty string')]
        [eHelpExample(@'
$Value = [eString]::new()
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        eString() {
            $this.Value = ''
        }
        #endregion

        #region [string] Value
        [eHelpSynopsis('Creates a new eString object with the specified string value')]
        [eHelpDescription('Overloaded constructor for the eString class. Creates a new eString object with the specified string value')]
        [eHelpParameter('Value', 'The string value to use',[string])]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        eString([string] $Value) {
            $this.Value = $Value
        }
        #endregion

        #region [eString] Value
        [eHelpSynopsis('Creates a new eString object with the specified eString value')]
        [eHelpDescription('Overloaded constructor for the eString class. Creates a new eString object with the specified eString value')]
        [eHelpParameter('Value', 'The eString value to use',[eString])]
        [eHelpExample(@'
$Value = [eString]::new([eString]::new('Hello, World!'))
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
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
        [eHelpSynopsis('Adds indentation to the empty string')]
        [eHelpDescription('Adds indentation to the empty string')]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.AddIndent()
'@)]
        [eHelpNotes('The default indentation size is 4')]
        [eHelpLink('')]
        [eString] AddIndent() {
            return [eString]::AddIndent($this.Value, [eString]::IndentSize)
        }


        [eHelpSynopsis('Adds indentation to the empty eString')]
        [eHelpDescription('Overloaded method for the AddIndent method. Allows you to specify the size of the indentation')]
        [eHelpParameter('IndentSize', 'The size of the indentation to add',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.AddIndent(2)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [eString] AddIndent([int] $IndentSize) {
            return [eString]::AddIndent($this.Value, $IndentSize)
        }


        [eHelpSynopsis('Adds indentation to the specified string')]
        [eHelpDescription('STATIC Overloaded method for the AddIndent method. Adds indentation to the specified string')]
        [eHelpParameter('Value', 'The string value to add indentation to',[string])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::AddIndent($Value)
'@)]
        [eHelpNotes('The default indentation size is 4')]
        [eHelpLink('')]
        static [eString] AddIndent([string] $Value) {
            return [eString]::AddIndent($Value, [eString]::IndentSize)
        }

        [eHelpSynopsis('Adds indentation to the specified eString')]
        [eHelpDescription('STATIC Overloaded method for the AddIndent method. Allows you to specify the size of the indentation')]
        [eHelpParameter('Value', 'The eString value to add indentation to',[string])]
        [eHelpParameter('IndentSize', 'The size of the indentation to add',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::AddIndent($Value, 2)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] AddIndent([string] $Value, [int] $IndentSize) {
            $indentation = ' ' * [math]::Max(($IndentSize),0)
            return [eString]::new(($Value -split "`n" | ForEach-Object { "${indentation}$_" }) -join "`n")
        }

        [eHelpSynopsis('Adds indentation to the specified eString')]
        [eHelpDescription('STATIC Overloaded method for the AddIndent method. Adds indentation to the specified eString')]
        [eHelpParameter('Value', 'The eString value to add indentation to',[eString])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::AddIndent($Value)
'@)]
        [eHelpNotes('The default indentation size is 4')]
        [eHelpLink('')]
        static [eString] AddIndent([eString] $Value) {
            return [eString]::AddIndent($Value.Value, [eString]::IndentSize)
        }


        [eHelpSynopsis('Adds indentation to the specified eString')]
        [eHelpDescription('STATIC Overloaded method for the AddIndent method. Allows you to specify the size of the indentation')]
        [eHelpParameter('Value', 'The eString value to add indentation to',[eString])]
        [eHelpParameter('IndentSize', 'The size of the indentation to add',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::AddIndent($Value, 2)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] AddIndent([eString] $Value, [int] $IndentSize) {
            return [eString]::AddIndent($Value.Value, $IndentSize)
        }
        #endregion

        #--------------------------------------------
        #region AddNewLine
        #--------------------------------------------
        # Adds a new line to the current string
        [eHelpSynopsis('Adds a new line to the empty string')]
        [eHelpDescription('Adds a new line to the empty string')]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new()
$Value.AddNewLine()
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [eString] AddNewLine() {
            return [eString]::AddNewLine($this.Value, [eNewlineAdd]::After)
        }


        [eHelpSynopsis('Adds a new line to the empty eString')]
        [eHelpDescription('Overloaded method for the AddNewLine method. Allows you to specify where the new line should be added')]
        [eHelpParameter('NewlineAdd', 'The location to add the new line',[eNewlineAdd])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.AddNewLine([eNewlineAdd]::Before)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [eString] AddNewLine([eNewlineAdd] $NewlineAdd) {
            return [eString]::AddNewLine($this.Value, $NewlineAdd)
        }


        [eHelpSynopsis('Adds a new line to the specified string')]
        [eHelpDescription('STATIC Overloaded method for the AddNewLine method. Adds a new line to the specified string')]
        [eHelpParameter('Value', 'The string value to add a new line to',[string])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::AddNewLine($Value)
'@)]
        [eHelpNotes('The new line is added after the specified string')]
        [eHelpLink('')]
        static [eString] AddNewLine([string] $Value) {
            return [eString]::AddNewLine($Value, [eNewlineAdd]::After)
        }


        [eHelpSynopsis('Adds a new line to the specified string')]
        [eHelpDescription('STATIC Overloaded method for the AddNewLine method. Accepts an eString object')]
        [eHelpParameter('Value', 'The eString value to add a new line to',[eString])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::AddNewLine($Value)
'@)]
        [eHelpNotes('The new line is added after the specified string')]
        [eHelpLink('')]
        static [eString] AddNewLine([eString] $Value) {
            return [eString]::AddNewLine($Value.Value, [eNewlineAdd]::After)
        }


        [eHelpSynopsis('Adds a new line to the specified string')]
        [eHelpDescription('STATIC Overloaded method for the AddNewLine method. Allows you to pass an eString and specify where the new line should be added (Before, After, Both)')]
        [eHelpParameter('Value', 'The string value to add a new line to',[eString])]
        [eHelpParameter('NewlineAdd', 'The location to add the new line',[eNewlineAdd])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::AddNewLine($Value, [eNewlineAdd]::Before)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] AddNewLine([eString] $Value, [eNewlineAdd] $NewlineAdd) {
            return [eString]::AddNewLine($Value.Value, $NewlineAdd)
        }


        [eHelpSynopsis('Adds a new line to the specified string')]
        [eHelpDescription('STATIC Overloaded method for the AddNewLine method. Allows you to specify where the new line should be added')]
        [eHelpParameter('Value', 'The string value to add a new line to',[string])]
        [eHelpParameter('NewlineAdd', 'The location to add the new line',[eNewlineAdd])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::AddNewLine($Value, [eNewlineAdd]::Before)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
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
        [eHelpSynopsis('Returns the character at the specified index')]
        [eHelpDescription('Returns the character at the specified index')]
        [eHelpParameter('Index', 'The index of the character to return',[int])]
        [eHelpOutputs('[char]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.Chars(0)
'@)]
        [eHelpNotes('The index is zero-based')]
        [eHelpLink('')]
        [char] Chars([int] $Index) {
            if ($Index -lt 0 -or $Index -ge $this.Value.Length) {
                throw [System.ArgumentOutOfRangeException]::new("index", "Index must be within the bounds of the string.")
            }
            return $this.Value[$Index]
        }


        [eHelpSynopsis('Returns the character at the specified index')]
        [eHelpDescription('STATIC Overloaded method for the Chars method. Returns the character at the specified index of the specified string')]
        [eHelpParameter('Value', 'The string value to return the character from',[string])]
        [eHelpParameter('Index', 'The index of the character to return',[int])]
        [eHelpOutputs('[char]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::Chars($Value, 2)
'@)]
        [eHelpNotes('The index is zero-based')]
        [eHelpLink('')]
        static [char] Chars([string] $Value, [int] $Index) {
            if ($Index -lt 0 -or $Index -ge $Value.Length) {
                throw [System.ArgumentOutOfRangeException]::new("index", "Index must be within the bounds of the string.")
            }
            return $Value[$Index]
        }


        [eHelpSynopsis('Returns the character at the specified index')]
        [eHelpDescription('STATIC Overloaded method for the Chars method. Returns the character at the specified index of the specified eString')]
        [eHelpParameter('Value', 'The eString value to return the character from',[eString])]
        [eHelpParameter('Index', 'The index of the character to return',[int])]
        [eHelpOutputs('[char]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::Chars($Value, 2)
'@)]
        [eHelpNotes('The index is zero-based')]
        [eHelpLink('')]
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
        [eHelpSynopsis('Determines if the current string contains a value')]
        [eHelpDescription('Determines if the current string contains a value')]
        [eHelpParameter('Value', 'The value to search for',[string])]
        [eHelpOutputs('[bool]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.Contains('World')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [bool] Contains([string] $Value) {
            return $this.Value.Contains($Value)
        }


        [eHelpSynopsis('Determines if the specified string contains a value')]
        [eHelpDescription('STATIC Overloaded method for the Contains method. Determines if the specified string contains a value')]
        [eHelpParameter('Value', 'The string value to search',[string])]
        [eHelpParameter('SearchValue', 'The value to search for',[string])]
        [eHelpOutputs('[bool]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::Contains($Value, 'World')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [bool] Contains([string] $Value, [string] $SearchValue) {
            return $Value.Contains($SearchValue)
        }


        [eHelpSynopsis('Determines if the specified eString contains a value')]
        [eHelpDescription('STATIC Overloaded method for the Contains method. Determines if the specified eString contains a value')]
        [eHelpParameter('Value', 'The eString value to search',[eString])]
        [eHelpParameter('SearchValue', 'The value to search for',[string])]
        [eHelpOutputs('[bool]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::Contains($Value, 'World')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [bool] Contains([eString] $Value, [string] $SearchValue) {
            return $Value.Value.Contains($SearchValue)
        }
        #endregion

        #--------------------------------------------
        #region ConvertToComment
        #--------------------------------------------
        [eHelpSynopsis('Converts the current string to a powershell comment')]
        [eHelpDescription('Converts the current string to a powershell comment')]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.ConvertToComment()
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [eString] ConvertToComment() {
            return [eString]::ConvertToComment($this.Value)
        }


        [eHelpSynopsis('Converts the specified string to a powershell comment')]
        [eHelpDescription('STATIC Overloaded method for the ConvertToComment method. Converts the specified string to a powershell comment')]
        [eHelpParameter('Value', 'The string value to convert',[string])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::ConvertToComment($Value)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] ConvertToComment([string] $Value) {
            return [eString]::new(($Value -split "`n" | ForEach-Object {"#$_"}) -join "`n")
        }


        [eHelpSynopsis('Converts the specified eString to a powershell comment')]
        [eHelpDescription('STATIC Overloaded method for the ConvertToComment method. Converts the specified eString to a powershell comment')]
        [eHelpParameter('Value', 'The eString value to convert',[eString])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::ConvertToComment($Value)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] ConvertToComment([eString] $Value) {
            return [eString]::ConvertToComment($Value.Value)
        }
        #endregion

        #--------------------------------------------
        #region EndsWith
        #--------------------------------------------
        [eHelpSynopsis('Determines if the current string ends with a value')]
        [eHelpDescription('Determines if the current string ends with a value')]
        [eHelpParameter('Value', 'The value to search for',[string])]
        [eHelpOutputs('[bool]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.EndsWith('World!')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [bool] EndsWith([string] $Value) {
            return $this.Value.EndsWith($Value)
        }


        [eHelpSynopsis('Determines if the specified string ends with a value')]
        [eHelpDescription('STATIC Overloaded method for the EndsWith method. Determines if the specified string ends with a value')]
        [eHelpParameter('Value', 'The string value to search',[string])]
        [eHelpParameter('SearchValue', 'The value to search for',[string])]
        [eHelpOutputs('[bool]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::EndsWith($Value, 'World!')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [bool] EndsWith([string] $Value, [string] $SearchValue) {
            return $Value.EndsWith($SearchValue)
        }


        [eHelpSynopsis('Determines if the specified eString ends with a value')]
        [eHelpDescription('STATIC Overloaded method for the EndsWith method. Determines if the specified eString ends with a value')]
        [eHelpParameter('Value', 'The eString value to search',[eString])]
        [eHelpParameter('SearchValue', 'The value to search for',[string])]
        [eHelpOutputs('[bool]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::EndsWith($Value, 'World!')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [bool] EndsWith([eString] $Value, [string] $SearchValue) {
            return $Value.Value.EndsWith($SearchValue)
        }
        #endregion

        #--------------------------------------------
        #region Equals
        #--------------------------------------------
        [eHelpSynopsis('Determines if the current string is equal to a value')]
        [eHelpDescription('Determines if the current string is equal to a value')]
        [eHelpParameter('Value', 'The value to compare',[string])]
        [eHelpOutputs('[bool]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.Equals('Hello, World!')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [bool] Equals([string] $Value) {
            return $this.Value.Equals($Value)
        }


        [eHelpSynopsis('Determines if the specified string is equal to a value')]
        [eHelpDescription('STATIC Overloaded method for the Equals method. Determines if the specified string is equal to a value')]
        [eHelpParameter('Value', 'The string value to compare',[string])]
        [eHelpParameter('SearchValue', 'The value to compare',[string])]
        [eHelpOutputs('[bool]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::Equals($Value, 'Hello, World!')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [bool] Equals([string] $Value, [string] $SearchValue) {
            return $Value.Equals($SearchValue)
        }


        [eHelpSynopsis('Determines if the specified eString is equal to a value')]
        [eHelpDescription('STATIC Overloaded method for the Equals method. Determines if the specified eString is equal to a value')]
        [eHelpParameter('Value', 'The eString value to compare',[eString])]
        [eHelpParameter('SearchValue', 'The value to compare',[string])]
        [eHelpOutputs('[bool]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::Equals($Value, 'Hello, World!')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [bool] Equals([eString] $Value, [string] $SearchValue) {
            return $Value.Value.Equals($SearchValue)
        }

        [eHelpSynopsis('Determines if the specified eString is equal to a value')]
        [eHelpDescription('STATIC Overloaded method for the Equals method. Determines if the specified eString is equal to an eString value')]
        [eHelpParameter('Value', 'The eString value to compare',[eString])]
        [eHelpParameter('SearchValue', 'The eString value to compare',[eString])]
        [eHelpOutputs('[bool]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::Equals($Value, [eString]::new('Hello, World!'))
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [bool] Equals([eString] $Value, [eString] $SearchValue) {
            return $Value.Value.Equals($SearchValue.Value)
        }
        #endregion

        #--------------------------------------------
        #region Length
        #--------------------------------------------
        [eHelpSynopsis('Returns the length of the current eString')]
        [eHelpDescription('Returns the length of the current eString')]
        [eHelpOutputs('[int]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.Length()
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [int] Length() {
            return $this.Value.Length            
        }


        [eHelpSynopsis('Returns the length of the specified string')]
        [eHelpDescription('STATIC Overloaded method for the Length method. Returns the length of the specified string')]
        [eHelpParameter('Value', 'The string value to get the length of',[string])]
        [eHelpOutputs('[int]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::Length($Value)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [int] Length([string] $Value) {
            return $Value.Length
        }


        [eHelpSynopsis('Returns the length of the specified eString')]
        [eHelpDescription('STATIC Overloaded method for the Length method. Returns the length of the specified eString')]
        [eHelpParameter('Value', 'The eString value to get the length of',[eString])]
        [eHelpOutputs('[int]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::Length($Value)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [int] Length([eString] $Value) {
            return $Value.Value.Length
        }
        #endregion

        #--------------------------------------------
        #region PadLeft
        #--------------------------------------------
        [eHelpSynopsis('Pads the current string on the left')]
        [eHelpDescription('Pads the current string on the left')]
        [eHelpParameter('TotalWidth', 'The total width of the string',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.PadLeft(20)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [eString] PadLeft([int] $TotalWidth) {
            return [eString]::PadLeft($this.Value, $TotalWidth, ' ')
        }


        [eHelpSynopsis('Pads the current string on the left')]
        [eHelpDescription('Overloaded method for the PadLeft method. Allows you to specify the padding character')]
        [eHelpParameter('TotalWidth', 'The total width of the string',[int])]
        [eHelpParameter('PaddingChar', 'The character to use for padding',[char])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('8675309')
$Value.PadLeft(20, '0')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [eString] PadLeft([int] $TotalWidth, [char] $PaddingChar) {
            return [eString]::PadLeft($this.Value, $TotalWidth, $PaddingChar)
        }


        [eHelpSynopsis('Pads the specified string on the left')]
        [eHelpDescription('STATIC Overloaded method for the PadLeft method. Pads the specified string on the left')]
        [eHelpParameter('Value', 'The string value to pad',[string])]
        [eHelpParameter('TotalWidth', 'The total width of the string',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::PadLeft($Value, 20)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] PadLeft([string] $Value, [int] $TotalWidth) {
            return [eString]::PadLeft($Value, $TotalWidth, ' ')
        }


        [eHelpSynopsis('Pads the specified string on the left')]
        [eHelpDescription('STATIC Overloaded method for the PadLeft method. Allows you to specify the padding character')]
        [eHelpParameter('Value', 'The string value to pad',[string])]
        [eHelpParameter('TotalWidth', 'The total width of the string',[int])]
        [eHelpParameter('PaddingChar', 'The character to use for padding',[char])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = '8675309'
[eString]::PadLeft($Value, 20, '0')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] PadLeft([string] $Value, [int] $TotalWidth, [char] $PaddingChar) {
            return [eString]::new($Value.PadLeft($TotalWidth, $PaddingChar))
        }


        [eHelpSynopsis('Pads the specified eString on the left')]
        [eHelpDescription('STATIC Overloaded method for the PadLeft method. Pads the specified eString on the left')]
        [eHelpParameter('Value', 'The eString value to pad',[eString])]
        [eHelpParameter('TotalWidth', 'The total width of the string',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::PadLeft($Value, 20)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] PadLeft([eString] $Value, [int] $TotalWidth) {
            return [eString]::PadLeft($Value.Value, $TotalWidth, ' ')
        }


        [eHelpSynopsis('Pads the specified eString on the left')]
        [eHelpDescription('STATIC Overloaded method for the PadLeft method. Allows you to specify the padding character')]
        [eHelpParameter('Value', 'The eString value to pad',[eString])]
        [eHelpParameter('TotalWidth', 'The total width of the string',[int])]
        [eHelpParameter('PaddingChar', 'The character to use for padding',[char])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('8675309')
[eString]::PadLeft($Value, 20, '0')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] PadLeft([eString] $Value, [int] $TotalWidth, [char] $PaddingChar) {
            return [eString]::PadLeft($Value.Value, $TotalWidth, $PaddingChar)
        }
        #endregion

        #--------------------------------------------
        #region PadRight
        #--------------------------------------------
        [eHelpSynopsis('Pads the current string on the right')]
        [eHelpDescription('Pads the current string on the right')]
        [eHelpParameter('TotalWidth', 'The total width of the string',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.PadRight(20)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [eString] PadRight([int] $TotalWidth) {
            return [eString]::PadRight($this.Value, $TotalWidth, ' ')
        }


        [eHelpSynopsis('Pads the current string on the right')]
        [eHelpDescription('Overloaded method for the PadRight method. Allows you to specify the padding character')]
        [eHelpParameter('TotalWidth', 'The total width of the string',[int])]
        [eHelpParameter('PaddingChar', 'The character to use for padding',[char])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('0.8675309')
$Value.PadRight(20, '0')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [eString] PadRight([int] $TotalWidth, [char] $PaddingChar) {
            return [eString]::PadRight($this.Value, $TotalWidth, $PaddingChar)
        }


        [eHelpSynopsis('Pads the specified string on the right')]
        [eHelpDescription('STATIC Overloaded method for the PadRight method. Pads the specified string on the right')]
        [eHelpParameter('Value', 'The string value to pad',[string])]
        [eHelpParameter('TotalWidth', 'The total width of the string',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::PadRight($Value, 20)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] PadRight([string] $Value, [int] $TotalWidth) {
            return [eString]::PadRight($Value, $TotalWidth, ' ')
        }


        [eHelpSynopsis('Pads the specified string on the right')]
        [eHelpDescription('STATIC Overloaded method for the PadRight method. Allows you to specify the padding character')]
        [eHelpParameter('Value', 'The string value to pad',[string])]
        [eHelpParameter('TotalWidth', 'The total width of the string',[int])]
        [eHelpParameter('PaddingChar', 'The character to use for padding',[char])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = '0.8675309'
[eString]::PadRight($Value, 20, '0')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] PadRight([string] $Value, [int] $TotalWidth, [char] $PaddingChar) {
            return [eString]::new($Value.PadRight($TotalWidth, $PaddingChar))
        }


        [eHelpSynopsis('Pads the specified eString on the right')]
        [eHelpDescription('STATIC Overloaded method for the PadRight method. Pads the specified eString on the right')]
        [eHelpParameter('Value', 'The eString value to pad',[eString])]
        [eHelpParameter('TotalWidth', 'The total width of the string',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::PadRight($Value, 20)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] PadRight([eString] $Value, [int] $TotalWidth) {
            return [eString]::PadRight($Value.Value, $TotalWidth, ' ')
        }


        [eHelpSynopsis('Pads the specified eString on the right')]
        [eHelpDescription('STATIC Overloaded method for the PadRight method. Allows you to specify the padding character')]
        [eHelpParameter('Value', 'The eString value to pad',[eString])]
        [eHelpParameter('TotalWidth', 'The total width of the string',[int])]
        [eHelpParameter('PaddingChar', 'The character to use for padding',[char])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('0.8675309')
[eString]::PadRight($Value, 20, '0')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] PadRight([eString] $Value, [int] $TotalWidth, [char] $PaddingChar) {
            return [eString]::PadRight($Value.Value, $TotalWidth, $PaddingChar)
        }
        #endregion

        #--------------------------------------------
        #region Remove
        #--------------------------------------------
        [eHelpSynopsis('Removes characters from the current string at the specified index')]
        [eHelpDescription('Removes characters from the current string at the specified index')]
        [eHelpParameter('StartIndex', 'The index to start removing characters from',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.Remove(7)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [eString] Remove([int] $StartIndex) {
            return [eString]::Remove($this.Value, $StartIndex)
        }


        [eHelpSynopsis('Removes a specified number of characters from middle of the current string')]
        [eHelpDescription('Removes a specified number of characters from the middle of current string')]
        [eHelpParameter('StartIndex', 'The index to start removing characters from',[int])]
        [eHelpParameter('Count', 'The number of characters to remove',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.Remove(7, 6)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [eString] Remove([int] $StartIndex, [int] $Count) {
            return [eString]::Remove($this.Value, $StartIndex, $Count)
        }


        [eHelpSynopsis('Removes characters from the specified string at the specified index')]
        [eHelpDescription('STATIC Overloaded method for the Remove method. Removes characters from the specified string at the specified index')]
        [eHelpParameter('Value', 'The string value to remove characters from',[string])]
        [eHelpParameter('StartIndex', 'The index to start removing characters from',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::Remove($Value, 7)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] Remove([string] $Value, [int] $StartIndex) {
            return [eString]::new($Value.Remove($StartIndex))
        }


        [eHelpSynopsis('Removes a specified number of characters from the specified string')]
        [eHelpDescription('STATIC Overloaded method for the Remove method. Removes a specified number of characters from the specified string')]
        [eHelpParameter('Value', 'The string value to remove characters from',[string])]
        [eHelpParameter('StartIndex', 'The index to start removing characters from',[int])]
        [eHelpParameter('Count', 'The number of characters to remove',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::Remove($Value, 7, 6)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] Remove([string] $Value, [int] $StartIndex, [int] $Count) {
            return [eString]::new($Value.Remove($StartIndex, $Count))
        }


        [eHelpSynopsis('Removes characters from the specified eString at the specified index')]
        [eHelpDescription('STATIC Overloaded method for the Remove method. Removes characters from the specified eString at the specified index')]
        [eHelpParameter('Value', 'The eString value to remove characters from',[eString])]
        [eHelpParameter('StartIndex', 'The index to start removing characters from',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::Remove($Value, 7)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] Remove([eString] $Value, [int] $StartIndex) {
            return [eString]::Remove($Value.Value, $StartIndex)
        }


        [eHelpSynopsis('Removes a specified number of characters from the specified eString')]
        [eHelpDescription('STATIC Overloaded method for the Remove method. Removes a specified number of characters from the specified eString')]
        [eHelpParameter('Value', 'The eString value to remove characters from',[eString])]
        [eHelpParameter('StartIndex', 'The index to start removing characters from',[int])]
        [eHelpParameter('Count', 'The number of characters to remove',[int])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::Remove($Value, 7, 6)
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] Remove([eString] $Value, [int] $StartIndex, [int] $Count) {
            return [eString]::Remove($Value.Value, $StartIndex, $Count)
        }
        #endregion

        #--------------------------------------------
        #region Replace
        #--------------------------------------------
        [eHelpSynopsis('Replaces a value in the current string')]
        [eHelpDescription('Replaces a value in the current string')]
        [eHelpParameter('OldValue', 'The value to replace',[string])]
        [eHelpParameter('NewValue', 'The value to replace with',[string])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
$Value.Replace('World', 'Universe')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        [eString] Replace([string] $OldValue, [string] $NewValue) {
            return [eString]::Replace($this.Value, $OldValue, $NewValue)
        }


        [eHelpSynopsis('Replaces a value in the specified string')]
        [eHelpDescription('STATIC Overloaded method for the Replace method. Replaces a value in the specified string')]
        [eHelpParameter('Value', 'The string value to search',[string])]
        [eHelpParameter('OldValue', 'The value to replace',[string])]
        [eHelpParameter('NewValue', 'The value to replace with',[string])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = 'Hello, World!'
[eString]::Replace($Value, 'World', 'Universe')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
        static [eString] Replace([string] $Value, [string] $OldValue, [string] $NewValue) {
            return [eString]::new($Value.Replace($OldValue, $NewValue))
        }


        [eHelpSynopsis('Replaces a value in the specified eString')]
        [eHelpDescription('STATIC Overloaded method for the Replace method. Replaces a value in the specified eString')]
        [eHelpParameter('Value', 'The eString value to search',[eString])]
        [eHelpParameter('OldValue', 'The value to replace',[string])]
        [eHelpParameter('NewValue', 'The value to replace with',[string])]
        [eHelpOutputs('[eString]')]
        [eHelpExample(@'
$Value = [eString]::new('Hello, World!')
[eString]::Replace($Value, 'World', 'Universe')
'@)]
        [eHelpNotes('')]
        [eHelpLink('')]
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
    #region class eLineBuilder
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
#╚═══BASE═════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

[eHelpSynopsis('Simple calculator class for basic arithmetic operations.')]
[eHelpDescription('This class provides basic arithmetic operations such as addition.')]
[eHelpNotes('This is a demo class for illustrating the use of eHelpAttributes for documentation.')]
[eHelpLink('https://example.com/CalculatorHelp')]
class Calculator {
    [eHelpProperty('property1', 'This is a sample property.')]
    [string] $property1

    Calculator() {}

    # Method to add two numbers with documentation
    [eHelpSynopsis('Adds two numbers and returns the sum.')]
    [eHelpDescription('This method takes two integers as input and returns their sum.')]
    [eHelpParameter('num1', 'The first number to add.')]
    [eHelpParameter('num2', 'The second number to add.')]
    [eHelpExample(@'
PS> $calc = [Calculator]::new()
PS> $calc.Add(5, 4)
9
'@)]
    [int] Add([int] $num1, [int] $num2) {
        return $num1 + $num2
    }

    # Help method to get the help documentation for the class
    [string] Help() {
        return [eHelp]::GetHelp($this)
    }
}

