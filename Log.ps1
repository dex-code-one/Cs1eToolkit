
#╔═ CLASSES ════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    #BinaryOutputType enum
    #------------------------------------------------------------------------------------------------------------------
    enum BinaryOutputType {
        # This enum is used to specify the output format for binary data (hashes, etc.)
        None
        Hex #0-9A-F
        Base62 #0-9A-Za-z
        Base64 #A-Za-z0-9+/=
        Base85 #A-Za-z0-9!#$%&()*+-;<=>?@^_`{|}~
        Base85Alternate #A-Za-z0-9ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØ
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


    #BoxStyle enum
    #------------------------------------------------------------------------------------------------------------------
    enum BoxStyle {
        # This enum is used to specify the style of box to draw
        None
        Light
        LightNoSides
        Heavy
        HeavyNoSides
        Double
        DoubleNoSides
        Thick
        ThickNoSides
        Custom
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

    #Base62 class
    #------------------------------------------------------------------------------------------------------------------
    class Base62 {

        # these are the default characters for base62 encoding
        hidden static [char[]]$EncodingCharacters = [char[]]('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz')
    
        # Methods
        # ------------------------------------------------------------------------------------------------------------------
    
        # Encode
        static [string] Encode ([string]$StringToEncode) {
            return [Base62]::Encode([System.Text.Encoding]::UTF8.GetBytes($StringToEncode))
        }
       
        static [string] Encode([byte[]]$BytesToEncode) {
            # Ensure the BigInteger is interpreted as positive by appending a 0 byte
            # If handling of negative values is required, this approach will need adjustment
            $positiveBytesToEncode = $BytesToEncode + @(0)
            $number = [System.Numerics.BigInteger]::new($positiveBytesToEncode)
    
            # Prepare for encoding
            $base = [Base62]::EncodingCharacters.Length
            $encoded = New-Object System.Collections.Generic.List[Object]
    
            # Convert to Base62
            while ($number -gt 0) {
                $remainder = $number % $base
                # Correctly performing integer division
                $number = [System.Numerics.BigInteger]::Divide($number, $base)
                $encoded.Insert(0, [Base62]::EncodingCharacters[$remainder])
            }
    
            # Return the encoded string
            return (-join $encoded)
        }
    
        # Decode
        static [byte[]] Decode([string]$StringToDecode) {
            $base = [Base62]::EncodingCharacters.Length
            $number = [System.Numerics.BigInteger]::Zero
    
            # Convert from Base62
            for ($i = 0; $i -lt $StringToDecode.Length; $i++) {
                $char = $StringToDecode[$i]
                $value = [Array]::IndexOf([Base62]::EncodingCharacters, $char)
                if ($value -lt 0) {
                    throw "Invalid character `'$char`' in Base62 encoded string."
                }
                $number += [System.Numerics.BigInteger]::Multiply($value, [System.Numerics.BigInteger]::Pow($base, $StringToDecode.Length - 1 - $i))
            }
    
            # Convert BigInteger to byte array and remove any leading zero bytes added during the encode process
            $byteArray = $number.ToByteArray()
            if ($byteArray[-1] -eq 0) {
                $byteArray = $byteArray[0..($byteArray.Length - 2)]
            }
    
            return $byteArray
        }
    
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
        static [string] Encode ([string]$StringToEncode) {
            return [Base85]::Encode([System.Text.Encoding]::UTF8.GetBytes($StringToEncode), [Base85]::EncodingCharacters)
        }

        static [string] Encode ([string]$StringToEncode, [bool]$UseAlternateCharacters) {
            $currChars = if ($UseAlternateCharacters) { [Base85]::AlternateEncodingCharacters }else { [Base85]::EncodingCharacters }
            return [Base85]::Encode([System.Text.Encoding]::UTF8.GetBytes($StringToEncode), [char[]]$currChars)
        }

        static [string] Encode ([byte[]]$BytesToEncode) {
            return [Base85]::Encode($BytesToEncode, [Base85]::EncodingCharacters)
        }

        static [string] Encode ([byte[]]$BytesToEncode, [bool]$UseAlternateCharacters) {
            $currChars = if ($UseAlternateCharacters) { [Base85]::AlternateEncodingCharacters }else { [Base85]::EncodingCharacters }
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
    
    #Box class
    #------------------------------------------------------------------------------------------------------------------
    class Box {
        [BoxStyle] $BoxStyle
        [int] $Width
        [TextAlignment] $TopAlignment
        [TextAlignment] $MiddleAlignment
        [TextAlignment] $BottomAlignment
        [BoxStyleAttributes] $StyleAttributes    


        # Default constructor
        Box() {
            $this.Initialize([Defaults]::BoxStyle)
        }

        Box([BoxStyle] $style) {
            $this.Initialize($style)
        }

        # Constructor with style
        Initialize([BoxStyle] $style) {
            $this.BoxStyle = $style
            $this.Width = [Defaults]::BoxWidth
            $this.TopAlignment = [Defaults]::BoxTopAlignment
            $this.MiddleAlignment = [Defaults]::BoxMiddleAlignment
            $this.BottomAlignment = [Defaults]::BoxBottomAlignment
            $this.StyleAttributes = [BoxFactory]::CreateBoxStyle($style)
        }

        # Instance Methods

        # Draw a box (top, middle, bottom) with text and alignment
        [string] DrawBox([string]$topText, [string]$middleText, [string]$bottomText) {
            $sb = New-Object System.Text.StringBuilder
            $sb.AppendLine($this.DrawTop($topText))
            $sb.AppendLine($this.DrawMiddle($middleText))
            $sb.Append($this.DrawBottom($bottomText))
            return $sb.ToString()
        }

        # Draw a straight line in the style of the box
        [string] DrawLine() {
            return [Box]::FormatTextWithBox($this.Width, '', $this.MiddleAlignment, $this.StyleAttributes.HorizontalLine, $this.StyleAttributes.HorizontalLine, $this.StyleAttributes.HorizontalLine)
        }

        [string] DrawLine([string]$text) {
            return [Box]::FormatTextWithBox($this.Width, $text, $this.MiddleAlignment, $this.StyleAttributes.HorizontalLine, $this.StyleAttributes.HorizontalLine, $this.StyleAttributes.HorizontalLine)
        }

        [string] DrawTop() {
            return $this.DrawTop('')
        }
        
        [string] DrawTop([string]$text) {
            return [Box]::FormatTextWithBox($this.Width, $text, $this.TopAlignment, $this.StyleAttributes.TopLeft, $this.StyleAttributes.HorizontalTop, $this.StyleAttributes.TopRight)
        }

        [string] DrawMiddle() {
            return $this.DrawMiddle('')
        }
    
        [string] DrawMiddle([string]$text) {
            $outList = New-Object System.Collections.Generic.List[string]
            foreach ($line in $text -split "`r?`n") {
                $lineOut = [Box]::FormatTextWithBox($this.Width, $line, $this.MiddleAlignment, $this.StyleAttributes.VerticalLeft, ' ', $this.StyleAttributes.VerticalRight)
                $outList.Add($lineOut)
            }
            return $outList -join "`n"
        }

        [string] DrawBottom() {
            return $this.DrawBottom('')
        }
    
        [string] DrawBottom([string]$text) {
            return [Box]::FormatTextWithBox($this.Width, $text, $this.BottomAlignment, $this.StyleAttributes.BottomLeft, $this.StyleAttributes.HorizontalBottom, $this.StyleAttributes.BottomRight)
        }

        # Static Methods
        static [Box] ReSerialize([Object]$DeserializedBox) {
            $box = [Box]::new($DeserializedBox.BoxStyle)
            $box.Width = $DeserializedBox.Width
            $box.TopAlignment = $DeserializedBox.TopAlignment
            $box.MiddleAlignment = $DeserializedBox.MiddleAlignment
            $box.BottomAlignment = $DeserializedBox.BottomAlignment
            return $box
        }

        # Hidden Static Methods    
        hidden static [string] FormatTextWithBox([int]$width, [string]$text, [TextAlignment]$alignment, [string]$leftCharacter, [string]$padCharacter, [string]$rightCharacter) {
            $effectiveWidth = $width - ($leftCharacter.Length + $rightCharacter.Length)
            $alignedText = $null
            switch ($alignment) {
                'Center' {
                    $totalPadding = $effectiveWidth - $text.Length
                    $leftPadding = [Math]::Floor($totalPadding / 2)
                    $rightPadding = [Math]::Ceiling($totalPadding / 2)
                    $alignedText = $text.PadLeft($text.Length + $leftPadding, $padCharacter).PadRight($text.Length+$leftPadding+$rightPadding, $padCharacter)
                }
                'Left' {
                    $alignedText = $text.PadRight($effectiveWidth, $padCharacter)
                }
                'Right' {
                    $alignedText = $text.PadLeft($effectiveWidth, $padCharacter)
                }
            }            
            return $leftCharacter + $alignedText + $rightCharacter
        }

    }

    #BoxStyleAttributes class
    #------------------------------------------------------------------------------------------------------------------
    class BoxStyleAttributes {
        [string] $HorizontalTop
        [string] $HorizontalLine
        [string] $HorizontalBottom
        [string] $VerticalLeft
        [string] $VerticalLine
        [string] $VerticalRight
        [string] $TopLeft
        [string] $TopRight
        [string] $BottomLeft
        [string] $BottomRight
        [string] $LeftTee
        [string] $RightTee
        [string] $TopTee
        [string] $BottomTee
        [string] $Cross
    
        BoxStyleAttributes([string[]] $styleAttributes) {
            $this.HorizontalTop = $styleAttributes[0]
            $this.HorizontalLine = $styleAttributes[1]
            $this.HorizontalBottom = $styleAttributes[2]
            $this.VerticalLeft = $styleAttributes[3]
            $this.VerticalLine = $styleAttributes[4]
            $this.VerticalRight = $styleAttributes[5]
            $this.TopLeft = $styleAttributes[6]
            $this.TopRight = $styleAttributes[7]
            $this.BottomLeft = $styleAttributes[8]
            $this.BottomRight = $styleAttributes[9]
            $this.LeftTee = $styleAttributes[10]
            $this.RightTee = $styleAttributes[11]
            $this.TopTee = $styleAttributes[12]
            $this.BottomTee = $styleAttributes[13]
            $this.Cross = $styleAttributes[14]
        }
    }

    #BoxFactory class
    #------------------------------------------------------------------------------------------------------------------
    class BoxFactory {
        hidden static [string[]] $None = ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
        hidden static [string[]] $Light = '─','─','─', '│', '│','│', '┌', '┐', '└', '┘', '├', '┤', '┬', '┴', '┼'
        hidden static [string[]] $LightNoSides = '─','─','─', ' ', '│',' ', '┌', '┐', '└', '┘', '├', '┤', '┬', '┴', '┼'
        hidden static [string[]] $Heavy = '━','━','━', '┃', '┃', '┃', '┏', '┓', '┗', '┛', '┣', '┫', '┳', '┻', '╋'
        hidden static [string[]] $HeavyNoSides = '━','━','━', ' ', '┃', ' ', '┏', '┓', '┗', '┛', '┣', '┫', '┳', '┻', '╋'
        hidden static [string[]] $Double = '═','═','═', '║', '║', '║', '╔', '╗', '╚', '╝', '╠', '╣', '╦', '╩', '╬'
        hidden static [string[]] $DoubleNoSides = '═','═','═', ' ', '║', ' ', '╔', '╗', '╚', '╝', '╠', '╣', '╦', '╩', '╬'
        hidden static [string[]] $Thick = '█', '█', '█', '██', '██', '██', '██', '██', '██', '██', '██', '██', '██', '██', '██'
        hidden static [string[]] $ThickNoSides = '█', '█', '█', '  ', '██', '  ', '██', '██', '██', '██', '██', '██', '██', '██', '██'
        hidden static [hashtable] $StyleMap = @{
            'None' = [BoxFactory]::None
            'Light' = [BoxFactory]::Light
            'LightNoSides' = [BoxFactory]::LightNoSides
            'Heavy' = [BoxFactory]::Heavy
            'HeavyNoSides' = [BoxFactory]::HeavyNoSides
            'Double' = [BoxFactory]::Double
            'DoubleNoSides' = [BoxFactory]::DoubleNoSides
            'Thick' = [BoxFactory]::Thick
            'ThickNoSides' = [BoxFactory]::ThickNoSides
            'Custom' = [BoxFactory]::None
        }        

        static [BoxStyleAttributes] CreateBoxStyle([BoxStyle] $style) {
            $styleAttributes = [BoxFactory]::StyleMap[$style.ToString()]
            if ($null -eq $styleAttributes) {$styleAttributes = [Box]::None}
            return [BoxStyleAttributes]::new($styleAttributes)
        }
    }

    #Auth class (base)
    #------------------------------------------------------------------------------------------------------------------
    class Auth {
        [string]$Server

        Auth() {
            $this.Server = (Read-Host -Prompt 'Enter the 1E Platform server name')
        }

        Auth([string]$server) {
            $this.Server = $server
        }

        [bool] Authenticate() {
            Set-1EServer -Server $this.Server
            return $this.TestConnection()
        }

        static [Auth] ReSerialize([Object]$DeserializedAuth) {
            if ($DeserializedAuth.PSObject.Properties.Name -contains 'Credential') {
                return [BasicAuth]::new($DeserializedAuth.Server, $DeserializedAuth.Credential)
            } elseif ($DeserializedAuth.PSObject.Properties.Name -contains 'CertSubject') {
                return [CertSubjectAuth]::new($DeserializedAuth.Server, $DeserializedAuth.AppId, $DeserializedAuth.CertSubject, $DeserializedAuth.Principal)
            } else {
                return [Auth]::new($DeserializedAuth.Server)
            }
        }

        [bool] TestConnection() {
            try {
                # try to execute something benign to see if we are connected to the 1E Server
                [void](Get-1ESystemStatistics -ErrorAction Stop -WarningAction Stop)
                # and if this auth server is the one we are connected to
                return ($this.Server -ieq (Get-1EServer))
            }
            catch {return $false}
        }

        [string] ToString() {
            return "AuthClass: $($this.GetType().FullName)`nServer: $($this.Server)"
        }
    }

    #BasicAuth class (inherits Auth)
    #------------------------------------------------------------------------------------------------------------------
    class BasicAuth : Auth {
        # This class is used to authenticate to the 1E Platform using basic authentication (username and password)

        #[string]$Server #Inherited from AuthSettings
        [pscredential]$Credential

        BasicAuth() {
            $this.Server = (Read-Host -Prompt 'Enter the 1E Platform server name')
            $this.Credential = Get-Credential -Title "1E Platform Credentials" -Message "Enter credentials to connect to $($this.Server)"
        }

        BasicAuth([string]$server) {
            $this.Server = $server
            $this.Credential = Get-Credential -Title "Platform Credentials" -Message "Enter credentials to connect to $server"
        }

        BasicAuth([string]$server, [pscredential]$credential) {
            $this.Server = $server
            $this.Credential = $credential
        }

        [bool] Authenticate() {
            Set-1EServer -Server $this.Server -UseBasicAuth -Credential $this.Credential
            return $this.TestConnection()
        }


    }

    #CertSubjectAuth class (inherits Auth)
    #------------------------------------------------------------------------------------------------------------------
    class CertSubjectAuth : Auth {
        # This class is used to authenticate to the 1E Platform using a certificate subject and azure app id

        #[string]$Server #Inherited from AuthSettings
        [string]$Server = '1eplatform.dex.local'
        [string]$AppId = 'ec8ba764-7dcd-43b9-a0c2-fe8c289d0e80'
        [string]$CertSubject = 'CN=1EIntegration'
        [string]$Principal = 'install@dexcodeone.onmicrosoft.com'

        CertSubjectAuth() {
            $this.Server = (Read-Host -Prompt 'Enter the 1E Platform server name')
            $this.AppId = (Read-Host -Prompt 'Enter the Azure App ID')
            $this.CertSubject = (Read-Host -Prompt 'Enter the certificate subject')
            $this.Principal = (Read-Host -Prompt 'Enter the Azure principal who maps to a platform user')
        }

        CertSubjectAuth([string]$server, [string]$appId, [string]$certSubject, [string]$principal) {
            $this.Server = $server
            $this.AppId = $appId
            $this.CertSubject = $certSubject
            $this.Principal = $principal
        }

        [bool] Authenticate() {
            Set-1EServer -Server $this.Server -AppId $this.AppId -CertSubject $this.CertSubject -Principal $this.Principal
            return $this.TestConnection()
        }
    }

    #UnattendedAuth class (inherits CertSubjectAuth)
    #------------------------------------------------------------------------------------------------------------------
    class UnattendedAuth : CertSubjectAuth {
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
        static [string] $FieldSeparator = "`u{200B} " # Zero-width space + space
        static [string] $RecordSeparator = "`u{200B}`n" # Zero-width space and a newline
        static [int] $Indent = 4
        static [int] $BoxWidth = 120
        static [BoxStyle] $BoxStyle = [BoxStyle]::DoubleNoSides
        static [TextAlignment] $BoxTopAlignment = [TextAlignment]::Center
        static [TextAlignment] $BoxMiddleAlignment = [TextAlignment]::Left
        static [TextAlignment] $BoxBottomAlignment = [TextAlignment]::Center
        static [Box]$Box = [Box]::new()
        static [HashAlgorithm] $HashAlgorithm = 'MD5'
        static [BinaryOutputType] $BinaryOutputType = 'Base64'
        static [int] $EncryptionKeySize = 256
        static [int] $EncryptionIVSize = 128
        static [int] $EncryptionIterations = 100000
        static [System.IO.FileInfo]$LogDirectory = [System.IO.Path]::Combine($env:LOCALAPPDATA, '1E\Logs')
        static [System.IO.FileInfo]$LogFallbackDirectory = $env:TEMP
        static [string]$LogPrefix = '1e.CustomerSuccess.'
        static [string]$LogNamePattern = 'yyyyMMdd_HHmmss_fffffff'
        static [string]$LogExtension = '.log'
        static [int]$LogTailLines = 40
        static [HashAlgorithm]$ContextIDAlgorithm = 'MD5'
        static [BinaryOutputType]$ContextIDFormat = 'Base62'
        static [System.IO.DirectoryInfo]$MigrationRoot = [System.IO.Path]::Combine($env:LOCALAPPDATA, '1E\Migration')
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

        # Constructor
        Defaults() {
            throw 'This class is static and cannot be instantiated.'
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
            $this.Ip = try {Get-NetIPAddress -AddressFamily IPv4 -Type Unicast | Where-Object {$_.InterfaceAlias -notlike '*Loopback*' -and $_.PrefixOrigin -ne 'WellKnown'}| Sort-Object -Property InterfaceMetric -Descending | Select-Object -First 1 -ExpandProperty IPAddress}catch {''}
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

    #Instance class
    #------------------------------------------------------------------------------------------------------------------
    class Instance {
        [string]$Name
        [Auth]$Authenticator
        [Log]$Log
        [System.Collections.Generic.List[System.Object]]$Instructions = @()
        [System.Collections.Generic.List[System.Object]]$InstructionSets = @()
        [System.Collections.Generic.List[System.Object]]$ManagementGroups = @()
        [System.Collections.Generic.List[System.Object]]$Policies = @()
        [System.Collections.Generic.List[System.Object]]$Rules = @()
        [System.Collections.Generic.List[System.Object]]$TriggerTemplates = @()
        [System.Collections.Generic.List[System.Object]]$Fragments = @()
        [System.DateTimeOffset]$CachedTimeUtc
        

        #Constructors
        #------------------------------------------------------------------------------------------------------------------
        Instance() {
            $this.Authenticator = [Auth]::new() # interactively connect to the 1E Platform
            $this.Name = $this.Authenticator.Server
            $this.Log = [Log]::new("Instance_$($this.Authenticator.Server).log",$true)
        }

        Instance([Log]$Log) {
            $this.Authenticator = [Auth]::new() # interactively connect to the 1E Platform
            $this.Name = $this.Authenticator.Server
            $this.Log = $Log # use specified log
        }

        Instance([Auth]$Authenticator) {
            $this.Authenticator = $Authenticator # use specified authenticator
            $this.Name = $Authenticator.Server
            $this.Log = [Log]::new("Instance_$($this.Authenticator.Server).log",$true)
        }

        Instance([String]$Name, [String]$Server) {
            $this.Authenticator = [Auth]::new($Server) # use specified server
            $this.Name = $Name ?? $Server
            $this.Log = [Log]::new("Instance_$($this.Authenticator.Server).log",$true)
        }

        Instance([Auth]$Authenticator, [Log]$Log) {
            $this.Authenticator = $Authenticator # use specified authenticator
            $this.Name = $Authenticator.Server
            $this.Log = $Log # use specified log
        }

        Instance([String]$Name,
                [Auth]$Authenticator,
                [Log]$Log,
                [System.Collections.Generic.List[System.Object]]$Instructions,
                [System.Collections.Generic.List[System.Object]]$InstructionSets,
                [System.Collections.Generic.List[System.Object]]$ManagementGroups,
                [System.Collections.Generic.List[System.Object]]$Policies,
                [System.Collections.Generic.List[System.Object]]$Rules,
                [System.Collections.Generic.List[System.Object]]$TriggerTemplates,
                [System.Collections.Generic.List[System.Object]]$Fragments,
                [System.DateTimeOffset]$CachedTimeUtc) {
            $this.Name = $Name
            $this.Authenticator = $Authenticator
            $this.Log = $Log
            $this.Instructions = $Instructions
            $this.InstructionSets = $InstructionSets
            $this.ManagementGroups = $ManagementGroups
            $this.Policies = $Policies
            $this.Rules = $Rules
            $this.TriggerTemplates = $TriggerTemplates
            $this.Fragments = $Fragments
            $this.CachedTimeUtc = $CachedTimeUtc
        }

        #Methods
        #------------------------------------------------------------------------------------------------------------------

        # Connect
        [void] Connect() {
            $this.Log.Info("INSTANCE_CONNECT: Connecting to $($this.Authenticator.Server)")
            $this.Authenticator.Authenticate()
        }

        # IsConnected
        [bool] IsConnected() {
            return $this.Authenticator.TestConnection()
        }

        # CacheInstructions
        [void] CacheInstructions() {
            $this.Log.Info("INSTRUCTION_CACHE: Getting instructions from server")
            try {
                $this.Instructions = Get-1EInstruction -ErrorAction Stop
            }
            catch {
                if (-not $this.IsConnected()) {$this.Connect()}
                $this.Instructions = Get-1EInstruction
            }
            $this.Log.Info("INSTRUCTION_CACHE: $($this.Instructions.Count) instructions cached")
        }

        # CacheInstructionSets
        [void] CacheInstructionSets() {
            $this.Log.Info("INSTRUCTION_SET_CACHE: Getting instruction sets from server")
            try {
                $this.InstructionSets = Get-1EInstructionSet -ErrorAction Stop
            }
            catch {
                if (-not $this.IsConnected()) {$this.Connect()}
                $this.InstructionSets = Get-1EInstructionSet
            }
            $this.Log.Info("INSTRUCTION_SET_CACHE: $($this.InstructionSets.Count) instruction sets cached")
        }

        # CacheManagementGroups
        [void] CacheManagementGroups() {
            $this.Log.Info("MANAGEMENT_GROUP_CACHE: Getting management groups from server")
            try {
                $this.ManagementGroups = Get-1ESLAManagementGroup -IncludeRules -ErrorAction Stop
            }
            catch {
                if (-not $this.IsConnected()) {$this.Connect()}
                $this.ManagementGroups = Get-1ESLAManagementGroup -IncludeRules                    
            }
            $this.Log.Info("MANAGEMENT_GROUP_CACHE: $($this.ManagementGroups.Count) management groups cached")
        }

        # CachePolicies
        [void] CachePolicies() {
            $this.Log.Info("POLICY_CACHE: Getting policies from server")
            try {
                $this.Policies = Get-1EAllPolicy -ErrorAction Stop
            }
            catch {
                if (-not $this.IsConnected()) {$this.Connect()}
                $this.Policies = Get-1EAllPolicy
            }
            $this.Log.Info("POLICY_CACHE: $($this.Policies.Count) policies cached")
        }

        # CacheRules
        [void] CacheRules() {
            $this.Log.Info("RULE_CACHE: Getting rules from server")
            try {
                $this.Rules = Get-1EAllRule -ErrorAction Stop
            }
            catch {
                if (-not $this.IsConnected()) {$this.Connect()}
                $this.Rules = Get-1EAllRule
            }
            $this.Log.Info("RULE_CACHE: $($this.Rules.Count) rules cached")
        }

        # CacheTriggerTemplates
        [void] CacheTriggerTemplates() {
            $this.Log.Info("TRIGGER_TEMPLATE_CACHE: Getting trigger templates from server")
            try {
                $this.TriggerTemplates = Get-1EAllTriggerTemplate -ErrorAction Stop
            }
            catch {
                if (-not $this.IsConnected()) {$this.Connect()}
                $this.TriggerTemplates = Get-1EAllTriggerTemplate
            }
            $this.Log.Info("TRIGGER_TEMPLATE_CACHE: $($this.TriggerTemplates.Count) trigger templates cached")
        }

        # CacheFragments
        [void] CacheFragments() {
            $this.Log.Info("FRAGMENT_CACHE: Getting fragments from server")
            try {
                $this.Fragments = Get-1EAllFragment -ErrorAction Stop
            }
            catch {
                if (-not $this.IsConnected()) {$this.Connect()}
                $this.Fragments = Get-1EAllFragment
            }
            $this.Log.Info("FRAGMENT_CACHE: $($this.Fragments.Count) fragments cached")
        }

        # CacheAllObjects
        [void] CacheAllObjects() {
            $this.Log.Info("Retrieving all objects from server and caching them locally")
            $this.CacheInstructions()
            $this.CacheInstructionSets()
            $this.CacheManagementGroups()
            $this.CachePolicies()
            $this.CacheRules()
            $this.CacheTriggerTemplates()
            $this.CacheFragments()
            $this.CachedTimeUtc = [System.DatetimeOffset]::Now
            $this.Log.Info("All server objects cached")
        }

        [void] ClearCache() {
            $this.Log.Info("Clearing all cached objects")
            $this.Instructions = @()
            $this.InstructionSets = @()
            $this.ManagementGroups = @()
            $this.Policies = @()
            $this.Rules = @()
            $this.TriggerTemplates = @()
            $this.Fragments = @()
            $this.CachedTimeUtc = $null
        }

        # ToString
        [string] ToString() {
            return ([ordered]@{
                Name = $this.Name
                Server = $this.Authenticator.Server
            }).ToString()
        }
    }

    #Migration class
    #------------------------------------------------------------------------------------------------------------------
    class Migration {
        [string]$Id = [DateTime]::UtcNow.ToString("yyyy.MM.dd.HH.mm.ss.fffffff")
        [System.IO.DirectoryInfo]$MigrationDirectory = [System.IO.DirectoryInfo]::new("$([Defaults]::MigrationRoot)\$($this.Id)")
        [System.IO.FileInfo]$ExportFile = [System.IO.FileInfo]::new((Join-Path $this.MigrationDirectory.FullName 'Export.xml'))
        [Log]$Log = [Log]::new('Migration',$true)
        [Instance[]]$Instances
        [Instance]$ExportInstance
        [Instance]$ImportInstance
        [string[]]$TypesToExport
        [System.Collections.Generic.List[System.Object]]$InstructionSetsToMigrate = @()
        [System.Collections.Generic.List[System.Object]]$InstructionsToMigrate = @()
        [System.Collections.Generic.List[System.Object]]$ManagementGroupsToMigrate = @()
        [System.Collections.Generic.List[System.Object]]$PoliciesToMigrate = @()
        [System.Collections.Generic.List[System.Object]]$RulesToMigrate = @()
        [System.Collections.Generic.List[System.Object]]$TriggerTemplatesToMigrate = @()
        [System.Collections.Generic.List[System.Object]]$FragmentsToMigrate = @()

        hidden [string[]]$ObjectTypes = @('InstructionSets', 'Instructions', 'ManagementGroups', 'Policies', 'Rules', 'TriggerTemplates', 'Fragments')
        

        #Constructors
        #------------------------------------------------------------------------------------------------------------------
        Migration() {
            throw "You must provide at least one instance to migrate"
        }     
        
        Migration([Instance[]]$Instances) {
            $this.Instances = $Instances
            $this.MigrationDirectory = [Directory]::Create($this.MigrationDirectory.FullName)
        }


        #Methods
        #------------------------------------------------------------------------------------------------------------------
        [void] Clear() {
            $this.Log.Info("Clearing all cached objects")
            $this.ExportInstance = $null
            $this.ImportInstance = $null
            $this.TypesToExport = @()
            $this.InstructionSetsToMigrate = @()
            $this.InstructionsToMigrate = @()
            $this.ManagementGroupsToMigrate = @()
            $this.PoliciesToMigrate = @()
            $this.RulesToMigrate = @()
            $this.TriggerTemplatesToMigrate = @()
            $this.FragmentsToMigrate = @()
        }

        [Void] Export () {
            $this.Log.WriteTopLine('Info'," OBJECT_EXPORT_BEGIN ")
            
            #Choose instance from which we'll export
            $this.Log.Info("USER_PROMPT: Prompting for the export instance")
            $choice = $this.Instances | Select-Object Name, @{Name='Server'; Expression={$_.Authenticator.Server}}| Out-GridView -Title "Select the Export instance" -OutputMode Single
            if (-not $choice) {
                $this.Stop("Error","NO_EXPORT_INSTANCE_SELECTED: No export instance was selected or the user cancelled. Exiting")
            } else {
                $this.ExportInstance = $this.Instances | Where-Object {$_.Name -eq $choice.Name} | Select-Object -First 1
                $this.Log.Info("EXPORT_INSTANCE_SELECTED: $($this.ExportInstance.Name) selected")
            }

            #Connect to the export instance and have it cache all objects to the class
            $this.Log.Info("EXPORT_CONNECT: Connecting to $($this.ExportInstance.Name) and caching all objects")
            if (-not $this.ExportInstance.IsConnected()) {$this.ExportInstance.Connect()}
            $this.ExportInstance.CacheAllObjects()

            #Choose the types of objects to export.
            $this.TypesToExport = $this.ObjectTypes | Out-GridView -Title "Select the object types to export" -OutputMode Multiple
            if ($this.TypesToExport.Count -eq 0) {
                $this.Stop("Error","NO_OBJECT_TYPES_SELECTED: No object types were selected to export or the user cancelled. Exiting")
            }

            #Choose the InstructionSets
            if ($this.TypesToExport -contains 'InstructionSets') {
                $this.Log.Info("USER_PROMPT: Prompting for the instruction sets to export")
                $this.InstructionSetsToMigrate = $this.ExportInstance.InstructionSets | Out-GridView -Title "Select the Instruction Sets to export" -OutputMode Multiple
                if ($this.InstructionSetsToMigrate.Count -eq 0) {
                    $this.Stop('Error',"NO_INSTRUCTION_SETS_SELECTED: No instruction sets were selected to export or the user cancelled. Exiting")
                }
            }

            #Choose the Instructions
            if ($this.TypesToExport -contains 'Instructions') {
                $this.Log.Info("USER_PROMPT: Prompting for the instructions to export")
                $this.InstructionsToMigrate = $this.ExportInstance.Instructions | Out-GridView -Title "Select the Instructions to export" -OutputMode Multiple
                if ($this.InstructionsToMigrate.Count -eq 0) {
                    $this.Stop('Error',"NO_INSTRUCTIONS_SELECTED: No instructions were selected to export or the user cancelled. Exiting")
                }
                #For any instructions to migrate, also get the actual XML content from the server (via .ZIP for now)
                $this.Log.Info("INSTRUCTION_CONTENT: Getting instruction content from server")
                if ($this.InstructionsToMigrate.Count -gt 0) {
                    $this.InstructionsToMigrate | ForEach-Object {
                        $currName = $_.Name
                        $this.Log.Info("INSTRUCTION_XML_RETRIEVAL: Getting XML content for instruction: $currName")
                        $currZip = Join-Path $env:temp "$currName.zip"
                        $currUnzipPath = Join-Path $env:temp $currName
                        try {
                            Export-1EInstruction -Name $currName -File $currZip # get zip from server
                            $currXmlfile = Expand-Archive -Path $currZip -DestinationPath $currUnzipPath -Force -PassThru | Select-Object -First 1 # unzip it to get at it's XML contents (first 1 in case there are multiple files in the zip, which shouldn't happen)
                            Remove-Item -Path $currZip -Force -ErrorAction SilentlyContinue # remove the zip file
                            $_ | Add-Member -MemberType NoteProperty -Name 'XmlContent' -Value ([string](Get-Content -Path $currXmlFile.FullName -Encoding UTF8)) -PassThru # add the content of the XML as a new property of the current instruction object in the pipeline
                            [Directory]::Remove($currUnzipPath, $true) # remove the unzip folder and everything in it quietly
                        } catch {
                            $this.Log.Error("INSTRUCTION_XML_RETRIEVAL_ERROR: $($_.Exception.Message)")
                        }
                    }
                    #Also get any instruction sets that are associated with the instructions chosen
                    $this.Log.Info("INSTRUCTION_SETS: Getting additional instruction sets associated with the selected instructions (if any)")
                    if ($this.InstructionsToMigrate.Count -gt 0) {
                        $this.InstructionsToMigrate.InstructionSetName | # get the instruction set names from the instructions
                            Where-Object {$_ -notin $this.InstructionSetsToMigrate.Name} | # filter out any instruction sets that are already in the export list
                                ForEach-Object { # for each instruction set name
                                    $currName = $_
                                    $this.InstructionSetsToMigrate.Add($this.ExportInstance.InstructionSets.Where({$_.Name -eq $currName},'First')) # add the instruction set to the export list
                                }
                    }
                }
            }

            #Choose the ManagementGroups
            if ($this.TypesToExport -contains 'ManagementGroups') {
                $this.Log.Info("USER_PROMPT: Prompting for the management groups to export")
                $this.ManagementGroupsToMigrate = $this.ExportInstance.ManagementGroups | Out-GridView -Title "Select the Management Groups to export" -OutputMode Multiple
                if ($this.ManagementGroupsToMigrate.Count -eq 0) {
                    $this.Stop('Error',"NO_MANAGEMENT_GROUPS_SELECTED: No management groups were selected to export or the user cancelled. Exiting")
                }
            }

            #Choose the Policies
            if ($this.TypesToExport -contains 'Policies') {
                $this.Log.Info("USER_PROMPT: Prompting for the policies to export")
                $this.PoliciesToMigrate = $this.ExportInstance.Policies | Out-GridView -Title "Select the Policies to export" -OutputMode Multiple
                if ($this.PoliciesToMigrate.Count -eq 0) {
                    $this.Stop('Error',"NO_POLICIES_SELECTED: No policies were selected to export or the user cancelled. Exiting")
                }
            }

            #Choose the Rules
            if ($this.TypesToExport -contains 'Rules') {
                $this.Log.Info("USER_PROMPT: Prompting for the rules to export")
                $this.RulesToMigrate = $this.ExportInstance.Rules | Out-GridView -Title "Select the Rules to export" -OutputMode Multiple
                if ($this.RulesToMigrate.Count -eq 0) {
                    $this.Stop('Error',"NO_RULES_SELECTED: No rules were selected to export or the user cancelled. Exiting")
                }
            }

            #Choose the TriggerTemplates
            if ($this.TypesToExport -contains 'TriggerTemplates') {
                $this.Log.Info("USER_PROMPT: Prompting for the trigger templates to export")
                $this.TriggerTemplatesToMigrate = $this.ExportInstance.TriggerTemplates | Out-GridView -Title "Select the Trigger Templates to export" -OutputMode Multiple
                if ($this.TriggerTemplatesToMigrate.Count -eq 0) {
                    $this.Stop('Error',"NO_TRIGGER_TEMPLATES_SELECTED: No trigger templates were selected to export or the user cancelled. Exiting")
                }
            }

            #Choose the Fragments
            if ($this.TypesToExport -contains 'Fragments') {
                $this.Log.Info("USER_PROMPT: Prompting for the fragments to export")
                $this.FragmentsToMigrate = $this.ExportInstance.Fragments | Out-GridView -Title "Select the Fragments to export" -OutputMode Multiple
                if ($this.FragmentsToMigrate.Count -eq 0) {
                    $this.Stop('Error',"NO_FRAGMENTS_SELECTED: No fragments were selected to export or the user cancelled. Exiting")
                }
                #For any fragments to migrate, also get the actual XML content from the server 
                $this.Log.Info("FRAGMENT_CONTENT: Getting fragment content from server")
                if ($this.FragmentsToMigrate.Count -gt 0) {
                    $this.FragmentsToMigrate | ForEach-Object {
                        $currName = $_.Name
                        $this.Log.Info("FRAGMENT_XML_RETRIEVAL: Getting XML content for fragment: $currName")
                        $currXmlFile = Join-Path $env:temp "$currName.xml"
                        try {
                            Export-1EFragment -Name $currName -File $currXmlFile
                            $_ | Add-Member -MemberType NoteProperty -Name 'XmlContent' -Value ([string](Get-Content -Path $currXmlFile -Encoding UTF8)) -PassThru # add the content of the XML as a new property of the current fragment object in the pipeline
                            Remove-Item -Path $currXmlFile -Force -ErrorAction SilentlyContinue | Out-Null # remove the file
                            [Directory]::Remove($currUnzipPath, $true) # remove the unzip folder and everything in it quietly
                        } catch {
                            $this.Log.Error("FRAGMENT_XML_RETRIEVAL_ERROR: $($_.Exception.Message)")
                        }
                    }
                }
            }

            #Save the export file
            $this.Save()
            $this.Log.WriteBottomLine('Info'," OBJECT_EXPORT_END ")
        }

        [void] Import() {
            $this.Log.WriteTopLine('Info'," OBJECT_IMPORT_BEGIN ")
            $this.Log.Info("USER_PROMPT: Prompting for the import instance")
            $choice = $this.Instances | Select-Object Name, @{Name='Server'; Expression={$_.Authenticator.Server}}| Out-GridView -Title "Select the destination (import) instance" -OutputMode Single
            if (-not $choice) {
                $this.Stop("Error","NO_IMPORT_INSTANCE_SELECTED: No import instance was selected or the user cancelled. Exiting")
            } else {
                $this.ImportInstance = $this.Instances | Where-Object {$_.Name -eq $choice.Name} | Select-Object -First 1
                $this.Log.Info("IMPORT_INSTANCE_SELECTED: $($this.ImportInstance.Name) selected")
            }

            $this.Log.Info("IMPORT_CONNECT: Connecting to $($this.ImportInstance.Name)")
            if (-not $this.ImportInstance.IsConnected()) {$this.ImportInstance.Connect()}
            $this.ImportInstance.CacheAllObjects()

            $this.Log.Info("READING_EXPORT_FILE: Reading export file $($this.ExportFile.FullName)")
            $export = [Migration]::new((Import-Clixml -Path $this.ExportFile.FullName))

        }

        [void] OpenExplorer() {
            Start-Process -FilePath "explorer.exe" -ArgumentList "/select, `"$($this.ExportFile.FullName)`""
        }

        [void] RemoveOldExports([int]$ExportsToKeep) {
            $this.Log.Info("REMOVING_OLD_EXPORTS")
            $oldExports = [System.IO.DirectoryInfo]::new("$env:LOCALAPPDATA\1E\Migration").GetDirectories() | Sort-Object -Property Name -Descending | Select-Object -Skip $ExportsToKeep
            $oldExports | ForEach-Object {
                $this.Log.Info("REMOVING_OLD_EXPORT: $($_.Name)")
                [Directory]::Remove($_.FullName, $true)
            }
            $this.Log.Info("OLD_EXPORTS_REMOVED")
        }

        [void] Save() {
            $this.Log.Info("EXPORT_SAVE: Saving export to $($this.ExportFile.FullName)")
            [ordered]@{
                Id = $this.Id
                MigrationDirectory = $this.MigrationDirectory.FullName
                ExportFile = $this.ExportFile.FullName
                Log = $this.Log
                Instances = $this.Instances
                ExportInstance = $this.ExportInstance
                ImportInstance = $this.ImportInstance
                TypesToExport = $this.TypesToExport
                InstructionSetsToMigrate = $this.InstructionSetsToMigrate
                InstructionsToMigrate = $this.InstructionsToMigrate
                ManagementGroupsToMigrate = $this.ManagementGroupsToMigrate
                PoliciesToMigrate = $this.PoliciesToMigrate
                RulesToMigrate = $this.RulesToMigrate
                TriggerTemplatesToMigrate = $this.TriggerTemplatesToMigrate
                FragmentsToMigrate = $this.FragmentsToMigrate
            } | Export-Clixml -Path $this.ExportFile.FullName -Force -Encoding UTF8
        }

        [void] Stop() {
            $this.Log.WriteBottomLine('Info','')
        }

        [void] Stop([LogLevel]$Level, [string]$Message) {
            $this.Log.Write($Level, $Message)
            $this.Log.WriteBottomLine('Info','')
            if ($Level -in 'Fatal','Error') {exit 1}
        }

    }

    #Dialog class
    #------------------------------------------------------------------------------------------------------------------
    class Dialog {
        #static dialog class for displaying messages to the user and getting input

        static Dialog() {
            # Load Windows Forms and Drawing assemblies
            Add-Type -AssemblyName System.Windows.Forms
            Add-Type -AssemblyName System.Drawing
        }

        static [PSCustomObject] TwoSinglePickers([string]$Title, [string]$List1Name, [array]$List1, [string]$List2Name, [array]$List2) {
            # Create a new form
            $form = New-Object System.Windows.Forms.Form
            $form.Text = $Title
            $form.Size = New-Object System.Drawing.Size(500, 300)
            $form.StartPosition = 'CenterScreen'

            # Create the Source Server Label
            $sourceLabel = New-Object System.Windows.Forms.Label
            $sourceLabel.Location = New-Object System.Drawing.Point(10, 10)
            $sourceLabel.Size = New-Object System.Drawing.Size(220, 20)
            $sourceLabel.Text = $List1Name

            # Create the Source ListBox
            $sourceListBox = New-Object System.Windows.Forms.ListBox
            $sourceListBox.Location = New-Object System.Drawing.Point(10, 35)
            $sourceListBox.Size = New-Object System.Drawing.Size(220, 175)
            $sourceListBox.SelectionMode = 'One'  # Single selection

            # Create the Target Server Label
            $targetLabel = New-Object System.Windows.Forms.Label
            $targetLabel.Location = New-Object System.Drawing.Point(250, 10)
            $targetLabel.Size = New-Object System.Drawing.Size(220, 20)
            $targetLabel.Text = $List2Name

            # Create the Target ListBox
            $targetListBox = New-Object System.Windows.Forms.ListBox
            $targetListBox.Location = New-Object System.Drawing.Point(250, 35)
            $targetListBox.Size = New-Object System.Drawing.Size(220, 175)
            $targetListBox.SelectionMode = 'One'  # Single selection

            # Populate the ListBoxes
            $sourceListBox.Items.AddRange($List1)
            $targetListBox.Items.AddRange($List2)

            # Add controls to the form
            $form.Controls.Add($sourceLabel)
            $form.Controls.Add($sourceListBox)
            $form.Controls.Add($targetLabel)
            $form.Controls.Add($targetListBox)

            # Create OK button
            $okButton = New-Object System.Windows.Forms.Button
            $okButton.Location = New-Object System.Drawing.Point(395, 220)  # Adjusted for right alignment
            $okButton.Size = New-Object System.Drawing.Size(75, 23)
            $okButton.Text = 'OK'
            $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $form.AcceptButton = $okButton
            $form.Controls.Add($okButton)

            try {
                # Show form as a dialog and capture the result
                $result = $form.ShowDialog()

                if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
                    $sourceServer = $sourceListBox.SelectedItem
                    $targetServer = $targetListBox.SelectedItem
                    return [PSCustomObject]@{Source = $sourceServer; Target = $targetServer}
                } else {
                    return $null
                }
            } finally {
                # Clean up
                if ($form) {$form.Dispose()}
            }
        }
    }

    #Directory class
    #------------------------------------------------------------------------------------------------------------------
    class Directory {
        Directory() {
            throw 'This class is static and cannot be instantiated.'
        }

        # New (or get existing) directory
        static [System.IO.DirectoryInfo] Create([string]$path) {
            $directory = [System.IO.DirectoryInfo]::new($path)
            if (-not $directory.Exists) {$directory.Create()}
            return $directory
        }

        # Remove the directory
        static [void] Remove([string]$path, [bool]$recursive) {
            try {
                $directory = [System.IO.DirectoryInfo]::new($path)
                if ($directory.Exists) {$directory.Delete($recursive)}
            } catch {}
        }

        # Get the directory size
        static [long] GetSize([string]$path) {
            $directory = [System.IO.DirectoryInfo]::new($path)
            if (-not $directory.Exists) {throw "Directory $path does not exist"}
            $size = 0
            $directory.EnumerateFiles('*.*', 'AllDirectories') | ForEach-Object {$size += $_.Length}
            return $size
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
                }finally {
                    if ($null -ne $rdb) {$rdb.Dispose()}
                }
            }finally {
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
            }finally {
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
                Where-Object {$_.Name -like '?:\'}|
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -Directory -ErrorAction SilentlyContinue -Force -Filter $Filter}
        }

        #File
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.FileInfo[]] File([string] $Filter) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'}|
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -File -ErrorAction SilentlyContinue -Force -Filter $Filter}
        }

        #FirstDirectory
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.DirectoryInfo] FirstDirectory([string] $Filter) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'}|
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -Directory -ErrorAction SilentlyContinue -Force -Filter $Filter}|
                        Select-Object -First 1
        }

        #FirstFile
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.FileInfo] FirstFile([string] $Filter) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'}|
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -File -ErrorAction SilentlyContinue -Force -Filter $Filter}|
                        Select-Object -First 1
        }

        #FirstFileWithString
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.FileInfo] FirstFileWithString([string] $Filter, [string] $Pattern) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'}|
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -File -ErrorAction SilentlyContinue -Force -Filter $Filter}|
                        Where-Object {(Select-String -Path $_ -Pattern $pattern -Quiet)}|
                            Select-Object -First 1
        }

        #FileWithString
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.FileInfo[]] FileWithString([string] $Filter, [string] $Pattern) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'}|
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -File -ErrorAction SilentlyContinue -Force -Filter $Filter}|
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
                Where-Object {$_.Name -like '?:\'}|
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -Directory -ErrorAction SilentlyContinue -Force -Filter $Filter}|
                        Select-Object -Last 1
        }

        #LastFile
        #------------------------------------------------------------------------------------------------------------------
        static [System.IO.FileInfo] LastFile([string] $Filter) {
            return [Find]::FixedDrives() |
                Where-Object {$_.Name -like '?:\'}|
                    ForEach-Object {Get-ChildItem -Path $_.Name -Recurse -File -ErrorAction SilentlyContinue -Force -Filter $Filter}|
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
                }finally {
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

        # ToBase62String
        #------------------------------------------------------------------------------------------------------------------
        [string] ToBase62String() {
            return [Base62]::Encode($this.HashedBytes)
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
                'Base62' {return $this.ToBase62String()}
                'Base64' {return $this.ToBase64String()}
                'Hex' {return $this.ToHexString()}
                'Base85' {return $this.ToBase85String()}
                'Base85Alternate' {return $this.ToBase85String($true)}
                'None' {return [System.Text.Encoding]::UTF8.GetString($this.HashedBytes)}
            }
            return $null
        }
    }

    #InstructionDefinition class
    #------------------------------------------------------------------------------------------------------------------
    class InstructionDefinition {
        [System.IO.FileInfo]$File
        [System.Xml.XmlNode]$Author
        [System.Xml.XmlNode]$Name
        [System.Xml.XmlNode]$ReadablePayload
        [System.Xml.XmlNode]$Description
        [System.Xml.XmlNode]$MinimumInstructionTtlMinutes
        [System.Xml.XmlNode]$MaximumInstructionTtlMinutes
        [System.Xml.XmlNode]$MinimumResponseTtlMinutes
        [System.Xml.XmlNode]$MaximumResponseTtlMinutes
        [System.Xml.XmlNode]$InstructionType
        [System.Xml.XmlNode]$InstructionTtlMinutes
        [System.Xml.XmlNode]$ResponseTtlMinutes
        [System.Xml.XmlNode]$Version
        [System.Xml.XmlNode]$xmlns
        [System.Xml.XmlNode]$Payload
        [System.Xml.XmlNode]$ResponseTemplateConfiguration
        [System.Xml.XmlNode]$Comments
        [System.Xml.XmlNode]$SchemaJson
        [System.Xml.XmlNode]$ParameterJson
        [System.Xml.XmlNode]$Resources
        [System.Xml.XmlNode]$TaskGroups
        [System.Xml.XmlNode]$Workflow
        [System.Xml.XmlNode]$AggregationJson
        [System.Xml.XmlNode]$Signature
        [xml]$xml
        [string]$OriginalHash
    
        # Constructors
    
        InstructionDefinition() {}
    
        # If passed a file, load the xml from the file
        InstructionDefinition([System.IO.FileInfo]$file) {
            $this.File = $file
            $this.xml = [xml](Get-Content $file.FullName)
            $this.Initialize()
        }
    
        # If passed an XML, use it directly
        InstructionDefinition([xml]$xml) {
            $this.xml = $xml
            $this.Initialize()
        }
    
        # If passed a string of XML, convert it to an XML object
        InstructionDefinition([string]$xml) {
            $this.xml = [xml]$xml
            $this.Initialize()
        }
    
        [void] Initialize() {
            # Create a namespace manager for better XPath queries
            $nsManager = New-Object System.Xml.XmlNamespaceManager($this.xml.NameTable)
            $nsManager.AddNamespace("ns", "http://schemas.1e.com/Tachyon/InstructionDefinition/1.0")
            # Get the attributes from the InstructionDefinition node (these are all passed by ref so changes to the class properties will be reflected in the xml)
            $node = $this.xml.SelectSingleNode("/ns:InstructionDefinition", $nsManager)
            $this.Author = $node.Attributes["Author"]
            $this.Name = $node.Attributes["Name"]
            $this.ReadablePayload = $node.Attributes["ReadablePayload"]
            $this.Description = $node.Attributes["Description"]
            $this.MinimumInstructionTtlMinutes = $node.Attributes["MinimumInstructionTtlMinutes"]
            $this.MaximumInstructionTtlMinutes = $node.Attributes["MaximumInstructionTtlMinutes"]
            $this.MinimumResponseTtlMinutes = $node.Attributes["MinimumResponseTtlMinutes"]
            $this.MaximumResponseTtlMinutes = $node.Attributes["MaximumResponseTtlMinutes"]
            $this.InstructionType = $node.Attributes["InstructionType"]
            $this.InstructionTtlMinutes = $node.Attributes["InstructionTtlMinutes"]
            $this.ResponseTtlMinutes = $node.Attributes["ResponseTtlMinutes"]
            $this.Version = $node.Attributes["Version"]
            $this.xmlns = $node.Attributes["xmlns"]
            # Get the other nodes
            $this.Payload = $this.xml.SelectSingleNode("/ns:InstructionDefinition/ns:Payload", $nsManager)
            $this.ResponseTemplateConfiguration = $this.xml.SelectSingleNode("/ns:InstructionDefinition/ns:ResponseTemplateConfiguration", $nsManager)
            $this.Comments = $this.xml.SelectSingleNode("/ns:InstructionDefinition/ns:Comments", $nsManager)
            $this.SchemaJson = $this.xml.SelectSingleNode("/ns:InstructionDefinition/ns:SchemaJson", $nsManager)
            $this.ParameterJson = $this.xml.SelectSingleNode("/ns:InstructionDefinition/ns:ParameterJson", $nsManager)
            $this.Resources = $this.xml.SelectSingleNode("/ns:InstructionDefinition/ns:Resources", $nsManager)
            $this.TaskGroups = $this.xml.SelectSingleNode("/ns:InstructionDefinition/ns:TaskGroups", $nsManager)
            $this.Workflow = $this.xml.SelectSingleNode("/ns:InstructionDefinition/ns:Workflow", $nsManager)
            $this.AggregationJson = $this.xml.SelectSingleNode("/ns:InstructionDefinition/ns:AggregationJson", $nsManager)
        }
    
        # Methods
        [void] IncrementVersion () {
            $this.Version
        }
    }    

    #Context class
    #------------------------------------------------------------------------------------------------------------------
    class Context {
        # This class is used to hold context information for logging or other audity uses
        [string]$ID
        [Device]$Device
        [OS]$OS
        [PowerShell]$PowerShell
        [Process]$Process
        [User]$User

        #Constructors
        #------------------------------------------------------------------------------------------------------------------
        Context() {
            $this.Device = [Device]::new()
            $this.OS = [OS]::new()
            $this.PowerShell = [PowerShell]::new()
            $this.Process = [Process]::new()
            $this.User = [User]::new()
            $this.ID = ([Hash]::new($this.ToString(), [Defaults]::ContextIDAlgorithm, [Defaults]::ContextIDFormat).ToString())
        }

        Context([HashAlgorithm]$Algorithm, [BinaryOutputType]$Format) {
            $this.Device = [Device]::new()
            $this.OS = [OS]::new()
            $this.PowerShell = [PowerShell]::new()
            $this.Process = [Process]::new()
            $this.User = [User]::new()
            $this.ID = ([Hash]::new($this.ToString(), $Algorithm, $Format).ToString())
        }

        #Methods
        #------------------------------------------------------------------------------------------------------------------
        [string] ToString() {
            return $this.Device.ToString()+"`n"+$this.OS.ToString()+"`n"+$this.PowerShell.ToString()+"`n"+$this.Process.ToString()+"`n"+$this.User.ToString()
        }
    }

    #LogEntry class
    #------------------------------------------------------------------------------------------------------------------
    class LogEntry {
        # This base class is used to hold log entries
        [System.DateTimeOffset]$Timestamp
        [LogLevel]$Level
        [string]$ContextID
        [string]$Message

        #Constructors
        #------------------------------------------------------------------------------------------------------------------
        LogEntry([string]$LogEntryString) {
            $fields = $LogEntryString.Split([Defaults]::FieldSeparator)
            if ($fields.Length -ne 4) {throw "Invalid log entry string: $LogEntryString`nExpected 4 fields, found $($fields.Length) fields."}
            $this.Timestamp = [System.DateTimeOffset]::Parse($fields[0])
            $this.ContextID = $fields[1]
            $this.Level = $fields[2]
            $this.Message = $fields[3]
        }

        LogEntry([string]$contextID, [LogLevel]$level, [string]$message) {
            $this.Timestamp = [System.DateTimeOffset]::Now
            $this.ContextID = $contextID
            $this.Level = $level
            $this.Message = $message
        }

        LogEntry([DateTimeOffset]$timestamp, [string]$contextID, [LogLevel]$level, [string]$message) {
            $this.Timestamp = $timestamp
            $this.ContextID = $contextID
            $this.Level = $level
            $this.Message = $message
        }

        #Methods
        #------------------------------------------------------------------------------------------------------------------
        [string] ToString() {
            return  $this.Timestamp.ToString("yyyy-MM-dd HH:mm:ss.fffffff zzz") + [Defaults]::FieldSeparator + $this.Context.ID + [Defaults]::FieldSeparator + $this.Level + [Defaults]::FieldSeparator + $this.Message + [Defaults]::RecordSeparator
        }

    }

    #Log class
    #------------------------------------------------------------------------------------------------------------------
    class Log {
        # Properties
        #==================================================================================================================
        [System.IO.FileInfo]$LogFile
        [int32]$LogMaxBytes = 10MB
        [int32]$LogMaxRollovers = 4 #in addition to the log file
        [System.IO.FileInfo[]]$RolloverLogs
        [int32]$TailLines = [Defaults]::LogTailLines
        [System.DateTimeOffset]$InstantiationTime = [System.DateTimeOffset]::Now
        [bool]$EchoMessages = $false
        [LogLevel]$LogLevel = [LogLevel]::Info
        [string]$FS = [Defaults]::FieldSeparator
        [string]$RS = [Defaults]::RecordSeparator
        [HashAlgorithm]$ContextIDAlgorithm = [Defaults]::ContextIDAlgorithm
        [BinaryOutputType]$ContextIDFormat = [Defaults]::ContextIDFormat
        [hashtable]$EchoColors = @{'Debug' = 'DarkGray';'Info' = 'Green';'Warn' = 'Yellow';'Error' = 'Red';'Fatal' = 'Magenta'}
        [Context]$Context
        [Box]$Box = [Box]::new([BoxStyle]::DoubleNoSides)

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

        # New log with specified name/location and echo messages flag
        Log([string]$logName, [bool]$echoMessages) {
            $this.LogFile = $this.NewFileInfo($logName)
            $this.EchoMessages = $echoMessages
            $this.Initialize()
        }

        # New log with all options passed in
        Log([System.IO.FileInfo]$LogFile,
            [int32]$LogMaxBytes,
            [int32]$LogMaxRollovers,
            [System.IO.FileInfo[]]$RolloverLogs,
            [int32]$TailLines,
            [System.DateTimeOffset]$InstantiationTime,
            [bool]$EchoMessages,
            [LogLevel]$LogLevel,
            [string]$FS,
            [string]$RS,
            [string]$ContextIDAlgorithm,
            [string]$ContextIDFormat,
            [hashtable]$EchoColors,
            [Context]$Context,
            [box]$Box 
        ) {
            $this.LogFile = $LogFile
            $this.LogMaxBytes = $LogMaxBytes
            $this.LogMaxRollovers = $LogMaxRollovers
            $this.RolloverLogs = $RolloverLogs
            $this.TailLines = $TailLines
            $this.InstantiationTime = $InstantiationTime
            $this.EchoMessages = $EchoMessages
            $this.LogLevel = $LogLevel
            $this.FS = $FS
            $this.RS = $RS
            $this.ContextIDAlgorithm = $ContextIDAlgorithm
            $this.ContextIDFormat = $ContextIDFormat
            $this.EchoColors = $EchoColors
            $this.Context = $Context
            $this.Box = $Box
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
                    Set-Content -Path $this.LogFile.FullName -Force -ErrorAction Stop -Encoding ([System.Text.Encoding]::UTF8) -Value '' -NoNewLine
                }
                catch {
                    # If we can't create the log file, fail
                    throw "Unable to create log file $($this.LogFile.FullName)`n$_"
                }
            }

            # Get the list of RollOver files
            $this.RolloverLogs = Get-ChildItem -Path $this.LogFile.Directory -Filter "$($this.LogFile.BaseName).*$($this.LogFile.Extension)" -File |
                Sort-Object -Property Name -Descending

            # If the ContextID isn't already in the log, write the context to the log
            $this.SyncContext()
            $this.LogFile.Refresh() # Refresh the file info to make sure the FileInfo object is up to date
        }
        

        # Methods
        #==================================================================================================================


        # ClearContent
        #------------------------------------------------------------------------------------------------------------------
        [void] ClearContent([bool]$ClearRollovers = $false) {
            # Clear the current log file
            Set-Content -Path $this.LogFile.FullName -Value '' -Force -Encoding $this.encodingName -NoNewLine

            # Clear the rollover logs
            if ($ClearRollovers) {
                foreach ($log in $this.RolloverLogs) {
                    try {
                        $log.Delete()
                    }
                    catch {
                        try {
                            # If we can't delete the log, try to clear it by setting the content to an empty string
                            Write-Warning "Unable to delete log file $($log.FullName). Attempting to clear it instead"
                            Set-Content -Path $log.FullName -Value '' -Force -Encoding $this.encodingName -NoNewline
                        }
                        catch {
                            # If we can't clear the log, write a warning
                            Write-Warning "Unable to clear log file $($log.FullName)"
                        }
                    }
                }
            }

        }

        # Debug
        #------------------------------------------------------------------------------------------------------------------
        [void] Debug([string] $Message) {
            $this.Write('Debug', $Message)
        }

        # Echo
        #------------------------------------------------------------------------------------------------------------------
        hidden [void] Echo([System.Array] $Message, [string] $Level) {
            $Message | ForEach-Object {
                $this.Echo($_, $Level)
            }
        }

        hidden [void] Echo([string] $Message, [string] $Level) {
            Write-Host "[$($this.LogFile.Name)]$($this.FS)$Message" -ForegroundColor $this.EchoColors[$Level] -NoNewline
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
        [LogEntry[]] FindInLog([string] $Pattern) {
            return $this.FindInLog($Pattern, '*', [DateTimeOffset]::MinValue, [DateTimeOffset]::MaxValue, '*')
        }

        # Finds a string in the log between two dates
        [LogEntry[]] FindInLog([string] $Pattern, [DateTimeOffset] $Start, [DateTimeOffset] $End) {
            return $this.FindInLog($Pattern, '*', $Start, $End, '*')
        }
        
        # Finds a string in the log of a specific level
        [LogEntry[]] FindInLog([string] $Pattern, [string] $Level) {
            return $this.FindInLog($Pattern, $Level, [DateTimeOffset]::MinValue, [DateTimeOffset]::MaxValue, '*')
        }

        # Finds a string in the log with a specific level and contextHash between two dates
        [LogEntry[]] FindInLog([string] $Pattern, [string] $Level, [DateTimeOffset] $Start, [DateTimeOffset] $End, [string]$ContextHash) {
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
                                [LogEntry]::new($fields[0], $fields[1], $fields[2], $fields[3])
                            }
                        } | Where-Object {
                            $_.Message -like $Pattern -and $_.Level -like $Level -and $_.ContextHash -like $ContextHash -and [DateTimeOffset]$_.TimeStamp -ge $Start -and [DateTimeOffset]$_.TimeStamp -le $End
                        } # Only return those records that match the pattern in the message
            } else {
                return [LogEntry[]]@()
            }                

        }

        # GetContent
        #------------------------------------------------------------------------------------------------------------------
        [LogEntry[]] GetContent() {
            # If the properties haven't been cleared, and the log exists, tail the log and return the result
            if ($this.LogFile.FullName -and (Test-Path -Path $this.LogFile.FullName)) {
                # Parse the log file into records using the record separator
                return (Get-Content -Path $this.LogFile.FullName -Raw) -split $this.RS |
                    # Parse each record into fields using the field separator
                    ForEach-Object {
                        $fields = ($_ -split $log.FS).ForEach({$_.Trim()})
                        if ($fields.Count -eq 4) {
                            [LogEntry]::new($fields[0], $fields[1], $fields[2], $fields[3])
                        }
                }                    
            } else {
                return [LogEntry[]]@()
            }
        }


        # Info
        #------------------------------------------------------------------------------------------------------------------
        [void] Info([string] $Message) {
            $this.Write('Info', $Message)
        }

        # NewEntryString
        #------------------------------------------------------------------------------------------------------------------
        [string] NewEntryString([LogLevel]$Level, [string]$Message) {
            return "{0}{1}[{2}]{3}{4}{5}{6}{7}" -f [DateTimeOffset]::Now.ToString("yyyy-MM-dd HH:mm:ss.fffffff zzz"), $this.FS, $this.Context.ID, $this.FS, $Level, $this.FS, $Message, $this.RS
        }

        # Overload for NewEntryString using custom datetimeoffset
        [string] NewEntryString([DateTimeOffset]$DateTimeOffset, [LogLevel]$Level, [string]$Message) {
            return "{0}{1}[{2}]{3}{4}{5}{6}{7}" -f $DateTimeOffset.ToString("yyyy-MM-dd HH:mm:ss.fffffff zzz"), $this.FS, $this.Context.ID, $this.FS, $Level, $this.FS, $Message, $this.RS
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
                        $retryCount = 0
                        $success = $false
                        while ($retryCount -lt 5 -and -not $success) {
                            try {
                                # Try to rename the log file to the next highest rollover
                                Rename-Item -Path $oldLog -NewName $newLog -Force -ErrorAction Stop
                                $success = $true
                            } catch {
                                # Increment retry count and pause if not successful
                                Start-Sleep -Seconds 1
                                $retryCount++
                            }
                        }
                    
                        if (-not $success) {
                            # if we can't rename the log, try to copy its contents to the next highest rollover this is a last-ditch effort
                            # to preserve the log contents if we can't rename the file for some reason like when the file is in use by 
                            # another process or the folder it is in has delete protection but we can still write to the file. This is more 
                            # disk intensive than a rename, but it's better than losing the log contents.
                            $firstError = $_
                            try {
                                Get-Content -Path $oldLog -Raw -Force -ErrorAction Stop |
                                    Set-Content -Path $newLog -Force -ErrorAction Stop -Encoding $this.encodingName -NoNewLine
                            } catch {
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
                        Get-Content -Path $this.LogFile.FullName -Raw -Force -ErrorAction Stop | Set-Content -Path $newLog -Encoding $this.encodingName -Force -ErrorAction Stop -NoNewLine
                    }
                    catch {
                        Write-Error $firstError
                        Write-Error $_
                        throw "Unable to rollover $($this.LogFile.FullName) --> $newLog"
                    }
                    # clear the log file contents since we couldn't rename it
                    for ($i = 0; $i -lt 5; $i++) {
                        # try to clear the log file contents up to 5 times
                        try {
                            Set-Content -Path $this.LogFile.FullName -Value '' -Force -Encoding $this.encodingName -ErrorAction Stop -NoNewLine
                        }
                        catch {}
                        $this.LogFile.Refresh()
                        if ($this.LogFile.Length -eq 0) {break}
                        Start-Sleep -Seconds 1
                    }
                }
        }

        # Size
        #------------------------------------------------------------------------------------------------------------------
        [int] Size() {
            $this.LogFile.Refresh()
            return $this.LogFile.Length
        }

        # Tail
        #------------------------------------------------------------------------------------------------------------------
        [string[]] Tail([int] $lines) {
            # If the properties haven't been cleared, and the log exists, tail the log and return the result
            if ($this.LogFile.FullName -and (Test-Path -Path $this.LogFile.FullName)) {
                # Parse the log file into records using the record separator
                return (Get-Content -Path $this.LogFile.FullName -Raw) -split $this.RS |
                    # Remove any empty records
                    Where-Object {$_}|
                        # Get the last $lines records
                        Select-Object -Last $lines 
            }else {
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
                LOG_FIELD_SEPARATOR = $this.FS.ToEscapedString()
                LOG_RECORD_SEPARATOR = $this.RS.ToEscapedString()
            }).ToString()
        }

        # Overload for Tail using default TailLines property
        [string[]] Tail() {
            return $this.Tail($this.TailLines)
        }

        # SyncContext
        #------------------------------------------------------------------------------------------------------------------
        [void] SyncContext() {
            # Get the current logging context into this object
            $this.Context = [Context]::new($this.ContextIDAlgorithm, $this.ContextIDFormat)
            # Write the log info and context to the log if it's not already there
            if (-not (Select-String -Path $this.LogFile -Pattern ($this.Context.ID) -Quiet)) {
                $msgList = [System.Collections.Generic.List[String]]@()
                $msgList.Add($this.Box.DrawTop(' CONTEXT '))
                foreach ($line in $this.ToString().Split("`n")) {$msgList.Add($line.AddIndent(2))}
                $msgList.Add("CONTEXT_ID: $($this.Context.ID)".AddIndent(2))
                foreach ($line in $this.Context.ToString().Split("`n")) {$msgList.Add($line.AddIndent(2))}
                $msgList.Add($this.Box.DrawBottom(' CONTEXT '))
                $this.Write('Info', $msgList)
            }
        }

        # Warn
        #------------------------------------------------------------------------------------------------------------------
        [void] Warn([string] $Message) {
            $this.Write('Warn', $Message)
        }

        # Write
        #------------------------------------------------------------------------------------------------------------------
        hidden [void] Write([LogLevel] $Level = 'Info', [string] $Message) {
            $this.LogFile.Refresh() #refresh size info
            if (($this.LogFile.Length ?? 0) -eq 0) {$this.Initialize()} #if the log file is empty, re-initialize it (this can happen if the log file is deleted externally)
            # Build the log entry string
            $msg = $this.NewEntryString($Level, $Message)
            #see if the message will make the log exceed the LogMaxBytes property
            $msgByteCount = [system.text.encoding]::utf8.GetByteCount($msg)
            if ($msgByteCount -ge $this.LogMaxBytes) {throw "This message alone exceeds the LogMaxBytes property and can't be written"}
            if (($msgByteCount + $this.LogFile.Length) -ge $this.LogMaxBytes) {
                $this.RollOver() # if it will exceed the LogMaxBytes, rollover the log
                $this.Initialize() #re-initialize the log
                $msg = $this.NewEntryString($Level, $Message) #generate the log entry we were going to write since some time has elapsed
            }
            # Write the message to the log
            Out-File -FilePath $this.LogFile.FullName -InputObject $msg -Append -Encoding $this.encodingName -ErrorAction Stop -Force -NoNewline

            # Echo the message to the console if EchoMessages is true
            if ($this.EchoMessages) {$this.Echo($msg, $level)}
        }

        # overload to write an array of messages
        [void] Write([LogLevel] $Level = 'Info',[System.Array] $Messages) {
            $this.LogFile.Refresh() # Refresh file info to get the latest file size
            if ($this.LogFile.Length -eq 0) {$this.Initialize()} #if the log file is empty, re-initialize it (this can happen if the log file is deleted externally)
            $availableSpace = $this.LogMaxBytes - $this.LogFile.Length
        
            $msgList = New-Object System.Collections.Generic.List[string]
            $totalSizeOfMessages = 0
        
            foreach ($message in $Messages) {
                $msg = $this.NewEntryString($Level, $message)
                $msgSize = [System.Text.Encoding]::UTF8.GetByteCount($msg)
        
                # Error out if the message alone exceeds the LogMaxBytes property
                if ($msgSize -ge $this.LogMaxBytes) {throw "This message alone exceeds the LogMaxBytes property and can't be written"}
                # If adding the new message will exceed the LogMaxBytes property, rollover and reinitialize
                if ($totalSizeOfMessages + $msgSize -gt $availableSpace) {
                    # Write accumulated messages to the log file before rolling over
                    if ($msgList.Count -gt 0) {
                        $batchedMessage = $msgList -join ''
                        Out-File -FilePath $this.LogFile.FullName -InputObject $batchedMessage -Append -Encoding $this.encodingName -ErrorAction Stop -Force -NoNewline
                        # Echo the batched messages so far if EchoMessages is true
                        if ($this.EchoMessages) {$this.Echo($batchedMessage)}
                        $msgList.Clear() # Clear the list after writing
                    }
                    # Rollover and reinitialize
                    $this.RollOver()
                    $this.Initialize()
                    $this.LogFile.Refresh() # Refresh to get the new file's size
                    $availableSpace = $this.LogMaxBytes - $this.LogFile.Length
                    # Add the message that was in-flight when the rollover occurred to the list
                    $msgList.Add($msg)
                    $totalSizeOfMessages = $msgSize
                }
                else {
                    # Add each message to the list and increment the total size of messages in the list
                    $msgList.Add($msg)
                    $totalSizeOfMessages += $msgSize
                }
            }
        
            # After processing all messages, write any remaining messages in the list to the log
            if ($msgList.Count -gt 0) {
                $batchedMessage = $msgList -join ''
                Out-File -FilePath $this.LogFile.FullName -InputObject $batchedMessage -Append -Encoding $this.encodingName -ErrorAction Stop -Force -NoNewline
                # Echo the batched messages so far if EchoMessages is true
                if ($this.EchoMessages) {$this.Echo($msgList, $level)}
            }
        }

        # WriteTopLine
        #------------------------------------------------------------------------------------------------------------------
        [void] WriteTopLine([LogLevel]$Level, [string] $Message) {
            $this.Write($Level, $this.Box.DrawTop($Message))
        }

        # WriteMiddle
        #------------------------------------------------------------------------------------------------------------------
        [void] WriteMiddle([LogLevel]$Level, [string] $Message) {
            $this.Write($Level, $this.Box.DrawMiddle($Message))
        }

        # WriteLine
        #------------------------------------------------------------------------------------------------------------------
        [void] WriteLine([LogLevel]$Level, [string] $Message) {
            $this.Write($Level, $this.Box.DrawLine($Message))
        }

        # WriteBottomLine
        #------------------------------------------------------------------------------------------------------------------
        [void] WriteBottomLine([LogLevel]$Level, [string] $Message) {
            $this.Write($Level, $this.Box.DrawBottom($Message))
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

    #Retry class
    #------------------------------------------------------------------------------------------------------------------
    class Retry {

        # static method to immediately invoke a script block and retry a specified number of times with a specified delay between retries
        static [bool] Invoke([int]$attempts, [int]$delay, [scriptblock]$scriptBlock) {
            $tried = 0
            while ($tried -lt $attempts) {
                try {
                    $scriptBlock.Invoke()
                    return $true
                }
                catch {
                    $tried++
                    if ($tried -lt $attempts) {
                        Start-Sleep -Seconds $delay
                    }
                    else {
                        return $false
                    }
                }
            }
            return $false
        }

        # Instance part of the class for times you need have different retry settings for different script blocks or reuse the same settings
        [int]$Attempts
        [int]$Delay
        [scriptblock]$ScriptBlock

        #Constructors
        #------------------------------------------------------------------------------------------------------------------
        Retry([int]$attempts, [int]$delay, [scriptblock]$scriptBlock) {
            $this.Attempts = $attempts
            $this.Delay = $delay
            $this.ScriptBlock = $scriptBlock
        }

        #Methods
        #------------------------------------------------------------------------------------------------------------------
        [void] Start() {
            $tried = 0
            while ($tried -lt $this.Attempts) {
                try {
                    $this.ScriptBlock.Invoke()
                    break
                }
                catch {
                    $tried++
                    if ($tried -lt $this.Attempts) {
                        Start-Sleep -Seconds $this.Delay
                    }
                    else {
                        throw $_
                    }
                }
            }
        }
    }

    #RetryResult class
    #------------------------------------------------------------------------------------------------------------------
    class RetryResult {
        [bool]$Success
        [int]$Attempts
        [int]$Delay
        [scriptblock]$ScriptBlock
        [object]$Result
        [object]$Err

        #Constructors
        #------------------------------------------------------------------------------------------------------------------
        RetryResult([bool]$success, [int]$attempts, [int]$delay, [scriptblock]$scriptBlock, [object]$result, [object]$err) {
            $this.Success = $success
            $this.Attempts = $attempts
            $this.Delay = $delay
            $this.ScriptBlock = $scriptBlock
            $this.Result = $result
            $this.Error = $err
        }

        #Methods
        #------------------------------------------------------------------------------------------------------------------
        [string] ToString() {
            return ([ordered]@{
                SUCCESS = $this.Success
                ATTEMPTS = $this.Attempts
                DELAY = $this.Delay
                SCRIPT_BLOCK = $this.ScriptBlock.ToString()
                RESULT = $this.Result
                ERROR = $this.Err
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
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName IsHex -Force -Value {
        ($this.Length % 2 -eq 0) -and ($this -match '^[0-9A-Fa-f]+$')
    }

    #LengthOfLongestLine
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName LengthOfLongestLine -Force -Value {
        ($this -split "\r?\n" | Measure-Object -Property Length -Maximum).Maximum
    }

    #ToBase62
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToBase62 -Force -Value {
        [Base62]::Encode([System.Text.Encoding]::UTF8.GetBytes($this ?? ''))
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
        if ([string]::IsNullOrEmpty($this)) {return $this}
        $InputString = $this -replace "`t", '`t' -replace "`r", '`r' -replace "`n", '`n'
        $escapedString = [Text.StringBuilder]::new()
        foreach ($char in $InputString.ToCharArray()) {
            $unicodeCategory = [Char]::GetUnicodeCategory($char)
            switch ($unicodeCategory) {
               {$_ -in 'Control', 'Surrogate', 'OtherNotAssigned', 'LineSeparator', 'ParagraphSeparator', 'Format', 'SpaceSeparator'}{
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

    #ToXmlEscapedString
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName ToXmlEscapedString -Force -Value {
        [System.Security.SecurityElement]::Escape($this)
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
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName IsNullOrEmpty -Force -Value {
        [string]::IsNullOrEmpty($this)
    }
    

    #IsNullOrWhiteSpace
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName IsNullOrWhiteSpace -Force -Value {
        [string]::IsNullOrWhiteSpace($this)
    }
      

    #MD5
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName MD5 -Force -Value {
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
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName SHA1 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA1', $format)
    }
    

    #SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName SHA256 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA256', $format)
    }
    

    #SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName SHA384 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA384', $format)
    }
    

    #SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.String -MemberType ScriptMethod -MemberName SHA512 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA512', $format)
    }
    
    #endregion    
#╚══════════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND String ═╝

#╔═ EXTEND BYTE[] ══════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.Byte[] class with additional common properties and methods

    #ToBase62
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptMethod -MemberName ToBase62 -Force -Value {
        [Base62]::Encode($this)
    }

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
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptMethod -MemberName MD5 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'MD5', $format)
    }
    

    #SHA1
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptMethod -MemberName SHA1 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA1', $format)
    }
    

    #SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptMethod -MemberName SHA256 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA256', $format)
    }
    

    #SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptMethod -MemberName SHA384 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA384', $format)
    }
    

    #SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Byte[] -MemberType ScriptMethod -MemberName SHA512 -Force -Value {
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
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptMethod -MemberName MD5 -Force -Value {
        $this.ToString().MD5()
    }

    # RemoveNullOrEmptyKeys
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptMethod -MemberName RemoveNullOrEmptyKeys -Force -Value {
        $keysToRemove = $this.GetEnumerator() | Where-Object {[string]::IsNullOrEmpty($_.Value) } | ForEach-Object { $_.Key }
        $keysToRemove | ForEach-Object { $this.Remove($_) }
    }

    # SHA1
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptMethod -MemberName SHA1 -Force -Value {
        $this.ToString().SHA1()
    }

    # SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptMethod -MemberName SHA256 -Force -Value {
        $this.ToString().SHA256()
    }

    # SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptMethod -MemberName SHA384 -Force -Value {
        $this.ToString().SHA384()
    }

    # SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Hashtable -MemberType ScriptMethod -MemberName SHA512 -Force -Value {
        $this.ToString().SHA512()
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
            $node.InnerText = if($_.Value -is [System.Array]) { $_.Value -join ',' }else { $_.Value }
            [void]$root.AppendChild($node)
        }| Out-Null
        $xml.OuterXml
    }

    #endregion
#╚═══════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND Hashtable ═╝

#╔═ EXTEND OrderedDictionary ═══════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # This section extends the System.Collections.Specialized.OrderedDictionary class with additional common properties and methods

    # MD5
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptMethod -MemberName MD5 -Force -Value {
        $this.ToString().MD5()
    }

    # RemoveNullOrEmptyKeys
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptMethod -MemberName RemoveNullOrEmptyKeys -Force -Value {
        $keysToRemove = $this.GetEnumerator() | Where-Object {[string]::IsNullOrEmpty($_.Value) } | ForEach-Object { $_.Key }
        $keysToRemove | ForEach-Object { $this.Remove($_) }
    }
    
    # SHA1
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptMethod -MemberName SHA1 -Force -Value {
        $this.ToString().SHA1()
    }

    # SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptMethod -MemberName SHA256 -Force -Value {
        $this.ToString().SHA256()
    }

    # SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptMethod -MemberName SHA384 -Force -Value {
        $this.ToString().SHA384()
    }

    # SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Collections.Specialized.OrderedDictionary -MemberType ScriptMethod -MemberName SHA512 -Force -Value {
        $this.ToString().SHA512()
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
            $node.InnerText = if($_.Value -is [System.Array]) { $_.Value -join ',' }else { $_.Value }
            [void]$root.AppendChild($node)
        }| Out-Null
        $xml.OuterXml
    }
        
    #endregion
#╚═══════════════════════════════════════════════════════════════════════════════════════════ EXTEND OrderedDictionary ═╝

#╔═ EXTEND SecureString ════════════════════════════════════════════════════════════════════════════════════════════════╗    
    #region
    # This section extends the System.Security.SecureString class with additional common properties and methods

    #MD5
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptMethod -MemberName MD5 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'MD5', $format)
    }

    #SHA1
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptMethod -MemberName SHA1 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA1', $format)
    }
    

    #SHA256
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptMethod -MemberName SHA256 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA256', $format)
    }
    

    #SHA384
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptMethod -MemberName SHA384 -Force -Value {
        param ([BinaryOutputType] $format = ([Defaults]::BinaryOutputType))
        [Hash]::new($this, 'SHA384', $format)
    }
    

    #SHA512
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Security.SecureString -MemberType ScriptMethod -MemberName SHA512 -Force -Value {
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

#╔ EXTEND Version ══════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region                                                                                                            
    # This section extends the System.Version class with additional common properties and methods

    # From DateTime
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Version -MemberType ScriptMethod -MemberName FromDateTime -Force -Value {
        param ([datetime] $dateTime = (Get-Date -AsUTC))
        # format: A.B.C.D where:
        # A = YYYYMM
        # B = DDHH
        # C = MMSS
        # D = (always) 1
        # A - Year and Month (6 digits)
        $yearMonthSegment = ($dateTime.Year.ToString() + $dateTime.Month.ToString("00"))
        # B - Day and Hour (4 digits)
        $dayHourSegment = ($dateTime.Day.ToString("00") + $dateTime.Hour.ToString("00"))
        # C - Minute and Second (4 digits)
        $minuteSecondSegment = ($dateTime.Minute.ToString("00") + $dateTime.Second.ToString("00"))
        # D - Default to 1
        $incrementingSegment = 1
        [Version]::new("$yearMonthSegment.$dayHourSegment.$minuteSecondSegment.$incrementingSegment")
    }

    # Increment
    #------------------------------------------------------------------------------------------------------------------
    Update-TypeData -TypeName System.Version -MemberType ScriptMethod -MemberName Increment -Force -Value {
        param([int] $IncrementBy = 1)
        $segments = $this.ToString().Split('.')
        $segments[-1] = [int]$segments[-1] + $IncrementBy
        [Version]::new($segments -join '.')
    }

    #endregion                                                                                                         
#╚══════════════════════════════════════════════════════════════════════════════════════════════════════ EXTEND Version ╝

#╔ Functions ═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region

    # New-Box
    #------------------------------------------------------------------------------------------------------------------
    function New-Box {
        [CmdletBinding()]
        [OutputType([Box])]
        param (
            [BoxStyle]$Style = [BoxStyle]::Single
        )
        return [Box]::new($Style)
    }

    # New-Log
    #------------------------------------------------------------------------------------------------------------------
    function New-Log {
        [CmdletBinding()]
        [OutputType([Log])]
        param (
            [string]$LogFileSpecifier = 'Log',
            [int]$MaxBytes = 10MB,
            [int]$MaxRollovers = 5,
            [bool]$EchoMessages = $true
        )
        $log = [Log]::new($LogFileSpecifier)
        $log.LogMaxBytes = $MaxBytes
        $log.LogMaxRollovers = $MaxRollovers
        $log.EchoMessages = $EchoMessages
        return $log
    }    

    # Test-Connected
    #------------------------------------------------------------------------------------------------------------------
    function Test-Connected {
        [CmdletBinding()]
        [OutputType([bool])]
        param (
            [string]$1eServer
        )
        #try to run something benign that expects a connection to the 1E server
        try {
            [void](Get-1ESystemStatistics -ErrorAction Stop -WarningAction Stop);
            return $true
        }
        catch {
            return $false
        }

    }

    #endregion                                                                                                             
#╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════ Functions ╝

#╔═ Script ═════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
    #region


        # Setup some defaults
        Import-Module .\Cs1eToolkit.psd1 -Force -Verbose
        $ProgressPreference = 'SilentlyContinue' # so we don't show progress bars on anything like unzipping or WMI queries

        # List of 1E platform instances
        $instances = @(
            [Instance]::new('Dev','1eplatform.dex.local'),
            [Instance]::new('Test','1eplatform.dex.local'),
            [Instance]::new('Prod','1eplatform.dex.local')
        )

        # Instantiate a migration project
        $mig = [Migration]::new($instances)
        # Remove all but the last export folder
        $mig.RemoveOldExports(1)
        # Export the objects (will prompt for the instance and objects to export)
        $mig.Export()
    #endregion
#╚═════════════════════════════════════════════════════════════════════════════════════════════════════════════ Script ═╝