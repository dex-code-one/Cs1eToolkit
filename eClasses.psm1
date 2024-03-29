
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

    class EncryptedData {
        # This class is used to hold the encrypted data, salt, and IV from the AES encryption process
        [string]$data
        [string]$salt
        [string]$iv

        EncryptedData ([string]$data, [string]$salt, [string]$iv) {
            $this.data = $data
            $this.salt = $salt
            $this.iv = $iv
        }

        [string] ToString() {
            return $this.data + [Defaults]::ZeroWidthSpace + $this.salt + [Defaults]::ZeroWidthSpace + $this.iv
        }

        static [EncryptedData] FromString([string]$EncryptedDataString) {
            $parts = $EncryptedDataString.Split([Defaults]::ZeroWidthSpace)
            return [EncryptedData]::new($parts[0], $parts[1], $parts[2])
        }

        [byte[]] ToByteArray() {
            return [Defaults]::Encoding.GetBytes($this.ToString())
        }

        static [EncryptedData] FromByteArray([byte[]]$EncryptedDataBytes) {
            return [EncryptedData]::FromString([Defaults]::Encoding.GetString($EncryptedDataBytes))
        }
    }

    class Encryption {

        #--------------------------------------------------------------
        #region ConvertByteArrayToSecureString
        #--------------------------------------------------------------
        static [System.Security.SecureString] ConvertByteArrayToSecureString([byte[]]$bytes) {
            $secureString = New-Object System.Security.SecureString
            for ($i = 0; $i -lt $bytes.Length; $i += 2) {
                # Convert 2 bytes at a time to char and add to SecureString
                $char = [System.BitConverter]::ToChar($bytes, $i)
                $secureString.AppendChar($char)
            }
            # Immediately zero out the byte array after it's been used to mitigate memory scraping
            for ($i = 0; $i -lt $bytes.Length; $i++) {$bytes[$i] = 0}
            return $secureString
        }
        #endregion

        #--------------------------------------------------------------
        #region ConvertPSCredentialToByteArray
        #--------------------------------------------------------------
        static [byte[]] ConvertPSCredentialToByteArray([System.Management.Automation.PSCredential]$credential) {
            # Safely converts a PSCredential to a byte array without ever exposing it in memory
            return [Defaults]::Encoding.GetBytes($credential.UserName) + [Encryption]::ConvertSecureStringToByteArray($credential.Password)
        }
        #endregion        

        #--------------------------------------------------------------
        #region ConvertSecureStringToByteArray
        #--------------------------------------------------------------
        static [byte[]] ConvertSecureStringToByteArray([System.Security.SecureString]$secureString) {
            # Safely converts a SecureString to a byte array without ever exposing it in memory
            $bytes = $null
            if ($null -eq $secureString) {throw [System.ArgumentNullException]::new('secureString')}
            $pointer = [System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($secureString)
            try {
                $length = $secureString.Length * 2
                $bytes = New-Object byte[] -ArgumentList $length
                [System.Runtime.InteropServices.Marshal]::Copy($pointer, $bytes, 0, $length)    
                return $bytes
            } finally {
                # immediately zero out and free the memory allocated for the secure string
                [System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($pointer)
            }
        }
        #endregion

        #--------------------------------------------------------------
        #region DecryptByteArray
        #--------------------------------------------------------------
        static [byte[]] DecryptByteArray([EncryptedData]$encryptedData, [byte[]]$passwordBytes) {
            $encryptedDataBytes = [Convert]::FromBase64String($encryptedData.data)
            $saltBytes = [Convert]::FromBase64String($encryptedData.salt)
            $ivBytes = [Convert]::FromBase64String($encryptedData.iv)
            $ms = $null
            $decryptedBytes = $null
            $rdb = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($passwordBytes, $saltBytes, [Defaults]::EncryptionIterations)
            $aes = [System.Security.Cryptography.Aes]::Create()
            try {
                $aes.Key = $rdb.GetBytes([Defaults]::EncryptionKeySize / 8)
                $aes.IV = $ivBytes
                $ms = New-Object System.IO.MemoryStream
                $cs = New-Object System.Security.Cryptography.CryptoStream $ms, $aes.CreateDecryptor(), 'Write'
                try {
                    $cs.Write($encryptedDataBytes, 0, $encryptedDataBytes.Length)
                    $cs.FlushFinalBlock()
                    $decryptedBytes = $ms.ToArray()
                } finally {
                    $cs.Dispose()
                }
            } finally {
                #zero out the derived key and IV immediately
                for ($i = 0; $i -lt $aes.Key.Length; $i++) {$aes.Key[$i] = 0}
                for ($i = 0; $i -lt $aes.IV.Length; $i++) {$aes.IV[$i] = 0}
                $aes.Dispose()
                $ms.Dispose()
            }
            # Zero out the byte arrays after they're used
            for ($i = 0; $i -lt $encryptedDataBytes.Length; $i++) {$encryptedDataBytes[$i] = 0}
            for ($i = 0; $i -lt $saltBytes.Length; $i++) {$saltBytes[$i] = 0}
            for ($i = 0; $i -lt $ivBytes.Length; $i++) {$ivBytes[$i] = 0}
            return $decryptedBytes
        }

        # override for SecureString password
        static [byte[]] DecryptByteArray([EncryptedData]$encryptedData, [System.Security.SecureString]$securePassword) {
            return [Encryption]::DecryptByteArray($encryptedData, [Encryption]::ConvertSecureStringToByteArray($securePassword))
        }

        # override for string password
        static [byte[]] DecryptByteArray([EncryptedData]$encryptedData, [string]$plainPass) {
            return [Encryption]::DecryptByteArray($encryptedData, [Defaults]::Encoding.GetBytes($plainPass))
        }
        #endregion

        #--------------------------------------------------------------
        #region DecryptSecureString
        #--------------------------------------------------------------
        static [System.Security.SecureString] DecryptSecureString([EncryptedData]$encryptedData, [byte[]]$passwordBytes) {
            $decryptedBytes = [Encryption]::DecryptByteArray($encryptedData, $passwordBytes)
            try {
                return [Encryption]::ConvertByteArrayToSecureString($decryptedBytes)
            } finally {
                # Zero out the decrypted array immediately
                for ($i = 0; $i -lt $decryptedBytes.Length; $i++) {$decryptedBytes[$i] = 0}
            }
        }

        # overload for SecureString password
        static [System.Security.SecureString] DecryptSecureString([EncryptedData]$encryptedData, [System.Security.SecureString]$securePassword) {
            return [Encryption]::DecryptSecureString($encryptedData, [Encryption]::ConvertSecureStringToByteArray($securePassword))
        }

        # overload for string password
        static [System.Security.SecureString] DecryptSecureString([EncryptedData]$encryptedData, [string]$plainPass) {
            $securePassword = New-Object System.Security.SecureString
            for ($i=0; $i -lt $plainPass.Length; $i++) {$securePassword.AppendChar($plainPass[$i])}
            return [Encryption]::DecryptSecureString($encryptedData, [Encryption]::ConvertSecureStringToByteArray($securePassword))
        }
        #endregion

        #--------------------------------------------------------------
        #region DecryptString
        #--------------------------------------------------------------
        static [string] DecryptString([EncryptedData]$encryptedData, [byte[]]$passwordBytes) {
            $decryptedBytes = [Encryption]::DecryptByteArray($encryptedData, $passwordBytes)
            try {
                return [Defaults]::Encoding.GetString($decryptedBytes)
            } finally {
                # Zero out the decrypted array immediately
                for ($i = 0; $i -lt $decryptedBytes.Length; $i++) {$decryptedBytes[$i] = 0}
            }
        }

        # overload for SecureString password
        static [string] DecryptString([EncryptedData]$encryptedData, [System.Security.SecureString]$securePassword) {
            return [Encryption]::DecryptString($encryptedData, [Encryption]::ConvertSecureStringToByteArray($securePassword))
        }

        # overload for string password
        static [string] DecryptString([EncryptedData]$encryptedData, [string]$plainPass) {
            return [Encryption]::DecryptString($encryptedData, [Defaults]::Encoding.GetBytes($plainPass))
        }
        #endregion

        #--------------------------------------------------------------
        #region EncryptByteArray
        #--------------------------------------------------------------
        static [EncryptedData] EncryptByteArray([byte[]]$dataBytes, [byte[]]$passwordBytes, [byte[]]$saltBytes) {
            # Initialize MemoryStream here
            $ms = New-Object System.IO.MemoryStream
            $EncryptedData = $null
        
            # and then encrypts the data using the password and salt
            $rdb = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($passwordBytes, $saltBytes, [Defaults]::EncryptionIterations)
            $aes = [System.Security.Cryptography.Aes]::Create()
            try {
                $aes.Key = $rdb.GetBytes([Defaults]::EncryptionKeySize / 8)
                $aes.IV = $rdb.GetBytes([Defaults]::EncryptionIVSize / 8)            
                $cs = New-Object System.Security.Cryptography.CryptoStream $ms, $aes.CreateEncryptor(), 'Write'
                try {
                    $cs.Write($dataBytes, 0, $dataBytes.Length)
                    $cs.FlushFinalBlock()
                    $EncryptedData = [EncryptedData]::new([Convert]::ToBase64String($ms.ToArray()), [Convert]::ToBase64String($saltBytes), [Convert]::ToBase64String($aes.IV))
                } finally {
                    $cs.Dispose()
                }
            } finally {
                #zero out the derived key and IV immediately
                for ($i = 0; $i -lt $aes.Key.Length; $i++) {$aes.Key[$i] = 0}
                for ($i = 0; $i -lt $aes.IV.Length; $i++) {$aes.IV[$i] = 0}
                $aes.Dispose()
                $ms.Dispose()
            }
            # Zero out the byte arrays immediately
            for ($i = 0; $i -lt $passwordBytes.Length; $i++) {$passwordBytes[$i] = 0}
            for ($i = 0; $i -lt $dataBytes.Length; $i++) {$dataBytes[$i] = 0}            
            return $EncryptedData
        }
        #endregion

        #--------------------------------------------------------------
        #region EncryptSecureString
        #--------------------------------------------------------------
        static [EncryptedData] EncryptSecureString([byte[]]$secureBytes, [byte[]]$securePasswordBytes, [byte[]]$secureSaltBytes) {
            return [Encryption]::EncryptByteArray($secureBytes, $securePasswordBytes, $secureSaltBytes)
        }

        # override for SecureString password and salt
        static [EncryptedData] EncryptSecureString([System.Security.SecureString]$secureData, [System.Security.SecureString]$securePassword, [System.Security.SecureString]$secureSalt) {
            return [Encryption]::EncryptByteArray([Encryption]::ConvertSecureStringToByteArray($secureData), [Encryption]::ConvertSecureStringToByteArray($securePassword), [Encryption]::ConvertSecureStringToByteArray($secureSalt))
        }
        #endregion

        #--------------------------------------------------------------
        #region EncryptString
        #--------------------------------------------------------------
        static [EncryptedData] EncryptString([byte[]]$plainBytes, [byte[]]$passwordBytes, [byte[]]$saltBytes) {
            return [Encryption]::EncryptByteArray($plainBytes, $passwordBytes, $saltBytes)
        }

        # overload for SecureString password and salt
        static [EncryptedData] EncryptString([string]$plainData, [System.Security.SecureString]$securePassword, [System.Security.SecureString]$secureSalt) {
            return [Encryption]::EncryptByteArray([Defaults]::Encoding.GetBytes($plainData), [Encryption]::ConvertSecureStringToByteArray($securePassword), [Encryption]::ConvertSecureStringToByteArray($secureSalt))
        }

        # overload for string password and salt
        static [EncryptedData] EncryptString([string]$plainData, [string]$plainPass, [string]$plainSalt) {
            return [Encryption]::EncryptByteArray([Defaults]::Encoding.GetBytes($plainData), [Defaults]::Encoding.GetBytes($plainPass), [Defaults]::Encoding.GetBytes($plainSalt))
        }
        #endregion


    }
    #endregion
#╚════════════════════════════════════════════════════════════════════════════════════════════════════════════ CLASSES ═╝

#╔═ EXTEND String ══════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.String class with additional common properties and methods

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

    # GetBytes
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName GetBytes -Force -Value {
        [Defaults]::Encoding.GetBytes($this ?? '')
    }

    # FromJson
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName FromJson -Force -Value {
        $this | ConvertFrom-Json
    }

    # FromClipboard
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName FromClipboard -Force -Value {
        Get-Clipboard
    }

    # Indent(int $indent = 4)
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName Indent -Force -Value {
        param([int] $indent = 4)
        $this -replace '(?m)^', (' ' * $indent)
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

    # RandomBytes(int $length = 16)
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName RandomBytes -Force -Value {
        param([int] $length = 16)
        $randomBytes = New-Object byte[] $Length
        $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
        try {$rng.GetBytes($randomBytes)}
        catch {throw}
        finally {$rng.Dispose()}
        $randomBytes
    }

    # RandomString(int $length = 16)
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName RandomString -Force -Value {
        param([int] $length = 16)
        $randomBytes = New-Object byte[] $Length
        $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
        try {$rng.GetBytes($randomBytes)}
        catch {throw}
        finally {$rng.Dispose()}
        [Convert]::ToBase64String($randomBytes).Substring(0,$length)
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

    # Salt
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName Salt -Force -Value {
        param()
        $salt = [byte[]]::new(16)
        [System.Security.Cryptography.RandomNumberGenerator]::Fill($salt)
        $salt
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

    # ToClipboard(bool $passthru = $false)
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToClipboard -Force -Value {
        param([bool] $passthru = $false)
        $this | Set-Clipboard
        if ($passthru) { $this }
    }

    # ToBase64
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToBase64 -Force -Value {
        [Convert]::ToBase64String([Defaults]::Encoding.GetBytes($this ?? ''))
    }

    # ToJson
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToJson -Force -Value {
        $this | ConvertTo-Json
    }

    # ToSecureString
    ###################################################################################################################
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToSecureString -Force -Value {
        $this | ConvertTo-SecureString -AsPlainText -Force
    }

    #endregion
#╚══════════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND String ═╝

#╔═ EXTEND BYTE[] ══════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.Byte[] class with additional common properties and methods

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

    # ToBase64
    ###################################################################################################################
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptMethod -MemberName ToBase64 -Force -Value {
        [Convert]::ToBase64String($this)
    }

    # ToHexString
    ###################################################################################################################
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptMethod -MemberName ToHexString -Force -Value {
        $this | ForEach-Object { $_.ToString('X2') } | Join-String
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


    #endregion
#╚════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND SecureString ═╝

#╔═ EXTEND PSCredential ════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.Management.Automation.PSCredential class with additional common properties and methods

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

    # ToByteArray
    ###################################################################################################################
    Update-TypeData -TypeName System.Management.Automation.PSCredential -MemberType ScriptMethod -MemberName ToByteArray -Force -Value {
        [Encryption]::ConvertPSCredentialToByteArray($this)
    }



    #endregion
#╚════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND PSCredential ═╝
