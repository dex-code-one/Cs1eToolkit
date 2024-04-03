
#╔═ CLASSES ════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    #BinaryOutputType enum
    #------------------------------------------------------------------------------------------------------------------
    enum BinaryOutputType {
        # This enum is used to specify the output format for binary data (hashes, etc.)
        None
        Hex
        Base64
        Base85
        Base85Alternate
    }

    #HashAlgorithm enum
    #------------------------------------------------------------------------------------------------------------------
    enum HashAlgorithm {
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

    #Base85 class
    #------------------------------------------------------------------------------------------------------------------
    class Base85 {

        # these are the default characters for base85 encoding using RFC1924
        hidden static [char[]]$EncodingCharacters = [char[]]('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#$%&()*+-;<=>?@^_`{|}~')
        # these are alternate characters for base85 encoding featuring letters, numbers and european diacritics without special characters or punctuation
        hidden static [char[]]$AlternateEncodingCharacters = [char[]]('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØ')
        # Methods
        # ------------------------------------------------------------------------------------------------------------------

        # Encode
        static [string] Encode ([string]$ValueToEncode) {
            return [Base85]::Encode([System.Text.Encoding]::UTF8.GetBytes($ValueToEncode), [Base85]::EncodingCharacters)
        }

        static [string] Encode ([string]$ValueToEncode, [bool]$UseAlternateCharacters) {
            $currChars = if ($UseAlternateCharacters) { [Base85]::AlternateEncodingCharacters } else { [Base85]::EncodingCharacters }
            return [Base85]::Encode([System.Text.Encoding]::UTF8.GetBytes($ValueToEncode), [char[]]$currChars)
        }

        static [string] Encode ([byte[]]$BytesToEncode) {
            return [Base85]::Encode($BytesToEncode, [Base85]::EncodingCharacters)
        }

        static [string] Encode ([byte[]]$BytesToEncode, [bool]$UseAlternateCharacters) {
            $currChars = if ($UseAlternateCharacters) { [Base85]::AlternateEncodingCharacters } else { [Base85]::EncodingCharacters }
            return [Base85]::Encode($BytesToEncode, [char[]]$currChars)
        }

        static [string] Encode([byte[]]$BytesToEncode, [char[]]$EncodingCharacters) {
            if ($EncodingCharacters.Length -ne 85) { throw [System.ArgumentException]::new('EncodingCharacters is not 85 characters') }
            $output = New-Object System.Text.StringBuilder
            for ($i = 0; $i -lt $BytesToEncode.Length; $i += 4) {
                $val = 0
                for ($j = 0; $j -lt 4; $j++) {
                    $val = $val * 256
                    if ($i + $j -lt $BytesToEncode.Length) {
                        $val += $BytesToEncode[$i + $j]
                    }
                }
                $chunk = New-Object char[] 5
                for ($k = 4; $k -ge 0; $k--) {
                    $chunk[$k] = $EncodingCharacters[$val % 85]
                    $val = [math]::Floor($val / 85)
                }
                $actualChunkSize = [math]::Min(5, $BytesToEncode.Length - $i + 1)
                $output.Append($chunk, 0, $actualChunkSize)
            }
            return $output.ToString()
        }
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
        # $encoding = [System.Text.Encoding]::UTF8
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
        static [HashAlgorithm] $HashAlgorithm = 'MD5'
        static [BinaryOutputType] $BinaryOutputType = 'Base64'
        static [int] $EncryptionKeySize = 256
        static [int] $EncryptionIVSize = 128
        static [int] $EncryptionIterations = 100000
        static [int] $ObfuscationKeySize = 128
        static [int] $ObfuscationIVSize = 128
        static [int] $ObfuscationIterations = 10
        static [byte[]] $ObfuscationString = [System.Text.Encoding]::UTF8.GetBytes('HppjmX3CBynZzbLIE8kLC/NRJ8Z5zLLF') # for obfuscating data
        static [System.IO.FileInfo]$LogDirectory = [System.IO.Path]::Combine($env:TEMP, '1E\Logs')
        static [System.IO.FileInfo]$LogFallbackDirectory = $env:TEMP
        static [string]$LogPrefix = '1e.CustomerSuccess.'
        static [string]$LogNamePattern = 'yyyyMMdd_HHmmss_fffffff'
        static [string]$LogExtension = '.log'
        static [int]$LogTailLines = 40
        static [HashAlgorithm]$LogContextIDAlgorithm = 'MD5'
        static [BinaryOutputType]$LogContextIDFormat = 'Base85Alternate'
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
            return $null -ne $encodingMap[([System.Text.Encoding]::UTF8.WebName)] ? $encodingMap[([System.Text.Encoding]::UTF8.WebName)] : 'UTF8'
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
                $rdb = New-Object System.Security.Cryptography.Rfc2898DeriveBytes $bytes, ([System.Text.Encoding]::UTF8.GetBytes([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureSalt)))), ([Defaults]::EncryptionIterations)
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
            $rdb = New-Object System.Security.Cryptography.Rfc2898DeriveBytes ([System.Text.Encoding]::UTF8.GetBytes($String)), ([System.Text.Encoding]::UTF8.GetBytes($Salt)), ([Defaults]::EncryptionIterations)
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

    #Hash class
    #------------------------------------------------------------------------------------------------------------------
    class Hash {
        [byte[]]$OriginalBytes
        [byte[]]$HashedBytes
        [HashAlgorithm]$Algorithm
        [BinaryOutputType]$BinaryOutputType = [Defaults]::BinaryOutputType

        #Constructors
        #------------------------------------------------------------------------------------------------------------------
        Hash([string]$data) {
            $this.OriginalBytes = [System.Text.Encoding]::UTF8.GetBytes($data)
            $this.Algorithm = [Defaults]::HashAlgorithm
            $this.HashedBytes = [Hash]::GetHash($this.OriginalBytes, $this.Algorithm)
        }

        Hash([string]$data, [HashAlgorithm]$algorithm) {
            $this.OriginalBytes = [System.Text.Encoding]::UTF8.GetBytes($data)
            $this.Algorithm = $algorithm
            $this.HashedBytes = [Hash]::GetHash($this.OriginalBytes, $this.Algorithm)
        }

        Hash([string]$data, [HashAlgorithm]$algorithm, [BinaryOutputType]$binaryOutputType) {
            $this.OriginalBytes = [System.Text.Encoding]::UTF8.GetBytes($data)
            $this.Algorithm = $algorithm
            $this.HashedBytes = [Hash]::GetHash($this.OriginalBytes, $this.Algorithm)
            $this.BinaryOutputType = $binaryOutputType
        }

        Hash([securestring]$secureString) {
            $this.OriginalBytes = $null
            $this.Algorithm = [Defaults]::HashAlgorithm
            $this.HashedBytes = [Hash]::GetHash($secureString, $this.Algorithm)
        }

        Hash([securestring]$secureString, [HashAlgorithm]$algorithm) {
            $this.OriginalBytes = $null
            $this.Algorithm = $algorithm
            $this.HashedBytes = [Hash]::GetHash($secureString, $this.Algorithm)
        }

        Hash([securestring]$secureString, [HashAlgorithm]$algorithm, [BinaryOutputType]$binaryOutputType) {
            $this.OriginalBytes = $null
            $this.Algorithm = $algorithm
            $this.HashedBytes = [Hash]::GetHash($secureString, $this.Algorithm)
            $this.BinaryOutputType = $binaryOutputType
        }

        Hash([byte[]]$bytes) {
            $this.OriginalBytes = $bytes
            $this.Algorithm = [Defaults]::HashAlgorithm
            $this.HashedBytes = [Hash]::GetHash($this.OriginalBytes, $this.Algorithm)
        }

        Hash([byte[]]$bytes, [HashAlgorithm]$algorithm) {
            $this.OriginalBytes = $bytes
            $this.Algorithm = $algorithm
            $this.HashedBytes = [Hash]::GetHash($this.OriginalBytes, $this.Algorithm)
        }

        Hash([byte[]]$bytes, [HashAlgorithm]$algorithm, [byte[]]$hashedBytes) {
            $this.OriginalBytes = $bytes
            $this.Algorithm = $algorithm
            $this.HashedBytes = $hashedBytes
        }

        Hash([byte[]]$bytes, [HashAlgorithm]$algorithm, [BinaryOutputType]$binaryOutputType) {
            $this.OriginalBytes = $bytes
            $this.Algorithm = $algorithm
            $this.HashedBytes = [Hash]::GetHash($this.OriginalBytes, $this.Algorithm)
            $this.BinaryOutputType = $binaryOutputType
        }

        # GetHash
        #------------------------------------------------------------------------------------------------------------------
        static [byte[]] GetHash([byte[]]$BytesToHash, [HashAlgorithm] $algorithm) {
            $hash = [System.Security.Cryptography.HashAlgorithm]::Create($algorithm)
            $hashValue = $null
            try {$hashValue = $hash.ComputeHash($BytesToHash)}
            finally {$hash.Dispose()}
            return $hashValue
        }

        # Overload for GetHash using string
        static [byte[]] GetHash([string]$StringToHash, [HashAlgorithm] $algorithm) {
            return [Hash]::GetHash([System.Text.Encoding]::UTF8.GetBytes($StringToHash), $algorithm)
        }

        # Overload for GetHash using secure string
        static [byte[]] GetHash([securestring]$SecureString, [HashAlgorithm] $algorithm) {
            $hash = [System.Security.Cryptography.HashAlgorithm]::Create($algorithm)
            $hashValue = $null
            try {
                $pointer = [System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($SecureString)
                $length = $SecureString.Length * 2
                $bytes = New-Object byte[] -ArgumentList $length
                try {
                    [System.Runtime.InteropServices.Marshal]::Copy($pointer, $bytes, 0, $length)
                    $hashValue = $hash.ComputeHash($bytes)
                } finally {
                    # Zero out the bytes array to securely clean up the data
                    if ($null -ne $bytes) {for ($i = 0; $i -lt $bytes.Length; $i++) { $bytes[$i] = 0 }}
                    [System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($pointer)
                }
                return $hashValue
            }
            finally {
                $hash.Dispose()
            }
        }

        # ToBase64String
        #------------------------------------------------------------------------------------------------------------------
        [string] ToBase64String() {
            return [Convert]::ToBase64String($this.HashedBytes)
        }

        # ToHexString
        #------------------------------------------------------------------------------------------------------------------
        [string] ToHexString() {
            return [BitConverter]::ToString($this.HashedBytes).Replace('-','')
        }

        # ToBase85String
        #------------------------------------------------------------------------------------------------------------------
        [string] ToBase85String() {
            return [Base85]::Encode($this.HashedBytes)
        }

        # Overload for ToBase85String using alternate character set
        [string] ToBase85String([bool]$UseAlternateCharacters) {
            return [Base85]::Encode($this.HashedBytes, $UseAlternateCharacters)
        }

        # ToString
        #------------------------------------------------------------------------------------------------------------------
        [string] ToString() {
            switch ($this.BinaryOutputType) {
                'Base64' {return $this.ToBase64String()}
                'Hex' {return $this.ToHexString()}
                'Base85' {return $this.ToBase85String()}
                'Base85Alternate' {return $this.ToBase85String($true)}
                'None' {return [System.Text.Encoding]::UTF8.GetString($this.HashedBytes)}
            }
            return $null
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
            $this.ID = ([Hash]::new($this.ToString(), 'MD5', 'Base85Alternate').ToString())
        }

        #Methods
        #------------------------------------------------------------------------------------------------------------------
        [string] ToString() {
            return $this.Device.ToString()+"`n"+$this.OS.ToString()+"`n"+$this.PowerShell.ToString()+"`n"+$this.Process.ToString()+"`n"+$this.User.ToString()
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
        [BinaryOutputType]$ContextIDFormat = [Defaults]::LogContextIDFormat
        [hashtable]$EchoColors = @{'Debug' = 'DarkGray';'Info' = 'Green';'Warn' = 'Yellow';'Error' = 'Red';'Fatal' = 'Magenta'}
        [LogContext]$Context

        # Private Properties
        #==================================================================================================================
        hidden [string]$encodingName = [System.Text.Encoding]::UTF8.WebName
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
                    Set-Content -Path $this.LogFile.FullName -Force -ErrorAction Stop -Encoding ([System.Text.Encoding]::UTF8) -Value ''
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
        [ordered] GetDateRangeOfLog() {
            # If the properties haven't been cleared, and the log exists
            if ($this.LogFile.FullName -and (Test-Path -Path $this.LogFile.FullName)) {
                # Get the date from the first record in the log
                $first = ((Get-Content -Path $this.LogFile.FullName -First 1) -split $this.FS)[0]

                # Get the date from the last record in the log
                $last = (((Get-Content -Path $this.LogFile.FullName -Raw) -split $this.RS | Where-Object {$_} | Select-Object -Last 1) -split $this.FS)[0]

                # Return the date range
                return [ordered]@{
                    First = [DateTimeOffset]::ParseExact($first, "yyyy-MM-dd HH:mm:ss.fffffff zzz", [System.Globalization.CultureInfo]::InvariantCulture)
                    Last = [DateTimeOffset]::ParseExact($last, "yyyy-MM-dd HH:mm:ss.fffffff zzz", [System.Globalization.CultureInfo]::InvariantCulture)
                    TimeSpan = [DateTimeOffset]::ParseExact($last, "yyyy-MM-dd HH:mm:ss.fffffff zzz", [System.Globalization.CultureInfo]::InvariantCulture) - [DateTimeOffset]::ParseExact($first, "yyyy-MM-dd HH:mm:ss.fffffff zzz", [System.Globalization.CultureInfo]::InvariantCulture)
                }
            }
            else {
                return [ordered]@{
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
        
        # ToString
        #------------------------------------------------------------------------------------------------------------------
        [string] ToString() {
            return ([ordered]@{
                LOG_NAME = $this.LogFile.Name
                LOG_SIZE = $this.Size()
                LOG_MAX_BYTES = $this.LogMaxBytes
                LOG_MAX_ROLLOVERS = $this.LogMaxRollovers
                LOG_TAIL_LINES = $this.TailLines
                LOG_ECHO_MESSAGES = $this.EchoMessages
                LOG_ENCODING = $this.encodingName
                LOG_ROLLOVER_LOGS = $this.RolloverLogs.Count
                LOG_INSTANTIATED_TIME = $this.InstantiatedTime.ToString("yyyy-MM-dd HH:mm:ss.fffffff zzz")
                LOG_FIELD_SEPARATOR = $this.FS.ToEscapedString()
                LOG_RECORD_SEPARATOR = $this.RS.ToEscapedString()
                LOG_CONTEXT_ID = $this.Context.ID
            }).ToString()
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
            #see if the message will make the log exceed the LogMaxBytes property
            $this.LogFile.Refresh() #refresh size info
            if (([system.text.encoding]::utf8.GetByteCount($msg) + $this.LogFile.Length) -ge $this.LogMaxBytes) {
                $this.RollOver() # if it will exceed the LogMaxBytes, rollover the log
                #get the current logging context
                $this.Context = [LogContext]::new()
                #write the context to the log
                $logDetails = "`n$([Draw]::BoxTop(' LOG_DETAILS ', 'Double','Left'))`n$($this.ToString())`n$([Draw]::BoxBottom(' LOG_DETAILS ', 'Double','Right'))"
                $contextDetails = "`n$([Draw]::BoxTop(' LOG_CONTEXT ', 'Double','Left'))`n$($this.Context.ToString())`n$([Draw]::BoxBottom(' LOG_CONTEXT ', 'Double','Right'))"
                $msg = $this.NewEntryString('Info',"$logDetails`n$contextDetails")
                Out-File -FilePath $this.LogFile.FullName -InputObject $msg -Append -Encoding $this.encodingName -ErrorAction Stop -Force -NoNewline
                #generate the log entry again, as the the original timestamp has changed
                $msg = $this.NewEntryString($Level, $Message)
            }
            # Write the message to the log
            Out-File -FilePath $this.LogFile.FullName -InputObject $msg -Append -Encoding $this.encodingName -ErrorAction Stop -Force -NoNewline

            # Echo the message to the console if EchoMessages is true
            if ($this.EchoMessages) {
                $this.Echo($msg, $level)
            }
        }

        # overload to write an array of messages
        [void] Write([LogLevel] $Level = 'Info', [string[]] $Messages) {
            foreach ($message in $Messages) {
                $this.Write($Level, $message)
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
        [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($this ?? ''))
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

    #Hash
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName Hash -Force -Value {
        param([string] $algorithm = ([Defaults]::HashAlgorithm), [BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
    }
    

    #IsHex
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName IsHex -Force -Value {
        ($this.Length % 2 -eq 0) -and ($this -match '^[0-9A-Fa-f]+$')
    }
    

    #ToBase64
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToBase64 -Force -Value {
        [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($this ?? ''))
    }    

    #ToByteArray
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToByteArray -Force -Value {
        [System.Text.Encoding]::UTF8.GetBytes($this ?? '')
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
        [System.BitConverter]::ToString([System.Text.Encoding]::UTF8.GetBytes($this ?? '')).Replace('-','')
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
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'MD5', $format)
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
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA1', $format)
    }
    

    #SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName SHA256 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA256', $format)
    }
    

    #SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName SHA384 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA384', $format)
    }
    

    #SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptProperty -MemberName SHA512 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA512', $format)
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
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'MD5', $format)
    }
    

    #SHA1
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName SHA1 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA1', $format)
    }
    

    #SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName SHA256 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA256', $format)
    }
    

    #SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName SHA384 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA384', $format)
    }
    

    #SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptProperty -MemberName SHA512 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA512', $format)
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
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'MD5', $format)
    }

    #SHA1
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName SHA1 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA1', $format)
    }
    

    #SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName SHA256 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA256', $format)
    }
    

    #SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName SHA384 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA384', $format)
    }
    

    #SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptProperty -MemberName SHA512 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA512', $format)
    }

    #endregion    
#╚════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND SecureString ═╝

#╔═ EXTEND PSCredential ════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region
    # This section extends the System.Management.Automation.PSCredential class with additional common properties and methods


    #endregion    
#╚════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND PSCredential ═╝
