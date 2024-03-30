
#╔═ CLASSES ════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region
    enum TextAlignment {
        # This enum is used to specify text alignment
        Left
        Center
        Right
    }

    enum LineStyle {
        # This enum is used to specify the style of box to draw
        Light
        Heavy
        Double
        Thick
    }

    class BoxLight {
        # This class holds the default characters for the light box drawing
        static [string] $Horizontal = '─'
        static [string] $Vertical = '│'
        static [string] $TopLeft = '┌'
        static [string] $TopRight = '┐'
        static [string] $BottomLeft = '└'
        static [string] $BottomRight = '┘'
        static [string] $LeftTee = '├'
        static [string] $RightTee = '┤'
        static [string] $TopTee = '┬'
        static [string] $BottomTee = '┴'
        static [string] $Cross = '┼'
    }

    class BoxHeavy {
        # This class holds the default characters for the heavy box drawing
        static [string] $Horizontal = '━'
        static [string] $Vertical = '┃'
        static [string] $TopLeft = '┏'
        static [string] $TopRight = '┓'
        static [string] $BottomLeft = '┗'
        static [string] $BottomRight = '┛'
        static [string] $LeftTee = '┣'
        static [string] $RightTee = '┫'
        static [string] $TopTee = '┳'
        static [string] $BottomTee = '┻'
        static [string] $Cross = '╋'
    }

    class BoxDouble {
        # This class holds the default characters for the double box drawing
        static [string] $Horizontal = '═'
        static [string] $Vertical = '║'
        static [string] $TopLeft = '╔'
        static [string] $TopRight = '╗'
        static [string] $BottomLeft = '╚'
        static [string] $BottomRight = '╝'
        static [string] $LeftTee = '╠'
        static [string] $RightTee = '╣'
        static [string] $TopTee = '╦'
        static [string] $BottomTee = '╩'
        static [string] $Cross = '╬'
    }

    class BoxThick {
        # This class holds the default characters for the thick box drawing
        static [string] $Horizontal = '█'
        static [string] $Vertical = '██'
        static [string] $TopLeft = '██'
        static [string] $TopRight = '██'
        static [string] $BottomLeft = '██'
        static [string] $BottomRight = '██'
        static [string] $LeftTee = '██'
        static [string] $RightTee = '██'
        static [string] $TopTee = '██'
        static [string] $BottomTee = '██'
        static [string] $Cross = '██'
    }

    class Defaults {
        # This static class is used to hold default values for the module.  You don't need to instantiate this class.
        # $encoding = [Defaults]::Encoding
        # $indent = [Defaults]::Indent
        # etc.
        static [System.Text.Encoding] $Encoding = [System.Text.Encoding]::Unicode
        static [string] $FieldSeparator = "`u{200B}`t"
        static [string] $RecordSeparator = "`u{200B}`n"
        static [string] $ZeroWidthSpace = "`u{200B}"
        static [string] $Base64Separator = ';'  #don't make this the same as the HexSeparator
        static [string] $HexSeparator = ','     #don't make this the same as the Base64Separator
        static [int] $Indent = 4
        static [int] $ConsoleWidth = 120
        static [LineStyle] $LineStyle = [LineStyle]::Double
        static [int] $TextAlignment = [TextAlignment]::Left
        static [int] $EncryptionKeySize = 256
        static [int] $EncryptionIVSize = 128
        static [int] $EncryptionIterations = 100000
        static [int] $ObfuscationKeySize = 128
        static [int] $ObfuscationIVSize = 128
        static [int] $ObfuscationIterations = 1000
        static [byte[]] $ObfuscationPasswordBytes = [Defaults]::Encoding.GetBytes('HppjmX3CBynZzbLIE8kLC/NRJ8Z5zLLF') # for insecurely encrypting (obfuscating) data without having to provide a password
        static [byte[]] $ObfuscationSaltBytes = [Defaults]::Encoding.GetBytes('pMuEgynY8gIOe/NhLIFzWiZEn5oiKnSq') # for insecurely encrypting (obfuscating) data without having to provide a salt
    }

    class Draw {
        # This class is used to draw boxes around text and draw lines/dividers between sections

        #--------------------------------------------------------------
        #region Line
        #--------------------------------------------------------------
        static [string] Line() {return [Draw]::Line([Defaults]::LineStyle, [Defaults]::ConsoleWidth)}
        static [string] Line([LineStyle] $LineStyle) {return [Draw]::Line($LineStyle, [Defaults]::ConsoleWidth)}
        static [string] Line([String] $LineStyle) {return [Draw]::Line($LineStyle, [Defaults]::ConsoleWidth)}
        static [string] Line([int] $width) {return [Draw]::Line([Defaults]::LineStyle, $width)}
        static [string] Line([LineStyle] $LineStyle, [int] $width) {
            $style = switch ($LineStyle) {
                'Light' {[BoxLight]::Horizontal}
                'Heavy' {[BoxHeavy]::Horizontal}
                'Double'{[BoxDouble]::Horizontal}
                'Thick'{[BoxThick]::Horizontal}
            }
            return $style * ($width / $style.Length)
        }
        #endregion

        #--------------------------------------------------------------
        #region BoxTop
        #--------------------------------------------------------------
        static [string] BoxTop() {return [Draw]::BoxTop('', [Defaults]::ConsoleWidth, [Defaults]::LineStyle, [Defaults]::TextAlignment)}
        static [string] BoxTop([string] $text) {return [Draw]::BoxTop($text, [Defaults]::ConsoleWidth, [LineStyle]::Heavy, [Defaults]::TextAlignment)}
        static [string] BoxTop([string] $text, [string] $LineStyle) {return [Draw]::BoxTop($text, [Defaults]::ConsoleWidth, $LineStyle, [Defaults]::TextAlignment)}
        static [string] BoxTop([string] $text, [int] $width) {return [Draw]::BoxTop($text, $width, [Defaults]::LineStyle, [Defaults]::TextAlignment)}
        static [string] BoxTop([string] $text, [LineStyle] $LineStyle) {return [Draw]::BoxTop($text, [Defaults]::ConsoleWidth, $LineStyle, [Defaults]::TextAlignment)}
        static [string] BoxTop([string] $text, [LineStyle] $LineStyle, [TextAlignment] $alignment) {return [Draw]::BoxTop($text, [Defaults]::ConsoleWidth, $LineStyle, $alignment)}
        static [string] BoxTop([string] $text, [TextAlignment] $alignment) {return [Draw]::BoxTop($text, [Defaults]::ConsoleWidth, [Defaults]::LineStyle, $alignment)}
        static [string] BoxTop([string] $text, [int] $width, [LineStyle] $LineStyle, [TextAlignment] $alignment) {
            $style = switch ($LineStyle) {
                'Light' {[BoxLight]}
                'Heavy' {[BoxHeavy]}
                'Double'{[BoxDouble]}
                'Thick'{[BoxThick]}
            }
            $effectiveWidth = $width - ($style::Horizontal.Length*2)
            $text = switch ($alignment) {
                'Left' {
                    $leftPadding = $style::Horizontal.Length
                    $rightPadding = $effectiveWidth - $text.Length - $style::Horizontal.Length
                    $text.PadLeft($leftPadding + $text.Length,$style::Horizontal).PadRight($leftPadding + $text.Length + $rightPadding,$style::Horizontal)
                }
                'Center'{ 
                    $totalPadding = $effectiveWidth - $text.Length
                    $leftPadding = [Math]::Floor($totalPadding / 2)
                    $rightPadding = [Math]::Ceiling($totalPadding / 2)
                    $text.PadLeft($leftPadding + $text.Length,$style::Horizontal).PadRight($leftPadding + $text.Length + $rightPadding,$style::Horizontal)
                }
                'Right'{
                    $leftPadding = $effectiveWidth - $text.Length - $style::Horizontal.Length
                    $rightPadding = $style::Horizontal.Length
                    $text.PadLeft($leftPadding + $text.Length,$style::Horizontal).PadRight($leftPadding + $text.Length + $rightPadding,$style::Horizontal)
                }
            }
            $top = $style::TopLeft + $text + $style::TopRight
            return $top
        }
        #endregion

        #--------------------------------------------------------------
        #region BoxMiddle
        #--------------------------------------------------------------
        static [string] BoxMiddle() {return [Draw]::BoxMiddle('', [Defaults]::ConsoleWidth, [Defaults]::LineStyle, [Defaults]::TextAlignment)}
        static [string] BoxMiddle([string] $text) {return [Draw]::BoxMiddle($text, [Defaults]::ConsoleWidth, [LineStyle]::Heavy, [Defaults]::TextAlignment)}
        static [string] BoxMiddle([string] $text, [int] $width) {return [Draw]::BoxMiddle($text, $width, [Defaults]::LineStyle, [Defaults]::TextAlignment)}
        static [string] BoxMiddle([string] $text, [LineStyle] $LineStyle) {return [Draw]::BoxMiddle($text, [Defaults]::ConsoleWidth, $LineStyle, [Defaults]::TextAlignment)}
        static [string] BoxMiddle([string] $text, [LineStyle] $LineStyle, [TextAlignment] $alignment) {return [Draw]::BoxMiddle($text, [Defaults]::ConsoleWidth, $LineStyle, $alignment)}
        static [string] BoxMiddle([string] $text, [TextAlignment] $alignment) {return [Draw]::BoxMiddle($text, [Defaults]::ConsoleWidth, [Defaults]::LineStyle, $alignment)}
        static [string] BoxMiddle([string]$text, [int]$width, [LineStyle]$LineStyle, [TextAlignment]$alignment) {
            $style = switch ($LineStyle) {
                'Light' {[BoxLight]}
                'Heavy' {[BoxHeavy]}
                'Double'{[BoxDouble]}
                'Thick'{[BoxThick]}
            }
            $effectiveWidth = $width - ($style::Horizontal.Length*2)
            $text = switch ($alignment) {
                'Left' {$text.PadRight($effectiveWidth)}
                'Center'{ 
                    $totalPadding = $effectiveWidth - $text.Length
                    $leftPadding = [Math]::Floor($totalPadding / 2)
                    $rightPadding = [Math]::Ceiling($totalPadding / 2)
                    $text.PadLeft($leftPadding + $text.Length).PadRight($leftPadding + $text.Length + $rightPadding)
                }
                'Right'{$text.PadLeft($effectiveWidth)}
            }            
            $middle = $style::Vertical + $text + $style::Vertical
            return $middle
        }
        #endregion

        #--------------------------------------------------------------
        #region BoxBottom
        #--------------------------------------------------------------
        static [string] BoxBottom() {return [Draw]::BoxBottom('', [Defaults]::ConsoleWidth, [Defaults]::LineStyle, [Defaults]::TextAlignment)}
        static [string] BoxBottom([string] $text) {return [Draw]::BoxBottom($text, [Defaults]::ConsoleWidth, [LineStyle]::Heavy, [Defaults]::TextAlignment)}
        static [string] BoxBottom([string] $text, [int] $width) {return [Draw]::BoxBottom($text, $width, [Defaults]::LineStyle, [Defaults]::TextAlignment)}
        static [string] BoxBottom([string] $text, [LineStyle] $LineStyle) {return [Draw]::BoxBottom($text, [Defaults]::ConsoleWidth, $LineStyle, [Defaults]::TextAlignment)}
        static [string] BoxBottom([string] $text, [string] $LineStyle) {return [Draw]::BoxBottom($text, [Defaults]::ConsoleWidth, $LineStyle, [Defaults]::TextAlignment)}
        static [string] BoxBottom([string] $text, [LineStyle] $LineStyle, [TextAlignment] $alignment) {return [Draw]::BoxBottom($text, [Defaults]::ConsoleWidth, $LineStyle, $alignment)}
        static [string] BoxBottom([string] $text, [TextAlignment] $alignment) {return [Draw]::BoxBottom($text, [Defaults]::ConsoleWidth, [Defaults]::LineStyle, $alignment)}
        static [string] BoxBottom([string]$text, [int]$width, [LineStyle]$LineStyle, [TextAlignment]$alignment) {
            $style = switch ($LineStyle) {
                'Light' {[BoxLight]}
                'Heavy' {[BoxHeavy]}
                'Double'{[BoxDouble]}
                'Thick'{[BoxThick]}
            }
            $effectiveWidth = $width - ($style::Horizontal.Length*2)
            $text = switch ($alignment) {
                'Left' {
                    $leftPadding = $style::Horizontal.Length
                    $rightPadding = $effectiveWidth - $text.Length - $style::Horizontal.Length
                    $text.PadLeft($leftPadding + $text.Length,$style::Horizontal).PadRight($leftPadding + $text.Length + $rightPadding,$style::Horizontal)
                }
                'Center'{ 
                    $totalPadding = $effectiveWidth - $text.Length
                    $leftPadding = [Math]::Floor($totalPadding / 2)
                    $rightPadding = [Math]::Ceiling($totalPadding / 2)
                    $text.PadLeft($leftPadding + $text.Length,$style::Horizontal).PadRight($leftPadding + $text.Length + $rightPadding,$style::Horizontal)
                }
                'Right'{
                    $leftPadding = $effectiveWidth - $text.Length - $style::Horizontal.Length
                    $rightPadding = $style::Horizontal.Length
                    $text.PadLeft($leftPadding + $text.Length,$style::Horizontal).PadRight($leftPadding + $text.Length + $rightPadding,$style::Horizontal)
                }
            }
            $bottom = $style::BottomLeft + $text + $style::BottomRight
            return $bottom
        }
        #endregion

        #--------------------------------------------------------------
        #region Box
        #--------------------------------------------------------------
        static [string] Box() {return [Draw]::Box('', [Defaults]::ConsoleWidth, [Defaults]::LineStyle, [Defaults]::TextAlignment)}
        static [string] Box([string] $text) {return [Draw]::Box($text, [Defaults]::ConsoleWidth, [LineStyle]::Heavy, [Defaults]::TextAlignment)}
        static [string] Box([string] $text, [int] $width) {return [Draw]::Box($text, $width, [Defaults]::LineStyle, [Defaults]::TextAlignment)}
        static [string] Box([string] $text, [LineStyle] $LineStyle) {return [Draw]::Box($text, [Defaults]::ConsoleWidth, $LineStyle, [Defaults]::TextAlignment)}
        static [string] Box([string] $text, [LineStyle] $LineStyle, [TextAlignment] $alignment) {return [Draw]::Box($text, [Defaults]::ConsoleWidth, $LineStyle, $alignment)}
        static [string] Box([string] $text, [TextAlignment] $alignment) {return [Draw]::Box($text, [Defaults]::ConsoleWidth, [Defaults]::LineStyle, $alignment)}
        static [string] Box(
            [string] $text,
            [int] $width,
            [LineStyle] $LineStyle,
            [TextAlignment] $alignment
        ) {
            $width = [math]::Max($width, $text.Length + ($LineStyle::Vertical.Length * 2))
            $middle = [Draw]::BoxMiddle($text, $width, $LineStyle, $alignment)
            $top = [Draw]::BoxTop('', $width, $LineStyle, $alignment)
            $bottom = [Draw]::BoxBottom('', $width, $LineStyle, $alignment)
            return $top + "`n" + $middle + "`n" + $bottom
        }
        #endregion
    }

    class Encryption {

        #------------------------------------------------------------------------------------------------------------------
        #region Decryption
        #------------------------------------------------------------------------------------------------------------------
        static [securestring] Decrypt ([string] $encryptedData, [byte[]] $keyBytes) {
            return (ConvertTo-SecureString -String $encryptedData -Key $keyBytes)
        }
        #endregion

        #------------------------------------------------------------------------------------------------------------------
        #region Encryption
        #------------------------------------------------------------------------------------------------------------------
        # Encrypts a string using a key
        static [string] Encrypt ([string] $data,[byte[]] $keyBytes) {
            return ConvertFrom-SecureString -SecureString (ConvertTo-SecureString $data -AsPlainText -Force) -Key $keyBytes
        }
    
        # Overload for Encrypt using SecureString
        static [string] Encrypt ([SecureString] $data,[byte[]] $keyBytes) {
            return ConvertFrom-SecureString -SecureString $data -Key $keyBytes
        }
    
        # Overload for Encrypt using Base64 encoded key
        static [string] Encrypt ([string] $data, [string] $keyBase64) {
            return ConvertFrom-SecureString -SecureString (ConvertTo-SecureString $data -AsPlainText -Force) -Key ([Convert]::FromBase64String($keyBase64))
        }
        #endregion 
    
        #------------------------------------------------------------------------------------------------------------------
        #region NewAesKey
        #------------------------------------------------------------------------------------------------------------------
        # Generates a new AES key using random strings for string and salt
        static [byte[]] NewAesKey() {
            return [Encryption]::NewAesKey([System.Guid]::NewGuid().ToString(),[System.Guid]::NewGuid().ToString())
        }
    
        # Overload for NewAesKey using SecureString with no salt.  Uses the $SecureString as the salt
        static [byte[]] NewAesKey([SecureString]$SecureString) {
            return [Encryption]::NewAesKey($SecureString, $SecureString)
        }
    
        # Overload for NewAesKey using SecureString and SecureSalt
        static [byte[]] NewAesKey ([SecureString]$SecureString, [SecureString]$SecureSalt) {
            return [Encryption]::NewAesKey([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)), [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureSalt)))
        }
    
        # Overload for NewAesKey using string and no salt.  Uses the $String as the salt
        static [byte[]] NewAesKey([string]$String) {
            return [Encryption]::NewAesKey($String, $String)
        }
    
        # Generates a new AES key using a string and salt
        static [byte[]] NewAesKey([string]$String,[string]$Salt) {
            $rdb = New-Object System.Security.Cryptography.Rfc2898DeriveBytes ([Defaults]::Encoding.GetBytes($String)), ([Defaults]::Encoding.GetBytes($Salt)), ([Defaults]::EncryptionIterations)
            try {
                return $rdb.GetBytes(32)
            } finally {
                if ($null -ne $rdb) {$rdb.Dispose()}
            }
        }
        #endregion

        #------------------------------------------------------------------------------------------------------------------
        #region Mask
        #------------------------------------------------------------------------------------------------------------------
        # Obfuscates a string
        static [string] Mask ([string] $data) {
            return [Encryption]::ROT13($data.Reverse().ToBase64())
        }
        #endregion

        #------------------------------------------------------------------------------------------------------------------
        #region Unmask
        #------------------------------------------------------------------------------------------------------------------
        # Deobfuscates a string
        static [string] Unmask ([string] $data) {
            return [Encryption]::ROT13($data).FromBase64().Reverse()
        }
        #endregion

        #------------------------------------------------------------------------------------------------------------------
        #region ROT13
        #------------------------------------------------------------------------------------------------------------------
        static [string] ROT13 ([string] $data) {
            $rot13 = [char[]]$data
            for ($i = 0; $i -lt $rot13.Length; $i++) {
                $c = $rot13[$i]
                if ($c -ge 'A' -and $c -le 'Z') {$rot13[$i] = [char](((($c - [char]'A' + 13) % 26) + [char]'A'))}
                elseif ($c -ge 'a' -and $c -le 'z') {$rot13[$i] = [char](((($c - [char]'a' + 13) % 26) + [char]'a'))}
            }
            return -join $rot13
        }
        #endregion
    }
    #endregion
#╚════════════════════════════════════════════════════════════════════════════════════════════════════════════ CLASSES ═╝

#╔═ EXTEND String ══════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.String class with additional common properties and methods

    # AddIndent(int $indent = 4)
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName AddIndent -Force -Value {
        param([int] $indent = 4)
        $this -replace '(?m)^', (' ' * $indent)
    }    

    # AESEncryptByteArray(SecureString $password, string $saltString)
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName AESEncryptWithPassword -Force -Value {
        param([System.Security.SecureString] $password, [string] $saltString = [Defaults]::EncryptionSaltString)
        [Encryption]::EncryptWithPassword($this, $password, $saltString)
    }

    # BlockComment(string blockOpen = '/*', string blockClose = '*/')
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName BlockComment -Force -Value {
        param([string] $blockOpen = '/*', [string] $blockClose = '*/')
        "$blockOpen`n$this`n$blockClose"
    }

    # Comment(string $commentChar = '#')
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName Comment -Force -Value {
        param([string] $commentChar = '#')
        $this -replace '(?m)^', $commentChar
    }

    # FromBase64
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName FromBase64 -Force -Value {
        [Defaults]::Encoding.GetString([Convert]::FromBase64String($this ?? ''))
    }

    # FromHex
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName FromHex -Force -Value {
        $bytes = New-Object Byte[] ($this.Length / 2)
        for ($i = 0; $i -lt $bytes.Length; $i++) {
            $bytes[$i] = [Convert]::ToByte($this.Substring($i * 2, 2), 16)
        }
        $bytes
    }

    # FromJson
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName FromJson -Force -Value {
        $this | ConvertFrom-Json
    }

    # IsHex
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName IsHex -Force -Value {
        ($this.Length % 2 -eq 0) -and ($this -match '^[0-9A-Fa-f]+$')
    }

    # ToBase64
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToBase64 -Force -Value {
        [Convert]::ToBase64String([Defaults]::Encoding.GetBytes($this ?? ''))
    }

    # ToByteArray
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToByteArray -Force -Value {
        [Defaults]::Encoding.GetBytes($this ?? '')
    }

    # ToHex
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToHex -Force -Value {
        [System.BitConverter]::ToString([Defaults]::Encoding.GetBytes($this ?? '')).Replace('-','')
    }

    # ToJson
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToJson -Force -Value {
        $this | ConvertTo-Json
    }

    # ToSecureString
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToSecureString -Force -Value {
        $secureString = New-Object System.Security.SecureString
        for ($i=0; $i -lt $this.Length; $i++) {$secureString.AppendChar($this[$i])}
        $secureString
    }    

    # GetClipboard
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName GetClipboard -Force -Value {
        Get-Clipboard
    }

    # GetRandomBytes(int $length = 16)
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName GetRandomBytes -Force -Value {
        param([int] $length = 16)
        $randomBytes = New-Object byte[] $Length
        $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
        try {$rng.GetBytes($randomBytes)}
        catch {throw}
        finally {$rng.Dispose()}
        $randomBytes
    }

    # GetRandomString(int $length = 16)
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName GetRandomString -Force -Value {
        param([int] $length = 16)
        $randomBytes = New-Object byte[] $Length
        $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
        try {$rng.GetBytes($randomBytes)}
        catch {throw}
        finally {$rng.Dispose()}
        [Convert]::ToBase64String($randomBytes).Substring(0,$length)
    }

    # IsNullOrEmpty
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName IsNullOrEmpty -Force -Value {
        [string]::IsNullOrEmpty($this)
    }

    # IsNullOrWhiteSpace
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName IsNullOrWhiteSpace -Force -Value {
        [string]::IsNullOrWhiteSpace($this)
    }

    # Mask
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName Mask -Force -Value {
        [Encryption]::Mask($this)
    }

    # MD5
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName MD5 -Force -Value {
        $md5 = [System.Security.Cryptography.MD5]::Create()
        try {$hash = [System.BitConverter]::ToString($md5.ComputeHash([Defaults]::Encoding.GetBytes($this ?? ''))).Replace('-','')}
        catch {throw}
        finally {$md5.Dispose()}
        $hash
    }

    # NewGuid
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName NewGuid -Force -Value {
        [guid]::NewGuid().ToString()
    }

    # RemoveComment(string $commentChar = '#')
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName RemoveComment -Force -Value {
        param([string] $commentChar = '#')
        $this -replace "(?m)^$commentChar"
    }

    # RemoveBlockComment(string blockOpen = '/*', string blockClose = '*/')
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName RemoveBlockComment -Force -Value {
        param([string] $blockOpen = '/*', [string] $blockClose = '*/')
            $escapedBlockOpen = [regex]::Escape($blockOpen)
            $escapedBlockClose = [regex]::Escape($blockClose)
            $pattern = "(?s)$escapedBlockOpen.*?$escapedBlockClose"
            $this -replace $pattern, ''
    }

    # RemoveIndent(int $indent = 4)
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName RemoveIndent -Force -Value {
        param([int] $indent = 4)
        $this -replace "(?m)^ {0,$indent}"
    }

    # Reverse
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName Reverse -Force -Value {
        $chars = $this.ToCharArray()
        [array]::Reverse($chars)
        -join $chars
    }

    # ROT13
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ROT13 -Force -Value {
        [Encryption]::ROT13($this)
    }

    # SetClipboard(bool $passthru = $false)
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName SetClipboard -Force -Value {
        param([bool] $passthru = $false)
        $this | Set-Clipboard
        if ($passthru) { $this }
    }    

    # SHA1
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName SHA1 -Force -Value {
        $sha1 = [System.Security.Cryptography.SHA1]::Create()
        try {$hash = [System.BitConverter]::ToString($sha1.ComputeHash([Defaults]::Encoding.GetBytes($this ?? ''))).Replace('-','')}
        catch {$hash = 'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709'}
        finally {$sha1.Dispose()}
        $hash
    }

    # SHA256
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName SHA256 -Force -Value {
        $sha256 = [System.Security.Cryptography.SHA256]::Create()
        try {$hash = [System.BitConverter]::ToString($sha256.ComputeHash([Defaults]::Encoding.GetBytes($this ?? ''))).Replace('-','')}
        catch {$hash = 'E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855'}
        finally {$sha256.Dispose()}
        $hash
    }

    # SHA384
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName SHA384 -Force -Value {
        $sha384 = [System.Security.Cryptography.SHA384]::Create()
        try {$hash = [System.BitConverter]::ToString($sha384.ComputeHash([Defaults]::Encoding.GetBytes($this ?? ''))).Replace('-','')}
        catch {$hash = '38B060A751AC96384CD9327EB1B1E36A21FDB71114BE07434C0CC7BF63F6E1DA274EDEBFE76F65FBD51AD2F14898B95B'}
        finally {$sha384.Dispose()}
        $hash
    }

    # SHA512
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName SHA512 -Force -Value {
        $sha512 = [System.Security.Cryptography.SHA512]::Create()
        try {$hash = [System.BitConverter]::ToString($sha512.ComputeHash([Defaults]::Encoding.GetBytes($this ?? ''))).Replace('-','')}
        catch {$hash = 'CF83E1357EEFB8BDF1542850D66D8007D620E4050B5715DC83F4A921D36CE9CE47D0D13C5D85F2B0FF8318D2877EEC2F63B931BD47417A81A538327AF927DA3E'}
        finally {$sha512.Dispose()}
        $hash
    }

    # Unmask
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName Unmask -Force -Value {
        [Encryption]::Unmask($this)
    }

    #endregion
#╚══════════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND String ═╝

#╔═ EXTEND BYTE[] ══════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.Byte[] class with additional common properties and methods

    # ToBase64
    ###################################################################################################################
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptMethod -MemberName ToBase64 -Force -Value {
        [Convert]::ToBase64String($this)
    }

    # ToHex
    ###################################################################################################################
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptMethod -MemberName ToHex -Force -Value {
        [System.BitConverter]::ToString($this).Replace('-','')
    }

    # MD5
    ###################################################################################################################
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName MD5 -Force -Value {
        $md5 = [System.Security.Cryptography.MD5]::Create()
        try {$hash = [System.BitConverter]::ToString($md5.ComputeHash($this)).Replace('-','')}
        catch {$hash = 'D41D8CD98F00B204E9800998ECF8427E'}
        finally {$md5.Dispose()}
        $hash
    }

    # SHA1
    ###################################################################################################################
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName SHA1 -Force -Value {
        $sha1 = [System.Security.Cryptography.SHA1]::Create()
        try {$hash = [System.BitConverter]::ToString($sha1.ComputeHash($this)).Replace('-','')}
        catch {$hash = 'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709'}
        finally {$sha1.Dispose()}
        $hash
    }

    # SHA256
    ###################################################################################################################
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName SHA256 -Force -Value {
        $sha256 = [System.Security.Cryptography.SHA256]::Create()
        try {$hash = [System.BitConverter]::ToString($sha256.ComputeHash($this)).Replace('-','')}
        catch {$hash = 'E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855'}
        finally {$sha256.Dispose()}
        $hash
    }

    # SHA384
    ###################################################################################################################
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName SHA384 -Force -Value {
        $sha384 = [System.Security.Cryptography.SHA384]::Create()
        try {$hash = [System.BitConverter]::ToString($sha384.ComputeHash($this)).Replace('-','')}
        catch {$hash = '38B060A751AC96384CD9327EB1B1E36A21FDB71114BE07434C0CC7BF63F6E1DA274EDEBFE76F65FBD51AD2F14898B95B'}
        finally {$sha384.Dispose()}
        $hash
    }

    # SHA512
    ###################################################################################################################
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName SHA512 -Force -Value {
        $sha512 = [System.Security.Cryptography.SHA512]::Create()
        try {$hash = [System.BitConverter]::ToString($sha512.ComputeHash($this)).Replace('-','')}
        catch {$hash = 'CF83E1357EEFB8BDF1542850D66D8007D620E4050B5715DC83F4A921D36CE9CE47D0D13C5D85F2B0FF8318D2877EEC2F63B931BD47417A81A538327AF927DA3E'}
        finally {$sha512.Dispose()}
        $hash
    }

    #endregion
#╚══════════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND BYTE[] ═╝

#╔═ EXTEND SecureString ════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.Security.SecureString class with additional common properties and methods

    # MD5
    ###################################################################################################################
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName MD5 -Force -Value {
        # Convert the SecureString to a byte array without exposing any of the data in memory
        $array = [Encryption]::ConvertSecureStringToByteArray($this)
        try {$array.MD5}
        finally {
            # immediately zero out the byte array to remove any trace of the data before it is garbage collected
            for ($i = 0; $i -lt $array.Length; $i++) { $array[$i] = 0 }
        }
    }

    # SHA1
    ###################################################################################################################
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName SHA1 -Force -Value {
        # Convert the SecureString to a byte array without exposing any of the data in memory
        $array = [Encryption]::ConvertSecureStringToByteArray($this)
        try {$array.SHA1}
        finally {
            # immediately zero out the byte array to remove any trace of the data before it is garbage collected
            for ($i = 0; $i -lt $array.Length; $i++) { $array[$i] = 0 }
        }
    }

    # SHA256
    ###################################################################################################################
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName SHA256 -Force -Value {
        # Convert the SecureString to a byte array without exposing any of the data in memory
        $array = [Encryption]::ConvertSecureStringToByteArray($this)
        try {$array.SHA256}
        finally {
            # immediately zero out the byte array to remove any trace of the data before it is garbage collected
            for ($i = 0; $i -lt $array.Length; $i++) { $array[$i] = 0 }
        }
    }

    # SHA384
    ###################################################################################################################
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName SHA384 -Force -Value {
        # Convert the SecureString to a byte array without exposing any of the data in memory
        $array = [Encryption]::ConvertSecureStringToByteArray($this)
        try {$array.SHA384}
        finally {
            # immediately zero out the byte array to remove any trace of the data before it is garbage collected
            for ($i = 0; $i -lt $array.Length; $i++) { $array[$i] = 0 }
        }
    }

    # SHA512
    ###################################################################################################################
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName SHA512 -Force -Value {
        # Convert the SecureString to a byte array without exposing any of the data in memory
        $array = [Encryption]::ConvertSecureStringToByteArray($this)
        try {$array.SHA512}
        finally {
            # immediately zero out the byte array to remove any trace of the data before it is garbage collected
            for ($i = 0; $i -lt $array.Length; $i++) { $array[$i] = 0 }
        }
    }

    # ToByteArray
    ###################################################################################################################
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptMethod -MemberName ToByteArray -Force -Value {
        [Encryption]::ConvertSecureStringToByteArray($this)
    }

    # ToHex
    ###################################################################################################################
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptMethod -MemberName ToHex -Force -Value {
        [System.BitConverter]::ToString([Encryption]::ConvertSecureStringToByteArray($this)).Replace('-','')
    }

    #endregion
#╚════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND SecureString ═╝

#╔═ EXTEND PSCredential ════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.Management.Automation.PSCredential class with additional common properties and methods

    # ToByteArray
    ###################################################################################################################
    Update-TypeData -TypeName System.Management.Automation.PSCredential -MemberType ScriptMethod -MemberName ToByteArray -Force -Value {
        [Encryption]::ConvertPSCredentialToByteArray($this)
    }

    # ToHex
    ###################################################################################################################
    Update-TypeData -TypeName System.Management.Automation.PSCredential -MemberType ScriptMethod -MemberName ToHex -Force -Value {
        [System.BitConverter]::ToString([Encryption]::ConvertPSCredentialToByteArray($this)).Replace('-','')
    }

    # MD5
    ###################################################################################################################
    Update-TypeData -TypeName System.Management.Automation.PSCredential -MemberType ScriptProperty -MemberName MD5 -Force -Value {
        # Convert the PSCredential to a byte array without exposing any of the data in memory
        $array = [Encryption]::ConvertPSCredentialToByteArray($this)
        try {$array.MD5}
        finally {
            # immediately zero out the byte array to remove any trace of the data before it is garbage collected
            for ($i = 0; $i -lt $array.Length; $i++) { $array[$i] = 0 }
        }
    }

    # SHA1
    ###################################################################################################################
    Update-TypeData -TypeName System.Management.Automation.PSCredential -MemberType ScriptProperty -MemberName SHA1 -Force -Value {
        # Convert the PSCredential to a byte array without exposing any of the data in memory
        $array = [Encryption]::ConvertPSCredentialToByteArray($this)
        try {$array.SHA1}
        finally {
            # immediately zero out the byte array to remove any trace of the data before it is garbage collected
            for ($i = 0; $i -lt $array.Length; $i++) { $array[$i] = 0 }
        }
    }

    # SHA256
    ###################################################################################################################
    Update-TypeData -TypeName System.Management.Automation.PSCredential -MemberType ScriptProperty -MemberName SHA256 -Force -Value {
        # Convert the PSCredential to a byte array without exposing any of the data in memory
        $array = [Encryption]::ConvertPSCredentialToByteArray($this)
        try {$array.SHA256}
        finally {
            # immediately zero out the byte array to remove any trace of the data before it is garbage collected
            for ($i = 0; $i -lt $array.Length; $i++) { $array[$i] = 0 }
        }
    }

    # SHA384
    ###################################################################################################################
    Update-TypeData -TypeName System.Management.Automation.PSCredential -MemberType ScriptProperty -MemberName SHA384 -Force -Value {
        # Convert the PSCredential to a byte array without exposing any of the data in memory
        $array = [Encryption]::ConvertPSCredentialToByteArray($this)
        try {$array.SHA384}
        finally {
            # immediately zero out the byte array to remove any trace of the data before it is garbage collected
            for ($i = 0; $i -lt $array.Length; $i++) { $array[$i] = 0 }
        }
    }

    # SHA512
    ###################################################################################################################
    Update-TypeData -TypeName System.Management.Automation.PSCredential -MemberType ScriptProperty -MemberName SHA512 -Force -Value {
        # Convert the PSCredential to a byte array without exposing any of the data in memory
        $array = [Encryption]::ConvertPSCredentialToByteArray($this)
        try {$array.SHA512}
        finally {
            # immediately zero out the byte array to remove any trace of the data before it is garbage collected
            for ($i = 0; $i -lt $array.Length; $i++) { $array[$i] = 0 }
        }
    }

    #endregion
#╚════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND PSCredential ═╝
