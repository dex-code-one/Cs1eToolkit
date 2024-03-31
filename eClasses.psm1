
#╔═ CLASSES ════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region    

    #TextAlignment enum
    #------------------------------------------------------------------------------------------------------------------
    enum TextAlignment {
        # This enum is used to specify text alignment
        Left
        Center
        Right
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
        static [int] $ObfuscationIterations = 10
        static [byte[]] $ObfuscationString = [Defaults]::Encoding.GetBytes('HppjmX3CBynZzbLIE8kLC/NRJ8Z5zLLF') # for obfuscating (insecurely encrypting) data without having to provide a password
        static [System.IO.FileInfo]$DefaultLogDirectory = [System.IO.Path]::Combine($env:TEMP, '1E\CsLogs')
        static [hashtable]$EchoColors = @{
            'Debug' = 'DarkGray'
            'Info' = 'Green'
            'Warn' = 'Yellow'
            'Error' = 'Red'
            'Fatal' = 'Magenta'
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
        
        # Hash
        #------------------------------------------------------------------------------------------------------------------
        # Generates a hash of a secure string using the specified algorithm
        static [string] Hash ([securestring] $secureString, [string] $algorithm) {
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
                    $hashBytes = $hash.ComputeHash($bytes)
                    return -join ($hashBytes | ForEach-Object { $_.ToString("x2") })
                } finally {
                    $hash.Dispose()
                }
            } finally {
                # Zero out the bytes array to securely clean up the data
                if ($null -ne $bytes) {for ($i = 0; $i -lt $bytes.Length; $i++) { $bytes[$i] = 0 }}
                [System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($pointer)
            }
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


        # Obfuscate
        #------------------------------------------------------------------------------------------------------------------
        # Obfuscates a string
        static [string] Obfuscate ([string] $data) {
            return [Encryption]::ROT13($data.ToBase64().Reverse())
        }

        # Obfuscate a SecureString
        static [string] Obfuscate ([SecureString] $secureString) {
            $bytes = $null
            $ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToGlobalAllocUnicode($secureString)
            try {
                $bytes = New-Object byte[] ($secureString.Length * 2)
                [System.Runtime.InteropServices.Marshal]::Copy($ptr, $bytes, 0, $bytes.Length)
                try {
                    return [Encryption]::ROT13([Defaults]::Encoding.GetString($bytes).ToBase64().Reverse())
                }
                finally {
                    if ($null -ne $bytes) {for ($i = 0; $i -lt $bytes.Length; $i++) {$bytes[$i] = 0}}
                }
            }
            finally {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeGlobalAllocUnicode($ptr)
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

        # Deobfuscate
        #------------------------------------------------------------------------------------------------------------------
        # Deobfuscates a string
        static [string] Deobfuscate ([string] $data) {
            return [Encryption]::ROT13($data).Reverse().FromBase64()
        }
    }
    
    #LogContext class
    #------------------------------------------------------------------------------------------------------------------
    class LogContext {

    }
    

    #Log class
    #------------------------------------------------------------------------------------------------------------------
    class Log {
        #Properties
        #==================================================================================================================
        [System.IO.FileInfo]$LogFile
        [int32]$MaxLogSize = 10MB
        [int32]$MaxLogCount = 5
        [System.IO.FileInfo[]]$RolloverLogs
        [int32]$TailLines = 40
        [ordered]$LoggingContext
        [System.DateTimeOffset]$InstantiatedTime = [System.DateTimeOffset]::Now
        [bool]$EchoMessages = $false
        [string]$FS = [Defaults]::FieldSeparator
        [string]$RS = [Defaults]::RecordSeparator
        [hashtable]$EchoColors = @{'Debug' = 'DarkGray';'Info' = 'Green';'Warn' = 'Yellow';'Error' = 'Red';'Fatal' = 'Magenta'}
        

        #Private Properties
        #==================================================================================================================
        hidden [System.Management.Automation.Host.PSHost] $host = $Host
        hidden [System.Collections.Hashtable] $psVersionTable = $PSVersionTable
        hidden [string] $PSScriptRoot = $PSScriptRoot
        hidden [string] $PSCommandPath = $PSCommandPath
        hidden [object] $os
        hidden [string] $deviceIp
        hidden [string] $userSid
        hidden [int32] $sessionId
        hidden [int32] $processId
        hidden [string] $contextHash
        

        #Constructors
        #==================================================================================================================
        Log() {
            $this.Initialize()
        }
        
        [void] Initialize() {
                # Get the OS details
                try{$this.os = Get-CimInstance Win32_OperatingSystem -Verbose:$false | Select-Object -Property Caption, Version, OSArchitecture, SystemDirectory, WindowsDirectory} catch{$this.os = @{Caption='';Version='';OSArchitecture='';SystemDirectory='';WindowsDirectory=''}}

                # Get device IP
                try {$this.deviceIp = Get-NetIPAddress -AddressFamily IPv4 -Type Unicast | Where-Object {$_.InterfaceAlias -notlike '*Loopback*' -and $_.PrefixOrigin -ne 'WellKnown'} | Sort-Object -Property InterfaceMetric -Descending | Select-Object -First 1 -ExpandProperty IPAddress} catch {$this.deviceIp = ''}

                # Get user SID
                try {$this.userSid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value} catch {$this.userSid = ''}

                # Get session ID
                try {$this.sessionId = [System.Diagnostics.Process]::GetCurrentProcess().SessionId} catch {$this.sessionId = $null}

                # Get process ID
                try {$this.processId = [System.Diagnostics.Process]::GetCurrentProcess().Id} catch {$this.processId = $null}

                # Get the 
        }
        

        #Methods
        #==================================================================================================================

        #GetContext
        #------------------------------------------------------------------------------------------------------------------
        hidden [ordered] GetContext() {
                # Get the logging context
                $this.LoggingContext = [ordered]@{
                    LOG_NAME =                   $this.LogFile.Name
                    LOG_BASE_NAME =              $this.LogFile.BaseName
                    LOG_EXTENSION =              $this.LogFile.Extension
                    LOG_FULL_NAME =              $this.LogFile.FullName
                    LOG_DIRECTORY =              $this.LogFile.Directory
                    LOG_MAX_BYTES =              $this.LogMaxBytes
                    LOG_MAX_ROLLOVERS =          $this.LogMaxRollovers
                    RECORD_SEPARATOR_UNICODE =   $this.StringEscape($this.RS)
                    FIELD_SEPARATOR_UNICODE =    $this.StringEscape($this.FS)
                    DEVICE_NAME =                $env:COMPUTERNAME
                    DEVICE_IP =                  $this.deviceIp
                    USER_SID =                   $this.userSid
                    SESSION_ID =                 $this.sessionId
                    SESSION_NAME =               $env:SESSIONNAME
                    PROCESS_ID =                 $this.processId
                    OS_NAME =                    $this.os.Caption
                    OS_VERSION =                 $this.os.Version
                    OS_ARCHITECTURE =            $this.os.OSArchitecture
                    OS_SYSTEM_DIRECTORY =        $this.os.SystemDirectory
                    OS_WINDOWS_DIRECTORY =       $this.os.WindowsDirectory
                    POWERSHELL_HOST_NAME =       $this.host.Name
                    POWERSHELL_HOST_VERSION =    $this.host.Version
                    POWERSHELL_HOST_CULTURE =    $this.host.CurrentCulture
                    POWERSHELL_HOST_UI_CULTURE = $this.host.CurrentUICulture
                    POWERSHELL_VERSION =         $this.psVersionTable.PSVersion
                    POWERSHELL_EDITION =         $this.psVersionTable.PSEdition
                    SCRIPT_PATH =                $this.PSCommandPath
                    SCRIPT_DIRECTORY =           $this.PSScriptRoot
                    TAIL_LINES =                 $this.TailLines
                }

                # Update the context hash with the current context
                $this.contextHash = $this.LoggingContext.MD5

                # If the contextHash is already found in the log, return false, otherwise return true
                try {
                    $isFound = (Select-String -Path $this.LogFile.FullName -Pattern $this.contextHash -Quiet -ErrorAction Stop)
                    return -Not $isFound
                }
                catch {
                    # if the log isn't found at all, return true
                    return $true
                }


    
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
