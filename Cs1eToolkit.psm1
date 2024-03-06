# This file is meant to be viewed in VSCode.  It is not intended to be run directly.
# Use CTRL+K CTRL+0 collapse all outlined sections for better readability.
#
# Module: Cs1eToolkit
# Author: John.Nelson@1e.com
# Version: 202312.1823.2950.1
#
# This module contains all of the functions and classes that are used by the 1E Customer Success team

#region Variables
# Define the ASCII control characters, but instead of using the actual control characters, we use their symbolic representations
# this allows us to see them in the code and makes it easier to understand what they are, but they are valid XML characters which
# could be used in XML files or other text files where the actual control characters would not be valid.  Important for logging
# where we delineate each log entry with a record separator character (RS) and each field within the log entry with a unit 
# separator character (US).  This allows us to parse the log file easily and programmatically.
$FS = [char]0x241C  # Field Separator symbol
$GS = [char]0x241D  # Group Separator symbol
$RS = [char]0x241E  # Record Separator symbol
$US = [char]0x241F  # Unit Separator symbol

#endregion Variables

#region Classes

class CsLog : System.IDisposable {
    [string] $LogFilePath
    [System.IO.StreamWriter] $LogWriter
    [int64] $MaxSize = 10MB  # Default max log size
    [int] $MaxRollovers = 5  # Default max number of rollover logs
    [System.Collections.Hashtable]$ValidLevels # Valid log levels

    # Private members
    hidden [TimeZoneInfo] $localTimeZone = [TimeZoneInfo]::Local
    hidden [System.Collections.Hashtable] $abbreviationMap

    CsLog() {
        $defaultLogFileName = $MyInvocation.MyCommand.Name -replace '\.ps1$', ''
        if (-not $defaultLogFileName) {
            $defaultLogFileName = (Get-Date -Format "yyyy.MM.dd.HH.mm.ss.fffffff")
        }
        $this.LogFilePath = "$env:ProgramData\1E\CsLogs\$($defaultLogFileName).log"
        $this.InitializeLog()
    }

    CsLog([string] $FilePath) {
        if (-not [System.IO.Path]::IsPathRooted($FilePath)) {
            $FilePath = "$env:ProgramData\1E\CsLogs\$FilePath"
        }

        if (-not $FilePath.EndsWith(".log")) {
            $FilePath += ".log"
        }

        $this.LogFilePath = $FilePath
        $this.InitializeLog()
    }

    [void] InitializeLog() {
        # Initialize the local time zone
        $this.abbreviationMap = @{
            $true = $this.localTimeZone.DaylightName
            $false = $this.localTimeZone.StandardName
        }

        # Initialize the valid log levels
        $this.ValidLevels = @{
            "VERBOSE" = $true
            "INFO" = $true
            "WARN" = $true
            "ERROR" = $true
        }        

        $logDirectory = [System.IO.Path]::GetDirectoryName($this.LogFilePath)
        if (-not [System.IO.Directory]::Exists($logDirectory)) {
            [System.IO.Directory]::CreateDirectory($logDirectory)
        }
    
        $fileStream = [System.IO.File]::Open(
            $this.LogFilePath, 
            [System.IO.FileMode]::OpenOrCreate, # Open the file or create if it doesn't exist
            [System.IO.FileAccess]::ReadWrite,  # Allow reading and writing
            [System.IO.FileShare]::ReadWrite)   # Allow other processes to read/write
    
        $fileStream.Seek(0, [System.IO.SeekOrigin]::End) # Seek to the end of the file
    
        $this.LogWriter = New-Object System.IO.StreamWriter $fileStream
        $this.LogWriter.AutoFlush = $true # Flush the buffer after every write

        # If this is an empty rollover or new log, Write the log header
        if ($this.GetLogSize() -eq 0) {
            Write-Verbose 'Initializing new log. Writing log header.'
            $this.WriteLogHeader()
        }
    }    
    
    [void] WriteVerbose([string] $Message) {
        $this.Write($Message, "VERBOSE",$null)
    }

    [void] WriteInfo([string] $Message) {
        $this.Write($Message, "INFO",$null)
    }

    [void] WriteWarning([string] $Message) {
        $this.Write($Message, "WARN",$null)
    }

    [void] WriteError([string] $Message) {
        $this.Write($Message, "ERROR",$null)
    }

    # Overload for writing a message with level and context
    [void] Write([string] $Message, [string] $Level = 'INFO', [string] $Context = ' ') {
        # Check to see if adding this message will cause the log to rollover, rollover if necessary
        $this.RotateLog([System.Text.Encoding]::UTF8.GetByteCount($Message))

        # Validate a valid log level was specified
        if (-not $this.validLevels[$Level]) {$Level = 'INFO'}

        # Handle null or empty context
        if ([string]::IsNullOrWhiteSpace($Context)) {$Context = ' '}

        # Write the message to the log file
        $now = [DateTime]::UtcNow
        $localTime = $now.ToLocalTime()

        # Use hashtable to determine abbreviation without explicit if/else
        $abbreviation = $this.abbreviationMap[$this.localTimeZone.IsDaylightSavingTime($localTime)]

        $logEntry = "[{0:yyyy-MM-dd HH:mm:ss.fffffff}][{1:yyyy-MM-dd HH:mm:ss.fffffff} {2}] [$Level] [$Context] $Message" -f $now, $localTime, $abbreviation
        $this.LogWriter.WriteLine($logEntry)
    }

    # Overload for writing a message with a level
    [void] Write([string] $Message, [string] $Level) {
        $this.Write($Message, $Level, $null)
    }
    
    # Overload for writing a message with default level and context
    [void] Write([string] $Message) {
        $this.Write($Message, $null, $null)
    }    

    # Close the log file and dispose of the StreamWriter object
    [void] Close() {
        $this.Dispose()
    }

    # Close the log file and dispose of the StreamWriter object
    [void] Dispose() {
        if ($this.LogWriter) {
            try {
                $this.LogWriter.Close()
            } finally {
                $this.LogWriter.Dispose()
            }
            $this.LogWriter = $null
        }
    }

    # Method to return the size of the log file
    [int64] GetLogSize() {if ([System.IO.File]::Exists($this.LogFilePath)) {return [System.IO.FileInfo]::new($this.LogFilePath).Length} else {return 0}}

    # NewSeparator method adapted from New-Separator function
    [string] NewSeparator([string] $Type = 'Double', [int] $Length = 100, [string] $Name) {
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

        if ($Type -in @('SingleTop', 'SingleBottom', 'DoubleTop', 'DoubleBottom', 'ThickTop', 'ThickBottom')) {
            $leftChar = $separatorChars[$Type][0]
            $middleChar = $separatorChars[$Type][1]
            $rightChar = $separatorChars[$Type][2]
            if ([string]::IsNullOrEmpty($Name)) {
                $middleChar = $middleChar * ($Length - 2)
                return $leftChar + $middleChar + $rightChar
            } else {
                $name = $name.ToUpper()
                $adjustedLength = $length - 2 - $name.Length
                if ($adjustedLength -lt 0) {
                    throw "Length is too short to include the name"
                }
                $middle = $middleChar * 2 + $name + $middleChar * ($adjustedLength - 1)
                return $leftChar + $middle + $rightChar
            }
        } else {
            return $separatorChars[$Type] * $Length
        }
    }

    # Method to try moving a file with retries (useful for log rotation)
    [void] TryMoveFile($source, $destination) {
        $maxRetries = 5
        $delay = 500 # milliseconds

        for ($i = 0; $i -lt $maxRetries; $i++) {
            try {
                [System.IO.File]::Move($source, $destination)
                break
            } catch {
                Start-Sleep -Milliseconds $delay
            }
        }
    }

    # Method to try deleting a file with retries (useful for log rotation)
    [void] TryDeleteFile($file) {
        $maxRetries = 5
        $delay = 500 # milliseconds

        for ($i = 0; $i -lt $maxRetries; $i++) {
            try {
                [System.IO.File]::Delete($file)
                break
            } catch {
                Start-Sleep -Milliseconds $delay
            }
        }
    }

    # Method to write the log header on new/rollover logs
    hidden [void] WriteLogHeader() {    
        # Format Output
        $output = @"
$($this.NewSeparator('DoubleTop',32,$null))
  NEW LOG: $([System.IO.FileInfo]::new($this.LogFilePath).CreationTime)
$($this.NewSeparator('Double',32,$null))
$($this.NewSeparator('DoubleTop',80,'System Information'))
$($this.NewSeparator('DoubleBottom',80,'System Information'))
"@
        $this.LogWriter.WriteLine($output)
    }        

    
    # Method to check the log size and rotate if necessary
    [void] RotateLog([int32]$AddedBytes = 0) {
        $logSize = [System.IO.FileInfo]::new($this.LogFilePath).Length + $AddedBytes

        if ($logSize -gt $this.maxSize) {
            # Close and dispose the current StreamWriter
            if ($this.LogWriter) {
                $this.LogWriter.Close()
                $this.LogWriter.Dispose()
                $this.LogWriter = $null # Clear the object
            }

            # Rotate the log files
            for ($i = $this.maxRollovers - 1; $i -gt 0; $i--) {
                $oldLog = "$($this.LogFilePath).$i"
                $newLog = "$($this.LogFilePath).$($i + 1)"
                if ([System.IO.File]::Exists($oldLog)) {
                    $this.TryMoveFile($oldLog, $newLog)
                }
            }

            # Rename the current log file to the first rollover
            $this.TryMoveFile($this.LogFilePath, "$($this.LogFilePath).1")

            # Delete the oldest log file if it exists
            $oldestLog = "$($this.LogFilePath).$($this.maxRollovers)"
            if ([System.IO.File]::Exists($oldestLog)) {
                $this.TryDeleteFile($oldestLog)
            }

            # Reinitialize log for a new file
            $this.InitializeLog()
        }
    }

    static [void] Help() {
        Write-Host @'
[CsLog] Class

.SYNOPSIS
A class for handling script logging in PowerShell.

.DESCRIPTION
    The CsLog class provides an easy way to create and manage log files for PowerShell scripts.
    It supports features like verbose, info, warning, and error message logging, log rotation based on size,
    and customizable logging levels.

    Simply create a new instance of the CsLog class, write your messages, and close the log when you're done.

.PARAMETER LogFilePath
    Specifies the path of the log file.

.PARAMETER MaxSize
    Sets the maximum size of the log file before it is rolled over. Default is 10MB.

.PARAMETER MaxRollovers
    Specifies the maximum number of rollover log files to keep. Default is 5.

.EXAMPLE
    $logger = [CsLog]::new("C:\logs\mylog.log")
    $logger.WriteInfo("This is an info message.")
    $logger.Close()

    This example creates a new instance of CsLog where the file is in c:\logs\mylog.log, writes an info message to the log, and then closes the log.

.EXAMPLE
    $logger = [CsLog]::new("C:\logs\mylog.log")
    $logger.WriteWarning("This is a warning message.")
    $logger.Close()

    This example creates a new instance of CsLog where the file is in c:\logs\mylog.log, writes a warning message to the log, and then closes the log.

.EXAMPLE
    $logger = [CsLog]::new("C:\logs\mylog.log")
    $logger.WriteError("This is an error message.")
    $logger.Close()

    This example creates a new instance of CsLog where the file is in c:\logs\mylog.log, writes an error message to the log, and then closes the log.

.EXAMPLE
    $logger = [CsLog]::new("stuff")
    $logger.WriteVerbose("This is a verbose message.")
    $logger.Close()

    This example creates a new instance of CsLog, writes a verbose message to the log, and then closes the log.
    Here there is no directory nor extension specified, so the log file will be created in C:\ProgramData\1E\CsLogs\stuff.log.

.EXAMPLE
    $logger = [CsLog]::new("stuff")
    $logger.Write("This is a custom message.")
    $logger.Close()

    This example creates a new instance of CsLog, writes a custom message to the log, and then closes the log.
    Here there is no directory nor extension specified, so the log file will be created in C:\ProgramData\1E\CsLogs\stuff.log.

.EXAMPLE
    $logger = [CsLog]::new()
    $logger.Write("This is a custom message.", "WARN")
    $logger.Close()

    This example creates a new instance of CsLog, writes a custom message to the log with a warning level, and then closes the log.
    Here there is nothing specified at all, so the log file will be created in C:\ProgramData\1E\CsLogs\YYYY.MM.DD.HH.mm.ss.fffffff.log.

.NOTES
    Author: john.nelson@1e.com
    Version: 202312.1823.2950.1

    Because we make use of the StreamWriter class, the log file can be written to very quickly and efficiently
    compared to other methods like Out-File or Add-Content. The StreamWriter is also opened in shared read/write
    mode, so the log file can be opened and read by other processes while the script is running.

    Don't forget to close the log when you're done with it!

    This class makes use of the following .NET classes:
        System.IO.File
        System.IO.FileInfo
        System.IO.Directory
        System.IO.StreamWriter
        System.DateTime
        System.IO.FileMode
        System.IO.FileAccess
        System.IO.FileShare

    This class makes use of the following PowerShell classes:
        System.IO.Path        
'@
    }
}

#endregion Classes

#region Functions

function ConvertFrom-JulianDay {
    <#
    .SYNOPSIS
        Converts a Julian Day number to a date and time.

    .DESCRIPTION
        The ConvertFrom-JulianDay function converts a Julian Day number to a date and time. The Julian Day number is a continuous count of days since the beginning of the Julian Period on January 1, 4713 BCE. The function supports both the Gregorian and Julian calendar systems as output.

    .PARAMETER JulianDay
        Specifies the Julian Day number to convert to a date and time. The parameter accepts a System.Double object, which represents the Julian Day number.

    .EXAMPLE
        PS> ConvertFrom-JulianDay -JulianDay 2459376.5
        This example returns the date and time for the specified Julian Day number.

    .OUTPUTS
        System.DateTime
        The output is a System.DateTime object, which represents the date and time for the Julian Day number.

    .NOTES
        Author: john.nelson@1e.com
        Version: 1.0
        Date: 2024-03-03
    #>
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [double]$JulianDay
    )
        
    process {
        $J = [Math]::Floor($JulianDay + 0.5)
        $j = $J + 32044
        $g = [Math]::Floor($j / 146097)
        $dg = $j % 146097
        $c = [Math]::Floor(($dg / 36524 + 1) * 3 / 4)
        $dc = $dg - $c * 36524
        $b = [Math]::Floor($dc / 1461)
        $db = $dc % 1461
        $a = [Math]::Floor(($db / 365 + 1) * 3 / 4)
        $da = $db - $a * 365
        $y = $g * 400 + $c * 100 + $b * 4 + $a
        $m = [Math]::Floor(($da * 5 + 308) / 153) - 2
        $d = $da - [Math]::Floor(($m + 4) * 153 / 5) + 122
        $Y = $y - 4800 + [Math]::Floor(($m + 2) / 12)
        $M = ($m + 2) % 12 + 1
        $D = $d + 1

        $dayFraction = $JulianDay + 0.5 - [Math]::Floor($JulianDay + 0.5)
        $ticksPerDay = 864000000000 # 24 * 60 * 60 * 10^7
        $tickFraction = $dayFraction * $ticksPerDay

        $date = Get-Date -Year $Y -Month $M -Day $D -Hour 0 -Minute 0 -Second 0
        $date = $date.AddTicks([Math]::Round($tickFraction))

        return $date
    }
}

function ConvertTo-XmlString {
    <#
    .SYNOPSIS
    Converts an object to a formatted XML string.

    .DESCRIPTION
    Converts an object to an XML string. The object is first serialized to an XML file using Export-Clixml, then the XML file is read, deleted, and its content is returned as a formatted string.

    .PARAMETER Object
    The object to convert to XML. This parameter accepts pipeline input.

    .EXAMPLE
    ConvertTo-XmlString -Object $error
    Converts the $error variable to a formatted XML string.

    .EXAMPLE
    $error | ConvertTo-XmlString
    Converts the $error variable to a formatted XML string by accepting it from the pipeline.

    .NOTES
    This does use a temporary file to store the XML data in order to make use of the Export-CliXml cmdlet which has really complete support for serializing objects to XML. The temporary file is created in the user's TEMP directory and is removed after the XML string is created.

    Author: john.nelson@1e.com
    Date: 2024-03-06
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Object]$InputObject
    )

    Process {
        $tempFile = $tempFile = New-TemporaryFile
        try {
            $InputObject | Export-Clixml -Path $tempFile
            $xmlDocument = New-Object System.Xml.XmlDocument
            $xmlDocument.Load($tempFile)
            $settings = New-Object System.Xml.XmlWriterSettings
            $settings.OmitXmlDeclaration = $false
            $settings.Encoding = [System.Text.Encoding]::UTF8
            $settings.Indent = $true
            $settings.IndentChars = '    '
            $stringWriter = New-Object System.IO.StringWriter
            $xmlWriter = [System.Xml.XmlWriter]::Create($stringWriter, $settings)
            $xmlDocument.WriteTo($xmlWriter)
            $xmlWriter.Flush()
            $stringWriter.Flush()
            $stringWriter.ToString()
        } catch {
            Write-Error "An error occurred: $_"
        } finally {
            Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue
        }
    }
}

function Get-JulianDay {

    <#
    .SYNOPSIS
        Converts a date and time to a Julian Day number.

    .DESCRIPTION
        The Get-JulianDay function converts a date and time to a Julian Day number. The Julian Day number is a continuous count of days since the beginning of the Julian Period on January 1, 4713 BCE. The function supports both the Gregorian and Julian calendar systems as input.

    .PARAMETER DateTime
        Specifies the date and time to convert to a Julian Day number. The parameter accepts a DateTime object or a string representation of a date and time. If the parameter is not specified, the current date and time are used.

    .EXAMPLE
        PS> Get-JulianDay
        This example returns the Julian Day number for the current date and time.

    .EXAMPLE
        PS> Get-JulianDay -DateTime "2023-11-26 12:00:00"
        This example returns the Julian Day number for the specified date and time.

    .OUTPUTS
        System.Double
        The output is a System.Double object, which represents the Julian Day number.

    .NOTES
        Author: john.nelson@1e.com
        Version: 1.0
        Date: 2024-03-03

    #>
    param (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -is [DateTime] -or $_ -is [string]})]$DateTime
    )

    process {

        if (-not $DateTime) {
            $DateTime = Get-Date
        } elseif ($DateTime -is [string]) {
            $DateTime = [DateTime]::Parse($DateTime)
        }

        $year = $DateTime.Year
        $month = $DateTime.Month
        $day = $DateTime.Day
        # No need to separately calculate hours, minutes, seconds, and milliseconds

        if ($month -le 2) {
            $year--
            $month += 12
        }

        $A = [Math]::Floor($year / 100)
        $B = 2 - $A + [Math]::Floor($A / 4)
        $JD = [Math]::Floor(365.25 * ($year + 4716)) + [Math]::Floor(30.6001 * ($month + 1)) + $day + $B - 1524.5

        # Calculate the fractional day from ticks
        $ticks = $DateTime.Ticks % [TimeSpan]::TicksPerDay # Get the remaining ticks for the current day
        $fractionalDay = $ticks / [TimeSpan]::TicksPerDay # Divide by the total number of ticks in a day

        $JD += $fractionalDay

        return $JD
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
        This function is part of the Cs1eToolkit PowerShell module.

    .LINK
        Online Documentation: [URL to more detailed documentation or module repository]
    #>

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

function New-Version {
    <#
    .SYNOPSIS
        Generates a version number based on the current date and time.

    .DESCRIPTION
        The New-Version function creates a version number using the current date and time.
        The format of the version number is A.B.C.D, where:
        - A represents the year and month in the format YYYYMM.
        - B represents the day and hour in the format DDHH.
        - C represents the minute and second in the format MMSS.
        - D is a constant segment, set to 1.

        This versioning system ensures that each version number is unique and sequentially 
        meaningful, based on the exact time of generation.

        This function does not accept any parameters.

    .EXAMPLE
        PS> New-Version
        This example generates a version number based on the current date and time.

    .OUTPUTS
        System.Version
        The output is a System.Version object, which represents the generated version number.

    .NOTES
        Author: john.nelson@1e.com
        Version: 1.0
        Date: 2023-11-26

    #>    
    [CmdletBinding()]
    [OutputType([System.Version])]
    $currentTime = Get-Date
    
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

    return [System.Version]"$yearMonthSegment.$dayHourSegment.$minuteSecondSegment.$incrementingSegment"  
    
}

#endregion Functions

#region Public

# Check if Ps1eToolkit is already loaded
if (-not (Get-Module -Name Ps1eToolkit -ListAvailable)) {
    Write-Warning "Ps1eToolkit module is not loaded. Attempting to load it."

    # Attempt to import Ps1eToolkit
    try {
        Import-Module Ps1eToolkit -ErrorAction Stop
        Write-Verbose "Ps1eToolkit module loaded successfully."
    } catch {
        Write-Error "Failed to load the required Ps1eToolkit module. Please ensure it is installed. Error: $_"
        return
    }
}
#endregion Public
