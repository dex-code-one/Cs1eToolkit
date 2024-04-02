
#╔═ CLASSES ════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region    

    #BinaryFormat enum
    #------------------------------------------------------------------------------------------------------------------
    enum BinaryFormat {
        # This enum is used to specify the output format for binary data (hashes, etc.)
        None
        Hex
        Base64
        Base85
    }

    #HashAlgorithm enum
    #------------------------------------------------------------------------------------------------------------------
    enum HashAlgorithm {
        # This enum is used to specify the hashing algorithm to use
        CRC64
        MD5
        SHA1
        SHA256
        SHA384
        SHA512
    }


    #LineStyle enum
    #------------------------------------------------------------------------------------------------------------------
    enum LineStyle {
        # This enum is used to specify the style of box to draw
        Light
        Heavy
        Double
        Thick
    }

    #LogLevel enum
    #------------------------------------------------------------------------------------------------------------------
    enum LogLevel {
        # This enum is used to specify the log level
        Debug
        Info
        Warn
        Error
        Fatal
    }


    #TextAlignment enum
    #------------------------------------------------------------------------------------------------------------------
    enum TextAlignment {
        # This enum is used to specify text alignment
        Left
        Center
        Right
    }
    

    #BoxLight class
    #------------------------------------------------------------------------------------------------------------------
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
    

    #BoxHeavy class
    #------------------------------------------------------------------------------------------------------------------
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
    

    #BoxDouble class
    #------------------------------------------------------------------------------------------------------------------
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
    

    #BoxThick class
    #------------------------------------------------------------------------------------------------------------------
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
   

    #Defaults class
    #------------------------------------------------------------------------------------------------------------------
    class Defaults {
        # This static class is used to hold default values for the module.  You don't need to instantiate this class.
        # $encoding = [Defaults]::Encoding
        # $indent = [Defaults]::Indent
        # etc.
        static [System.Text.Encoding] $Encoding = [System.Text.Encoding]::UTF8
        static [string] $EncodingName = [Defaults]::GetEncodingName()
        static [string] $FieldSeparator = "`u{200B} " # Zero-width space and a space
        static [string] $RecordSeparator = "`u{2063}`n" # Invisible separator and a newline
        static [int] $Indent = 4
        static [int] $ConsoleWidth = 120
        static [LineStyle] $LineStyle = [LineStyle]::Double
        static [int] $TextAlignment = [TextAlignment]::Left
        static [HashAlgorithm] $HashingAlgorithm = 'MD5'
        static [BinaryFormat] $HashingOutputFormat = 'Base64'
        static [int] $EncryptionKeySize = 256
        static [int] $EncryptionIVSize = 128
        static [int] $EncryptionIterations = 100000
        static [int] $ObfuscationKeySize = 128
        static [int] $ObfuscationIVSize = 128
        static [int] $ObfuscationIterations = 10
        static [byte[]] $ObfuscationString = [Defaults]::Encoding.GetBytes('HppjmX3CBynZzbLIE8kLC/NRJ8Z5zLLF') # for obfuscating data
        static [System.IO.FileInfo]$LogDirectory = [System.IO.Path]::Combine($env:TEMP, '1E\Logs')
        static [System.IO.FileInfo]$LogFallbackDirectory = $env:TEMP
        static [string]$LogPrefix = '1e.CustomerSuccess.'
        static [string]$LogNamePattern = 'yyyyMMdd_HHmmss_fffffff'
        static [string]$LogExtension = '.log'
        static [int]$LogTailLines = 40
        static [HashAlgorithm]$LogContextIDAlgorithm = 'MD5'
        static [BinaryFormat]$LogContextIDFormat = 'Base85'
        static [hashtable]$EchoColors = @{
            'Debug' = 'DarkGray'
            'Info' = 'Green'
            'Warn' = 'Yellow'
            'Error' = 'Red'
            'Fatal' = 'Magenta'
        }

        # GetEncodingName
        static [string] GetEncodingName() {
            $encodingMap = @{
                "us-ascii" = 'ASCII'
                "utf-16BE" = 'BigEndianUnicode'
                "utf-16" = 'Unicode'
                "utf-7" = 'UTF8'
                "utf-8" = 'UTF8'
            }
            return $null -ne $encodingMap[([Defaults]::Encoding.WebName)] ? $encodingMap[([Defaults]::Encoding.WebName)] : 'UTF8'
        }
    }

    #Device class
    #------------------------------------------------------------------------------------------------------------------
    class Device {
        # This class is used to get information about the local system
        [string]$Name
        [string]$Ip
        [string]$Manufacturer
        [string]$Model
        [string]$SerialNumber
    
        # Constructors
        # ------------------------------------------------------------------------------------------------------------------
        Device([string]$name, [string]$ip, [string]$manufacturer, [string]$model, [string]$serialNumber) {
            $this.Name = $name
            $this.Ip = $ip
            $this.Manufacturer = $manufacturer
            $this.Model = $model
            $this.SerialNumber = $serialNumber
        }
    
        # Overload to get the device information with no parameters
        Device() {
            $this.Name = [System.Net.Dns]::GetHostEntry([System.Net.Dns]::GetHostName()).HostName
            $this.Ip = try {Get-NetIPAddress -AddressFamily IPv4 -Type Unicast | Where-Object {$_.InterfaceAlias -notlike '*Loopback*' -and $_.PrefixOrigin -ne 'WellKnown'} | Sort-Object -Property InterfaceMetric -Descending | Select-Object -First 1 -ExpandProperty IPAddress} catch {''}
            $this.Manufacturer = (Get-WmiObject -Class Win32_BaseBoard).Manufacturer
            $this.Model = (Get-WmiObject -Class Win32_ComputerSystem).Model
            $this.SerialNumber = (Get-WmiObject -Class Win32_BIOS).SerialNumber
        }
    
        # Methods
        # ------------------------------------------------------------------------------------------------------------------
        [string] ToString() {
            return ([ordered]@{
                'DEVICE_NAME' = $this.Name
                'DEVICE_IP' = $this.Ip
                'DEVICE_MANUFACTURER' = $this.Manufacturer
                'DEVICE_MODEL' = $this.Model
                'DEVICE_SERIAL_NUMBER' = $this.SerialNumber
            }).ToString()
        }
    }
    

    #Draw class
    #------------------------------------------------------------------------------------------------------------------
    class Draw {
        # This class is used to draw boxes around text and draw lines/dividers between sections

        #Line
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
        

        #BoxTop
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
        

        #BoxMiddle
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
        

        #BoxBottom
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
        

        #Box
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
        
    }
    

    #Encryption class
    #------------------------------------------------------------------------------------------------------------------
    class Encryption {

        #Base85Encode
        #------------------------------------------------------------------------------------------------------------------
        static [string] Base85Encode ([byte[]] $bytes) {
            # This function encodes a byte array into a base85 string
            # Here we are using a custom base85 character set that uses letters, numbers and european diacritics to avoid issues with special characters
            $base85Chars = [char[]]('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞß')
            $output = New-Object System.Text.StringBuilder
    
            for ($i = 0; $i -lt $bytes.Length; $i += 4) {
                # Accumulate up to 4 bytes into a uint
                $value = 0
                for ($j = 0; $j -lt 4; $j++) {
                    $value = $value * 256
                    if ($i + $j -lt $bytes.Length) {
                        $value += $bytes[$i + $j]
                    }
                }
    
                # Convert the uint into 5 base85 characters
                $chunk = New-Object char[] 5
                for ($k = 4; $k -ge 0; $k--) {
                    $chunk[$k] = $base85Chars[$value % 85]
                    $value = [math]::Floor($value / 85)
                }
    
                # Adjust the chunk size for the last block if it's shorter
                $actualChunkSize = [math]::Min(5, $bytes.Length - $i + 1)
                $output.Append($chunk, 0, $actualChunkSize)
            }
    
            return $output.ToString()
        }

        # Overload for Base85Encode using string
        static [string] Base85Encode ([string] $data) {
            return [Encryption]::Base85Encode([Defaults]::Encoding.GetBytes($data))
        }

        # Overload for Base85Encode using SecureString
        static [string] Base85Encode ([SecureString] $secureString) {
            $bytes = $null
            $pointer = [System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($secureString)
            try {
                $bytes = New-Object byte[] -ArgumentList $secureString.Length * 2
                [System.Runtime.InteropServices.Marshal]::Copy($pointer, $bytes, 0, $bytes.Length)
                return [Encryption]::Base85Encode($bytes)
            } finally {
                # Zero out the bytes array to securely clean up the data
                if ($null -ne $bytes) {for ($i = 0; $i -lt $bytes.Length; $i++) { $bytes[$i] = 0 }}
                [System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($pointer)
            }
        }

        #Crc64
        #------------------------------------------------------------------------------------------------------------------
        static [string] Crc64 ([byte[]] $data) {
            $poly = 0xC96C5795D7870F42
            $table = New-Object 'uint64[]' 256
            for ($i = 0; $i -lt 256; $i++) {
                $value = [uint64]$i
                for ($j = 0; $j -lt 8; $j++) {
                    if ($value -band 1) {
                        $value = [uint64](($value -shr 1) -bxor $poly)
                    } else {
                        $value = [uint64]($value -shr 1)
                    }
                }
                $table[$i] = $value
            }
        
            $crc = [uint64]::MaxValue
            foreach ($byte in $data) {
                $index = [byte](($crc -bxor [uint64]$byte) -and 0xFF)
                $crc = $table[$index] -bxor ($crc -shr 8)
            }
            return ($crc -bxor [uint64]::MaxValue)
        }

        #Decrypt
        #------------------------------------------------------------------------------------------------------------------
        static [securestring] Decrypt ([string] $encryptedData, [byte[]] $keyBytes) {
            return (ConvertTo-SecureString -String $encryptedData -Key $keyBytes)
        }
        

        #Encrypt
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
        
        # Hash
        #------------------------------------------------------------------------------------------------------------------
        # Generates a hash of a secure string using the specified algorithm
        static [string] Hash ([securestring] $secureString, [HashAlgorithm] $algorithm, [BinaryFormat] $outputFormat) {
            if ($null -eq $secureString) { throw [System.ArgumentNullException]::new('secureString') }
            $bytes = $null
            $pointer = [System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($secureString)
            try {
                $length = $secureString.Length * 2
                $bytes = New-Object byte[] -ArgumentList $length
                [System.Runtime.InteropServices.Marshal]::Copy($pointer, $bytes, 0, $length)
                # Calculate hash from bytes
                $hash = [System.Security.Cryptography.HashAlgorithm]::Create($algorithm)
                try {
                    switch ($outputFormat) {
                        'Base64' {return [Convert]::ToBase64String($hash.ComputeHash($bytes))}
                        'Hex' {return [BitConverter]::ToString($hash.ComputeHash($bytes)).Replace('-','')}
                        'Base85' {return [Encryption]::Base85Encode($hash.ComputeHash($bytes))}
                        'None' {return [Encryption]::Crc64($bytes)}
                        default {throw [System.ArgumentException]::new('outputFormat')}
                    }
                    return $null
                } finally {
                    if ($null -ne $hash) {$hash.Dispose()}
                }
            } finally {
                # Zero out the bytes array to securely clean up the data
                if ($null -ne $bytes) {for ($i = 0; $i -lt $bytes.Length; $i++) { $bytes[$i] = 0 }}
                [System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($pointer)
            }
        }

        # Overload for Hash using string
        static [string] Hash ([string] $data, [HashAlgorithm] $algorithm, [BinaryFormat] $outputFormat) {
            $bytes = [Defaults]::Encoding.GetBytes($data)
            $hash = [System.Security.Cryptography.HashAlgorithm]::Create($algorithm)
            try {
                switch ($outputFormat) {
                    'Base64' {return [Convert]::ToBase64String($hash.ComputeHash($bytes))}
                    'Hex' {return [BitConverter]::ToString($hash.ComputeHash($bytes)).Replace('-','')}
                    'Base85' {return [Encryption]::Base85Encode($hash.ComputeHash($bytes))}
                    'None' {return [Encryption]::Crc64($bytes)}
                    default {throw [System.ArgumentException]::new('outputFormat')}
                }
                return $null
            }
            finally {
                if ($null -ne $hash) {$hash.Dispose()}
            }
        }

        # Overload for Hash using byte array
        static [string] Hash ([byte[]] $bytes, [HashAlgorithm] $algorithm, [BinaryFormat] $outputFormat) {
            $hash = [System.Security.Cryptography.HashAlgorithm]::Create($algorithm)
            try {
                switch ($outputFormat) {
                    'Base64' {return [Convert]::ToBase64String($hash.ComputeHash($bytes))}
                    'Hex' {return [BitConverter]::ToString($hash.ComputeHash($bytes)).Replace('-','')}
                    'Base85' {return [Encryption]::Base85Encode($hash.ComputeHash($bytes))}
                    'None' {return [Encryption]::Crc64($bytes)}
                    default {throw [System.ArgumentException]::new('outputFormat')}
                }
                return $null
            }
            finally {
                if ($null -ne $hash) {$hash.Dispose()}
            }
        }

        # Overload for Hash using SecureString and no output format
        static [string] Hash ([SecureString] $secureString, [HashAlgorithm] $algorithm) {
            return [Encryption]::Hash($secureString, $algorithm, [Defaults]::HashingOutputFormat)
        }

        # Overload for Hash using string and no output format
        static [string] Hash ([string] $data, [HashAlgorithm] $algorithm) {
            return [Encryption]::Hash($data, $algorithm, [Defaults]::HashingOutputFormat)
        }

        # Overload for Hash using byte array and no output format
        static [string] Hash ([byte[]] $bytes, [HashAlgorithm] $algorithm) {
            return [Encryption]::Hash($bytes, $algorithm, [Defaults]::HashingOutputFormat)
        }

        # Overload for Hash using SecureString with no algorithm and no output format
        static [string] Hash ([SecureString] $secureString) {
            return [Encryption]::Hash($secureString, [Defaults]::HashingAlgorithm, [Defaults]::HashingOutputFormat)
        }

        # Overload for Hash using string with no algorithm and no output format
        static [string] Hash ([string] $data) {
            return [Encryption]::Hash($data, [Defaults]::HashingAlgorithm, [Defaults]::HashingOutputFormat)
        }

        # Overload for Hash using byte array with no algorithm and no output format
        static [string] Hash ([byte[]] $bytes) {
            return [Encryption]::Hash($bytes, [Defaults]::HashingAlgorithm, [Defaults]::HashingOutputFormat)
        }
    
        #NewAesKey
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
            if ($null -eq $secureString) { throw [System.ArgumentNullException]::new('secureString') }
            $bytes = $null
            $pointer = [System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($secureString)
            try {
                $length = $secureString.Length * 2
                $bytes = New-Object byte[] -ArgumentList $length
                [System.Runtime.InteropServices.Marshal]::Copy($pointer, $bytes, 0, $length)
                $rdb = New-Object System.Security.Cryptography.Rfc2898DeriveBytes $bytes, ([Defaults]::Encoding.GetBytes([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureSalt)))), ([Defaults]::EncryptionIterations)
                try {
                    return $rdb.GetBytes(32)
                } finally {
                    if ($null -ne $rdb) {$rdb.Dispose()}
                }           
            } finally {
                # Zero out the bytes array to securely clean up the data
                if ($null -ne $bytes) {for ($i = 0; $i -lt $bytes.Length; $i++) { $bytes[$i] = 0 }}
                [System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($pointer)
            }
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

        # ROT13
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

    }

    #Find class
    #------------------------------------------------------------------------------------------------------------------
    class Find {
        # This class is used to find files and folders on the local system
        # Find::File('*.txt')
        # Find::Directory('C:\Windows')
        # Find::FirstFile('*SQLite.dll')
        # Find::FirstDirectory('C:\Windows\System32')
        # Find::FixedDrives()
        # Find::MostFreeDisk()
        # Find::LastFile('*SQLite.dll')
        # Find::LastDirectory('C:\Windows\System32')
        # Find::FileWithString('*.txt','password')
        # Find::FirstFileWithString('*.txt','password')

        #Directory
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.DirectoryInfo[]] Directory([string] $Filter) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'} |
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -Directory -ErrorAction SilentlyContinue -Force -Filter $Filter}
        }

        #File
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.FileInfo[]] File([string] $Filter) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'} |
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -File -ErrorAction SilentlyContinue -Force -Filter $Filter}
        }

        #FirstDirectory
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.DirectoryInfo] FirstDirectory([string] $Filter) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'} |
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -Directory -ErrorAction SilentlyContinue -Force -Filter $Filter} |
                        Select-Object -First 1
        }

        #FirstFile
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.FileInfo] FirstFile([string] $Filter) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'} |
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -File -ErrorAction SilentlyContinue -Force -Filter $Filter} |
                        Select-Object -First 1
        }

        #FirstFileWithString
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.FileInfo] FirstFileWithString([string] $Filter, [string] $Pattern) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'} |
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -File -ErrorAction SilentlyContinue -Force -Filter $Filter} |
                        Where-Object {(Select-String -Path $_ -Pattern $pattern -Quiet)} |
                            Select-Object -First 1
        }

        #FileWithString
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.FileInfo[]] FileWithString([string] $Filter, [string] $Pattern) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'} |
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -File -ErrorAction SilentlyContinue -Force -Filter $Filter} |
                        Where-Object {(Select-String -Path $_ -Pattern $pattern -Quiet)}
        }

        #FixedDrives
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.DriveInfo[]] FixedDrives() {
            return [System.IO.DriveInfo]::GetDrives() | Where-Object {$_.DriveType -in 3,6}
        }

        #LastDirectory
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.DirectoryInfo] LastDirectory([string] $Filter) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'} |
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -Directory -ErrorAction SilentlyContinue -Force -Filter $Filter} |
                        Select-Object -Last 1
        }

        #LastFile
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.FileInfo] LastFile([string] $Filter) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'} |
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -File -ErrorAction SilentlyContinue -Force -Filter $Filter} |
                        Select-Object -Last 1
        }

        #MostFreeDrive
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.DriveInfo] MostFreeDrive() {
            return [Find]::FixedDrives() | Sort-Object -Property AvailableFreeSpace -Descending | Select-Object -First 1
        }
    }

    #LogContext class
    #------------------------------------------------------------------------------------------------------------------
    class LogContext {
        # This class is used to hold context information for logging
        [string]$ID
        [Device]$Device
        [OS]$OS
        [PowerShell]$PowerShell
        [Process]$Process
        [User]$User

        #Constructors
        #------------------------------------------------------------------------------------------------------------------
        LogContext() {
            $this.Device = [Device]::new()
            $this.OS = [OS]::new()
            $this.PowerShell = [PowerShell]::new()
            $this.Process = [Process]::new()
            $this.User = [User]::new()
            $this.ID = [Encryption]::Hash($this.ToString(), [Defaults]::LogContextIDAlgorithm, [Defaults]::LogContextIDFormat)
        }

        #Methods
        #------------------------------------------------------------------------------------------------------------------
        [string] ToString() {
            return $this.Device.ToString()+$this.OS.ToString()+$this.PowerShell.ToString()+$this.Process.ToString()+$this.User.ToString()
        }
    }

    #Log class
    #------------------------------------------------------------------------------------------------------------------
    class Log {
        # Properties
        #==================================================================================================================
        [System.IO.FileInfo]$LogFile
        [int32]$LogMaxBytes = 10MB
        [int32]$LogMaxRollovers = 5
        [System.IO.FileInfo[]]$RolloverLogs
        [int32]$TailLines = [Defaults]::LogTailLines
        [ordered]$LoggingContext
        [System.DateTimeOffset]$InstantiatedTime = [System.DateTimeOffset]::Now
        [bool]$EchoMessages = $false
        [string]$FS = [Defaults]::FieldSeparator
        [string]$RS = [Defaults]::RecordSeparator
        [HashAlgorithm]$ContextIDAlgorithm = [Defaults]::LogContextIDAlgorithm
        [BinaryFormat]$ContextIDFormat = [Defaults]::LogContextIDFormat
        [hashtable]$EchoColors = @{'Debug' = 'DarkGray';'Info' = 'Green';'Warn' = 'Yellow';'Error' = 'Red';'Fatal' = 'Magenta'}
        [LogContext]$Context

        # Private Properties
        #==================================================================================================================
        hidden [string]$encodingName = [Defaults]::EncodingName
        hidden [System.IO.FileInfo]$cmTrace

        # Constructors
        #==================================================================================================================

        # New log with default name/location
        Log() {
            $this.LogFile = $this.NewFileInfo($null)            
            $this.Initialize()
        }

        # New log with specified name/location
        Log([string]$logName) {
            $this.LogFile = $this.NewFileInfo($logName)
            $this.Initialize()
        }        
        
        [void] Initialize() {
            # Make sure the log directory exists first, if not, force it to exist
            if (-not (Test-Path -Path $this.LogFile.Directory)) {
                try {
                    New-Item -Path $this.LogFile.Directory -ItemType Directory -Force -ErrorAction Stop
                }
                catch {
                    # If we can't create the log directory, use the fallback directory (%TEMP%\1e\CsLogs)
                    Write-Warning "Unable to create log directory $($this.LogFile.Directory). Using fallback directory $([Defaults]::LogFallbackDirectory) instead"
                    $this.LogFile = $this.NewFileInfo([System.IO.Path]::Combine([Log]::LogFallbackDirectory, $this.LogFile.Name))
                    if (-not (Test-Path -Path $this.LogFile.Directory)) {
                        try {
                            New-Item -Path $this.LogFile.Directory -ItemType Directory -Force -ErrorAction Stop
                        }
                        catch {
                            # If we can't create the log directory, fail
                            throw "Unable to create log directory $($this.defaultDirectory) and fallback directory $($this.fallbackDirectory)"
                        }
                    }
                }
            }

            # Make sure the log file exists, if not, create it
            if (-not (Test-Path -Path $this.LogFile.FullName)) {
                try {
                    Set-Content -Path $this.LogFile.FullName -Force -ErrorAction Stop -Encoding ([Defaults]::Encoding) -Value ''
                }
                catch {
                    # If we can't create the log file, fail
                    throw "Unable to create log file $($this.LogFile.FullName)`n$_"
                }
            }

            # Get the list of RollOver files
            $this.RolloverLogs = Get-ChildItem -Path $this.LogFile.Directory -Filter "$($this.LogFile.BaseName).*$($this.LogFile.Extension)" -File |
                Sort-Object -Property Name -Descending

            # Get the logging context
            $this.Context = [LogContext]::new()

            # If the ContextID isn't already in the log, write the context to the log
            try {$isFound = (Select-String -Path $this.LogFile.FullName -Pattern ($this.Context.ID) -Quiet -ErrorAction Stop)} catch {$isFound = $false}
            if (-not $isFound) {
                $this.Write('Info',"`n$([Draw]::BoxTop(' LOG_CONTEXT ', 'Double','Left'))`n$($this.Context.ToString())`n$([Draw]::BoxBottom(' LOG_CONTEXT ', 'Double','Right'))")
            }
        }
        

        # Methods
        #==================================================================================================================

        # Debug
        #------------------------------------------------------------------------------------------------------------------
        [void] Debug([string] $Message) {
            $this.Write('Debug', $Message)
        }


        # Echo
        #------------------------------------------------------------------------------------------------------------------
        hidden [void] Echo([string] $Message, [string] $Level) {
            Write-Host $Message -ForegroundColor $this.EchoColors[$Level] -NoNewline
        }

        # Error
        #------------------------------------------------------------------------------------------------------------------
        [void] Error([string] $Message) {
            $this.Write('Error', $Message)
        }


        # Fatal
        #------------------------------------------------------------------------------------------------------------------
        [void] Fatal([string] $Message) {
            $this.Write('Fatal', $Message)
        }

        # FindInLog
        #------------------------------------------------------------------------------------------------------------------
        [String[]] FindInLog([string] $Pattern) {
            return $this.FindInLog($Pattern, '*', [DateTime]::MinValue, [DateTime]::MaxValue, '*')
        }

        # Finds a string in the log between two dates
        [String[]] FindInLog([string] $Pattern, [DateTime] $Start, [DateTime] $End) {
            return $this.FindInLog($Pattern, '*', $Start, $End, '*')
        }
        
        # Finds a string in the log of a specific level
        [String[]] FindInLog([string] $Pattern, [string] $Level) {
            return $this.FindInLog($Pattern, $Level, [DateTime]::MinValue, [DateTime]::MaxValue, '*')
        }

        # Finds a string in the log with a specific level and contextHash between two dates
        [String[]] FindInLog([string] $Pattern, [string] $Level, [DateTime] $Start, [DateTime] $End, [string]$ContextHash) {
            # If the properties haven't been cleared, and the log exists, tail the log and return the result
            if ($this.LogFile.FullName -and (Test-Path -Path $this.LogFile.FullName)) {
                # Parse the log file into records using the record separator
                return (Get-Content -Path $this.LogFile.FullName -Raw) -split $this.RS |
                    # Pre-filter to return only those records that match the pattern somewhere on the line
                    Where-Object {($_ -like $Pattern) -and ($_ -like "*$Level*") -and ($_ -like "*$ContextHash*")} |
                        # Parse each record into fields using the field separator
                        ForEach-Object {
                            $fields = ($_ -split $log.FS).ForEach({$_.Trim()})
                            if ($fields.Count -eq 4) {
                                @{
                                    TimeStamp = $fields[0]
                                    ContextID = $fields[1]
                                    Level = $fields[2]
                                    Message = $fields[3]
                                }
                            }
                        } | Where-Object {
                            $_.Message -like $Pattern -and $_.Level -like $Level -and $_.ContextHash -like $ContextHash -and [DateTime]$_.TimeStamp -ge $Start -and [DateTime]$_.TimeStamp -le $End
                        } # Only return those records that match the pattern in the message
            } else {
                return [String[]]@()
            }                
        }        

        # GetContent
        #------------------------------------------------------------------------------------------------------------------
        [string] GetContent() {
            # If the properties haven't been cleared, and the log exists, tail the log and return the result
            if ($this.LogFile.FullName -and (Test-Path -Path $this.LogFile.FullName)) {
                # Parse the log file into records using the record separator
                return (Get-Content -Path $this.LogFile.FullName -Raw) -split $this.RS |
                    # Remove empty records
                    Where-Object {$_}
                                    
            } else {return [string[]]@()}
        }


        # GetDateRangeOfLog
        #------------------------------------------------------------------------------------------------------------------
        [PSCustomObject] GetDateRangeOfLog() {
            # If the properties haven't been cleared, and the log exists
            if ($this.LogFile.FullName -and (Test-Path -Path $this.LogFile.FullName)) {
                # Get the date from the first record in the log
                $first = ((Get-Content -Path $this.LogFile.FullName -First 1) -split $this.FS)[0]

                # Get the date from the last record in the log
                $last = (((Get-Content -Path $this.LogFile.FullName -Raw) -split $this.RS | Where-Object {$_} | Select-Object -Last 1) -split $this.FS)[0]

                # Return the date range
                return [PSCustomObject]@{
                    First = [DateTimeOffset]::ParseExact($first, "yyyy-MM-dd HH:mm:ss.fffffff zzz", [System.Globalization.CultureInfo]::InvariantCulture)
                    Last = [DateTimeOffset]::ParseExact($last, "yyyy-MM-dd HH:mm:ss.fffffff zzz", [System.Globalization.CultureInfo]::InvariantCulture)
                    TimeSpan = [DateTimeOffset]::ParseExact($last, "yyyy-MM-dd HH:mm:ss.fffffff zzz", [System.Globalization.CultureInfo]::InvariantCulture) - [DateTimeOffset]::ParseExact($first, "yyyy-MM-dd HH:mm:ss.fffffff zzz", [System.Globalization.CultureInfo]::InvariantCulture)
                }
            }
            else {
                return [PSCustomObject]@{
                    First = [DateTimeOffset]::MinValue
                    Last = [DateTimeOffset]::MinValue
                    TimeSpan = [DateTimeOffset]::MinValue - [DateTimeOffset]::MinValue
                }
            }
        }        


        # Info
        #------------------------------------------------------------------------------------------------------------------
        [void] Info([string] $Message) {
            $this.Write('Info', $Message)
        }


        # NewEntryString
        #------------------------------------------------------------------------------------------------------------------
        hidden [string] NewEntryString([LogLevel]$Level, [string]$Message) {
            return "{0}{1}[{2}]{3}{4}{5}{6}{7}" -f [DateTimeOffset]::Now.ToString("yyyy-MM-dd HH:mm:ss.fffffff zzz"), $this.FS, $this.Context.ID, $this.FS, $Level, $this.FS, $Message, $this.RS
        }

        # NewFileInfo 
        #------------------------------------------------------------------------------------------------------------------
        hidden [System.IO.FileInfo] NewFileInfo([string] $Path) {
            # Converts a string representing a path of somekind (like Name, FullName, BaseName) to a
            # FileInfo object using defaults if there's not enough to make a [System.IO.FileInfo] object

            # If the path is empty, set it to a default value of defaultPrefix + defaultExtension
            if (-not $Path) {
                $Path = [Defaults]::LogPrefix + (Get-Date -Format ([Defaults]::LogNamePattern) -AsUTC) + [Defaults]::LogExtension
            }

            # Get the parts of the path passed in so we know if we've been given a full path or just a file name
            $directory = [System.IO.Path]::GetDirectoryName($Path)
            $name = [System.IO.Path]::GetFileName($Path)
            $extension = [System.IO.Path]::GetExtension($Path)

            # If the log name doesn't have an extension, add default extension
            if (-not $extension) {
                $name = $name + [Defaults]::LogExtension
            }

            # If the log name doesn't have a directory, use the preferred log folder
            if (-not $directory) {
                $directory = [Defaults]::LogDirectory
            }

            # Return a new FileInfo object        
            return [System.IO.FileInfo]::new([System.IO.Path]::Combine($directory, $name))
        }

        # OpenCmTrace
        #------------------------------------------------------------------------------------------------------------------
        [void] OpenCmTrace() {
            # Using powershell, Find the first instance of CMTrace.exe and open a logfile with it
            if ($null -eq $this.cmTrace) {
                $this.cmTrace = [Find]::FirstFile('*CMTrace.exe')
                if ($this.cmTrace) {
                    Start-Process -FilePath $this.cmTrace.FullName -ArgumentList $this.LogFile.FullName
                }
            }
        }

        # OpenExplorer
        #------------------------------------------------------------------------------------------------------------------
        [void] OpenExplorer() {
            # Open the log file in explorer
            Start-Process -FilePath "explorer.exe" -ArgumentList "/select, `"$($this.LogFile.FullName)`""
        }

        # RollOver
        #------------------------------------------------------------------------------------------------------------------
        hidden [void] RollOver() {
                # Get the existing rollover log files (rollover logs are named LogFolder\LogBaseName.*.log where * is a number from 1 to LogMaxRollovers)
                $this.RolloverLogs = Get-ChildItem -Path $this.LogFile.Directory -Filter "$($this.LogFile.BaseName).*$($this.LogFile.Extension)" -File |
                    Sort-Object -Property Name

                # If the number of rollover logs is greater than or equal to LogMaxRollovers, delete the oldest rollover log
                if ($this.RolloverLogs.Count -ge $this.LogMaxRollovers) {
                    try {
                        $this.RolloverLogs[-1].Delete()
                    }
                    catch {
                        # If we can't delete the oldest rollover log, do nothing, we'll try to move the data below instead
                    }
                }

                # Rename all the existing logs to the next highest number
                for ($i = $this.LogMaxRollovers; $i -gt 1; $i--) {
                    $oldLog = [System.IO.Path]::Combine($this.LogFile.Directory, "$($this.LogFile.BaseName).$($i - 1)$($this.LogFile.Extension)")
                    $newLog = [System.IO.Path]::Combine($this.LogFile.Directory, "$($this.LogFile.BaseName).$($i)$($this.LogFile.Extension)")
                    if (Test-Path -Path $oldLog) {
                        Write-Verbose "Rolling over $oldLog --> $newLog"
                        try {
                            # try to rename the log file to the next highest rollover
                            Rename-Item -Path $oldLog -NewName $newLog -Force -ErrorAction Stop
                        }
                        catch {
                            # if we can't rename the log, try to copy its contents to the next highest rollover this is a last-ditch effort
                            # to preserve the log contents if we can't rename the file for some reason like when the file is in use by 
                            # another process or the folder it is in has delete protection but we can still write to the file. This is more 
                            # disk intensive than a rename, but it's better than losing the log contents.
                            $firstError = $_
                            try {
                                Get-Content -Path $oldLog -Raw -Force -ErrorAction Stop | Set-Content -Path $newLog -Force -ErrorAction Stop -Encoding $this.encodingName
                            }
                            catch {
                                Write-Host $firstError
                                Write-Host $_
                                throw "Unable to rollover $oldLog --> $newLog"
                            }
                        }
                    }
                }

                # Rename the current log to .1.log
                $newLog = [System.IO.Path]::Combine($this.LogFile.Directory, "$($this.LogFile.BaseName).1$($this.LogFile.Extension)")
                Write-Verbose "Rolling over $($this.LogFile.FullName) --> $newLog"
                try {
                    Rename-Item -Path $this.LogFile.FullName -NewName $newLog -Force -ErrorAction Stop
                }
                catch {
                    $firstError = $_
                    # if we can't rename the log, try to copy its contents to the archive
                    try {
                        Get-Content -Path $this.LogFile.FullName -Raw -Force -ErrorAction Stop | Set-Content -Path $newLog -Encoding $this.encodingName -Force -ErrorAction Stop
                    }
                    catch {
                        Write-Error $firstError
                        Write-Error $_
                        throw "Unable to rollover $($this.LogFile.FullName) --> $newLog"
                    }
                    # clear the log file contents since we couldn't rename it
                    Set-Content -Path $this.LogFile.FullName -Value '' -Force -Encoding $this.encodingName -ErrorAction Stop
                }

                # re-populate the list of rollover logs (this is a bit redundant, but it makes sure the list is for sure up to date)
                $this.RolloverLogs = Get-ChildItem -Path $this.LogFile.Directory -Filter "$($this.LogFile.BaseName).*$($this.LogFile.Extension)" -File |
                    Sort-Object -Property Name -Descending

                # clear the context so the context will always be written to the new log
                $this.Context = $null
        }

        # Size
        #------------------------------------------------------------------------------------------------------------------
        [int] Size() {
            return (Get-Item -Path $this.LogFile.FullName).Length
        }


        # Tail
        #------------------------------------------------------------------------------------------------------------------
        [string[]] Tail([int] $lines) {
            # If the properties haven't been cleared, and the log exists, tail the log and return the result
            if ($this.LogFile.FullName -and (Test-Path -Path $this.LogFile.FullName)) {
                # Parse the log file into records using the record separator
                return (Get-Content -Path $this.LogFile.FullName -Raw) -split $this.RS |
                    # Remove any empty records
                    Where-Object {$_} |
                        # Get the last $lines records
                        Select-Object -Last $lines 
            } else {
                return [string[]]@()
            }
        }        

        # Overload for Tail using default TailLines property
        [string[]] Tail() {
            return $this.Tail($this.TailLines)
        }

        # Warn
        #------------------------------------------------------------------------------------------------------------------
        [void] Warn([string] $Message) {
            $this.Write('Warn', $Message)
        }


        # Write
        #------------------------------------------------------------------------------------------------------------------
        hidden [void] Write([LogLevel] $Level = 'Info', [string] $Message) {
            # Build the log entry string
            $msg = $this.NewEntryString($Level, $Message)
            try {
                # Open the log file
                $fileStream = [System.IO.File]::Open($this.LogFile, [System.IO.FileMode]::Append, [System.IO.FileAccess]::Write, [System.IO.FileShare]::ReadWrite)
                $streamWriter = New-Object System.IO.StreamWriter $fileStream, [defaults]::encoding                
                try {
                    # see if the message will make the log exceed the LogMaxBytes property
                    if (([defaults]::encoding.GetByteCount($msg) + $streamWriter.BaseStream.Length) -ge $this.LogMaxBytes) {
                        # if it will, close the log...
                        $streamWriter.Close()
                        $fileStream.Close()
                        # ...and roll it over
                        $this.RollOver()
                        # then open the log again
                        $fileStream = [System.IO.File]::Open($this.LogFile, [System.IO.FileMode]::Append, [System.IO.FileAccess]::Write, [System.IO.FileShare]::ReadWrite)
                        $streamWriter = New-Object System.IO.StreamWriter $fileStream, [defaults]::encoding
                        # get the current logging context
                        $this.Context = [LogContext]::new()
                        # write the context to the log
                        $streamWriter.Write($this.NewEntryString('Info',"`n$([Draw]::BoxTop(' LOG_CONTEXT ', 'Double','Left'))`n$($this.Context.ToString())`n$([Draw]::BoxBottom(' LOG_CONTEXT ', 'Double','Right'))"))
                        # generate the log entry again, as the the original timestamp has changed
                        $msg = $this.NewEntryString($Level, $Message)
                    }

                    # Write the message to the log
                    $streamWriter.Write($msg)
                    $streamWriter.Flush()

                    # Echo the message to the console if EchoMessages is true
                    if ($this.EchoMessages) {
                        $this.Echo($msg, $level)
                    }
                }
                catch {
                    # If there was an error writing to the log, write the error to the console
                    Write-Error "Error writing to log:`n$_"
                }
                finally {
                    # Close the log if it's open
                    if ($streamWriter) {$streamWriter.Close()}
                    if ($fileStream) {$fileStream.Close()}
                }
            }
            catch {
                # If there was an error writing to the log, write the error to the console
                Write-Host "Error writing to log:`n$_"
            }
        }
        
        hidden [void] Write([LogLevel] $Level = 'Info', [string[]] $Messages) {
            # Open the log file with a StreamWriter
            $fileStream = [System.IO.File]::Open($this.LogFile, [System.IO.FileMode]::Append, [System.IO.FileAccess]::Write, [System.IO.FileShare]::ReadWrite)
            $streamWriter = New-Object System.IO.StreamWriter $fileStream, [defaults]::encoding
            try {

                # Loop through each message and write it to the log without closing in between (unless the log rolls over)
                foreach ($message in $Messages) {
                    # Build the log message
                    $msg = $this.NewEntryString($Level, $message)
                    # see if the message will make the log exceed the LogMaxBytes property
                    if (([defaults]::encoding.GetByteCount($msg) + $streamWriter.BaseStream.Length) -ge $this.LogMaxBytes) {
                        # if it will, close the log...
                        $streamWriter.Close()
                        $fileStream.Close()
                        # ...and roll it over
                        $this.RollOver()
                        # then open the log again
                        $fileStream = [System.IO.File]::Open($this.LogFile, [System.IO.FileMode]::Append, [System.IO.FileAccess]::Write, [System.IO.FileShare]::ReadWrite)
                        $streamWriter = New-Object System.IO.StreamWriter $fileStream, [defaults]::encoding
                        # get the current logging context
                        $this.Context = [LogContext]::new()
                        # write the context to the log
                        $streamWriter.Write($this.NewEntryString('Info',"`n$([Draw]::BoxTop(' LOG_CONTEXT ', 'Double','Left'))`n$($this.Context.ToString())`n$([Draw]::BoxBottom(' LOG_CONTEXT ', 'Double','Right'))"))
                        $streamWriter.Flush()
                        # generate the log entry again, as the the original timestamp has changed
                        $msg = $this.NewEntryString($Level, $Message)
                    }

                    # Write the message to the log
                    $streamWriter.Write($msg)

                    # Echo the message to the console if EchoMessages is true
                    if ($this.EchoMessages) {
                        $this.Echo($msg, $level)
                    }
                }
            }
            catch {
                # If there was an error writing to the log, write the error to the console
                Write-Error "Error writing to log:`n$_"
            }
            finally {
                # Close the log if it's open
                if ($streamWriter) {$streamWriter.Close()}
                if ($fileStream) {$fileStream.Close()}
            }
        }
    }

    #OS Class
    #------------------------------------------------------------------------------------------------------------------
    class OS {
        # This class is used to get information about the current operating system
        [string]$Name
        [string]$Version
        [string]$Architecture
        [string]$SystemDirectory
        [string]$WindowsDirectory
        [string]$LastBootUpTime
        [string]$OSLanguage
        [string]$CurrentCulture
        [string]$CurrentUICulture

        #Constructors
        #------------------------------------------------------------------------------------------------------------------
        OS([string]$name, [string]$version, [string]$architecture, [string]$systemDirectory, [string]$windowsDirectory, [string]$lastBootUpTime, [string]$osLanguage, [string]$currentCulture, [string]$currentUICulture) {
            $this.Name = $name
            $this.Version = $version
            $this.Architecture = $architecture
            $this.SystemDirectory = $systemDirectory
            $this.WindowsDirectory = $windowsDirectory
            $this.LastBootUpTime = $lastBootUpTime
            $this.OSLanguage = $osLanguage
            $this.CurrentCulture = $currentCulture
            $this.CurrentUICulture = $currentUICulture
        }
        
        #overload to get the current OS
        OS() {
            $os = Get-CimInstance Win32_OperatingSystem -Verbose:$false | Select-Object -Property Caption, Version, OSArchitecture, SystemDirectory, WindowsDirectory, LastBootUpTime, OSLanguage 
            $this.Name = $os.Caption
            $this.Version = $os.Version
            $this.Architecture = $os.OSArchitecture
            $this.SystemDirectory = $os.SystemDirectory
            $this.WindowsDirectory = $os.WindowsDirectory
            $this.LastBootUpTime = $os.LastBootUpTime
            $this.OSLanguage = $os.OSLanguage
            $this.CurrentCulture = [System.Globalization.CultureInfo]::CurrentCulture.Name
            $this.CurrentUICulture = [System.Globalization.CultureInfo]::CurrentUICulture.Name
        }

        #ToString
        [string] ToString() {
            return $this.ToString($false)
        }

        [string] ToString([bool]$sorted = $false) {
            return ([ordered]@{
                OS_NAME = $this.Name
                OS_VERSION = $this.Version
                OS_ARCHITECTURE = $this.Architecture
                OS_SYSTEM_DIRECTORY = $this.SystemDirectory
                OS_WINDOWS_DIRECTORY = $this.WindowsDirectory
                OS_LAST_BOOT_UP_TIME = $this.LastBootUpTime
                OS_LANGUAGE = $this.OSLanguage
                OS_CURRENT_CULTURE = $this.CurrentCulture
                OS_CURRENT_UI_CULTURE = $this.CurrentUICulture
            }).ToString()
        }
    }

    #PowerShell class
    #------------------------------------------------------------------------------------------------------------------
    class PowerShell {
        # This class is used to get information about the current PowerShell session
        [string]$Version
        [string]$Edition
        [string]$ScriptPath
        [string]$ScriptDirectory

        hidden $PSVersionTable = $PSVersionTable
        hidden $PSScriptRoot = $PSScriptRoot
        hidden $PSCommandPath = $PSCommandPath

        #Constructors
        #------------------------------------------------------------------------------------------------------------------
        PowerShell([string]$version, [string]$edition) {
            $this.Version = $version
            $this.Edition = $edition
        }

        #overload to get the current PowerShell session
        PowerShell() {
            $this.Version = $this.PSVersionTable.PSVersion
            $this.Edition = $this.PSVersionTable.PSEdition
            $this.ScriptPath = $this.PSCommandPath
            $this.ScriptDirectory = $this.PSScriptRoot
        }

        #ToString
        [string] ToString() {
            return ([ordered]@{
                POWERSHELL_VERSION = $this.Version
                POWERSHELL_EDITION = $this.Edition
                POWERSHELL_SCRIPT_PATH = $this.ScriptPath
                POWERSHELL_SCRIPT_DIRECTORY = $this.ScriptDirectory
            }).ToString()
        }
    }

    #Process class
    #------------------------------------------------------------------------------------------------------------------
    class Process {
        # This class is used to get information about the current process
        [string]$Name
        [int]$Id
        [int]$SessionId
        [string]$SessionName

        #Constructors
        #------------------------------------------------------------------------------------------------------------------
        Process([string]$name, [int]$id, [int]$sessionId, [string]$sessionName) {
            $this.Name = $name
            $this.Id = $id
            $this.SessionId = $sessionId
            $this.SessionName = $sessionName
        }

        #overload to get the current process
        Process() {
            $process = [System.Diagnostics.Process]::GetCurrentProcess()
            $this.Name = $process.ProcessName
            $this.Id = $process.Id
            $this.SessionId = $process.SessionId
            $this.SessionName = $env:SESSIONNAME
        }

        #ToString
        [string] ToString() {
            return ([ordered]@{
                PROCESS_NAME = $this.Name
                PROCESS_ID = $this.Id
                PROCESS_SESSION_ID = $this.SessionId
                PROCESS_SESSION_NAME = $this.SessionName
            }).ToString()
        }
    }

    #User class
    #------------------------------------------------------------------------------------------------------------------
    class User {
        [string]$Name
        [string]$Identifier

        #Constructors
        #------------------------------------------------------------------------------------------------------------------
        User() {
            $currUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
            $this.Name = $currUser.Name
            $this.Identifier = $currUser.User.Value
        }

        User([string]$userName, [string]$identifier) {
            $this.Name = $userName
            $this.Identifier = $identifier
        }

        #Methods
        #------------------------------------------------------------------------------------------------------------------
        [string] ToString() {
            return ([ordered]@{
                USER_NAME = $this.Name
                USER_IDENTIFIER = $this.Identifier
            }).ToString()
        }
    }    
    
    #endregion
#╚════════════════════════════════════════════════════════════════════════════════════════════════════════════ CLASSES ═╝

#╔═ EXTEND String ══════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.String class with additional common properties and methods

    #AddIndent
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName AddIndent -Force -Value {
        param([int] $indent = 4)
        $this -replace '(?m)^', (' ' * $indent)
    }
    

    #BlockComment
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName BlockComment -Force -Value {
        param([string] $blockOpen = '/*', [string] $blockClose = '*/')
        "$blockOpen`n$this`n$blockClose"
    }
    

    #Comment
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName Comment -Force -Value {
        param([string] $commentChar = '#')
        $this -replace '(?m)^', $commentChar
    }
    

    #FromBase64
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName FromBase64 -Force -Value {
        [Defaults]::Encoding.GetString([Convert]::FromBase64String($this ?? ''))
    }
    

    #FromHex
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName FromHex -Force -Value {
        $bytes = New-Object Byte[] ($this.Length / 2); for ($i = 0; $i -lt $bytes.Length; $i++) {$bytes[$i] = [Convert]::ToByte($this.Substring($i * 2, 2), 16)};$bytes
    }
    

    #FromJson
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName FromJson -Force -Value {
        $this | ConvertFrom-Json
    }
    

    #IsHex
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName IsHex -Force -Value {
        ($this.Length % 2 -eq 0) -and ($this -match '^[0-9A-Fa-f]+$')
    }
    

    #ToBase64
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToBase64 -Force -Value {
        [Convert]::ToBase64String([Defaults]::Encoding.GetBytes($this ?? ''))
    }    

    #ToByteArray
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToByteArray -Force -Value {
        [Defaults]::Encoding.GetBytes($this ?? '')
    }
    

    #ToEscapedString
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToEscapedString -Force -Value {
        if ([string]::IsNullOrWhiteSpace($this)) {return $this}
        $InputString = $this -replace "`t", '`t' -replace "`r", '`r' -replace "`n", '`n'
        $escapedString = [Text.StringBuilder]::new()
        foreach ($char in $InputString.ToCharArray()) {
            $unicodeCategory = [Char]::GetUnicodeCategory($char)
            switch ($unicodeCategory) {
               {$_ -in 'Control', 'Surrogate', 'OtherNotAssigned', 'LineSeparator', 'ParagraphSeparator', 'Format'} {
                    $charCode = [int]$char
                    [void]$escapedString.Append('`u{'+ $charCode.ToString("X4")+ '}')
                }
                default {
                    [void]$escapedString.Append($char)
                }
            }
        }
        $escapedString.ToString()
    }
    

    #ToHex
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToHex -Force -Value {
        [System.BitConverter]::ToString([Defaults]::Encoding.GetBytes($this ?? '')).Replace('-','')
    }
    

    #ToJson
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToJson -Force -Value {
        $this | ConvertTo-Json
    }
    

    #ToSecureString
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToSecureString -Force -Value {
        $secureString = New-Object System.Security.SecureString
        for ($i=0; $i -lt $this.Length; $i++) {$secureString.AppendChar($this[$i])}
        $secureString
    }
    

    #GetClipboard
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName GetClipboard -Force -Value {
        Get-Clipboard
    }
    

    #IsNullOrEmpty
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName IsNullOrEmpty -Force -Value {
        [string]::IsNullOrEmpty($this)
    }
    

    #IsNullOrWhiteSpace
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName IsNullOrWhiteSpace -Force -Value {
        [string]::IsNullOrWhiteSpace($this)
    }
    

    #Obfuscate
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName Obfuscate -Force -Value {
        [Encryption]::Obfuscate($this)
    }
    

    #MD5
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName MD5 -Force -Value {
        $md5 = [System.Security.Cryptography.MD5]::Create()
        try {$hash = [System.BitConverter]::ToString($md5.ComputeHash([Defaults]::Encoding.GetBytes($this ?? ''))).Replace('-','')}
        catch {$hash = 'D41D8CD98F00B204E9800998ECF8427E'}
        finally {$md5.Dispose()}
        $hash
    }


    #NewGuid
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName NewGuid -Force -Value {
        [guid]::NewGuid().ToString()
    }
    

    #RemoveComment
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName RemoveComment -Force -Value {
        param([string] $commentChar = '#')
        $this -replace "(?m)^$commentChar"
    }
    

    #RemoveBlockComment
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName RemoveBlockComment -Force -Value {
        param([string] $blockOpen = '/*', [string] $blockClose = '*/')
            $escapedBlockOpen = [regex]::Escape($blockOpen)
            $escapedBlockClose = [regex]::Escape($blockClose)
            $pattern = "(?s)$escapedBlockOpen.*?$escapedBlockClose"
            $this -replace $pattern, ''
    }
    

    #RemoveIndent
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName RemoveIndent -Force -Value {
        param([int] $indent = 4)
        $this -replace "(?m)^ {0,$indent}"
    }
    

    #Reverse
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName Reverse -Force -Value {
        $chars = $this.ToCharArray()
        [array]::Reverse($chars)
        -join $chars
    }
    

    #ROT13
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ROT13 -Force -Value {
        [Encryption]::ROT13($this)
    }
    

    #SetClipboard
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName SetClipboard -Force -Value {
        param([bool] $passthru = $false)
        $this | Set-Clipboard -PassThru:$passthru
    }
    

    #SHA1
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName SHA1 -Force -Value {
        $sha1 = [System.Security.Cryptography.SHA1]::Create()
        try {$hash = [System.BitConverter]::ToString($sha1.ComputeHash([Defaults]::Encoding.GetBytes($this ?? ''))).Replace('-','')}
        catch {$hash = 'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709'}
        finally {$sha1.Dispose()}
        $hash
    }
    

    #SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName SHA256 -Force -Value {
        $sha256 = [System.Security.Cryptography.SHA256]::Create()
        try {$hash = [System.BitConverter]::ToString($sha256.ComputeHash([Defaults]::Encoding.GetBytes($this ?? ''))).Replace('-','')}
        catch {$hash = 'E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855'}
        finally {$sha256.Dispose()}
        $hash
    }
    

    #SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName SHA384 -Force -Value {
        $sha384 = [System.Security.Cryptography.SHA384]::Create()
        try {$hash = [System.BitConverter]::ToString($sha384.ComputeHash([Defaults]::Encoding.GetBytes($this ?? ''))).Replace('-','')}
        catch {$hash = '38B060A751AC96384CD9327EB1B1E36A21FDB71114BE07434C0CC7BF63F6E1DA274EDEBFE76F65FBD51AD2F14898B95B'}
        finally {$sha384.Dispose()}
        $hash
    }
    

    #SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName SHA512 -Force -Value {
        $sha512 = [System.Security.Cryptography.SHA512]::Create()
        try {$hash = [System.BitConverter]::ToString($sha512.ComputeHash([Defaults]::Encoding.GetBytes($this ?? ''))).Replace('-','')}
        catch {$hash = 'CF83E1357EEFB8BDF1542850D66D8007D620E4050B5715DC83F4A921D36CE9CE47D0D13C5D85F2B0FF8318D2877EEC2F63B931BD47417A81A538327AF927DA3E'}
        finally {$sha512.Dispose()}
        $hash
    }
    

    #Deobfuscate
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName Deobfuscate -Force -Value {
        [Encryption]::Deobfuscate($this)
    }

    #endregion    
#╚══════════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND String ═╝

#╔═ EXTEND BYTE[] ══════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.Byte[] class with additional common properties and methods

    #ToBase64
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptMethod -MemberName ToBase64 -Force -Value {
        [Convert]::ToBase64String($this)
    }
    

    #ToHex
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptMethod -MemberName ToHex -Force -Value {
        [System.BitConverter]::ToString($this).Replace('-','')
    }
    

    #MD5
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName MD5 -Force -Value {
        $md5 = [System.Security.Cryptography.MD5]::Create()
        try {$hash = [System.BitConverter]::ToString($md5.ComputeHash($this)).Replace('-','')}
        catch {$hash = 'D41D8CD98F00B204E9800998ECF8427E'}
        finally {$md5.Dispose()}
        $hash
    }

    #MD5B64
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName MD5B64 -Force -Value {
        $md5 = [System.Security.Cryptography.MD5]::Create()
        try {$hash = [Convert]::ToBase64String($md5.ComputeHash($this))}
        catch {$hash = '0A'}
        finally {$md5.Dispose()}
        $hash
    }
    

    #SHA1
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName SHA1 -Force -Value {
        $sha1 = [System.Security.Cryptography.SHA1]::Create()
        try {$hash = [System.BitConverter]::ToString($sha1.ComputeHash($this)).Replace('-','')}
        catch {$hash = 'DA39A3EE5E6B4B0D3255BFEF95601890AFD80709'}
        finally {$sha1.Dispose()}
        $hash
    }
    

    #SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName SHA256 -Force -Value {
        $sha256 = [System.Security.Cryptography.SHA256]::Create()
        try {$hash = [System.BitConverter]::ToString($sha256.ComputeHash($this)).Replace('-','')}
        catch {$hash = 'E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855'}
        finally {$sha256.Dispose()}
        $hash
    }
    

    #SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName SHA384 -Force -Value {
        $sha384 = [System.Security.Cryptography.SHA384]::Create()
        try {$hash = [System.BitConverter]::ToString($sha384.ComputeHash($this)).Replace('-','')}
        catch {$hash = '38B060A751AC96384CD9327EB1B1E36A21FDB71114BE07434C0CC7BF63F6E1DA274EDEBFE76F65FBD51AD2F14898B95B'}
        finally {$sha384.Dispose()}
        $hash
    }
    

    #SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName SHA512 -Force -Value {
        $sha512 = [System.Security.Cryptography.SHA512]::Create()
        try {$hash = [System.BitConverter]::ToString($sha512.ComputeHash($this)).Replace('-','')}
        catch {$hash = 'CF83E1357EEFB8BDF1542850D66D8007D620E4050B5715DC83F4A921D36CE9CE47D0D13C5D85F2B0FF8318D2877EEC2F63B931BD47417A81A538327AF927DA3E'}
        finally {$sha512.Dispose()}
        $hash
    }

    #endregion    
#╚══════════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND BYTE[] ═╝

#╔═ EXTEND Hashtable ═══════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.Collections.Hashtable class with additional common properties and methods

    # MD5
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptProperty -MemberName MD5 -Force -Value {
        $this.ToString().MD5
    }

    # SHA1
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptProperty -MemberName SHA1 -Force -Value {
        $this.ToString().SHA1
    }

    # SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptProperty -MemberName SHA256 -Force -Value {
        $this.ToString().SHA256
    }

    # SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptProperty -MemberName SHA384 -Force -Value {
        $this.ToString().SHA384
    }

    # SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptProperty -MemberName SHA512 -Force -Value {
        $this.ToString().SHA512
    }
    
    # ToJson
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptMethod -MemberName ToJson -Force -Value {
        ConvertTo-Json -InputObject $this -EnumsAsStrings -EscapeHandling EscapeNonAscii
    }

    # ToSortedString
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptMethod -MemberName ToSortedString -Force -Value {
        ($this.GetEnumerator() | Sort-Object -Property Key | ForEach-Object {"$($_.Key)`: $($_.Value)"}) -join "`n"
    }

    # ToString
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptMethod -MemberName ToString -Force -Value {
        ($this.GetEnumerator() | ForEach-Object {"$($_.Key)`: $($_.Value)"}) -join "`n"
    }

    # ToXml
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptMethod -MemberName ToXml -Force -Value {
        $xml = [xml]::new()
        $root = $xml.CreateElement('root')
        [void]$xml.AppendChild($root)
        $this.GetEnumerator() | ForEach-Object {
            $node = $xml.CreateElement($_.Key)
            $node.InnerText = if($_.Value -is [System.Array]) { $_.Value -join ',' } else { $_.Value }
            [void]$root.AppendChild($node)
        } | Out-Null
        $xml.OuterXml
    }    

    #endregion
#╚═══════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND Hashtable ═╝

#╔═ EXTEND OrderedDictionary ═══════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.Collections.Specialized.OrderedDictionary class with additional common properties and methods

    # MD5
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptProperty -MemberName MD5 -Force -Value {
        $this.ToString().MD5
    }

    # SHA1
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptProperty -MemberName SHA1 -Force -Value {
        $this.ToString().SHA1
    }

    # SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptProperty -MemberName SHA256 -Force -Value {
        $this.ToString().SHA256
    }

    # SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptProperty -MemberName SHA384 -Force -Value {
        $this.ToString().SHA384
    }

    # SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptProperty -MemberName SHA512 -Force -Value {
        $this.ToString().SHA512
    }
    
    # ToJson
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptMethod -MemberName ToJson -Force -Value {
        ConvertTo-Json -InputObject $this -EnumsAsStrings -EscapeHandling EscapeNonAscii
    }

    # ToSortedString
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptMethod -MemberName ToSortedString -Force -Value {
        ($this.GetEnumerator() | Sort-Object -Property Key | ForEach-Object {"$($_.Key)`: $($_.Value)"}) -join "`n"
    }

    # ToString
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptMethod -MemberName ToString -Force -Value {
        ($this.GetEnumerator() | ForEach-Object {"$($_.Key)`: $($_.Value)"}) -join "`n"
    }

    # ToXml
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptMethod -MemberName ToXml -Force -Value {
        $xml = [xml]::new()
        $root = $xml.CreateElement('root')
        [void]$xml.AppendChild($root)
        $this.GetEnumerator() | ForEach-Object {
            $node = $xml.CreateElement($_.Key)
            $node.InnerText = if($_.Value -is [System.Array]) { $_.Value -join ',' } else { $_.Value }
            [void]$root.AppendChild($node)
        } | Out-Null
        $xml.OuterXml
    }
        
    #endregion
#╚═══════════════════════════════════════════════════════════════════════════════════════════ EXTEND OrderedDictionary ═╝

#╔═ EXTEND SecureString ════════════════════════════════════════════════════════════════════════════════════════════════╗    
    #region
    # This section extends the System.Security.SecureString class with additional common properties and methods

    #MD5
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName MD5 -Force -Value {
        [Encryption]::Hash($this, 'MD5')
    }

    #SHA1
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName SHA1 -Force -Value {
        [Encryption]::Hash($this, 'SHA1')
    }
    

    #SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName SHA256 -Force -Value {
        [Encryption]::Hash($this, 'SHA256')
    }
    

    #SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName SHA384 -Force -Value {
        [Encryption]::Hash($this, 'SHA384')
    }
    

    #SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName SHA512 -Force -Value {
        [Encryption]::Hash($this, 'SHA512')
    }

    #endregion    
#╚════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND SecureString ═╝

#╔═ EXTEND PSCredential ════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region
    # This section extends the System.Management.Automation.PSCredential class with additional common properties and methods


    #endregion    
#╚════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND PSCredential ═╝

#╔═ Script ═════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region
        $log = [Log]::new('CsLog')
        $log.EchoMessages = $false
        1..10 | ForEach-Object {$log.Write('Debug',"This is a test message $_")}
        1..10 | ForEach-Object {$log.Write('Info',"This is a test message $_")}
        1..10 | ForEach-Object {$log.Write('Warn',"This is a test message $_")}
        1..10 | ForEach-Object {$log.Write('Error',"This is a test message $_")}
        1..10 | ForEach-Object {$log.Write('Fatal',"This is a test message $_")}
    #endregion
#╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════ Script ═╝


